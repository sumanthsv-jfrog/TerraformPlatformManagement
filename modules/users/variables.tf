variable "users" {
  description = "User definitions from environment YAML"
  type = list(object({
    name                       = string
    email                      = string
    password                   = string
    admin                      = optional(bool, false)
    disable_ui_access          = optional(bool, false)
    profile_updatable          = optional(bool, true)
    internal_password_disabled = optional(bool, false)
    groups                     = optional(list(string), [])
  }))
  default = []
}
