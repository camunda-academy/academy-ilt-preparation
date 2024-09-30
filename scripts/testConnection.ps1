# Define the path to the environment variables file
$envVarsFilePath = "envVars.txt"

# Check if the environment variables file exists
if (-Not (Test-Path -Path $envVarsFilePath)) {
    Write-Host "***** CONNECTION FAILED: Environment variables file '$envVarsFilePath' not found *****"
    exit 1
}

# Load environment variables from the file
try {
    $envVars = Get-Content -Path $envVarsFilePath | ForEach-Object {
        $pair = $_ -split "="
        [System.Environment]::SetEnvironmentVariable($pair[0], $pair[1])
    }
} catch {
    Write-Host "Error loading environment variables: $_"
    exit 1
}

# Get the access token
try {
    $body = @{
        client_id     = $env:ZEEBE_CLIENT_ID
        client_secret = $env:ZEEBE_CLIENT_SECRET
        audience      = $env:ZEEBE_TOKEN_AUDIENCE
        grant_type    = "client_credentials"
    }

    $response = Invoke-RestMethod -Uri $env:ZEEBE_AUTHORIZATION_SERVER_URL -Method Post -ContentType "application/json" -Body ($body | ConvertTo-Json)
    $accessToken = $response.access_token
} catch {
    Write-Host "Error obtaining access token: $_"
    exit 1
}

# Get the topology information
try {
    $topologyResponse = Invoke-RestMethod -Uri "$env:ZEEBE_REST_ADDRESS/v1/topology" -Method Get -Headers @{ Authorization = "Bearer $accessToken" }
} catch {
    Write-Host "Error obtaining topology information: $_"
    exit 1
}

# Count the number of brokers
try {
    $brokerCount = $topologyResponse.brokers.Count
    Write-Host "Broker count: $brokerCount"

    if ($brokerCount -ge 1) {
        $topologyResponse | ConvertTo-Json | Write-Host
        Write-Host "***** OK ******"
    } else {
        Write-Host "***** CONNECTION FAILED: No brokers found *****"
    }
} catch {
    Write-Host "Error counting brokers or processing topology response: $_"
    Write-Host "***** CONNECTION FAILED: Unable to process topology response *****"
}
