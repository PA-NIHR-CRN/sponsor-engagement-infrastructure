module "waf" {
  source = "./code"
  # enabled     = data.external.check_waf_exists.result.result
  enabled     = var.waf_create
  name_prefix = var.name

  allow_default_action = true

  scope = var.waf_scope

  create_alb_association = true
  alb_arn                = var.alb_arn

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-metric"
    sampled_requests_enabled   = false
  }

  create_logging_configuration = var.enable_logging
  log_destination_configs      = var.log_group
  rules = [

    // WAF AWS Managed Rule 

    {
      name            = "${var.name}-commonruleset"
      priority        = 0
      override_action = "none"

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        excluded_rule = [
          "NoUserAgent_HEADER",
          "UserAgent_BadBots_HEADER",
          "SizeRestrictions_QUERYSTRING",
          "SizeRestrictions_Cookie_HEADER",
          "SizeRestrictions_BODY",
          "SizeRestrictions_URIPATH",
          "EC2MetaDataSSRF_BODY",
          "EC2MetaDataSSRF_COOKIE",
          "EC2MetaDataSSRF_URIPATH",
          "EC2MetaDataSSRF_QUERYARGUMENTS",
          "RestrictedExtensions_URIPATH",
          "RestrictedExtensions_QUERYARGUMENTS",
          "GenericRFI_QUERYARGUMENTS",
          "GenericRFI_BODY",
          "GenericRFI_URIPATH",
          "CrossSiteScripting_COOKIE",
          "CrossSiteScripting_QUERYARGUMENTS",
          "CrossSiteScripting_BODY",
          "CrossSiteScripting_URIPATH"
        ]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.name}-commonruleset-metric"
        sampled_requests_enabled   = false
      }
    },
    {
      name            = "${var.name}-knownbadnnputsruleset",
      priority        = 1
      override_action = "none"

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
        excluded_rule = [
          "Host_localhost_HEADER",
          "PROPFIND_METHOD"
        ]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.name}-knownbadnnputsruleset-metric"
        sampled_requests_enabled   = true
      }

    },
    {
      name            = "${var.name}-ipreputationlist",
      priority        = 2
      override_action = "none"

      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        excluded_rule = [
          "AWSManagedIPReputationList",
          "AWSManagedReconnaissanceList"
        ]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.name}-ipreputationlist-metric"
        sampled_requests_enabled   = true
      }

    },
    {
      name            = "${var.name}-httpfloodprotection",
      priority        = 3
      override_action = "none"

      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        excluded_rule = [
          "AWSManagedIPReputationList",
          "AWSManagedReconnaissanceList"
        ]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.name}-metric"
        sampled_requests_enabled   = true
      }

    }

  ]

  tags = {
    Name        = var.name
    Environment = var.env
    System      = var.system
  }
}
