#!/bin/bash

# Azure Container Registry (ACR) Creation and AKS Integration Script
# This script creates an ACR and integrates it with the AKS cluster

set -e

# Configuration variables
RESOURCE_GROUP_NAME="aks-lab-rg"
AKS_CLUSTER_NAME="aks-lab-cluster"
ACR_NAME="akslabacr$(date +%s)"  # Unique name with timestamp
LOCATION="East US"

echo "Creating Azure Container Registry..."
echo "ACR Name: $ACR_NAME"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"

# Create ACR
az acr create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true

echo "✅ ACR '$ACR_NAME' created successfully"

# Get ACR login server
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP_NAME --query loginServer --output tsv)
echo "ACR Login Server: $ACR_LOGIN_SERVER"

# Attach ACR to AKS
echo "Attaching ACR to AKS cluster..."
az aks update \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AKS_CLUSTER_NAME \
    --attach-acr $ACR_NAME

echo "✅ ACR attached to AKS cluster successfully"

# Login to ACR
echo "Logging into ACR..."
az acr login --name $ACR_NAME

# Create kubectl secret for pulling images
echo "Creating image pull secret..."
kubectl create secret docker-registry acr-secret \
    --docker-server=$ACR_LOGIN_SERVER \
    --docker-username=$(az acr credential show --name $ACR_NAME --query username --output tsv) \
    --docker-password=$(az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv) \
    --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "✅ ACR setup completed successfully!"
echo "ACR Name: $ACR_NAME"
echo "ACR Login Server: $ACR_LOGIN_SERVER"
echo ""
echo "Next steps:"
echo "1. Build and push your Docker image using: 04-build-and-push.sh"
echo "2. Update the image name in deployment.yaml to: $ACR_LOGIN_SERVER/customer-service:latest"
