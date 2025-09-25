#!/bin/bash

# Kubernetes Configuration Script
# This script creates ConfigMap and Secret with PostgreSQL database details

set -e

# Configuration variables
RESOURCE_GROUP_NAME="aks-lab-rg"
POSTGRES_SERVER_NAME="akslabpostgres$(date +%s)"  # This should match the PostgreSQL server created in step 5
DATABASE_NAME="customers"
ADMIN_USERNAME="postgres"
ADMIN_PASSWORD="SecurePassword123!"

echo "Creating Kubernetes ConfigMap and Secret..."
echo "PostgreSQL Server: $POSTGRES_SERVER_NAME"
echo "Database Name: $DATABASE_NAME"

# Get PostgreSQL server FQDN
SERVER_FQDN=$(az postgres flexible-server show \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $POSTGRES_SERVER_NAME \
    --query fullyQualifiedDomainName --output tsv)

if [ -z "$SERVER_FQDN" ]; then
    echo "❌ Error: Could not find PostgreSQL server. Please run 05-create-postgres.sh first"
    exit 1
fi

echo "Server FQDN: $SERVER_FQDN"

# Create ConfigMap with database configuration
echo "Creating ConfigMap..."
kubectl create configmap customer-service-config \
    --from-literal=db-host="$SERVER_FQDN" \
    --from-literal=db-port="5432" \
    --from-literal=db-name="$DATABASE_NAME" \
    --from-literal=db-username="$ADMIN_USERNAME" \
    --dry-run=client -o yaml | kubectl apply -f -

echo "✅ ConfigMap created successfully"

# Create Secret with database password
echo "Creating Secret..."
kubectl create secret generic customer-service-secret \
    --from-literal=db-password="$ADMIN_PASSWORD" \
    --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Secret created successfully"

# Verify the resources
echo ""
echo "Verifying created resources..."

echo "ConfigMap:"
kubectl get configmap customer-service-config -o yaml

echo ""
echo "Secret:"
kubectl get secret customer-service-secret -o yaml

echo ""
echo "✅ Kubernetes configuration completed successfully!"
echo ""
echo "Database Configuration:"
echo "Host: $SERVER_FQDN"
echo "Port: 5432"
echo "Database: $DATABASE_NAME"
echo "Username: $ADMIN_USERNAME"
echo ""
echo "Next steps:"
echo "1. Deploy the application: 07-deploy.sh"
echo "2. Get service IP: 08-get-service-ip.sh"
