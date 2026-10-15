locals {
  security_policies = {
    for policy in var.security_policies :
    policy.name => policy
  }

  license_policies = {
    for policy in var.license_policies :
    policy.name => policy
  }

  operational_risk_policies = {
    for policy in var.operational_risk_policies :
    policy.name => policy
  }
}

resource "xray_security_policy" "this" {
  for_each = local.security_policies

  name        = each.value.name
  description = each.value.description
  type        = "security"

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      criteria {
        min_severity           = rule.value.min_severity
        fix_version_dependant  = rule.value.fix_version_dependant
        applicable_cves_only   = rule.value.applicable_cves_only
        malicious_package    = rule.value.malicious_package
      }

      actions {
        fail_build              = rule.value.fail_build
        notify_watch_recipients = rule.value.notify_watch_recipients
        mails                   = rule.value.notify_emails

        block_download {
          active    = rule.value.block_download_active
          unscanned = rule.value.block_download_unscanned
        }
      }
    }
  }
}

resource "xray_license_policy" "this" {
  for_each = local.license_policies

  name        = each.value.name
  description = each.value.description
  type        = "license"

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      criteria {
        allow_unknown            = rule.value.allow_unknown
        multi_license_permissive = rule.value.multi_license_permissive
        banned_licenses          = length(rule.value.banned_licenses) > 0 ? rule.value.banned_licenses : null
        allowed_licenses         = length(rule.value.allowed_licenses) > 0 ? rule.value.allowed_licenses : null
      }

      actions {
        fail_build              = rule.value.fail_build
        notify_watch_recipients = rule.value.notify_watch_recipients
        mails                   = rule.value.notify_emails

        block_download {
          active    = rule.value.block_download_active
          unscanned = rule.value.block_download_unscanned
        }
      }
    }
  }
}

resource "xray_operational_risk_policy" "this" {
  for_each = local.operational_risk_policies

  name        = each.value.name
  description = each.value.description
  type        = "operational_risk"

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      criteria {
        op_risk_min_risk = rule.value.op_risk_min_risk
      }

      actions {
        fail_build              = rule.value.fail_build
        notify_watch_recipients = rule.value.notify_watch_recipients
        mails                   = rule.value.notify_emails

        block_download {
          active    = rule.value.block_download_active
          unscanned = rule.value.block_download_unscanned
        }
      }
    }
  }
}
