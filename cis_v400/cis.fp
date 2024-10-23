locals {
  cis_v400_control_mapping = {
    cis_v400_1 = pipeline.cis_v400_1
    cis_v400_2 = pipeline.cis_v400_2
    cis_v400_3 = pipeline.cis_v400_3
    cis_v400_4 = pipeline.cis_v400_4
    cis_v400_5 = pipeline.cis_v400_5
  }
}

pipeline "cis_v400" {
  title         = "CIS v4.0.0"
  description   = "The CIS Amazon Web Services Foundations Benchmark provides prescriptive guidance for configuring security options for a subset of Amazon Web Services with an emphasis on foundational, testable, and architecture agnostic settings."
  #documentation = file("./cis_v400/docs/cis_overview.md")

  tags = {
    folder      = "CIS v4.0.0"
    recommended = "true"
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
    text     = "CIS v4.0.0"
  }

  step "pipeline" "run_pipelines" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v400_control_mapping))-1)
    }

    pipeline = local.cis_v400_control_mapping[keys(local.cis_v400_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}
