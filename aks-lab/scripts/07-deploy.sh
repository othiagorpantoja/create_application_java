#!/bin/bash

# Kubernetes Deployment Script
# This script deploys the customer service to AKS

set -e

echo "Deploying Customer Service to Kubernetes..."

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."

echo "Creating ConfigMap..."
kubectl apply -f ../k8s/configmap.yaml

echo "Creating Secret..."
kubectl apply -f ../k8s/secret.yaml

echo "Creating Deployment..."
kubectl apply -f ../k8s/deployment.yaml

echo "Creating Service..."
kubectl apply -f ../k8s/service.yaml

echo "✅ All Kubernetes resources created successfully"

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/customer-service

echo "✅ Deployment is ready"

# Show deployment status
echo ""
echo "Deployment Status:"
kubectl get deployments
echo ""
echo "Pod Status:"
kubectl get pods -l app=customer-service
echo ""
echo "Service Status:"
kubectl get services customer-service

echo ""
echo "✅ Customer Service deployed successfully!"
echo ""
echo "To get the external IP address, run: 08-get-service-ip.sh"
echo "To check logs, run: kubectl logs -l app=customer-service"
echo "To check health, run: kubectl exec -it <pod-name> -- curl http://localhost:8080/actuator/health"
