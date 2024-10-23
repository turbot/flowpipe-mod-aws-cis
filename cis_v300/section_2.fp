locals {
  cis_v300_2_control_mapping = {
    cis_v300_2_1_1 = pipeline.cis_v300_2_1_1
    cis_v300_2_1_2 = pipeline.cis_v300_2_1_2
    cis_v300_2_1_3 = pipeline.cis_v300_2_1_3
    cis_v300_2_1_4 = pipeline.cis_v300_2_1_4
    cis_v300_2_2_1 = pipeline.cis_v300_2_2_1
    cis_v300_2_3_1 = pipeline.cis_v300_2_3_1
    cis_v300_2_3_2 = pipeline.cis_v300_2_3_2
    cis_v300_2_3_3 = pipeline.cis_v300_2_3_3
    cis_v300_2_4_1 = pipeline.cis_v300_2_4_1
  }
}

pipeline "cis_v300_2" {
  title         = "2 Storage"
  description   = "This section contains recommendations for configuring AWS Storage."
  documentation = file("./cis_v300/docs/cis_v300_2.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage"
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
    text     = "2 Storage"
  }

  step "pipeline" "cis_v300_2" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_2_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_2_control_mapping[keys(local.cis_v300_2_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

/*
# TODO: Is there a way to include subsections without cyclic dependencies? Do we want them?
pipeline "cis_v300_2_1" {
  title         = "2.1 Simple Storage Service (S3)"
  #documentation = file("./cis_v300/docs/cis_v300_2_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.1 Simple Storage Service (S3)"
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
    text     = "2.1 Simple Storage service (S3)"
  }

  step "pipeline" "run_pipelines" {
    depends_on = [step.message.header]
    for_each   = var.cis_v300_2_1_enabled_pipelines
    pipeline   = local.cis_v300_2_1_control_mapping[each.value]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}
*/

pipeline "cis_v300_2_1_1" {
  title         = "2.1.1 Ensure S3 Bucket Policy is set to deny HTTP requests"
  description   = "At the Amazon S3 bucket level, you can configure permissions through a bucket policy making the objects accessible only through HTTPS."
  documentation = file("./cis_v300/docs/cis_v300_2_1_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.1 Simple Storage Service (S3)"
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
    text     = "2.1.1 Ensure S3 Bucket Policy is set to deny HTTP requests"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_s3_buckets_without_ssl_enforcement

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_1_2" {
  title         = "2.1.2 Ensure MFA Delete is enabled on S3 buckets"
  description   = "Once MFA Delete is enabled on your sensitive and classified S3 bucket it requires the user to have two forms of authentication."
  documentation = file("./cis_v300/docs/cis_v300_2_1_2.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.1 Simple Storage Service (S3)"
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
    text     = "2.1.2 Ensure MFA Delete is enabled on S3 buckets"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_s3_buckets_with_mfa_delete_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_1_3" {
  title         = "2.1.3 Ensure all data in Amazon S3 has been discovered, classified and secured when required"
  description   = "Amazon S3 buckets can contain sensitive data, that for security purposes should be discovered, monitored, classified and protected."
  documentation = file("./cis_v300/docs/cis_v300_2_1_3.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.1 Simple Storage Service (S3)"
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
    text     = "2.1.3 Ensure all data in Amazon S3 has been discovered, classified and secured when required"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_s3_buckets_with_macie_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_1_4" {
  title         = "2.1.4 Ensure that S3 Buckets are configured with 'Block public access (bucket settings)'"
  description   = "Amazon S3 provides Block public access (bucket settings) and Block public access (account settings) to help you manage public access to Amazon S3 resources."
  documentation = file("./cis_v300/docs/cis_v300_2_1_4.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.1 Simple Storage Service (S3)"
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
    text     = "2.1.4 Ensure that S3 Buckets are configured with 'Block public access (bucket settings)'"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_s3_buckets_with_block_public_access_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_2_1" {
  title         = "2.2.1 Ensure EBS Volume Encryption is Enabled in all Regions"
  description   = "Elastic Compute Cloud (EC2) supports encryption at rest when using the Elastic Block Store (EBS) service. While disabled by default, forcing encryption at EBS volume creation is supported."
  documentation = file("./cis_v300/docs/cis_v300_2_2_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.2 Elastic Compute Cloud (EC2)"
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
    text     = "2.2.1 Ensure EBS Volume Encryption is Enabled in all Regions"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_regions_with_ebs_encryption_by_default_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_3_1" {
  title         = "2.3.1 Ensure that encryption-at-rest is enabled for RDS Instances"
  description   = "Amazon RDS encrypted DB instances use the industry standard AES-256 encryption algorithm to encrypt your data on the server that hosts your Amazon RDS DB instances."
  documentation = file("./cis_v300/docs/cis_v300_2_3_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.3 Relational Database Service (RDS)"
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
    text     = "2.3.1 Ensure that encryption-at-rest is enabled for RDS Instances"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_rds_db_instances_with_encryption_at_rest_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_2_3_2" {
  title         = "2.3.2 Ensure Auto Minor Version Upgrade feature is Enabled for RDS Instances"
  description   = "Ensure that RDS database instances have the Auto Minor Version Upgrade flag enabled in order to receive automatically minor engine upgrades during the specified maintenance window."
  documentation = file("./cis_v300/docs/cis_v300_2_3_2.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.3 Relational Database Service (RDS)"
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
    text     = "2.3.2 Ensure Auto Minor Version Upgrade feature is Enabled for RDS Instances"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_rds_db_instances_with_auto_minor_version_upgrade_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_2_3_3" {
  title         = "2.3.3 Ensure that public access is not given to RDS Instance"
  description   = "Ensure and verify that RDS database instances provisioned in your AWS account do restrict unauthorized access in order to minimize security risks."
  documentation = file("./cis_v300/docs/cis_v300_2_3_3.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.3 Relational Database Service (RDS)"
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
    text     = "2.3.3 Ensure that public access is not given to RDS Instance"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_rds_db_instances_with_public_access_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}


pipeline "cis_v300_2_4_1" {
  title         = "2.4.1 Ensure that encryption is enabled for EFS file systems"
  description   = "EFS data should be encrypted at rest using AWS KMS (Key Management Service)."
  documentation = file("./cis_v300/docs/cis_v300_2_4_1.md")

  tags = {
    folder = "CIS v3.0.0/2 Storage/2.4 Elastic File System (EFS)"
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
    text     = "2.4.1 Ensure that encryption is enabled for EFS file systems"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_efs_file_systems_with_encryption_at_rest_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}
