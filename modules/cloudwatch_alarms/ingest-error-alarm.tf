resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "${var.account}-cloudwatch-${var.env}-${var.app}-ingest-error-filter"
  pattern        = "{$.level = 50}"
  log_group_name = var.ingest_log_group

  metric_transformation {
    name      = "ErrorCount"
    namespace = "SE/${var.env}-se-ecs-ingest-errors"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-ingest-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = "SE/${var.env}-se-ecs-ingest-errors"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"

  alarm_description = "Alarm when an error has occured for the Sponsor Engagement ingest daily task"
  alarm_actions     = [var.sns_topic]

  dimensions = {
    LogGroupName = var.ingest_log_group
  }

  treat_missing_data = "notBreaching"
}