#!/bin/bash
set -e

# Update system
apt-get update -y

# Install Docker
apt-get install -y docker.io git

# Start Docker service
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Create app directory
mkdir -p /app
cd /app

# Clone your FastAPI repo (CHANGE THIS)
git clone https://github.com/laxmikant93/aqary-tasks.git .

cd apps

# Build Docker image
docker build -t fastapi-app .

# Run container
docker run -d \
  -p 8000:8000 \
  -e QUEUE_URL="https://sqs.us-east-1.amazonaws.com/111111111111/fastapi-jobs" \
  -e DB_HOST="localhost:5432" \
  -e DB_USER="postgres" \
  -e DB_PASS="Password123@" \
  -e DB_NAME="mydb" \
  fastapi-sqs-app