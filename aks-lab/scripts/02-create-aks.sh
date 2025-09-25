#!/bin/bash

# AKS Cluster Creation Script
# This script creates an AKS cluster for the lab

set -e

# Configuration variables
RESOURCE_GROUP_NAME="aks-lab-rg"
AKS_CLUSTER_NAME="aks-lab-cluster"
LOCATION="East US"
NODE_COUNT=2
NODE_VM_SIZE="Standard_B2s"

echo "Creating AKS Cluster..."
echo "Cluster Name: $AKS_CLUSTER_NAME"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"
echo "Node Count: $NODE_COUNT"
echo "Node VM Size: $NODE_VM_SIZE"

# Create AKS cluster
az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AKS_CLUSTER_NAME \
    --location "$LOCATION" \
    --node-count $NODE_COUNT \
    --node-vm-size $NODE_VM_SIZE \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --enable-managed-identity

echo "✅ AKS cluster '$AKS_CLUSTER_NAME' created successfully"

# Get credentials
echo "Getting cluster credentials..."
az aks get-credentials \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AKS_CLUSTER_NAME \
    --overwrite-existing

# Verify cluster
echo ""
echo "Cluster Status:"
kubectl get nodes

echo ""
echo "✅ AKS cluster setup completed successfully!"
echo "You can now use 'kubectl' to manage your cluster."
