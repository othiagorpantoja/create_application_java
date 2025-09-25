#!/bin/bash

# Service IP Retrieval Script
# This script gets the external IP address of the customer service

set -e

echo "Getting Customer Service External IP..."

# Wait for external IP to be assigned
echo "Waiting for external IP to be assigned..."
while [ -z "$EXTERNAL_IP" ]; do
    EXTERNAL_IP=$(kubectl get service customer-service --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [ -z "$EXTERNAL_IP" ]; then
        echo "External IP not yet assigned, waiting 10 seconds..."
        sleep 10
    fi
done

echo "✅ External IP assigned: $EXTERNAL_IP"

# Display service information
echo ""
echo "Service Information:"
kubectl get service customer-service

echo ""
echo "✅ Customer Service is accessible at:"
echo "http://$EXTERNAL_IP"
echo ""
echo "Available endpoints:"
echo "- Health Check: http://$EXTERNAL_IP/actuator/health"
echo "- Customer API: http://$EXTERNAL_IP/api/customers"
echo "- Customer by ID: http://$EXTERNAL_IP/api/customers/1"
echo "- Customer by Email: http://$EXTERNAL_IP/api/customers/email/john.doe@example.com"
echo ""
echo "Test the service:"
echo "curl http://$EXTERNAL_IP/api/customers"
echo "curl http://$EXTERNAL_IP/actuator/health"
