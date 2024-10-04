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
  ami                     = data.aws_ami.ubuntu.id  
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.public.id  # Reference the public subnet directly
  vpc_security_group_ids  = [aws_security_group.k3s_sg.id]  # Reference the created SG directly
  key_name                = aws_key_pair.terraform_key.key_name # Reference the created key in data

  associate_public_ip_address = true
  
  user_data = file("../scripts/k3s-ec2-script.sh")

  tags = {
    Name = "k3s-instance"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type         =  var.instance_type
  key_name              = aws_key_pair.terraform_key.key_name
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]   # Reference the created SG directly

  associate_public_ip_address = true

  tags = {
    Name = "jenkins-instance"
  }
}