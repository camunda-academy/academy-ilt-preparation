#!/bin/bash

# Path to the environment variables file
env_file="envVars.txt"

# Check if environment variable file exists
if [ ! -f "$env_file" ]; then
  echo "***** CONNECTION FAILED: Environment variables file '$env_file' not found *****"
  exit 1
fi

# Load environment variables from the file
while IFS='=' read -r key value; do
  export "$key"="$value"
done < "$env_file"

# Get the access token
response=$(curl -s --request POST \
  --url "${ZEEBE_AUTHORIZATION_SERVER_URL}" \
  --header 'content-type: application/json' \
  --data "{\"client_id\":\"${ZEEBE_CLIENT_ID}\",\"client_secret\":\"${ZEEBE_CLIENT_SECRET}\",\"audience\":\"${ZEEBE_TOKEN_AUDIENCE}\",\"grant_type\":\"client_credentials\"}")

# Check if the access token request succeeded
if [ -z "$response" ]; then
  echo "***** CONNECTION FAILED: Error obtaining access token *****"
  exit 1
fi

# Extract access token
ACCESS_TOKEN=$(echo "$response" | grep -o '"access_token":"[^"]*"' | sed 's/"access_token":"\([^"]*\)"/\1/')

if [ -z "$ACCESS_TOKEN" ]; then
  echo "***** CONNECTION FAILED: Access token not found in response *****"
  exit 1
fi

# Get the topology information
response=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer ${ACCESS_TOKEN}" "${ZEEBE_REST_ADDRESS}/v1/topology")

# Check if topology request succeeded
if [ -z "$response" ]; then
  echo "***** CONNECTION FAILED: Error obtaining topology information *****"
  exit 1
fi

# Count the number of brokers (based on nodeId)
broker_count=$(echo "$response" | grep -o '"nodeId"' | wc -l)

# Print broker count
echo "Broker count: $broker_count"

# Ensure broker_count is a valid number and matches the expected value
if [ "$broker_count" -eq 3 ]; then
  echo "Response: $response"  # Print the raw response
  echo "***** OK ******"
else
  echo "***** CONNECTION FAILED: Incorrect number of brokers *****"
fi
