# security_groups.tf

# Security group for SSH access
resource "aws_security_group" "k3s_sg" {

  # NOT Optional: A description of the security group
  description = "Security group for SSH access to K3s instances"

  vpc_id =  aws_vpc.main.id 
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s_sg"  # Optional: tag for easier identification
  }
}