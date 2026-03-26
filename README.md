# 🚀 Production-Ready 3-Tier Infrastructure using Terraform

## 📌 Project Overview
This project implements a **secure, scalable, and modular 3-tier architecture** on AWS using Terraform (Infrastructure as Code).

The architecture separates the application into three layers:
- **Web Tier (Presentation Layer)**
- **Application Tier (Logic Layer)**
- **Database Tier (Data Layer)**

This eliminates manual provisioning, reduces configuration drift, and ensures consistent deployments.

---

## 🏗️ Architecture

### 🔹 3-Tier Design
- **Web Tier** → Public Subnet (Nginx)
- **Application Tier** → Private Subnet (PHP Backend)
- **Database Tier** → Private Subnet (Amazon RDS - MySQL)

### 🔹 Key Components
- Custom VPC
- Public & Private Subnets (2 Availability Zones)
- Internet Gateway
- NAT Gateway
- Route Tables
- EC2 Instances
- Amazon RDS

---

## 🧭 Architecture Flow

1. User sends request via browser
2. Request enters through **Internet Gateway**
3. Routed to **Web Tier (EC2 - Nginx)** in Public Subnet
4. Web server forwards request to **Application Tier (EC2 - PHP)** in Private Subnet
5. Application processes data and interacts with **RDS MySQL Database**
6. Response is returned back to the user

---

## ⚙️ Technologies Used

- Terraform
- AWS EC2
- Amazon RDS (MySQL)
- AWS VPC
- Nginx (Web Server)
- PHP (Backend Processing)

---

## 📦 Terraform Modules
### 🔹 VPC Module
- Creates VPC, subnets, IGW, NAT Gateway
- Configures routing
### 🔹 EC2 Module
- Launches Web and App instances
- Configures user_data scripts
### 🔹 RDS Module
- Creates MySQL database
- Configures DB subnet group
- Restricts access to App tier

---
## 🚀 Deployment Steps
### 1️⃣ Initialize Terraform
```bash
terraform init
2️⃣ Validate Configuration
terraform validate
3️⃣ Apply Infrastructure
terraform apply
Type yes when prompted.
🌐 Access Application
After deployment, get public IP:
terraform output
Open in browser:
http://<web-public-ip>

🔐 Security Best Practices
Web tier allows only HTTP/HTTPS traffic
Application tier has no public IP
Database is in private subnet
RDS access restricted to App-tier security group
NAT Gateway used for outbound internet from private instances
Sensitive data excluded using .gitignore

📁 Project Structure
project3-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── .gitignore
├── README.md
│
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── rds/
│
├── templates/
│   ├── index.html
│   └── submit.php
📊 Results
Successfully deployed 3-tier architecture
Web application accessible via public IP
Form submission processed through backend
Data stored securely in RDS
✅ Advantages
Modular and reusable infrastructure
Improved security using private subnets
Automated provisioning with Terraform
Scalable architecture design
Reduced manual errors
🔮 Future Enhancements
Add Application Load Balancer (ALB)
Enable Auto Scaling
Implement HTTPS (SSL/TLS)
Integrate CI/CD pipeline
Add monitoring using CloudWatch
👩‍💻 Author
Aaliya Shaikh
