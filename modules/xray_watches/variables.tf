variable "watches" {
  description = "Xray watches from environment YAML"
  type = list(object({
    name        = string
    description = optional(string, "")
    active      = optional(bool, true)
    recipients  = optional(list(string), [])
    # Set automatically for a watch declared in a file under projects/ that
    # also manages a "project" block — null for a watch declared directly
    # in platform.yaml, which stays unscoped to any one project.
    project_key = optional(string)
    resources = list(object({
      type       = string
      name       = optional(string)
      repo_type  = optional(string)
      bin_mgr_id = optional(string, "default")
    }))
    policies = list(object({
      name = string
      type = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for watch in var.watches :
      length(watch.resources) > 0
    ])
    error_message = "Each Xray watch must include at least one resource."
  }

  validation {
    condition = alltrue([
      for watch in var.watches :
      length(watch.policies) > 0
    ])
    error_message = "Each Xray watch must include at least one assigned policy."
  }

  validation {
    condition = alltrue(flatten([
      for watch in var.watches : [
        for resource in watch.resources :
        resource.type != "repository" || (
          try(resource.name, null) != null && try(resource.repo_type, null) != null
        )
      ]
    ]))
    error_message = "Repository watch resources require name and repo_type."
  }

  validation {
    condition = alltrue([
      for watch in var.watches :
      watch.project_key == null || can(regex("^[a-z0-9-]{2,10}$", watch.project_key))
    ])
    error_message = "A watch's project_key must be 2-10 lowercase alphanumeric and hyphen characters."
  }
}
