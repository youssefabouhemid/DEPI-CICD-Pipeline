# data_sources.tf

# Create a Key Pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "my-terraform-key"  # Name of the key pair in AWS
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
}

# Define a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Fetch a specific security group by name
data "aws_security_group" "ssh_sg" {
  filter {
    name   = "group-name"
    values = ["httpd-webserver-sg"]  # Replace with your actual security group name
  }
  vpc_id = aws_vpc.main.id  # Ensure this references the VPC we created
}