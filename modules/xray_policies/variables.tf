variable "security_policies" {
  description = "Xray security policies from environment YAML"
  type = list(object({
    name        = string
    description = optional(string, "")
    rules = list(object({
      name                     = string
      priority                 = number
      min_severity             = optional(string, "High")
      fix_version_dependant    = optional(bool, false)
      applicable_cves_only   = optional(bool, false)
      malicious_package        = optional(bool, false)
      block_download_active    = optional(bool, true)
      block_download_unscanned = optional(bool, false)
      fail_build               = optional(bool, true)
      notify_watch_recipients  = optional(bool, true)
      notify_emails            = optional(list(string), [])
    }))
  }))
  default = []
}

variable "license_policies" {
  description = "Xray license policies from environment YAML"
  type = list(object({
    name        = string
    description = optional(string, "")
    rules = list(object({
      name                     = string
      priority                 = number
      banned_licenses          = optional(list(string), [])
      allowed_licenses         = optional(list(string), [])
      allow_unknown            = optional(bool, false)
      multi_license_permissive = optional(bool, false)
      block_download_active    = optional(bool, true)
      block_download_unscanned = optional(bool, false)
      fail_build               = optional(bool, false)
      notify_watch_recipients  = optional(bool, true)
      notify_emails            = optional(list(string), [])
    }))
  }))
  default = []
}

variable "operational_risk_policies" {
  description = "Xray operational risk policies from environment YAML"
  type = list(object({
    name        = string
    description = optional(string, "")
    rules = list(object({
      name                     = string
      priority                 = number
      op_risk_min_risk         = optional(string, "High")
      block_download_active    = optional(bool, false)
      block_download_unscanned = optional(bool, false)
      fail_build               = optional(bool, false)
      notify_watch_recipients  = optional(bool, true)
      notify_emails            = optional(list(string), [])
    }))
  }))
  default = []
}
