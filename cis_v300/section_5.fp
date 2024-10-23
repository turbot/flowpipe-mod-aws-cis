locals {
  cis_v300_5_control_mapping = {
    cis_v300_5_1 = pipeline.cis_v300_5_1
    cis_v300_5_2 = pipeline.cis_v300_5_2
    cis_v300_5_3 = pipeline.cis_v300_5_3
    cis_v300_5_4 = pipeline.cis_v300_5_4
    cis_v300_5_5 = pipeline.cis_v300_5_5
    cis_v300_5_6 = pipeline.cis_v300_5_6
  }
}

pipeline "cis_v300_5" {
  title         = "5 Networking"
  description   = "This section contains recommendations for configuring security-related aspects of AWS Virtual Private Cloud (VPC)."
  documentation = file("./cis_v300/docs/cis_v300_4.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5 Networking"
  }

  step "pipeline" "cis_v300_5" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v300_5_control_mapping)) - 1)
    }

    pipeline = local.cis_v300_5_control_mapping[keys(local.cis_v300_5_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v300_5_1" {
  title         = "5.1 Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports"
  description   = "The Network Access Control List (NACL) function provide stateless filtering of ingress and egress network traffic to AWS resources."
  documentation = file("./cis_v300/docs/cis_v300_5_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5.1 Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_vpc_network_acls_allowing_ingress_to_remote_server_administration_ports

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_2" {
  title         = "5.2 Ensure no security groups allow ingress from 0.0.0.0/0 to remote server administration ports"
  description   = "Security groups provide stateful filtering of ingress and egress network traffic to AWS resources. It is recommended that no security group allows unrestricted ingress access to remote server administration ports, such as SSH to port 22 and RDP to port 3389, using either the TCP (6), UDP (17) or ALL (-1) protocols."
  documentation = file("./cis_v300/docs/cis_v300_5_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5.2 Ensure no security groups allow ingress from 0.0.0.0/0 to remote server administration ports"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_vpc_security_groups_allowing_ingress_to_remote_server_administration_ports_ipv4

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_3" {
  title         = "5.3 Ensure no security groups allow ingress from ::/0 to remote server administration ports"
  description   = "Security groups provide stateful filtering of ingress and egress network traffic to AWS resources. It is recommended that no security group allows unrestricted ingress access to remote server administration ports, such as SSH to port 22 and RDP to port 3389."
  documentation = file("./cis_v300/docs/cis_v300_5_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5.3 Ensure no security groups allow ingress from ::/0 to remote server administration ports"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_vpc_security_groups_allowing_ingress_to_remote_server_administration_ports_ipv6

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_4" {
  title         = "5.4 Ensure the default security group of every VPC restricts all traffic"
  description   = "A VPC comes with a default security group whose initial settings deny all inbound traffic, allow all outbound traffic, and allow all traffic between instances assigned to the security group. If you don't specify a security group when you launch an instance, the instance is automatically assigned to this default security group."
  documentation = file("./cis_v300/docs/cis_v300_5_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5.4 Ensure the default security group of every VPC restricts all traffic"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_vpc_default_security_groups_allowing_ingress_egress

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_5" {
  title         = "5.5 Ensure routing tables for VPC peering are \"least access\""
  description   = "Once a VPC peering connection is established, routing tables must be updated to establish any connections between the peered VPCs."
  documentation = file("./cis_v300/docs/cis_v300_5_1.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5.5 Ensure routing tables for VPC peering are \"least access\""
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = pipeline.manual_detection

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v300_5_6" {
  title         = "5.6 Ensure that EC2 Metadata Service only allows IMDSv2"
  description   = "When enabling the Metadata Service on AWS EC2 instances, users have the option of using either Instance Metadata Service Version 1 (IMDSv1; a request/response method) or Instance Metadata Service Version 2 (IMDSv2; a session-oriented method)."
  documentation = file("./cis_v300/docs/cis_v300_5_6.md")

  tags = {
    folder = "CIS v3.0.0/5 Networking"
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
    text     = "5.6 Ensure that EC2 Metadata Service only allows IMDSv2"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_ec2_instances_with_imdsv1_enabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}
