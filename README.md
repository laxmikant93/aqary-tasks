# aqary-tasks

🚀 Terraform AWS Infrastructure (LocalStack-Based)

This project provisions a complete AWS-like infrastructure using Terraform, designed to run locally with LocalStack for development and testing purposes.

It simulates a production-style architecture including networking, compute, storage, database, messaging, and serverless components.

📌 Overview

This Terraform configuration creates:

A custom VPC with public and private subnets
Internet Gateway and routing for public access
EC2 instance running Dockerized NGINX
Application Load Balancer (ALB)
PostgreSQL RDS instance (private)
S3 bucket with event notifications
Lambda function triggered by S3
SQS queue for asynchronous messaging
IAM roles and security groups

All AWS services are configured to run against LocalStack endpoints (http://localhost:4566).

🏗️ Architecture
                Internet
                    |
             [ Internet Gateway ]
                    |
           ---------------------
           |                   |
   Public Subnets       Private Subnets
           |                   |
        [ ALB ]          [ RDS PostgreSQL ]
           |
      [ EC2 Instance ]
           |
     (Docker: NGINX)

S3 Bucket --> Lambda --> (processing)
       |
      SQS Queue
⚙️ Prerequisites

Make sure you have:

Terraform
 >= 1.0
Docker
LocalStack running locally

Start LocalStack:

docker run -d -p 4566:4566 localstack/localstack
🔧 Configuration Notes
AWS credentials are mock values (used only for LocalStack)
Region: us-east-1
All AWS services are redirected to LocalStack endpoints
No real AWS resources are created
🚀 Usage
1. Initialize Terraform
terraform init
2. Preview the infrastructure
terraform plan
3. Apply the configuration
terraform apply

Confirm with yes when prompted.

📦 Resources Created
🌐 Networking
VPC (10.0.0.0/16)
3 Public Subnets
3 Private Subnets
Internet Gateway
Route Table (public)
🖥️ Compute
EC2 Instance (t2.micro)
Runs Docker
Hosts NGINX container on port 80
⚖️ Load Balancing
Application Load Balancer
Target Group + Listener
🛢️ Database
PostgreSQL RDS instance (private subnets)
📁 Storage
S3 Bucket (aqary-tasks-terraform-bucket)
Event notifications to Lambda
⚡ Serverless
Lambda function (python3.13)
Triggered by S3 object creation
📬 Messaging
SQS Queue (app-queue)
🔐 Security
Security Groups:
Web SG (SSH + HTTP)
ALB SG (HTTP)
DB SG (PostgreSQL from web only)
🔄 Data Flow
User accesses the ALB
ALB routes traffic to the EC2 instance
EC2 serves content via NGINX (Docker)
Files uploaded to S3
S3 triggers Lambda function
Lambda processes events (extendable)
Messages can be queued via SQS
🧪 Testing
Access EC2 (via LocalStack simulation)
NGINX runs on port 80
Try:
curl http://localhost
Test S3 → Lambda trigger

Upload a file to the bucket and verify Lambda execution logs.

⚠️ Important Notes
This setup is for local development only
Hardcoded credentials and passwords are not secure
RDS, ALB, and Lambda behavior may be partially simulated in LocalStack
Health check path /health may need implementation in NGINX
🧹 Cleanup

Destroy all resources:

terraform destroy
