
<#
#============================================= beigeworm's Mouse Monitor ========================================================

SYNOPSIS
This script gathers information about any mouse movement and idletime and saves it to a file".


USAGE
2. Run Script on target System
3. Check temp folder for results

#>

$outpath = "$env:temp\activity.txt"
$prevX = [System.Windows.Forms.Cursor]::Position.X
$idleThreshold = New-TimeSpan -Seconds 60
$lastActivityTime = [System.DateTime]::Now
$isActive = $true
while ($true) {
    $currentX = [System.Windows.Forms.Cursor]::Position.X
    $currentTime = [System.DateTime]::Now
    $idleTime = $currentTime - $lastActivityTime


if ($currentX -ne $prevX) {
    if ($iActive) {
        $prevX = $currentX
        $lastActivityTime = $currentTime
        if ($idleTime -lt $idleThreshold) {
        Write-Host "$lastActivityTime : Mouse is active"
        "$lastActivityTime : Mouse is active" | Out-File -FilePath $outpath -Encoding ASCII -Append
        }
        $iActive = $false
    }
}
    else {
        $iActive = $true
    }


    if ($idleTime -ge $idleThreshold) {
        if ($isActive) {
            Write-Host "$lastActivityTime : Mouse has been inactive for 60 seconds"
            "$lastActivityTime : Mouse has been inactive for 30 seconds" | Out-File -FilePath $outpath -Encoding ASCII -Append
            $isActive = $false
            $iActive = $true
           
        }
        else {
        }
    }
    else {
        $isActive = $true
    }

    Start-Sleep -Milliseconds 100
}
