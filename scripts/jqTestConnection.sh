source envVars.txt
export ACCESS_TOKEN=$(curl -s --request POST \
  --url ${ZEEBE_AUTHORIZATION_SERVER_URL} \
  --header 'content-type: application/json' \
  --data "{\"client_id\":\"${ZEEBE_CLIENT_ID}\",\"client_secret\":\"${ZEEBE_CLIENT_SECRET}\",\"audience\":\"${ZEEBE_TOKEN_AUDIENCE}\",\"grant_type\":\"client_credentials\"}" \
  | jq -r .access_token )
response=$(curl -s -XGET -H 'Accept: application/json' -H "Authorization: Bearer ${ACCESS_TOKEN}" ${ZEEBE_REST_ADDRESS}/v1/topology)
broker_count=$(echo "$response" | jq '.brokers | length')
echo "$broker_count"
# Ensure broker_count is a valid number
if [ -n "$broker_count" ] && [ "$broker_count" -ge 1 ]; then
  echo "$response" | jq .
  echo "***** OK ******"
else
  echo "***** CONNECTION FAILED *****"
fi

