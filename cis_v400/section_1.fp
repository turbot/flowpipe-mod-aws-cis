locals {
  cis_v400_1_control_mapping = {
    cis_v400_1_01  = pipeline.cis_v400_1_1
    cis_v400_1_02  = pipeline.cis_v400_1_2
    cis_v400_1_03  = pipeline.cis_v400_1_3
    cis_v400_1_04  = pipeline.cis_v400_1_4
    cis_v400_1_05  = pipeline.cis_v400_1_5
    cis_v400_1_06  = pipeline.cis_v400_1_6
    cis_v400_1_07  = pipeline.cis_v400_1_7
    cis_v400_1_08  = pipeline.cis_v400_1_8
    cis_v400_1_09  = pipeline.cis_v400_1_9
    cis_v400_1_10 = pipeline.cis_v400_1_10
    cis_v400_1_11 = pipeline.cis_v400_1_11
    cis_v400_1_12 = pipeline.cis_v400_1_12
    cis_v400_1_13 = pipeline.cis_v400_1_13
    cis_v400_1_14 = pipeline.cis_v400_1_14
    cis_v400_1_15 = pipeline.cis_v400_1_15
    cis_v400_1_16 = pipeline.cis_v400_1_16
    cis_v400_1_17 = pipeline.cis_v400_1_17
    cis_v400_1_18 = pipeline.cis_v400_1_18
    cis_v400_1_19 = pipeline.cis_v400_1_19
    cis_v400_1_20 = pipeline.cis_v400_1_20
    cis_v400_1_21 = pipeline.cis_v400_1_21
    cis_v400_1_22 = pipeline.cis_v400_1_22
  }
}

locals {
  cis_v400_1_12_pipelines = [
    aws_compliance.pipeline.detect_and_correct_iam_users_with_unused_access_key_45_days,
    aws_compliance.pipeline.detect_and_correct_iam_users_with_unused_login_profile_45_days
  ]
  cis_v400_1_16_pipelines = [
    aws_compliance.pipeline.detect_and_correct_iam_groups_with_policy_star_star_attached,
    aws_compliance.pipeline.detect_and_correct_iam_roles_with_policy_star_star_attached,
    aws_compliance.pipeline.detect_and_correct_iam_users_with_policy_star_star_attached
  ]
  cis_v400_1_22_pipelines = [
    aws_compliance.pipeline.detect_and_correct_iam_groups_with_unrestricted_cloudshell_full_access,
    aws_compliance.pipeline.detect_and_correct_iam_roles_with_unrestricted_cloudshell_full_access,
    aws_compliance.pipeline.detect_and_correct_iam_users_with_unrestricted_cloudshell_full_access
  ]
}

