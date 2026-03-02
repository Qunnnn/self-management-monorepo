#!/bin/bash

BASE_URL="http://localhost:8080"

echo "==================================="
echo "Testing Server Behavior"
echo "==================================="
echo ""

echo "1. Testing /health (no database needed):"
curl -s $BASE_URL/health
echo -e "\n"

echo "2. Testing /users (requires database):"
curl -s $BASE_URL/users | head -c 200
echo -e "\n"

echo "3. PostgreSQL status:"
brew services list | grep postgresql
echo ""

echo "==================================="
echo "Instructions:"
echo "1. Make sure your server is running: go run main.go"
echo "2. Run this script: ./test_connection.sh"
echo "3. Stop PostgreSQL: brew services stop postgresql"
echo "4. Run this script again to see the difference!"
echo "==================================="
