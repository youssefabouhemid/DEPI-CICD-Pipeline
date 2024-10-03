# variables.tf
variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"
}