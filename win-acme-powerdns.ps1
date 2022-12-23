param(
   [string]$Action,
   [string]$ZoneName,
   [string]$RecordName,
   [string]$Token
)

# Set the base URL for the PowerDNS API and the API key
$BaseURL = "https://power.dns.server/api/v1"
$ApiKey = "CHANGEME"

if ($Action -ne "create" -and $Action -ne "delete") {
    Write-Output "No action to take..."
    exit
}

# Check if the Verbose flag was passed
if ($Action -eq 'create') {
   Write-Output "Creating record ..."

   # Build the request body
   $body = [PSCustomObject]@{
       rrsets = @(
           [PSCustomObject]@{
               name = $RecordName + "."
               type = "TXT"
               ttl = 60
               changetype = "REPLACE"
               records = @(
                   [PSCustomObject]@{
                       content = '"' + $Token + '"'
                       disabled = $false
                   }
               )
           }
       )
   } | ConvertTo-Json -Depth 10
}

if ($Action -eq 'delete') {
   Write-Output "Deleting record ..."

   # Build the request body
   $body = [PSCustomObject]@{
       rrsets = @(
           [PSCustomObject]@{
               name = $RecordName + "."
               type = "TXT"
               ttl = $ttl
               changetype = "DELETE"
           }
       )
   } | ConvertTo-Json

} 

# Make the PATCH request to the PowerDNS API
$response = Invoke-WebRequest -Method PATCH -Uri "$BaseURL/servers/localhost/zones/$ZoneName" -Body $body -ContentType "application/json" -Headers @{ "X-API-Key" = $ApiKey }

# Check the response status code
if ($response.StatusCode -eq 204) {
  # Record was added / deleted successfully
  Write-Output "Success"
}
else {
  # There was an error adding the record
  Write-Output "Error: $($response.StatusCode) $($response.StatusDescription)"
}

