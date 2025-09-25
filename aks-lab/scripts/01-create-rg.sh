#!/bin/bash

# Azure Resource Group Creation Script
# This script creates a resource group for the AKS lab

set -e

# Configuration variables
RESOURCE_GROUP_NAME="aks-lab-rg"
LOCATION="East US"

echo "Creating Azure Resource Group..."
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"

# Create resource group
az group create \
    --name $RESOURCE_GROUP_NAME \
    --location "$LOCATION"

echo "✅ Resource group '$RESOURCE_GROUP_NAME' created successfully in '$LOCATION'"

# Display resource group details
echo ""
echo "Resource Group Details:"
az group show --name $RESOURCE_GROUP_NAME --output table
