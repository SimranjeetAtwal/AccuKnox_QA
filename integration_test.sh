#!/bin/bash

# Run the FRONTEND_URL command using nohup
nohup bash -c 'minikube service frontend-service --url' > nohup.out 2>&1 &
MINIKUBE_PID=$!

# Set up a trap to kill the background minikube process when the script exits
trap "kill $MINIKUBE_PID" EXIT

# Wait a bit for nohup.out to be populated
sleep 10

# Extract the first line from nohup.out
FRONTEND_URL=$(head -n 1 nohup.out)

# Send a GET request to the frontend service
response=$(curl -s -o /dev/null -w "%{http_code}" "$FRONTEND_URL")

# Expected status code (usually 200 for a successful response)
expected_status=200

# Check if the frontend service responded successfully
if [[ "$response" -eq "$expected_status" ]]; then
  echo "Integration Test Passed: Frontend service is working correctly."
else
  echo "Integration Test Failed: Frontend service returned status code $response instead of $expected_status."
  exit 1
fi

# Optional: Check for specific content in the response
response_body=$(curl -s "$FRONTEND_URL")

# If your frontend service interacts with the backend, look for a key string
# (This string should be something that indicates successful backend integration)
if [[ "$response_body" == *"Backend"* ]]; then
  echo "Backend integration is working correctly."
else
  echo "Integration Test Failed: Backend integration issue detected."
  exit 1
fi

