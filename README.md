# AWS_Terraform_POC
# Day 1: Deploy EC2 with Apache in AWS Free Tier (Terraform)

This is **Day 1** of my AWS Terraform Proof-of-Concept. The goal was to create a public web server running Apache in the AWS Free Tier using Terraform, with fully portable code that can be deployed to any region and AZ.
A screenshot of the running website is in the repository named "Webserver_URL_Screenshot.png"

---

## 🚀 What This Build Includes

- ✅ Amazon Linux 2 EC2 instance
- ✅ Apache web server installed via `user_data`
- ✅ Security Group with SSH (22) and HTTP (80) open to the world
- ✅ Subnet and AZ assignment via variables
- ✅ Region-portable AMI lookup
- ✅ Clean `.gitignore` and no state files committed

---

## 🌎 Deployment Instructions

```bash
terraform init
terraform plan
terraform apply
This will launch the EC2 instance and output the public IP.

Open your browser and visit the IP — you should see:

html
Copy
Edit
<h1>Deployed with Terraform in us-west-2</h1>
📁 Files

File	Purpose
main.tf	Infrastructure definition (EC2, SG, Subnet)
variables.tf	Inputs for instance type, region, AZ
terraform.tfvars	Actual values used for the variables
.gitignore	Ignores .terraform, state files, etc.
🧠 Notes
This was my first-ever Terraform project and the first day of my full AWS POC build. I chose to start with the basics — provisioning infrastructure as code, creating a working EC2 web server, and proving that I could build portable, modular Terraform from scratch.

## 🔧 Recent Updates
- **04/21/25**: Added PHP date display to show instance creation time. Added POC_Key to fix SSH connectivity.

✅ Status
Deployed and verified

Pushed to GitHub with Git history cleaned

Ready for reuse and expansion in future milestones
# AWS_Terraform_POC
