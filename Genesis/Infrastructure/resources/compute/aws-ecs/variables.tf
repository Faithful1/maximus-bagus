# Labels
variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "owner" {
  type        = string
  description = "managed-by e.g. 'terraform'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev'"
}

variable "ecs_service_name" {
  default = ""
}

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. `app` or `docker`"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster name, e.g. `app` or `docker`"
}

# main containers config details

variable "container_name" {
  description = "name of the ECS container"
  default     = ""
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

# tasks containers config details
variable "tasks_container_name" {
  description = "name of the ECS container"
  default     = ""
}

variable "tasks_fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "tasks_fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "tasks_service_name" {
  default = ""
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = ""
}

variable "tasks_app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = ""
}

# shared task definition details

variable "aws_rds_mysql_server" {
  description = "db server endpoint"
  default     = ""
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 0
}

variable "tasks_app_count" {
  description = "Number of docker containers to run"
  default     = 0
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-southeast-2"
}

variable "ss_secret_access_key" {
  description = "The AWS secret key for SS"
  default     = ""
}

variable "ss_aws_key_id" {
  description = "The AWS access key for SS"
  default     = ""
}

variable "ss_cf_aws_key_id" {
  description = "The AWS access key for SS"
  default     = ""
}

variable "ss_cf_secret_access_key" {
  description = "The AWS secret key for SS"
  default     = ""
}

variable "ecs_task_execution_role_arn" {
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "private_subnets" {
  type = list(string)
}

variable "ecs_tasks_sg" {
  default = ""
}

variable "alb_target_group_id" {
  default = ""
}

variable "alb_listener" {
  default = ""
}

variable "iam_role_policy_attachment" {
  default = ""
}

variable "logs_group_name" {
  default = ""
}

variable "tasks_logs_group_name" {
  default = ""
}

variable "launch_type" {
  default = ""
}

variable "ss_bucket_name" {
  default = ""
}

variable "aws_rds_mysql_server_endpoint" {
  default = ""
}

variable "aws_rds_mysql_db_username" {
  default = ""
}

variable "aws_rds_mysql_db_name" {
  default = ""
}

variable "aws_rds_mysql_db_password" {
  default   = ""
  sensitive = true
}

variable "ss_username" {
  default = ""
}

variable "ss_password" {
  default   = ""
  sensitive = true
}

variable "ss_session_key" {
  default = ""
}

variable "ss_bucket_region" {
  default = ""
}

variable "sentry_dsn" {
  default = ""
  type    = string
}

variable "starrez_usa_username" {
  default = ""
  type    = string
}

variable "starrez_usa_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "starrez_aus_username" {
  default = ""
  type    = string
}

variable "starrez_aus_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "starrez_nz_username" {
  default = ""
  type    = string
}

variable "starrez_nz_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "starrez_uk_username" {
  default = ""
  type    = string
}

variable "starrez_uk_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "starrez_uk_portal_username" {
  default = ""
  type    = string
}

variable "starrez_uk_portal_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "container_volume_name" {
  description = "container volume"
  type        = string
}

variable "mail_gun_api_key" {
  default = ""
  type    = string
}

variable "mail_gun_domain" {
  description = "mail gun domain"
  type        = string
}

variable "cloudfront_id" {
  description = "cloudfront id"
  type        = string
}

variable "google_recaptcha_secret" {
  description = "google recaptcha secret"
  type        = string
}

# variable "aws_efs_access_point_id" {
#   description = "access id of the efs access point"
#   default     = ""
# }

# variable "aws_efs_file_system_id" {
#   description = "file system id of the efs"
#   default     = ""
# }

# variable "mount_point_path" {
#   description = "mount point for efs"
#   default     = "/var/www/html/silverstripe-cache"
# }

variable "path_to_template" {
  description = "path to template"
  default     = ""
}

variable "path_to_tasks_template" {
  description = "path to task template"
  default     = ""
}

variable "cron_schedule" {
  description = "cron job schedule in mins e.g rate(15 minutes)"
  default     = ""
}

variable "enable_scheduler" {
  description = "If true, scheduler is deployed"
  type        = bool
  default     = false
}
