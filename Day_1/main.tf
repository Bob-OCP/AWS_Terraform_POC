/*	main.tf
	Bob Caruso - 04/19/25

	POC Build in Amazon Free Tier
	Recreate Day One 
		- Create EC2 instance
		- Install Apache         */

provider "aws" {                # Loads plugin for AWS. Examples of other values for learning:  azurerm, google, vSphere
	region = var.region
} #provider

locals {													
	selected_ami = try(data.aws_ami.amazon_linux_2.id, null)	# If no image, let's write that in Outputs.
} #locals

data "aws_vpc" "default" {
	default = true
} #data

data "aws_ami" "amazon_linux_2" {			#### Look up the latest Amazon Linux 2 AMI in the selected region

	most_recent = true
	owners      = ["amazon"]

	filter {
		name   = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	} #filter

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	} #filter

} #data

data "aws_subnet" "default_az_subnet" {

	filter {
		name   = "availabilityZone"
		values = [var.area_zone]
	} #filter

	filter {
		name   = "default-for-az"
		values = ["true"]
	} #filter

} #data


# Create a security group for web + SSH access
resource "aws_security_group" "webservers_sg" {

	name        = "WebServers"
	description = "Allow SSH and HTTP"

	ingress {
		description = "SSH"
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	} #ingress

	ingress {
		description = "HTTP"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	} #ingress

	egress {							#### I don't really need this because this is already the default SG behavior. 
		from_port   = 0					#### I am going to add in case I want to copy the code for SG later 
		to_port     = 0					#### and want to lock it down.
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	} #egress

} #resource

										##### Launch an EC2 instance with Apache installed
resource "aws_instance" "webservers" {

	count = local.selected_ami == null ? 0 : 1				# Exit block if no AMI was found.
	ami   = local.selected_ami  
	instance_type = var.instance_type												 
	vpc_security_group_ids = [aws_security_group.webservers_sg.id]				
	subnet_id = data.aws_subnet.default_az_subnet.id
	key_name = "POC_Key"

	user_data = <<-EOF
		#!/bin/bash
		yum update -y
		yum install -y httpd php -y
		systemctl start httpd
		systemctl enable httpd

		cat <<EOPHP > /var/www/html/index.php
			<html>
				<head>
					<title>Welcome to My EC2 Instance</title>
				</head>
				<body>
					<h1>Welcome to My EC2 Instance -- Created with Terraform</h1>
					<p>This instance name is:
						<strong><?php echo file_get_contents("http://169.254.169.254/latest/meta-data/hostname"); ?></strong>
					</p>

					<p>This instance is running in Availability Zone:
						<strong><?php echo file_get_contents("http://169.254.169.254/latest/meta-data/placement/availability-zone"); ?></strong>
					</p>
					<p>This instance was created on:
						<strong><?php echo date("Y-m-d H:i:s"); ?></strong>
					</p>
				</body>
			</html>
		EOPHP
	EOF
	
	tags = {
		Name = "WebServer-Day1"
	} #tags
} #resource


output "selected_ami" {
	value = local.selected_ami != null ? local.selected_ami : "⚠ No matching AMI found!"
} #output

output "instance_public_ip" {
	value = local.selected_ami != null ? aws_instance.webservers[0].public_ip : "⚠️ Instance not created"
} #output



