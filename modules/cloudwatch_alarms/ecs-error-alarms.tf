resource "aws_cloudwatch_log_metric_filter" "ecs_error_filter" {
  name           = "${var.account}-cloudwatch-${var.env}-${var.app}-web-error-filter"
  pattern        = "{$.level = 50 && $.err.config.params.grant_type != \"refresh_token\"}"
  log_group_name = var.web_log_group

  metric_transformation {
    name      = "ErrorCount"
    namespace = "SE/${var.env}-se-ecs-web-errors"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_error_alarm" {
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-web-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = "SE/${var.env}-se-ecs-web-errors"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"

  alarm_description = "Alarm when an error has occured for the Sponsor Engagement Web"
  alarm_actions     = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions        = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-web-error-alarm"
    Environment = var.env
    System      = var.app
  }
}



# ECS INGEST ALARM

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
  statistic           = "Minimum"
  threshold           = "1"

  alarm_description = "Alarm when an error has occured for the Sponsor Engagement ingest daily task"
  alarm_actions     = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions        = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-ingest-error-alarm"
    Environment = var.env
    System      = var.app
  }
}

# ECS NOTIFY ALARM

resource "aws_cloudwatch_log_metric_filter" "notify_error_filter" {
  name           = "${var.account}-cloudwatch-${var.env}-${var.app}-notify-error-filter"
  pattern        = "{$.level = 50}"
  log_group_name = var.notify_log_group

  metric_transformation {
    name      = "ErrorCount"
    namespace = "SE/${var.env}-se-ecs-notify-errors"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "notify_error_alarm" {
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-notify-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = "SE/${var.env}-se-ecs-notify-errors"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"

  alarm_description = "Alarm when an error has occured for the Sponsor Engagement notify daily task"
  alarm_actions     = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions        = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-notify-error-alarm"
    Environment = var.env
    System      = var.app
  }
}

# ECS INVITATION-MONITOR ALARM

resource "aws_cloudwatch_log_metric_filter" "invitation_monitor_error_filter" {
  name           = "${var.account}-cloudwatch-${var.env}-${var.app}-invitation-monitor-error-filter"
  pattern        = "{$.level = 50}"
  log_group_name = var.invitation_monitor_log_group

  metric_transformation {
    name      = "ErrorCount"
    namespace = "SE/${var.env}-se-ecs-invitation-monitor-errors"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "invitation_monitor_error_alarm" {
  alarm_name          = "${var.account}-cloudwatch-${var.env}-${var.app}-invitation-monitor-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = "SE/${var.env}-se-ecs-invitation-monitor-errors"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"

  alarm_description = "Alarm when an error has occured for the Sponsor Engagement invitation-monitor daily task"
  alarm_actions     = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]
  ok_actions        = var.env == "prod" ? [var.sns_topic, var.sns_topic_service_desk] : [var.sns_topic]

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "${var.account}-cloudwatch-${var.env}-${var.app}-invitation-monitor-error-alarm"
    Environment = var.env
    System      = var.app
  }
}
