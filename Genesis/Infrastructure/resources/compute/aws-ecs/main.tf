resource "aws_ecs_cluster" "main" {
  name = var.genesis_cluster_name
}

# Main ECS service
resource "aws_ecs_service" "main" {
  name             = var.ecs_service_name
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.genesis_app_definition.arn
  desired_count    = var.genesis_desired_count
  launch_type      = var.launch_type
  platform_version = var.ecs_platform_version

  network_configuration {
    security_groups  = [var.ecs_tasks_sg]
    subnets          = var.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_id
    container_name   = var.container_name
    container_port   = var.app_port
  }

  depends_on = [var.alb_listener, var.iam_role_policy_attachment]
}

# Genesis app ECS task definition
resource "aws_ecs_task_definition" "genesis_app_definition" {
  family                   = var.container_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.genesis_app_template_file.rendered
  tags                     = var.tags
}

data "template_file" "genesis_app_template_file" {
  template = file("${path.module}${var.path_to_template}")

  vars = {
    fargate_cpu     = var.fargate_cpu
    task_name       = var.container_name
    app_image       = var.app_image
    app_port        = var.app_port
    fargate_memory  = var.fargate_memory
    aws_region      = var.aws_region
    logs_group_name = var.logs_group_name
  }
}
