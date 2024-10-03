# data_sources.tf

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch public subnets in the VPC
data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.default.id
}

# Fetch the first public subnet from the list of public subnets
data "aws_subnet" "public_subnet" {
  id = data.aws_subnet_ids.public_subnets.ids[0]
}

# Fetch a specific security group (replace with actual group name)
data "aws_security_group" "ssh_sg" {
  filter {
    name   = "group-name"
    values = ["my-ssh-sg"]
  }
  vpc_id = data.aws_vpc.default.id
}

# Fetch the latest Ubuntu AMI for EC2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}