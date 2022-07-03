# configure labels
module "label" {
  source     = "../../terraform-label"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

# Set up ecr (prod and staging are using setup - this)
resource "aws_ecr_repository" "this" {
  count                = var.is_staging ? 1 : 0
  name                 = var.main_repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_repository" "this_task_prod" {
  count                = var.is_prod ? 1 : 0
  name                 = var.task_repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_repository" "this_cms_prod" {
  count                = var.is_cms ? 1 : 0
  name                 = var.cms_repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}