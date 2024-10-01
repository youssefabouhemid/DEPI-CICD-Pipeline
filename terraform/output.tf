output "k3s_instance_public_ip" {
  value = aws_instance.k3s_instance.public_ip
}

output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}
# jenkins_instance_public_ip = "50.16.52.70"
# k3s_instance_public_ip = "3.89.39.92"