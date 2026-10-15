variable "groups" {
  description = "Group definitions from environment YAML"
  type = list(object({
    name             = string
    description      = optional(string, "")
    auto_join        = optional(bool, false)
    admin_privileges = optional(bool, false)
    policy_manager   = optional(bool, false)
    policy_viewer    = optional(bool, false)
    watch_manager    = optional(bool, false)
    reports_manager  = optional(bool, false)
    manage_resources = optional(bool, false)
    manage_webhook   = optional(bool, false)
  }))
  default = []
}
