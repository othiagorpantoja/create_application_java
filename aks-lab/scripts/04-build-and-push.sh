#!/bin/bash

# Docker Build and Push Script
# This script builds the Docker image and pushes it to ACR

set -e

# Configuration variables
ACR_NAME="akslabacr$(date +%s)"  # This should match the ACR created in step 3
IMAGE_NAME="customer-service"
TAG="latest"
APP_PATH="../app"

echo "Building and pushing Docker image..."
echo "ACR Name: $ACR_NAME"
echo "Image Name: $IMAGE_NAME"
echo "Tag: $TAG"
echo "App Path: $APP_PATH"

# Get ACR login server
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --resource-group aks-lab-rg --query loginServer --output tsv)
if [ -z "$ACR_LOGIN_SERVER" ]; then
    echo "❌ Error: Could not find ACR. Please run 03-create-acr-and-wire-aks.sh first"
    exit 1
fi

FULL_IMAGE_NAME="$ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG"

echo "Full Image Name: $FULL_IMAGE_NAME"

# Login to ACR
echo "Logging into ACR..."
az acr login --name $ACR_NAME

# Build Docker image
echo "Building Docker image..."
docker build -f Dockerfile -t $FULL_IMAGE_NAME $APP_PATH

echo "✅ Docker image built successfully"

# Push image to ACR
echo "Pushing image to ACR..."
docker push $FULL_IMAGE_NAME

echo "✅ Image pushed to ACR successfully"

# Update deployment.yaml with the correct image name
echo "Updating deployment.yaml with image name..."
sed -i.bak "s|image: customer-service:latest|image: $FULL_IMAGE_NAME|g" ../k8s/deployment.yaml

echo ""
echo "✅ Build and push completed successfully!"
echo "Image: $FULL_IMAGE_NAME"
echo ""
echo "Next steps:"
echo "1. Create PostgreSQL database: 05-create-postgres.sh"
echo "2. Configure Kubernetes secrets: 06-k8s-configs.sh"
echo "3. Deploy to Kubernetes: 07-deploy.sh"
