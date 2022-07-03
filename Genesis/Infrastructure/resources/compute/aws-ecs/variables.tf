variable "genesis_cluster_name" {
  type        = string
  default     = ""
  description = "Cluster name, e.g. `genesis` or `primary`"
}

variable "ecs_service_name" {
  description = "Name of the ecs service"
}

variable "genesis_desired_count" {
  description = "Number of containers to run"
  default     = 0
}

variable "launch_type" {}

variable "ecs_platform_version" {
  description = "Platform version on which to run your service."
  default     = "1.4.0"
}

variable "ecs_tasks_sg" {}

variable "private_subnets" {
  type = list(string)
}

variable "alb_target_group_id" {}

variable "container_name" {
  description = "Name of the app container"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "alb_listener" {}

variable "iam_role_policy_attachment" {}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "ecs_task_execution_role_arn" {}

variable "path_to_template" {
  description = "path to template"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-west-2"
}
S
variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = ""
}

variable "logs_group_name" {}

variable "path_to_tasks_template" {
  description = "path to task template"
  default     = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}
