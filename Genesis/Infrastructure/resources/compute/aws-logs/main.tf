# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_logs ? 1 : 0
  name              = var.genesis_app_log_group_name
  retention_in_days = var.genesis_app_log_retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  count          = var.enable_logs ? 1 : 0
  name           = var.genesis_app_log_stream_name
  log_group_name = aws_cloudwatch_log_group.this.name
}
