#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Running infrastructure tests..."
echo "==============================="

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local expected_status=$2
    local description=$3
    
    echo -n "Testing $description... "
    response=$(curl -s -w "\n%{http_code}" "$url")
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}OK${NC}"
        echo "Response: $body"
    else
        echo -e "${RED}FAILED${NC}"
        echo "Expected status $expected_status, got $status_code"
        echo "Response: $body"
    fi
    echo "------------------------"
}

# Function to validate JSON response
validate_json() {
    local url=$1
    local description=$2
    
    echo -n "Validating $description... "
    if response=$(curl -s "$url" | jq . 2>/dev/null); then
        echo -e "${GREEN}OK${NC}"
        echo "Response:"
        echo "$response" | jq .
    else
        echo -e "${RED}FAILED${NC}"
        echo "Invalid JSON response"
    fi
    echo "------------------------"
}

# 1. Test Terraform Infrastructure
echo "1. Testing Terraform Infrastructure"
echo "--------------------------------"

# Check if containers are running
echo -n "Checking nginx container... "
if docker ps | grep -q "sysadmin-infra_nginx"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

echo -n "Checking PHP-FPM container... "
if docker ps | grep -q "sysadmin-infra_php"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

echo -n "Checking shared network... "
if docker network inspect sysadmin-net >/dev/null 2>&1; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

echo -n "Checking shared volume... "
if docker volume inspect web-data >/dev/null 2>&1; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
fi

# 2. Test HTTP Endpoints
echo -e "\n2. Testing HTTP Endpoints"
echo "--------------------------------"

# Test root endpoint
test_endpoint "http://localhost:8080/" "200" "Root endpoint"

# Test healthz endpoint
validate_json "http://localhost:8080/healthz" "Healthz endpoint"

# Test PHP processing
test_endpoint "http://localhost:8080/test.php" "200" "PHP processing"

# 3. Test Environment Variables
echo -e "\n3. Testing Environment Variables"
echo "--------------------------------"
curl -s "http://localhost:8080/healthz" | jq '.env'

# 4. Test Nginx Configuration
echo -e "\n4. Testing Nginx Configuration"
echo "--------------------------------"
docker exec sysadmin-infra_nginx nginx -t

# 5. Test PHP-FPM Configuration
echo -e "\n5. Testing PHP-FPM Status"
echo "--------------------------------"
docker exec sysadmin-infra_php php-fpm -v

echo -e "\nAll tests completed!"