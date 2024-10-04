# outputs.tf

# Output the private key in PEM format to be saved locally
output "private_key_pem" {
  value     = tls_private_key.terraform_key.private_key_pem
  sensitive = true  # Mark the output as sensitive so it's not exposed in logs
}

# Output for k3s EC2 instance ID
output "k3s_instance_id" {
  value = aws_instance.k3s_instance.id
}

# Output for Jenkins EC2 instance ID
output "jenkins_instance_id" {
  value = aws_instance.jenkins_instance.id
}

output "k3s_instance_public_ip" {
  value = aws_instance.k3s_instance.public_ip
}

output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}

# Output ECR repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.python_app.repository_url
}