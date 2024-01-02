#============================================================================================
#                                      WEBHOOK TEST TOOL
#============================================================================================

# Define the Webhook address URL (Optional - it can be shortened)
$hookurl = "https://t.ly/shortlink"

# shortened URL Detection
if ($hookurl.Length -ne 121){
write-host "Short URL Detected.."
$hookurl = irm $hookurl | select -ExpandProperty url
}

# Define the body of the message and convert it to JSON
$body = @{"username" = "Webhook Test Tool" ;"content" = "The webhook works!"} | ConvertTo-Json

# Use 'Invoke-RestMethod' command to send the message to Discord
IRM -Uri $url -Method Post -ContentType "application/json" -Body $body
