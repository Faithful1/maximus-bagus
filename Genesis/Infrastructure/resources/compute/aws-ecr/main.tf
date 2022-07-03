# Create ECR repository resource
resource "aws_ecr_repository" "this" {
  name                 = var.genesis_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}
