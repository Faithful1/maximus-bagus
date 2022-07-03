module "label" {
  source     = "../../terraform-label"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days

  tags = module.label.tags
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}

# Set up log group and log stream for tasks
# This is not necessary for cms since cms does not need a task thing running
# so enable should be false
resource "aws_cloudwatch_log_group" "tasks_log_group" {
  count             = var.enable_logs ? 1 : 0
  name              = var.tasks_log_group_name
  retention_in_days = var.retention_in_days

  tags = module.label.tags
}

resource "aws_cloudwatch_log_stream" "task_log_stream" {
  count          = var.enable_logs ? 1 : 0
  name           = var.tasks_log_stream_name
  log_group_name = element(aws_cloudwatch_log_group.tasks_log_group.*.name, count.index)
}
