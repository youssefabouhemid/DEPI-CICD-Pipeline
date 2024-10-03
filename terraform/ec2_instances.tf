# Fetch the latest Ubuntu AMI for EC2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# You can define your EC2 instances here, making sure to reference the VPC, subnet, and security group
resource "aws_instance" "k3s_instance" {
  ami                    = data.aws_ami.ubuntu.id  # Use the fetched Ubuntu AMI
  instance_type         = "t2.micro"
  key_name              = aws_key_pair.terraform_key.key_name  # Use the created key pair
  subnet_id             = aws_subnet.public.id  # Ensure it's attached to the public subnet
  vpc_security_group_ids = [data.aws_security_group.ssh_sg.id]  # Use the fetched security group

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y curl
              curl -sfL https://get.k3s.io | sh -
            EOF

  tags = {
    Name = "k3s-instance"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                    = data.aws_ami.ubuntu.id  # Use the fetched Ubuntu AMI
  instance_type         = "t2.micro"
  key_name              = aws_key_pair.terraform_key.key_name  # Use the created key pair
  subnet_id             = aws_subnet.public.id  # Ensure it's attached to the public subnet
  vpc_security_group_ids = [data.aws_security_group.ssh_sg.id]  # Use the fetched security group

  tags = {
    Name = "jenkins-instance"
  }
}