# outputs.tf

# Output for k3s EC2 instance ID
output "k3s_instance_id" {
  value = aws_instance.k3s_instance.id
}

# Output for Jenkins EC2 instance ID
output "jenkins_instance_id" {
  value = aws_instance.jenkins_instance.id
}

# Output ECR repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.python_app.repository_url
}