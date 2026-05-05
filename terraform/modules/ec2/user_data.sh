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
  --name fastapi \
  fastapi-app