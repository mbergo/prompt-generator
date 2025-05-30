#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t prompt-generator .

# Run the container with environment variables
echo "Starting container..."
docker run -d \
    --name prompt-generator \
    -p 8080:80 \
    -e GEMINI_API_KEY="${GEMINI_API_KEY}" \
    prompt-generator

echo "Application is running at http://localhost:8080"
echo "To stop: docker stop prompt-generator"
echo "To remove: docker rm prompt-generator"