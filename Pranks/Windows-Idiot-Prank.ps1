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
iwr -Uri 'https://i.ibb.co/gDVfZ0L/white.jpg' -OutFile "$env:TEMP\white.jpg"
iwr -Uri 'https://i.ibb.co/0nxjGzH/black.jpg' -OutFile "$env:TEMP\black.jpg"
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
    $image1 = [System.Drawing.Image]::FromFile("$env:TEMP\white.jpg")
    $image2 = [System.Drawing.Image]::FromFile("$env:TEMP\black.jpg")
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $Width = $screen.Bounds.Width
    $Height = $screen.Bounds.Height
    $desktopHandle = [System.IntPtr]::Zero
    $graphics = [System.Drawing.Graphics]::FromHwnd($desktopHandle)

    while ($true){
        $graphics.DrawImage($image1, 0, 0, $Width, $Height)
        $graphics.DrawImage($image2, 0, 0, $Width, $Height)
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
pause