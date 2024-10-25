# Define the file path
$TOKEN_FILE = ".\token.txt"

# Function to print error message and exit
function Print-Error {
    Write-Host "***** CONNECTION FAILED: $args *****"
    exit 1
}

# Check if the token file exists
if (-not (Test-Path $TOKEN_FILE)) {
    # Prompt the user for the path to the token file if the default file doesn't exist
    $TOKEN_FILE = Read-Host "Please provide the path to the file with the token"
}

# Check again if the provided token file exists
if (-not (Test-Path $TOKEN_FILE)) {
    Print-Error "Token file not found."
}

# Read the token from the file
$TOKEN = Get-Content $TOKEN_FILE

# Execute the Invoke-RestMethod command with the token and store the response
try {
    $headers = @{
        "Authorization" = "Bearer $TOKEN"
    }
    $response = Invoke-RestMethod -Uri "https://api.cloud.camunda.io/members" -Method Get -Headers $headers
    $response | ConvertTo-Json
    Write-Host "***** CONNECTION SUCCESSFUL *****"
} catch {
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription
        Print-Error "Status code: $statusCode Response body: $statusDescription"
    } else {
        Print-Error "Error obtaining members information or server returned error status"
    }
}
