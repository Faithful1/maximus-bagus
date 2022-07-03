resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 1
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "genesis_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "genesis_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "genesis_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = var.aws_ecs_cluster_name
    ServiceName = var.aws_ecs_service_name
  }

  alarm_actions = [
    aws_appautoscaling_policy.up.arn,
    aws_sns_topic.this.arn
  ]
}

# Only create sns topic that notifies for high cpu
resource "aws_sns_topic" "this" {
  name = var.sns_topic_name_for_service_cpu_high
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.email_for_subscription
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "genesis_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = var.aws_ecs_cluster_name
    ServiceName = var.aws_ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}
