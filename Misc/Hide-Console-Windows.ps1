<# ============ Hiding Windows Terminal App =================

Windows 11 22H2 and onwards, powershell opens with windows terminal.
this script hides either process from the user.

#>

$Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$hwnd = (Get-Process -PID $pid).MainWindowHandle

# if running in powershell console
if($hwnd -ne [System.IntPtr]::Zero){
$Type::ShowWindowAsync($hwnd, 0)
}
# if running in windows terminal app
else{
$Host.UI.RawUI.WindowTitle = 'hideme'
$Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
$hwnd = $Proc.MainWindowHandle
$Type::ShowWindowAsync($hwnd, 0)
}
