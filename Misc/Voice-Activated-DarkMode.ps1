<# ===================== VOICE ACTIVATED DARK/LIGHT MODE ======================

SYNOPSIS
Control Windows theme with your voice.
Say 'Light' OR 'Dark' to change theme.

#>


while ($true) {    
    Add-Type -AssemblyName System.Speech
    $speech = New-Object System.Speech.Recognition.SpeechRecognitionEngine
    $grammar = New-Object System.Speech.Recognition.DictationGrammar
    $speech.LoadGrammar($grammar)
    $speech.SetInputToDefaultAudioDevice()
    $result = $speech.Recognize()
    $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    if ($result) {
        $text = $result.Text
        Write-Output $text

        if ($text -match 'Dark'){
            Write-Host "Set Dark Theme"
            Set-ItemProperty $Theme AppsUseLightTheme -Value 0
            Set-ItemProperty $Theme SystemUsesLightTheme -Value 0
        }
        if ($text -match 'Light'){
            Set-ItemProperty $Theme AppsUseLightTheme -Value 1
            Set-ItemProperty $Theme SystemUsesLightTheme -Value 1
            Write-Host "Set Light Theme"
        }
    }
}