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
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]

  dimensions = {
    DBInstanceIdentifier = var.cluster_instances[count.index]
  }
  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-rds-aurora-cpu-utilization-${count.index}"
    Environment = var.env
    System      = var.app
  }
}