# AKS Lab - Customer Service

This project demonstrates a complete deployment of a Java Spring Boot application to Azure Kubernetes Service (AKS) with PostgreSQL database integration.

## Project Structure

```
aks-lab/
├── app/
│   ├── pom.xml
│   └── src/
│       ├── main/java/com/lab/
│       │   ├── App.java
│       │   └── customer/
│       │       ├── Customer.java
│       │       ├── CustomerRepository.java
│       │       └── CustomerController.java
│       └── main/resources/
│           ├── application.properties
│           ├── schema.sql
│           └── data.sql
├── docker/
│   └── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── secret.yaml
├── scripts/
│   ├── 01-create-rg.sh
│   ├── 02-create-aks.sh
│   ├── 03-create-acr-and-wire-aks.sh
│   ├── 04-build-and-push.sh
│   ├── 05-create-postgres.sh
│   ├── 06-k8s-configs.sh
│   ├── 07-deploy.sh
│   └── 08-get-service-ip.sh
└── README.md
```

## Architecture Overview

- **Application**: Java Spring Boot REST API for customer management
- **Database**: PostgreSQL with sample customer data
- **Container Registry**: Azure Container Registry (ACR)
- **Orchestration**: Azure Kubernetes Service (AKS)
- **Infrastructure**: Azure-managed PostgreSQL and AKS cluster

## Prerequisites

1. **Azure CLI** - [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. **Docker** - [Install Docker](https://docs.docker.com/get-docker/)
3. **kubectl** - [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
4. **Maven** - [Install Maven](https://maven.apache.org/install.html)
5. **Java 17** - [Install OpenJDK 17](https://openjdk.java.net/projects/jdk/17/)

## Quick Start

### 1. Clone and Setup

```bash
git clone <repository-url>
cd aks-lab
```

### 2. Azure Login

```bash
az login
az account set --subscription <your-subscription-id>
```

### 3. Run Deployment Scripts

Execute the scripts in order:

```bash
# Make scripts executable
chmod +x scripts/*.sh

# 1. Create Resource Group
./scripts/01-create-rg.sh

# 2. Create AKS Cluster
./scripts/02-create-aks.sh

# 3. Create ACR and integrate with AKS
./scripts/03-create-acr-and-wire-aks.sh

# 4. Build and push Docker image
./scripts/04-build-and-push.sh

# 5. Create PostgreSQL database
./scripts/05-create-postgres.sh

# 6. Create Kubernetes ConfigMap and Secret
./scripts/06-k8s-configs.sh

# 7. Deploy application to Kubernetes
./scripts/07-deploy.sh

# 8. Get service external IP
./scripts/08-get-service-ip.sh
```

## Application Details

### Customer Service API

The application provides a REST API for customer management with the following endpoints:

- `GET /api/customers` - Get all customers
- `GET /api/customers/{id}` - Get customer by ID
- `GET /api/customers/email/{email}` - Get customer by email
- `POST /api/customers` - Create new customer
- `PUT /api/customers/{id}` - Update customer
- `DELETE /api/customers/{id}` - Delete customer
- `GET /actuator/health` - Health check endpoint

### Sample Data

The application comes with pre-populated sample data:
- John Doe (john.doe@example.com)
- Jane Smith (jane.smith@example.com)
- Bob Johnson (bob.johnson@example.com)
- Alice Brown (alice.brown@example.com)
- Charlie Wilson (charlie.wilson@example.com)

## Testing the Application

### 1. Get Service IP

```bash
./scripts/08-get-service-ip.sh
```

### 2. Test API Endpoints

```bash
# Replace <EXTERNAL_IP> with the actual IP from step 1

# Health check
curl http://<EXTERNAL_IP>/actuator/health

# Get all customers
curl http://<EXTERNAL_IP>/api/customers

# Get customer by ID
curl http://<EXTERNAL_IP>/api/customers/1

# Create new customer
curl -X POST http://<EXTERNAL_IP>/api/customers \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'
```

## Kubernetes Resources

### Deployment
- **Replicas**: 2
- **Resources**: 256Mi-512Mi memory, 250m-500m CPU
- **Health Checks**: Liveness and readiness probes
- **Image**: Pulled from Azure Container Registry

### Service
- **Type**: LoadBalancer
- **Port**: 80 → 8080
- **External Access**: Yes (via Azure Load Balancer)

### ConfigMap
- Database host, port, name, and username configuration

### Secret
- Database password (base64 encoded)

## Monitoring and Troubleshooting

### Check Pod Status

```bash
kubectl get pods -l app=customer-service
```

### View Logs

```bash
kubectl logs -l app=customer-service
```

### Check Service Status

```bash
kubectl get service customer-service
```

### Debug Deployment

```bash
kubectl describe deployment customer-service
kubectl describe pod <pod-name>
```

## Cleanup

To remove all resources and avoid Azure costs:

```bash
# Delete resource group (this removes everything)
az group delete --name aks-lab-rg --yes --no-wait
```

## Security Considerations

1. **Database Password**: Stored as Kubernetes Secret (base64 encoded)
2. **ACR Authentication**: Integrated with AKS managed identity
3. **Network Security**: PostgreSQL configured with public access (for demo purposes)
4. **Container Security**: Non-root user in Docker container
5. **Health Checks**: Proper liveness and readiness probes

## Cost Optimization

- **AKS**: Standard_B2s nodes (2 replicas)
- **PostgreSQL**: Standard_B1ms (Burstable tier)
- **ACR**: Basic SKU
- **Load Balancer**: Standard SKU

Estimated monthly cost: ~$100-150 (varies by region and usage)

## Next Steps

1. **Production Considerations**:
   - Use Azure Key Vault for secrets management
   - Implement proper network security groups
   - Set up monitoring with Azure Monitor
   - Configure backup strategies

2. **Scaling**:
   - Implement horizontal pod autoscaling
   - Configure cluster autoscaling
   - Optimize database performance

3. **CI/CD**:
   - Integrate with Azure DevOps or GitHub Actions
   - Implement blue-green deployments
   - Add automated testing

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Azure CLI and kubectl documentation
3. Check application logs for errors
4. Verify all prerequisites are installed

## License

This project is for educational purposes and demonstrates AKS deployment patterns.
