# ec2_instances.tf

# EC2 instance for Kubernetes (k3s) - Ubuntu AMI
resource "aws_instance" "k3s_instance" {
  ami           = data.aws_ami.ubuntu.id  
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [data.aws_security_group.ssh_sg.id]
  key_name      = var.key_name

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

# EC2 instance for Jenkins and Docker - Ubuntu AMI
resource "aws_instance" "jenkins_instance" {
  ami           = data.aws_ami.ubuntu.id  
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [data.aws_security_group.ssh_sg.id]
  key_name      = var.key_name

  tags = {
    Name = "jenkins-instance"
  }
}