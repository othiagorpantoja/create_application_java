#!/bin/bash

# PostgreSQL Database Creation Script
# This script creates a PostgreSQL database in Azure

set -e

# Configuration variables
RESOURCE_GROUP_NAME="aks-lab-rg"
POSTGRES_SERVER_NAME="akslabpostgres$(date +%s)"  # Unique name with timestamp
ADMIN_USERNAME="postgres"
ADMIN_PASSWORD="SecurePassword123!"
DATABASE_NAME="customers"
LOCATION="East US"

echo "Creating PostgreSQL Database..."
echo "Server Name: $POSTGRES_SERVER_NAME"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"
echo "Database Name: $DATABASE_NAME"
echo "Admin Username: $ADMIN_USERNAME"

# Create PostgreSQL server
az postgres flexible-server create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $POSTGRES_SERVER_NAME \
    --location "$LOCATION" \
    --admin-user $ADMIN_USERNAME \
    --admin-password $ADMIN_PASSWORD \
    --sku-name Standard_B1ms \
    --tier Burstable \
    --public-access 0.0.0.0 \
    --storage-size 32 \
    --version 13

echo "✅ PostgreSQL server '$POSTGRES_SERVER_NAME' created successfully"

# Create database
echo "Creating database '$DATABASE_NAME'..."
az postgres flexible-server db create \
    --resource-group $RESOURCE_GROUP_NAME \
    --server-name $POSTGRES_SERVER_NAME \
    --database-name $DATABASE_NAME

echo "✅ Database '$DATABASE_NAME' created successfully"

# Get server details
SERVER_FQDN=$(az postgres flexible-server show \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $POSTGRES_SERVER_NAME \
    --query fullyQualifiedDomainName --output tsv)

echo ""
echo "✅ PostgreSQL setup completed successfully!"
echo "Server Name: $POSTGRES_SERVER_NAME"
echo "Server FQDN: $SERVER_FQDN"
echo "Database Name: $DATABASE_NAME"
echo "Admin Username: $ADMIN_USERNAME"
echo "Admin Password: $ADMIN_PASSWORD"
echo ""
echo "Connection String:"
echo "Host: $SERVER_FQDN"
echo "Port: 5432"
echo "Database: $DATABASE_NAME"
echo "Username: $ADMIN_USERNAME"
echo "Password: $ADMIN_PASSWORD"
echo ""
echo "Next steps:"
echo "1. Update the ConfigMap and Secret with these database details"
echo "2. Run: 06-k8s-configs.sh"
echo "3. Deploy to Kubernetes: 07-deploy.sh"
