variable "aws_ecs_cluster_name" {
  type        = string
  description = "Name of ECS cluster."
}

variable "aws_ecs_service_name" {
  type        = string
  description = "Name of ECS service."
}

variable "sns_topic_name_for_service_cpu_high" {
  type        = string
  description = "Name of SNS topic for high cpu monitor."
}

variable "email_for_subscription" {
  type        = string
  description = "Email for sns subscription."
}

