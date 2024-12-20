locals {
  cis_v400_4_control_mapping = {
    cis_v400_4_01 = pipeline.cis_v400_4_1
    cis_v400_4_02 = pipeline.cis_v400_4_2
    cis_v400_4_03 = pipeline.cis_v400_4_3
    cis_v400_4_04 = pipeline.cis_v400_4_4
    cis_v400_4_05 = pipeline.cis_v400_4_5
    cis_v400_4_06 = pipeline.cis_v400_4_6
    cis_v400_4_07 = pipeline.cis_v400_4_7
    cis_v400_4_08 = pipeline.cis_v400_4_8
    cis_v400_4_09 = pipeline.cis_v400_4_9
    cis_v400_4_10 = pipeline.cis_v400_4_10
    cis_v400_4_11 = pipeline.cis_v400_4_11
    cis_v400_4_12 = pipeline.cis_v400_4_12
    cis_v400_4_13 = pipeline.cis_v400_4_13
    cis_v400_4_14 = pipeline.cis_v400_4_14
    cis_v400_4_15 = pipeline.cis_v400_4_15
    cis_v400_4_16 = pipeline.cis_v400_4_16
  }
}

pipeline "cis_v400_4" {
  title         = "4 Monitoring"
  description   = "This section contains recommendations for configuring AWS to assist with monitoring and responding to account activities."
  documentation = file("./cis_v400/docs/cis_v400_4.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4 Monitoring"
  }

  step "pipeline" "cis_v400_4" {
    depends_on = [step.message.header]
    loop {
      until = loop.index >= (length(keys(local.cis_v400_4_control_mapping)) - 1)
    }

    pipeline = local.cis_v400_4_control_mapping[keys(local.cis_v400_4_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_1" {
  title         = "4.1 Ensure unauthorized API calls are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_1.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.1 Ensure unauthorized API calls are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_unauthorized_api_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_2" {
  title         = "4.2 Ensure management console sign-in without MFA is monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_2.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.2 Ensure management console sign-in without MFA is monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_console_login_mfa_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_3" {
  title         = "4.3 Ensure usage of the 'root' account is monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_3.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.3 Ensure usage of the 'root' account is monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_root_login

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_4" {
  title         = "4.4 Ensure IAM policy changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_4.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.4 Ensure IAM policy changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_iam_policy_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_5" {
  title         = "4.5 Ensure CloudTrail configuration changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, where metric filters and alarms can be established."
  documentation = file("./cis_v400/docs/cis_v400_4_5.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.5 Ensure CloudTrail configuration changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_cloudtrail_configuration

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_6" {
  title         = "4.6 Ensure AWS Management Console authentication failures are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_6.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.6 Ensure AWS Management Console authentication failures are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_console_authentication_failure

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_7" {
  title         = "4.7 Ensure disabling or scheduled deletion of customer created CMKs is monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_7.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.7 Ensure disabling or scheduled deletion of customer created CMKs is monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_disable_or_delete_cmk

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_8" {
  title         = "4.8 Ensure S3 bucket policy changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_8.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.8 Ensure S3 bucket policy changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_bucket_policy_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_9" {
  title         = "4.9 Ensure AWS Config configuration changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_9.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.9 Ensure AWS Config configuration changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_config_configuration_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_10" {
  title         = "4.10 Ensure security group changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_10.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.10 Ensure security group changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_security_group_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_11" {
  title         = "4.11 Ensure Network Access Control List (NACL) changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_11.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.11 Ensure Network Access Control List (NACL) changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_network_acl_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_12" {
  title         = "4.12 Ensure changes to network gateways are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_12.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.12 Ensure changes to network gateways are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_network_gateway_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_13" {
  title         = "4.13 Ensure route table changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_13.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.13 Ensure route table changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_route_table_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_14" {
  title         = "4.14 Ensure VPC changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, or an external Security information and event management (SIEM) environment, and establishing corresponding metric filters and alarms."
  documentation = file("./cis_v400/docs/cis_v400_4_14.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.14 Ensure VPC changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_vpc_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_15" {
  title         = "4.15 Ensure AWS Organizations changes are monitored"
  description   = "Real-time monitoring of API calls can be achieved by directing CloudTrail Logs to CloudWatch Logs, and establishing corresponding metric filters and alarms. It is recommended that a metric filter and alarm be established for AWS Organizations changes made in the master AWS Account."
  documentation = file("./cis_v400/docs/cis_v400_4_15.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.15 Ensure AWS Organizations changes are monitored"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_metric_filter_for_organization_changes

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_4_16" {
  title         = "4.16 Ensure AWS Security Hub is enabled"
  description   = "Security Hub collects security data from across AWS accounts, services, and supported third-party partner products and helps you analyze your security trends and identify the highest priority security issues."
  documentation = file("./cis_v400/docs/cis_v400_4_16.md")

  tags = {
    folder = "CIS v4.0.0/4 Monitoring"
  }

  param "database" {
    type        = connection.steampipe
    description = local.description_database
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = local.description_notifier
    default     = var.notifier
  }

  param "notification_level" {
    type        = string
    description = local.description_notifier_level
    default     = var.notification_level
  }

  param "approvers" {
    type        = list(notifier)
    description = local.description_approvers
    default     = var.approvers
  }

  step "message" "header" {
    notifier = param.notifier
    text     = "4.16 Ensure AWS Security Hub is enabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_security_hub_disabled_in_regions

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}
