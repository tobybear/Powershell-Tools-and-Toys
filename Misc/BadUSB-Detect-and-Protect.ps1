<# ================ BAD USB DETECTION AND PROTECTION ===================

SYNOPSIS
This script runs passively in the background waiting for any new usb devices.
When a new USB device is connected to the machine this script monitors keypresses for 30 seconds.
If there are 15 or more keypresses detected within 200 milliseconds it will attempt to disable the most recently connected USB device

USAGE
1. Run the script and follow instructions
2. A pop up will appear when monitoring is active and if a 'BadUSB' device is detected
3. logs are found in 'usblogs' folder in the temp directory.

REQUIREMENTS
Admin privlages are required for removing any suspected devices (you can re-enable devices too)

#>

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Write-Host "Checking User Permissions.." -ForegroundColor DarkGray
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Admin privileges needed for this script..." -ForegroundColor Red
    Write-Host "This script will self elevate to run as an Administrator and continue." -ForegroundColor DarkGray
    Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    exit
}
else{
    sleep 1
    Write-Host "This script is running as Admin!"  -ForegroundColor Green
    New-Item -ItemType Directory -Path "$env:TEMP\usblogs\"
    cls
    $enable = Read-Host "Re-enable All Devices? (y/n) "
    $hidden = Read-Host "Hide This Window (y/n) "
}


If ($hidden -eq 'y'){
    Write-Host "Hiding the Window.."  -ForegroundColor Red
    sleep 1
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    if($hwnd -ne [System.IntPtr]::Zero){
        $Type::ShowWindowAsync($hwnd, 0)
    }
    else{
        $Host.UI.RawUI.WindowTitle = 'hideme'
        $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
        $hwnd = $Proc.MainWindowHandle
        $Type::ShowWindowAsync($hwnd, 0)
    }
}

$usbDevices = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE PNPDeviceID LIKE 'USB%'"
$currentUSBDevices = @()
$newUSBDevices = @()
foreach ($device in $usbDevices) {
    $deviceID = $device.DeviceID
    $newUSBDevices += $deviceID
}
$currentUSBDevices = $newUSBDevices


function EnableDevices {
    param (
        [string[]]$deviceIDs
    )

    foreach ($deviceID in $deviceIDs) {
        try {
            Write-Host "Attempting to enable device with ID: $deviceID" -ForegroundColor Yellow
            $pnpDevice = Get-PnpDevice -InstanceId $deviceID -ErrorAction Stop
            if ($pnpDevice.Status -ne 'OK') {
                Enable-PnpDevice -InstanceId $deviceID -Confirm:$false -ErrorAction Stop
                Write-Host "Successfully enabled device with ID: $deviceID" -ForegroundColor Green
            } else {
                Write-Host "Device with ID: $deviceID is already enabled." -ForegroundColor Blue
            }
        } catch {
            Write-Host "Error enabling device with ID: $deviceID. $_" -ForegroundColor Red
        }
    }
}
if ($enable -eq 'y'){
    EnableDevices -deviceIDs $newUSBDevices
    cls
    Write-Host "All Devices Enabled!" -ForegroundColor Green
    sleep 1
    $2ndpass = Read-Host "Run Again? (sometimes required) [y/n]"
    if ($2ndpass -eq 'y'){
        EnableDevices -deviceIDs $newUSBDevices
    }
    pause
    exit
}
else{
    "" | Out-File -FilePath "$env:TEMP\usblogs\ids.log"
    "" | Out-File -FilePath "$env:TEMP\usblogs\monon.log"
    Write-Host "Monitoring for devices.." -ForegroundColor Green
    sleep 1
}


$monitor = {

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$API = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@
$API = Add-Type -MemberDefinition $API -Name 'Win32' -Namespace API -PassThru


$balloon = {

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Warning
$notify.Visible = $true
$balloonTipTitle = "WARNING"
$balloonTipText = "Bad USB Device Intercepted!"
$notify.ShowBalloonTip(30000, $balloonTipTitle, $balloonTipText, [System.Windows.Forms.ToolTipIcon]::WARNING)

}

function DisableDevices {
    param ([string[]]$deviceIDs)
    foreach ($deviceID in $deviceIDs) {
        try {
            "Attempting to disable device with ID: $deviceID" | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append
            $pnpDevice = Get-PnpDevice -InstanceId $deviceID -ErrorAction Stop
            if ($pnpDevice.Status -eq 'OK') {
                Disable-PnpDevice -InstanceId $deviceID -Confirm:$false -ErrorAction Stop
                "Successfully disabled device with ID: $deviceID" | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append
            } else {
                "Device with ID: $deviceID is not in an 'OK' state and cannot be disabled." | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append
            }
        } catch {
            "Error disabling device with ID: $deviceID. $_" | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append
        }
    }
}

function MonitorKeys {
    
    $startTime = $null
    $keypressCount = 0
    $initTime = Get-Date
    while ($MonitorTime -lt $initTime.AddSeconds(30)) {
        $stopjob = Get-Content "$env:TEMP\usblogs\monon.log"
        if ($stopjob -eq 'true'){"killed monitoring for: $deviceID" | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append ;exit}
        $MonitorTime = Get-Date
        Start-Sleep -Milliseconds 10
        for ($i = 8; $i -lt 256; $i++) {
            $keyState = $API::GetAsyncKeyState($i)
            if ($keyState -eq -32767) {
                if (-not $startTime) {
                    $startTime = Get-Date
                }
                $keypressCount++
            }
        }
        
        if ($startTime -and (New-TimeSpan -Start $startTime).TotalMilliseconds -ge 200) {
            if ($keypressCount -gt 14) {
                $script:newUSBDeviceIDs = Get-Content "$env:TEMP\usblogs\ids.log"
                Start-Job -ScriptBlock $balloon -Name BallonIcon
                DisableDevices -deviceIDs $script:newUSBDeviceIDs
                
            }
            $startTime = $null
            $keypressCount = 0
            
        }
    }
    
}
MonitorKeys
}

function CheckNew {
    $usbDevices = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE PNPDeviceID LIKE 'USB%'"
    $newUSBDevices = @()
    $newUSBDeviceIDs = @()
    foreach ($device in $usbDevices) {
        $deviceID = $device.DeviceID
        $newUSBDevices += $deviceID
        if ($currentUSBDevices -notcontains $deviceID) {
            Write-Host "New USB device added: $($device.Name) ID: $($deviceID)"
            $script:match = $true
            $newUSBDeviceIDs += $deviceID -split "," | Out-File -FilePath "$env:TEMP\usblogs\ids.log" -Append
        }
    }
    
    $global:currentUSBDevices = $newUSBDevices
    $global:newUSBDeviceIDs = $newUSBDeviceIDs
}

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Shield
$notify.Visible = $true
$balloonTipTitle = "USB Monitoring"
$balloonTipText = "BadUSB Monitoring Active.."
$notify.ShowBalloonTip(30000, $balloonTipTitle, $balloonTipText, [System.Windows.Forms.ToolTipIcon]::Info)

while ($true) {

    CheckNew
    if ($match){
        Write-Host "Monitoring Keys"
        $jobon = Get-Job -Name Monitor
        if ($jobon){
            "true" | Out-File -FilePath "$env:TEMP\usblogs\monon.log"
            sleep -Milliseconds 500
        }
        $script:match = $false
        "false" | Out-File -FilePath "$env:TEMP\usblogs\monon.log"
        Start-Job -ScriptBlock $monitor -Name Monitor
    }
    
    sleep -Milliseconds 500
    
}

