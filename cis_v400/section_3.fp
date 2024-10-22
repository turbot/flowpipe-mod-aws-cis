locals {
  cis_v400_3_control_mapping = {
    cis_v400_3_01  = pipeline.cis_v400_3_1
    cis_v400_3_02  = pipeline.cis_v400_3_2
    cis_v400_3_03  = pipeline.cis_v400_3_3
    cis_v400_3_04  = pipeline.cis_v400_3_4
    cis_v400_3_05  = pipeline.cis_v400_3_5
    cis_v400_3_06  = pipeline.cis_v400_3_6
    cis_v400_3_07  = pipeline.cis_v400_3_7
    cis_v400_3_08  = pipeline.cis_v400_3_8
    cis_v400_3_09  = pipeline.cis_v400_3_9
  }
}

pipeline "cis_v400_3" {
  title         = "3 Logging"
  documentation = file("./cis_v400/docs/cis_v400_3.md")

  tags = {
	  folder = "CIS v4.0.0/3 Logging"
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
    text     = "3 Logging"
  }

  step "pipeline" "cis_v400_3" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v400_3_control_mapping))-1)
    }

    pipeline = local.cis_v400_1_control_mapping[keys(local.cis_v400_3_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_3_1" {
  title         = "3.1 Ensure CloudTrail is enabled in all regions"
  documentation = file("./cis_v400/docs/cis_v400_3_1.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.1 Ensure CloudTrail is enabled in all regions"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_cloudtrail_trails_with_multi_region_read_write_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_3_2" {
  title         = "3.2 Ensure CloudTrail log file validation is enabled"
  documentation = file("./cis_v400/docs/cis_v400_3_2.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.2 Ensure CloudTrail log file validation is enabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_cloudtrail_trails_with_log_file_validation_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_3_3" {
  title         = "3.3 Ensure AWS Config is enabled in all regions"
  documentation = file("./cis_v400/docs/cis_v400_3_3.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.3 Ensure AWS Config is enabled in all regions"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_config_disabled_in_regions

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_3_4" {
  title         = "3.4 Ensure that server access logging is enabled on the CloudTrail S3 bucket"
  documentation = file("./cis_v400/docs/cis_v400_3_4.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.4 Ensure that server access logging is enabled on the CloudTrail S3 bucket"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_cloudtrail_trails_with_s3_logging_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_3_5" {
  title         = "3.5 Ensure CloudTrail logs are encrypted at rest using KMS CMKs"
  documentation = file("./cis_v400/docs/cis_v400_3_5.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.5 Ensure CloudTrail logs are encrypted at rest using KMS CMKs"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_cloudtrail_trail_logs_not_encrypted_with_kms_cmk

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_3_6" {
  title         = "3.6 Ensure rotation for customer-created symmetric CMKs is enabled"
  documentation = file("./cis_v400/docs/cis_v400_3_6.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.6 Ensure rotation for customer-created symmetric CMKs is enabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_kms_keys_with_rotation_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_3_7" {
  title         = "3.7 Ensure VPC flow logging is enabled in all VPCs"
  documentation = file("./cis_v400/docs/cis_v400_3_7.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.7 Ensure VPC flow logging is enabled in all VPCs"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_vpcs_without_flow_logs

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_3_8" {
  title         = "3.8 Ensure that object-level logging for write events is enabled for S3 buckets"
  documentation = file("./cis_v400/docs/cis_v400_3_8.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.8 Ensure that object-level logging for write events is enabled for S3 buckets"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_cloudtrail_trails_with_s3_object_level_logging_for_write_events_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_3_9" {
  title         = "3.9 Ensure that object-level logging for read events is enabled for S3 buckets"
  documentation = file("./cis_v400/docs/cis_v400_3_9.md")

  tags = {
    folder = "CIS v4.0.0/3 Logging"
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
    text     = "3.9 Ensure that object-level logging for read events is enabled for S3 buckets"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_cloudtrail_trails_with_s3_object_level_logging_for_read_events_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}
