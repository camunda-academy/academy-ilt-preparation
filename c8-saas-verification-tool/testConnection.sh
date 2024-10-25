#!/bin/sh

# Define the file path
TOKEN_FILE="./token.txt"

# Function to print error message
print_error() {
    echo "***** CONNECTION FAILED: $1"
    exit 1
}

# Check if the token file exists
if [ ! -f "$TOKEN_FILE" ]; then
    # Prompt the user for the path to the token file if the default file doesn't exist
    read -p "Please provide the path to the file with the token: " TOKEN_FILE
fi

# Check again if the provided token file exists
if [ ! -f "$TOKEN_FILE" ]; then
    print_error "Token file not found."
    exit 1
fi

# Read the token from the file
TOKEN=$(<"$TOKEN_FILE")

# Execute the curl command with the token and store the response
# Perform the curl command and capture the HTTP status code and response body
HTTP_RESPONSE=$(curl --silent --header "Authorization: Bearer $TOKEN" \
                --write-out "HTTPSTATUS:%{http_code}" \
                https://api.cloud.camunda.io/members)

# Extract the body and the status
BODY=$(echo "$HTTP_RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')
STATUS=$(echo "$HTTP_RESPONSE" | grep -o 'HTTPSTATUS:.*' | sed -e 's/HTTPSTATUS\://')

# Check the status code
if [ "$STATUS" -eq 200 ]; then
    # Print the response to the screen if the status code is 200 OK
    echo "$BODY"
    echo "***** CONNECTION SUCCESSFUL *****"
else
    # If the status code is not 200, print the error message
    print_error "Status code: $STATUS Response body: $BODY"
fi