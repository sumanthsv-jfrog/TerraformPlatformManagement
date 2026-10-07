variable "permissions" {
  description = "Permission definitions from environment YAML"
  type = list(object({
    name = string
    targets = list(object({
      repo             = string
      include_patterns = optional(list(string), ["**"])
      exclude_patterns = optional(list(string), [""])
    }))
    groups = optional(list(object({
      name        = string
      permissions = optional(list(string))
      operations  = optional(list(string))
    })), [])
    users = optional(list(object({
      name        = string
      permissions = optional(list(string))
      operations  = optional(list(string))
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for permission in var.permissions :
      length(permission.targets) > 0
    ])
    error_message = "Each permission must include at least one target repository."
  }

  validation {
    condition = alltrue([
      for permission in var.permissions :
      length(permission.groups) > 0 || length(permission.users) > 0
    ])
    error_message = "Each permission must include at least one group or user."
  }

  validation {
    condition = alltrue(flatten([
      for permission in var.permissions : concat(
        [
          for group in permission.groups :
          length(coalesce(group.permissions, group.operations, [])) > 0
        ],
        [
          for user in permission.users :
          length(coalesce(user.permissions, user.operations, [])) > 0
        ],
      )
    ]))
    error_message = "Each group or user must define permissions (or operations as an alias)."
  }
}
