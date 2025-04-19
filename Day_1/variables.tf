/*	variables.tf
	Bob Caruso	04/19/25

	POC Build in Amazon Free Tier
	Recreate Day One 
		- Create EC2 instance
		- Install Apache
*/

variable "region" {
  description = "AWS region to deploy into"
  default     = "us-west-2"                  
} #region

variable "area_zone" {
  description = "AWS AZ to deploy into"
  default     = "us-west-2c"                  
} #region

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
} #instance_type



