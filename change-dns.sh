#!/bin/bash
# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi
# Function to get IP
get_ip() {
    if [ -n "$IP_URL" ]; then
        curl -s "$IP_URL"
    else
        echo "Error: IP_URL not defined in .env file"
        exit 1
    fi
}
# Function to update DNS record
update_dns() {
    local ip=$1
    curl --request PATCH \
        --url "$CF_API_URL" \
        --header "Content-Type: application/json" \
        --header "X-Auth-Email: $CF_EMAIL" \
        --header "X-Auth-Key: $CF_API_KEY" \
        --data "{
            \"content\": \"$ip\",
            \"name\": \"$DOMAIN\",
            \"proxied\": false,
            \"type\": \"A\",
            \"comment\": \"Domain verification record\"
        }"
}
# Get initial IP and set last IP
IP=$(get_ip)
LAST_IP=$IP
echo "ip=$IP"
# First API call
RESPONSE=$(update_dns "$IP")
echo "Response: $RESPONSE"
# Main loop
while true; do
    sleep 30
    IP=$(get_ip)
    
    echo "ip=$IP"
    echo "lastIp=$LAST_IP"
    
    if [ "$IP" != "$LAST_IP" ]; then
        echo "IP has changed to $IP"
        LAST_IP=$IP
        
        RESPONSE=$(update_dns "$IP")
        echo "Response: $RESPONSE"
    fi
done