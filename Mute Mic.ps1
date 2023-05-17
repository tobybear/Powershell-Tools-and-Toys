<#
====================== 5 Second Black Screen =========================

SYNOPNIS
Mutes/Unmutes your current microphone.

USAGE
1.Run script and click mute in the GUI.

#>



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

$tooltip1 = New-Object System.Windows.Forms.ToolTip
$ShowHelp={
    Switch ($this.name) {

      
        "start"  {$tip = "Mute the Microphone"}
}
$tooltip1.SetToolTip($this,$tip)
}

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '100,50'
$MainWindow.Text = "| Montools | Mic Mute |"
$MainWindow.BackColor = "#242424"
$MainWindow.Opacity = 0.93
$MainWindow.TopMost = $true

$mutebutton = New-Object System.Windows.Forms.Button
$mutebutton.Text = "MUTE"
$mutebutton.Width = 60
$mutebutton.Height = 25
$mutebutton.Location = New-Object System.Drawing.Point(30, 10)
$mutebutton.Font = 'Microsoft Sans Serif,8,style=Bold'
$mutebutton.BackColor = "#eeeeee"
$mutebutton.add_MouseHover($showhelp)
$mutebutton.name="start"

$MainWindow.controls.AddRange(@($mutebutton))

Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;public class Audio {[DllImport("user32.dll", CharSet = CharSet.Auto)]public static extern IntPtr SendMessageW(IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);}
"@

$mutebutton.Add_Click({

$WM_APPCOMMAND = 0x0319
$APPCOMMAND_MICROPHONE_VOLUME_MUTE = 0x180000
$handle = (Get-Process -PID $PID).MainWindowHandle

[Audio]::SendMessageW($handle, $WM_APPCOMMAND, $handle, [IntPtr]::new($APPCOMMAND_MICROPHONE_VOLUME_MUTE))


})

$MainWindow.ShowDialog() | Out-Null
exit 