pipeline "cis_v400_1" {
  title         = "1 Identity and Access Management"
  description   = "This section contains recommendations for configuring identity and access management related options."
  documentation = file("./cis_v400/docs/cis_v400_1.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1 Identity and Access Management"
  }

  step "pipeline" "cis_v400_1" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(keys(local.cis_v400_1_control_mapping))-1)
    }

    pipeline = local.cis_v400_1_control_mapping[keys(local.cis_v400_1_control_mapping)[loop.index]]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_1_1" {
  title         = "1.1 Maintain current contact details"
  description   = "Ensure contact email and telephone details for AWS accounts are current and map to more than one individual in your organization."
  documentation = file("./cis_v400/docs/cis_v400_1_1.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.1 Maintain current contact details"
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

pipeline "cis_v400_1_2" {
  title         = "1.2 Ensure security contact information is registered"
  description   = "AWS provides customers with the option of specifying the contact information for account's security team. It is recommended that this information be provided."
  documentation = file("./cis_v400/docs/cis_v400_1_2.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.2 Ensure security contact information is registered"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_accounts_without_alternate_security_contact

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_3" {
  title         = "1.3 Ensure security questions are registered in the AWS account"
  description   = "The AWS support portal allows account owners to establish security questions that can be used to authenticate individuals calling AWS customer service for support."
  documentation = file("./cis_v400/docs/cis_v400_1_3.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.3 Ensure security questions are registered in the AWS account"
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

pipeline "cis_v400_1_4" {
  title         = "1.4 Ensure no 'root' user account access key exists"
  description   = "The 'root' user account is the most privileged user in an AWS account. AWS Access Keys provide programmatic access to a given AWS account. It is recommended that all access keys associated with the 'root' user account be deleted."
  documentation = file("./cis_v400/docs/cis_v400_1_4.md")

  tags = {
   folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.4 Ensure no 'root' user account access key exists"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_root_users_with_access_keys

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_1_5" {
  title         = "1.5 Ensure MFA is enabled for the 'root' user account"
  description   = "The 'root' user account is the most privileged user in an AWS account. Multi-factor Authentication (MFA) adds an extra layer of protection on top of a username and password. With MFA enabled, when a user signs in to an AWS website, they will be prompted for their username and password as well as for an authentication code from their AWS MFA device."
  documentation = file("./cis_v400/docs/cis_v400_1_5.md")

  tags = {
   folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.5 Ensure MFA is enabled for the 'root' user account"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_root_users_with_mfa_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_1_6" {
  title         = "1.6 Ensure hardware MFA is enabled for the 'root' user account"
  description   = "The 'root' user account is the most privileged user in an AWS account. MFA adds an extra layer of protection on top of a user name and password. With MFA enabled, when a user signs in to an AWS website, they will be prompted for their user name and password as well as for an authentication code from their AWS MFA device. For Level 2, it is recommended that the 'root' user account be protected with a hardware MFA."
  documentation = file("./cis_v400/docs/cis_v400_1_6.md")

  tags = {
   folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.6 Ensure hardware MFA is enabled for the 'root' user account"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_root_users_with_hardware_mfa_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_1_7" {
  title         = "1.7 Eliminate use of the 'root' user for administrative and daily tasks"
  description   = "With the creation of an AWS account, a 'root user' is created that cannot be disabled or deleted. That user has unrestricted access to and control over all resources in the AWS account. It is highly recommended that the use of this account be avoided for everyday tasks."
  documentation = file("./cis_v400/docs/cis_v400_1_7.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.7 Eliminate use of the 'root' user for administrative and daily tasks"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_root_users_last_used_90_days

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_1_8" {
  title         = "1.8 Ensure IAM password policy requires minimum length of 14 or greater"
  description   = "Password policies are, in part, used to enforce password complexity requirements. IAM password policies can be used to ensure password are at least a given length. It is recommended that the password policy require a minimum password length 14."
  documentation = file("./cis_v400/docs/cis_v400_1_8.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.8 Ensure IAM password policy requires minimum length of 14 or greater"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_account_password_policies_without_min_length_14

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_9" {
  title         = "1.9 Ensure IAM password policy prevents password reuse"
  description   = "IAM password policies can prevent the reuse of a given password by the same user. It is recommended that the password policy prevent the reuse of passwords."
  documentation = file("./cis_v400/docs/cis_v400_1_9.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.9 Ensure IAM password policy prevents password reuse"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_account_password_policies_without_password_reuse_24

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_10" {
  title         = "1.10 Ensure multi-factor authentication (MFA) is enabled for all IAM users that have a console password"
  description   = "Multi-Factor Authentication (MFA) adds an extra layer of authentication assurance beyond traditional credentials. With MFA enabled, when a user signs in to the AWS Console, they will be prompted for their user name and password as well as for an authentication code from their physical or virtual MFA token. It is recommended that MFA be enabled for all accounts that have a console password."
  documentation = file("./cis_v400/docs/cis_v400_1_10.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.10 Ensure multi-factor authentication (MFA) is enabled for all IAM users that have a console password"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_users_with_console_access_mfa_disabled

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
    }
  }
}

pipeline "cis_v400_1_11" {
  title         = "1.11 Do not create access keys during initial setup for IAM users with a console password"
  description   = "AWS console defaults to no check boxes selected when creating a new IAM user. When creating the IAM User credentials you have to determine what type of access they require."
  documentation = file("./cis_v400/docs/cis_v400_1_11.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.11 Do not create access keys during initial setup for IAM users with a console password"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_users_with_access_key_during_initial_user_setup

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_12" {
  title         = "1.12 Ensure credentials unused for 45 days or more are disabled"
  description   = "AWS IAM users can access AWS resources using different types of credentials, such as passwords or access keys. It is recommended that all credentials that have been unused in 45 or greater days be deactivated or removed."
  documentation = file("./cis_v400/docs/cis_v400_1_12.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.12 Ensure credentials unused for 45 days or more are disabled"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(local.cis_v400_1_12_pipelines) - 1)
    }

    pipeline = local.cis_v400_1_12_pipelines[loop.index]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_13" {
  title         = "1.13 Ensure there is only one active access key for any single IAM user"
  description   = "Access keys are long-term credentials for an IAM user or the AWS account 'root' user. You can use access keys to sign programmatic requests to the AWS CLI or AWS API (directly or using the AWS SDK)."
  documentation = file("./cis_v400/docs/cis_v400_1_13.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.13 Ensure there is only one active access key for any single IAM user"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_users_with_more_than_one_active_key

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_14" {
  title         = "1.14 Ensure access keys are rotated every 90 days or less"
  description   = "Access keys consist of an access key ID and secret access key, which are used to sign programmatic requests that you make to AWS. AWS users need their own access keys to make programmatic calls to AWS from the AWS Command Line Interface (AWS CLI), Tools for Windows PowerShell, the AWS SDKs, or direct HTTP calls using the APIs for individual AWS services. It is recommended that all access keys be regularly rotated."
  documentation = file("./cis_v400/docs/cis_v400_1_14.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.14 Ensure access keys are rotated every 90 days or less"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_users_with_access_key_age_90_days

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_15" {
  title         = "1.15 Ensure IAM users receive permissions only through groups"
  description   = "IAM users are granted access to services, functions, and data through IAM policies. There are four ways to define policies for a user: 1) Edit the user policy directly, aka an inline, or user, policy; 2) attach a policy directly to a user; 3) add the user to an IAM group that has an attached policy; 4) add the user to an IAM group that has an inline policy."
  documentation = file("./cis_v400/docs/cis_v400_1_15.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.15 Ensure IAM users receive permissions only through groups"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_users_with_inline_policy_attached

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_16" {
  title         = "1.16 Ensure IAM policies that allow full \"*:*\" administrative privileges are not attached"
  description   = "IAM policies are the means by which privileges are granted to users, groups, or roles. It is recommended and considered a standard security advice to grant least privilege -that is, granting only the permissions required to perform a task."
  documentation = file("./cis_v400/docs/cis_v400_1_16.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.16 Ensure IAM policies that allow full \"*:*\" administrative privileges are not attached"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(local.cis_v400_1_16_pipelines) - 1)
    }

    pipeline = local.cis_v400_1_16_pipelines[loop.index]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }

}

pipeline "cis_v400_1_17" {
  title         = "1.17 Ensure a support role has been created to manage incidents with AWS Support"
  description   = "AWS provides a support center that can be used for incident notification and response, as well as technical support and customer services. Create an IAM Role, with the appropriate policy assigned, to allow authorized users to manage incidents with AWS Support."
  documentation = file("./cis_v400/docs/cis_v400_1_17.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.17 Ensure a support role has been created to manage incidents with AWS Support"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_accounts_without_support_role

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_18" {
  title         = "1.18 Ensure IAM instance roles are used for AWS resource access from instances"
  description   = "AWS access from within AWS instances can be done by either encoding AWS keys into AWS API calls or by assigning the instance to a role which has an appropriate permissions policy for the required access."
  documentation = file("./cis_v400/docs/cis_v400_1_18.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.18 Ensure IAM instance roles are used for AWS resource access from instances"
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

pipeline "cis_v400_1_19" {
  title         = "1.19 Ensure that all expired SSL/TLS certificates stored in AWS IAM are removed"
  description   = "To enable HTTPS connections to your website or application in AWS, you need an SSL/TLS server certificate. You can use ACM or IAM to store and deploy server certificates."
  documentation = file("./cis_v400/docs/cis_v400_1_19.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.19 Ensure that all expired SSL/TLS certificates stored in AWS IAM are removed"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_server_certificates_expired

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_20" {
  title         = "1.20 Ensure that IAM Access Analyzer is enabled for all regions"
  description   = "Enable IAM Access analyzer for IAM policies about all resources in each active AWS region."
  documentation = file("./cis_v400/docs/cis_v400_1_20.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.20 Ensure that IAM Access Analyzer is enabled for all regions"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]
    pipeline   = aws_compliance.pipeline.detect_and_correct_iam_access_analyzer_disabled_in_regions

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}

pipeline "cis_v400_1_21" {
  title         = "1.21 Ensure IAM users are managed centrally via identity federation or AWS Organizations for multi-account environments"
  description   = "In multi-account environments, IAM user centralization facilitates greater user control."
  documentation = file("./cis_v400/docs/cis_v400_1_21.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.21 Ensure IAM users are managed centrally via identity federation or AWS Organizations for multi-account environmentss"
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

pipeline "cis_v400_1_22" {
  title         = "1.22 Ensure access to AWSCloudShellFullAccess is restricted"
  description   = "AWS CloudShell is a convenient way of running CLI commands against AWS services; a managed IAM policy ('AWSCloudShellFullAccess') provides full access to CloudShell, which allows file upload and download capability between a user's local system and the CloudShell environment. Within the CloudShell environment a user has sudo permissions, and can access the internet. So it is feasible to install file transfer software (for example) and move data from CloudShell to external internet servers."
  documentation = file("./cis_v400/docs/cis_v400_1_22.md")

  tags = {
    folder = "CIS v4.0.0/1 Identity and Access Management"
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
    text     = "1.22 Ensure access to AWSCloudShellFullAccess is restricted"
  }

  step "pipeline" "run_pipeline" {
    depends_on = [step.message.header]

    loop {
      until = loop.index >= (length(local.cis_v400_1_22_pipelines) - 1)
    }

    pipeline = local.cis_v400_1_22_pipelines[loop.index]

    args = {
      database           = param.database
      notifier           = param.notifier
      notification_level = param.notification_level
      approvers          = param.approvers
    }
  }
}
