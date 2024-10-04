# data_sources.tf

# Generate a private key (PEM format)
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key as a PEM file locally using a local file provisioner
resource "local_file" "save_pem" {
  filename = ".ssh/my-terraform-key.pem"  # This will save the file locally
  content  = tls_private_key.terraform_key.private_key_pem
  file_permission = "0400"  # Set appropriate permissions for the PEM file
}

# Use the generated public key to create the AWS Key Pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.terraform_key.public_key_openssh
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