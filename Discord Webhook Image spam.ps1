<#
========================= Discord Webhook Spammer ============================--

SYNOPSIS
This script will spam a discord webhook with an invisible image which will clear the chat feed.

USAGE
1. Change '10' to the number of shortcuts you want created
2. Run the script.

#>



$hookurl = 'YOUR_WEBHOOK_HERE' # replace with your webhook
$n = 10                        # the number of messages sent in total.
$b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAQAAATvCAYAAAAhPVEsAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACGSURBVHhe7c1LDoAgDAVAjqRoIt7/YMjPwNaNq1k0pdPXEPYj5bU'
$b64+= 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAfcJXHrBDH5u09EZfEfqa81W3pLdGisQ+1l5O7DLPat+1k9JGosCTWAt8g5Qcr8LCkbrQx2gAAAABJRU5ErkJggg=='
$decodedFile = [System.Convert]::FromBase64String($b64)
$File = "$env:temp\bl.png"
Set-Content -Path $File -Value $decodedFile -Encoding Byte
$i = 0
while($i -lt $n) {
curl.exe -F "file1=@$file" $hookurl
$i++
}

Remove-Item -Path $file