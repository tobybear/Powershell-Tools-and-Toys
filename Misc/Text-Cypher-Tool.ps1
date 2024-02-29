[Console]::BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(78, 30)
[Console]::Title = " Cypher Tool"

function Generate-RandomKey {
    $allAsciiCharacters = [char]::ConvertFromUtf32(0)..[char]::ConvertFromUtf32(127)
    $characters = -join $allAsciiCharacters

    $random = Get-Random -Minimum 0 -Maximum $characters.Length
    $randomKey = ""

    for ($i = 0; $i -lt 25; $i++) {
        $randomIndex = Get-Random -Minimum 0 -Maximum $characters.Length
        $randomKey += $characters[$randomIndex]
    }

    return $randomKey
}

function Cipher-Text {
    param (
        [string]$text,
        [string]$key
    )

    $result = ""
    for ($i = 0; $i -lt $text.Length; $i++) {
        $charCode = [int]$text[$i] -bxor [int]$key[$i % $key.Length]
        $result += [char]$charCode
    }
    return [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($result))
}

function Decipher-Text {
    param (
        [string]$encodedText,
        [string]$key
    )

    $decodedText = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encodedText))
    $result = ""
    for ($i = 0; $i -lt $decodedText.Length; $i++) {
        $charCode = [int]$decodedText[$i] -bxor [int]$key[$i % $key.Length]
        $result += [char]$charCode
    }
    return $result
}

Function Header {
cls
Write-Host "
===================================================================
=                                                                 =
=                          CYPHER TOOL                            =
=                                                                 =
===================================================================" -ForegroundColor Green
}

while($true){

Header
$seperator = ("-" * 30)

$operation = Read-Host "
===================================================================
=                                                                 =
= 1. Encrypt Text                                                 =
= 2. Decrypt Text                                                 =
=                                                                 =
===================================================================
Please choose an option "

    if($operation -eq '1'){
    
        Header
        $key = Read-Host "Enter a keyphrase "
        $text = Read-Host "Enter text to be encrypted "
        Header
        Write-Host "Keyphrase: $key" -ForegroundColor DarkGray
        Write-Host "Original Text: $text" -ForegroundColor DarkGray
        Write-Host $seperator
        $encryptedText = Cipher-Text -text $text -key $key
        Write-Host "Encrypted Text: $encryptedText"
        Write-Host $seperator
        pause

    }
    if($operation -eq '2'){
    
        Header
        $key = Read-Host "Enter the keyphrase "
        $encryptedText = Read-Host "Enter encrypted message "

        Header
        Write-Host "Keyphrase: $key" -ForegroundColor DarkGray
        Write-Host "Encrypted Text: $encryptedText" -ForegroundColor DarkGray
        Write-Host $seperator
        $decryptedText = Decipher-Text -encodedText $encryptedText -key $key
        Write-Host "Decrypted Text: $decryptedText"
        Write-Host $seperator
        pause

    }
    else{
    }

}