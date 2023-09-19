#============================================================================================
#                                      WEBHOOK TEST TOOL
#============================================================================================

# Define the Webhook address URL
$url = "https://discord.com/api/webhooks/.........."

# Define the body of the message and convert it to JSON
$body = @{"username" = "Webhook Test Tool" ;"content" = "The webhook works!"} | ConvertTo-Json

# Use 'Invoke-RestMethod' command to send the message to Discord
IRM -Uri $url -Method Post -ContentType "application/json" -Body $body