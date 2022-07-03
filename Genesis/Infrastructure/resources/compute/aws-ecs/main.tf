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

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# ---------------------------------------------------------------------------------------------------
# MAIN ECS SERVICE
resource "aws_ecs_service" "main" {
  name             = var.ecs_service_name
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.app_count
  launch_type      = var.launch_type
  platform_version = "1.4.0"

  network_configuration {
    security_groups  = [var.ecs_tasks_sg]
    subnets          = var.private_subnets //should be private subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_id //for Port exposed by the docker image to redirect traffic to
    container_name   = var.container_name
    container_port   = var.app_port
  }

  depends_on = [var.alb_listener, var.iam_role_policy_attachment]
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.container_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                   = var.fargate_cpu
  memory                = var.fargate_memory
  execution_role_arn    = var.ecs_task_execution_role_arn
  container_definitions = data.template_file.myapp.rendered

  # define efs volume in task definition
  # setup the volume environment and the mount points on task definition json file
  # volume {
  #   name = var.container_volume_name

  #   efs_volume_configuration {
  #     file_system_id = var.aws_efs_file_system_id
  #     # root_directory     = var.mount_point_path
  #     transit_encryption = "ENABLED"
  #     authorization_config {
  #       access_point_id = var.aws_efs_access_point_id
  #       # iam             = "ENABLED"
  #     }
  #   }
  # }

  tags = module.label.tags
}

data "template_file" "myapp" {
  template = file("${path.module}${var.path_to_template}")

  vars = {
    task_name = var.container_name
    # container_volume_name     = var.container_volume_name
    app_image                  = var.app_image
    app_port                   = var.app_port
    fargate_cpu                = var.fargate_cpu
    fargate_memory             = var.fargate_memory
    aws_region                 = var.aws_region
    logs_group_name            = var.logs_group_name
    aws_rds_mysql_server       = var.aws_rds_mysql_server_endpoint
    aws_rds_mysql_db_username  = var.aws_rds_mysql_db_username
    aws_rds_mysql_db_password  = var.aws_rds_mysql_db_password
    ss_username                = var.ss_username
    ss_password                = var.ss_password
    ss_session_key             = var.ss_session_key
    ss_bucket_region           = var.ss_bucket_region
    ss_bucket_name             = var.ss_bucket_name
    ss_aws_key_id              = var.ss_aws_key_id
    ss_secret_access_key       = var.ss_secret_access_key
    ss_cf_aws_key_id           = var.ss_cf_aws_key_id
    ss_cf_secret_access_key    = var.ss_cf_secret_access_key
    aws_rds_mysql_db_name      = var.aws_rds_mysql_db_name
    sentry_dsn                 = var.sentry_dsn
    starrez_usa_password       = var.starrez_usa_password
    starrez_aus_username       = var.starrez_aus_username
    starrez_aus_password       = var.starrez_aus_password
    starrez_nz_username        = var.starrez_nz_username
    starrez_nz_password        = var.starrez_nz_password
    starrez_uk_username        = var.starrez_uk_username
    starrez_uk_password        = var.starrez_uk_password
    starrez_uk_portal_username = var.starrez_uk_portal_username
    starrez_uk_portal_password = var.starrez_uk_portal_password
    mail_gun_api_key           = var.mail_gun_api_key
    mail_gun_domain            = var.mail_gun_domain
    cloudfront_id              = var.cloudfront_id
    google_recaptcha_secret    = var.google_recaptcha_secret

    # volume_name               = var.container_volume_name
    # container_path            = var.mount_point_path
  }
}

# -----------------------------------------------------------------------------------------------------------
# PROD TASKS SCHEDULER
# fargate scheduled tasks container
module "ecs_scheduled_task" {
  count                          = var.enable_scheduler ? 1 : 0
  source                         = "git::https://github.com/tmknom/terraform-aws-ecs-scheduled-task.git?ref=tags/2.0.0"
  task_count                     = 1
  is_enabled                     = true
  enabled                        = true
  assign_public_ip               = true
  create_ecs_task_execution_role = false
  cluster_arn                    = aws_ecs_cluster.main.arn
  name                           = var.tasks_container_name
  schedule_expression            = var.cron_schedule
  container_definitions          = element(data.template_file.tasks.*.rendered, count.index)
  subnets                        = var.private_subnets
  cpu                            = var.tasks_fargate_cpu
  memory                         = var.tasks_fargate_memory
  security_groups                = [var.ecs_tasks_sg]
  platform_version               = "1.4.0"
  requires_compatibilities       = ["FARGATE"]
  ecs_task_execution_role_arn    = var.ecs_task_execution_role_arn

  tags = {
    Name = "campus-living-village-tasks"
  }

  depends_on = [var.iam_role_policy_attachment]
}


#---------------------------------------------------
# setup for our tasks container service

data "template_file" "tasks" {
  count    = var.enable_scheduler ? 1 : 0
  template = file("${path.module}${var.path_to_tasks_template}")

  vars = {
    task_name                  = var.tasks_container_name
    app_image                  = var.tasks_app_image
    app_port                   = var.app_port
    fargate_cpu                = var.tasks_fargate_cpu
    fargate_memory             = var.tasks_fargate_memory
    aws_region                 = var.aws_region
    logs_group_name            = var.tasks_logs_group_name
    aws_rds_mysql_server       = var.aws_rds_mysql_server_endpoint
    aws_rds_mysql_db_username  = var.aws_rds_mysql_db_username
    aws_rds_mysql_db_password  = var.aws_rds_mysql_db_password
    ss_username                = var.ss_username
    ss_password                = var.ss_password
    ss_session_key             = var.ss_session_key
    ss_bucket_region           = var.ss_bucket_region
    ss_bucket_name             = var.ss_bucket_name
    ss_aws_key_id              = var.ss_aws_key_id
    ss_secret_access_key       = var.ss_secret_access_key
    ss_cf_aws_key_id           = var.ss_cf_aws_key_id
    ss_cf_secret_access_key    = var.ss_cf_secret_access_key
    aws_rds_mysql_db_name      = var.aws_rds_mysql_db_name
    sentry_dsn                 = var.sentry_dsn
    volume_name                = var.container_volume_name
    starrez_usa_password       = var.starrez_usa_password
    starrez_aus_username       = var.starrez_aus_username
    starrez_aus_password       = var.starrez_aus_password
    starrez_nz_username        = var.starrez_nz_username
    starrez_nz_password        = var.starrez_nz_password
    starrez_uk_username        = var.starrez_uk_username
    starrez_uk_password        = var.starrez_uk_password
    starrez_uk_portal_username = var.starrez_uk_portal_username
    starrez_uk_portal_password = var.starrez_uk_portal_password
    mail_gun_api_key           = var.mail_gun_api_key
    mail_gun_domain            = var.mail_gun_domain
    cloudfront_id              = var.cloudfront_id
    google_recaptcha_secret    = var.google_recaptcha_secret
  }
}
