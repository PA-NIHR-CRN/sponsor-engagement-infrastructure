resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = length(var.cluster_instances)
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-rds-aurora-cpu-utilization-${count.index}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "65"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions          = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]

  dimensions = {
    DBInstanceIdentifier = var.cluster_instances[count.index]
  }
  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-rds-aurora-cpu-utilization-${count.index}"
    Environment = var.env
    System      = var.app
  }
}

// Memory Utilization
resource "aws_cloudwatch_metric_alarm" "memory_freeable_too_low" {
  count               = length(var.cluster_instances)
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-rds-aurora-lowFreeableMemory-${count.index}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "512000000"
  alarm_description   = "Average database freeable memory is too low, performance may be negatively impacted."
  alarm_actions       = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions          = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  dimensions = {
    DBInstanceIdentifier = var.cluster_instances[count.index]
  }
  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-rds-aurora-lowFreeableMemory-${count.index}"
    Environment = var.env
    System      = var.app
  }
}

// Connection Count
resource "aws_cloudwatch_metric_alarm" "alarm_rds_DatabaseConnections" {
  count               = length(var.cluster_instances)
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-rds-aurora-DatabaseConnections-${count.index}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.rds_max_connections
  alarm_description   = "Database Connections to RDS is greater than ${var.rds_max_connections}"
  alarm_actions       = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions          = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]

  dimensions = {
    DBInstanceIdentifier = var.cluster_instances[count.index]
  }
}