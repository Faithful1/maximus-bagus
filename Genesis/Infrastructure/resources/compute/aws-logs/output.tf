output "ecs_logs_name" {
  value = aws_cloudwatch_log_group.app_log_group.name
}

# use this also for production
output "tasks_ecs_logs_name" {
  value = aws_cloudwatch_log_group.tasks_log_group[0].name
}

# CMS does not need any tasks logs
