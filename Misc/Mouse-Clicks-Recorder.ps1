<# ================================== MOUSE CLICKS RECORDER =================================

SYNOPSIS
Record your mouse clicks and positions along with interval time between clicks.. (for loading screens etc.)
Play them back later and automate clicky tasks!

USAGE
1. Run the script and select an option

HELP
the click sequence file is located in your temp folder as 'sequence.ps1'
you can play it manually - Rightclick - 'Run with Powershell' then minimize the console window.

#>

Add-Type -AssemblyName System.Windows.Forms

[Console]::BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(50, 20)
[Console]::Title = "Mouse Click Recorder"

while ($true){


    $header = "
    ===============================================
    
    ===========  MOUSE CLICK RECORDER  ============
    
    ===============================================
    
    OPTIONS :
    
    1. Record Mouse Clicks
    2. Play Mouse Clicks
    3. Clean Up Temp Files & Exit
    4. Exit
    "
    cls
    Write-Host $header -ForegroundColor Cyan
    $option = Read-Host "Please Select an Option "
    
    if ($option -eq 1){
        $sequencefile = "$env:TEMP/sequence.ps1"
        Write-Host "Creating a file.."
        
        "# ===================================== CLICK SEQUENCER ========================================" | Out-File -FilePath $sequencefile -Force 
        "Add-Type -AssemblyName System.Windows.Forms" | Out-File -FilePath $sequencefile -Append -Force

'Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class MouseSimulator {
        [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
        public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
        
        public const int MOUSEEVENTF_LEFTDOWN = 0x02;
        public const int MOUSEEVENTF_LEFTUP = 0x04;

        public static void LeftClick() {
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            System.Threading.Thread.Sleep(30);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
        }
        public const int MOUSEEVENTF_RIGHTDOWN = 0x08;
        public const int MOUSEEVENTF_RIGHTUP = 0x10;

        public static void RightClick() {
            mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
            System.Threading.Thread.Sleep(30);
            mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
        }

    }
"@' | Out-File -FilePath $sequencefile -Append -Force
        
        Write-Host "Setting up..." -ForegroundColor Yellow
        sleep 1
        function MouseState {
            $previousState = [System.Windows.Forms.Control]::MouseButtons
            $lastClickTime = $null
            $lastClickPosition = $null
            $lastIntervalTime = $null
            $singleClickDetected = $false
            $intTime = Get-Date
            while ($true) {
                $currentState = [System.Windows.Forms.Control]::MouseButtons
                $currentTime = Get-Date
                if ($previousState -ne $currentState) {
                    if ($currentState -ne [System.Windows.Forms.MouseButtons]::None) {
                        $mousePosition = [System.Windows.Forms.Cursor]::Position
                        $button = "Left"
                        if ($currentState -eq [System.Windows.Forms.MouseButtons]::Right) {
                            $button = "Right"
                        }
                        # DOUBLE
                        if ($lastClickTime -ne $null -and ($currentTime - $lastClickTime).TotalSeconds -le 1) {
                            $intTime = Get-Date
                            $interval = ($intTime - $lastIntervalTime).TotalSeconds
                            "Start-Sleep $interval" | Out-File -FilePath $sequencefile -Append -Force
                            "[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($($mousePosition.X), $($mousePosition.Y))" | Out-File -FilePath $sequencefile -Append -Force
                            "Start-Sleep -Milliseconds 200" | Out-File -FilePath $sequencefile -Append -Force
                            "[MouseSimulator]::${button}Click()" | Out-File -FilePath $sequencefile -Append -Force
                            "Start-Sleep -Milliseconds 50" | Out-File -FilePath $sequencefile -Append -Force
                            "[MouseSimulator]::${button}Click()" | Out-File -FilePath $sequencefile -Append -Force
                            Write-Host "Interval Time: $interval seconds" -ForegroundColor DarkGray
                            Write-Host "Double-Click Detected at X:$($mousePosition.X) Y:$($mousePosition.Y)!" -ForegroundColor DarkGray
                            $lastClickTime = $currentTime
                            $singleClickDetected = $false
                        } else {
                            # WAIT FOR DOUBLE
                            $lastClickTime = $currentTime
                            $lastClickPosition = $mousePosition
                            $lastIntervalTime = $intTime
                            $singleClickDetected = $true
                        }
                    }
                    $previousState = $currentState
                }
                elseif ($singleClickDetected -and ($currentState -eq [System.Windows.Forms.MouseButtons]::None)) {
                    # SINGLE
                    if (($currentTime - $lastClickTime).TotalSeconds -gt 1) {
                        $intTime = Get-Date
                        $interval = ($intTime - $lastIntervalTime).TotalSeconds
                        "Start-Sleep $interval" | Out-File -FilePath $sequencefile -Append -Force
                        "[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($($mousePosition.X), $($mousePosition.Y))" | Out-File -FilePath $sequencefile -Append -Force
                        "Start-Sleep -Milliseconds 200" | Out-File -FilePath $sequencefile -Append -Force
                        "[MouseSimulator]::${button}Click()" | Out-File -FilePath $sequencefile -Append -Force
                        Write-Host "Interval Time: $interval seconds" -ForegroundColor DarkGray
                        Write-Host "Mouse Click Detected at X:$($lastClickPosition.X) Y:$($lastClickPosition.Y)! Button: $button" -ForegroundColor DarkGray
                        $lastClickTime = $null
                        $singleClickDetected = $false
                    }
                }
                Start-Sleep -Milliseconds 30
            }
        }
        Write-Host "Recording..." -ForegroundColor Red
        while ($true) {
            MouseState
        }        
    }
    
    if ($option -eq 2){
        Write-Host "Playing..." -ForegroundColor Yellow
        Get-Content -Path $sequencefile -Raw | iex
        Write-Host "Succeded!" -ForegroundColor Green
        sleep 3
    
    }
    
    if ($option -eq 3){
        Write-Host "Cleaning up..." -ForegroundColor yellow
        sleep 3
        $sequencefile = "$env:TEMP/sequence.ps1"
        rm -Path $sequencefile -Force
        Write-Host "Closing.." -ForegroundColor Red
        sleep 3
        exit
    }
    
    if ($option -eq 4){
        Write-Host "Closing.." -ForegroundColor Red
        sleep 3
        exit
    }
    
    else{
        Write-Host "Please choose a valid option." -ForegroundColor Red
        sleep 3
    }

}