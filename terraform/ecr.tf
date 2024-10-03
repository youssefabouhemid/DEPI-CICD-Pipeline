# ecr.tf

# Create an ECR repository for the Python app
resource "aws_ecr_repository" "python_app" {
  name = "python-app"
}
