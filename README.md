# DevSecOps Assignment – GET 2026

**Author:** Dheeraj Omprakash Vishwakarma

---

## 1. Project Overview

This repository demonstrates a secure DevSecOps pipeline that automates application deployment on AWS using Infrastructure as Code, CI/CD, and security scanning.

Objectives:
- Containerize a web application
- Provision cloud infrastructure with Terraform
- Integrate security scanning (Trivy) in CI/CD
- Identify and remediate vulnerabilities with AI assistance
- Deploy a secure application on AWS

---

## 2. Application Details

- Application: Python Flask web app
- Purpose: Simple web application for deployment validation
- Container Port: 5000 (mapped publicly to 80)
- Response: Static HTML page describing the DevSecOps pipeline

Key files:
- App code: [app/app.py](app/app.py)
- Container: [app/Dockerfile](app/Dockerfile)
- Compose (optional): [app/docker-compose.yml](app/docker-compose.yml)

---

## 3. Tech Stack

| Category | Tools |
|---|---|
| Cloud | AWS (EC2) |
| IaC | Terraform |
| CI/CD | Jenkins |
| Security Scanning | Trivy |
| Containerization | Docker |
| Web Framework | Flask (Python) |
| AI Assistance | ChatGPT |

---

## 4. Architecture Overview

1. Developer pushes code to GitHub
2. Jenkins pipeline triggers automatically
3. Jenkins runs Trivy to scan Terraform and configs
4. Vulnerabilities are identified
5. AI is used to analyze and suggest remediations
6. Terraform provisions AWS infrastructure
7. Docker container is built and deployed on EC2
8. Application is accessible via the EC2 public IP

---

## 5. Infrastructure as Code (Terraform)

Terraform resources:
- AWS EC2 instance
- Security Group with ingress for HTTP and SSH
- Encrypted root EBS volume
- IMDSv2 enforced (`http_tokens = "required"`)

Current configuration: [terraform/main.tf](terraform/main.tf)

Intentional initial risks for scanning validation:
- SSH open to `0.0.0.0/0`
- Egress limited to HTTPS only (secure)
- IMDSv2 enabled
- Encrypted root volume

Recommended remediation before production:
- Restrict SSH to your admin IP (replace `0.0.0.0/0` with `YOUR.IP.ADDR.XXX/32`)

Example change in `aws_security_group.secure_sg` ingress:
```hcl
  ingress {
    description = "Allow SSH for setup"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<YOUR_PUBLIC_IP>/32"]
  }
```

Apply Terraform:
```bash
cd terraform
terraform init
terraform plan
terraform apply
# Later, to clean up
terraform destroy
```

Notes:
- Do not commit Terraform state: `.terraform/`, `*.tfstate*` are ignored by [.gitignore](.gitignore).
- A `terraform.tfstate` file may exist locally; ensure it is not pushed.

---

## 6. Security Scanning (Trivy)

Scan Terraform/IaC locally:
```bash
# Scan Terraform directory for misconfigurations
trivy config ./terraform
```

Typical findings include open SSH access and other misconfigurations. After remediation, Trivy should show no critical issues. Re-run the scan to verify.

---

## 7. CI/CD Pipeline (Jenkins)

- Pipeline definition: [Jenkinsfile](Jenkinsfile)
- Jenkins runs locally via Docker

Run Jenkins in Docker:
```bash
docker network create jenkins-net

# Linux/macOS example for a quick start (adjust for Windows volume paths)
docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --network jenkins-net \
  jenkins/jenkins:lts
```

Pipeline stages:
1. Checkout source code
2. Trivy scan of Terraform
3. Terraform init and plan
4. Build and deploy container on EC2

Requirements on the Jenkins agent:
- Docker CLI available
- Terraform installed
- Trivy installed
- AWS credentials configured in the environment or Jenkins credentials

---

## 8. Build and Run the App Locally

Using Docker (from repo root):
```bash
# Build image from the app context
docker build -t assignment ./app

# Run locally on port 5000
docker run --rm -p 5000:5000 assignment
```

Using Docker Compose (inside the app folder):
```bash
cd app
docker compose up --build
```

Open http://localhost:5000 to view the app.

---

## 9. Deploy Container on EC2

After Terraform provisions the EC2 instance:

```bash
# SSH into EC2 (example username varies by AMI)
ssh -i <PATH_TO_KEY>.pem ec2-user@<EC2_PUBLIC_IP>

# On the EC2 host, install and start Docker if needed
sudo yum update -y || sudo apt-get update -y
sudo yum install -y docker || sudo apt-get install -y docker.io
sudo systemctl enable --now docker

# Option A: Build from source on EC2
# If code is present on the instance
sudo docker build -t assignment ~/repo/app

# Option B: Copy and build from your machine
# From local machine
scp -i <PATH_TO_KEY>.pem -r ./app ec2-user@<EC2_PUBLIC_IP>:/home/ec2-user/app
ssh -i <PATH_TO_KEY>.pem ec2-user@<EC2_PUBLIC_IP> "cd /home/ec2-user/app && sudo docker build -t assignment ."

# Run mapping public 80 -> container 5000
sudo docker run -d --name web -p 80:5000 assignment
```

Public URL:
```
http://3.110.174.170/
```

---

## 10. AI Usage Log (Mandatory)

- AI Tool Used: ChatGPT
- Prompt Used: "Analyze the following Trivy security report and suggest secure Terraform configurations to fix the vulnerabilities."

Risks identified:
- Open SSH access
- Unencrypted storage (validated/checked)
- Missing IMDSv2 (validated/checked)
- Overly permissive firewall rules

AI-recommended fixes implemented:
- Restrict SSH to admin IP
- Enforce IMDSv2
- Encrypt root EBS volume
- Restrict outbound traffic

Re-validate with Trivy after each change.

---

## 11. Screenshots

Include screenshots for:
- Jenkins pipeline execution
- Trivy scan (before and after remediation)
- Terraform apply
- Docker container running
- Application accessed via browser

---

## 12. Video Demonstration

Provide a 5–10 minute screen recording demonstrating:
- Jenkins pipeline execution
- Trivy security scan
- Terraform provisioning
- Application running on AWS

Video link: <PASTE_VIDEO_LINK_HERE>

---

## 13. Notes and Best Practices

- Always restrict SSH to a trusted IP (or disable after provisioning)
- Keep Terraform state secure (e.g., S3 + DynamoDB for remote state)
- Use least privilege IAM roles for Jenkins and Terraform
- Pin Docker base images and scan regularly
- Store secrets in a secure manager (e.g., AWS Secrets Manager)

---

## 14. Cleanup

Destroy infrastructure when done:
```bash
cd terraform
terraform destroy
```
