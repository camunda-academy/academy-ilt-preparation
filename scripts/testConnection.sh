# Load environment variables from a file (make sure to create this file)
while IFS='=' read -r key value; do
    export "$key"="$value"
done < "envVarsWin.txt"

# Get the access token
response=$(curl -s --request POST \
  --url "${ZEEBE_AUTHORIZATION_SERVER_URL}" \
  --header 'content-type: application/json' \
  --data "{\"client_id\":\"${ZEEBE_CLIENT_ID}\",\"client_secret\":\"${ZEEBE_CLIENT_SECRET}\",\"audience\":\"${ZEEBE_TOKEN_AUDIENCE}\",\"grant_type\":\"client_credentials\"}")

# Extract access token
ACCESS_TOKEN=$(echo "$response" | grep -o '"access_token":"[^"]*"' | sed 's/"access_token":"\([^"]*\)"/\1/')

# Get the topology information
response=$(curl -s -XGET -H 'Accept: application/json' -H "Authorization: Bearer ${ACCESS_TOKEN}" "${ZEEBE_REST_ADDRESS}/v1/topology")

# Count the number of brokers (based on nodeId)
broker_count=$(echo "$response" | grep -o '"nodeId"' | wc -l)

# Print broker count
echo "Broker count: $broker_count"

# Ensure broker_count is a valid number
if [ "$broker_count" -eq 3 ]; then
    echo "Response: $response"  # Print the raw response
    echo "***** OK ******"
else
    echo "***** CONNECTION FAILED *****"
fi

