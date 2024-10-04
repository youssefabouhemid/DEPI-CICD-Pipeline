# Fetch the latest Ubuntu AMI for EC2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


resource "aws_instance" "k3s_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type         = "t2.micro"
  key_name              = aws_key_pair.terraform_key.key_name
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]   # Reference the created SG directly

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
  ami                    = data.aws_ami.ubuntu.id
  instance_type         = "t2.micro"
  key_name              = aws_key_pair.terraform_key.key_name
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]   # Reference the created SG directly

  tags = {
    Name = "jenkins-instance"
  }
}