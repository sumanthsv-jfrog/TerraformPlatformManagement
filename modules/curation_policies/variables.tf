variable "policies" {
  description = "Curation policies from environment YAML"
  type = list(object({
    name                  = string
    condition_id          = optional(string)
    condition_ref         = optional(string)
    scope                 = string
    policy_action         = string
    waiver_request_config = optional(string, "forbidden")
    repo_include          = optional(list(string), [])
    repo_exclude          = optional(list(string), [])
    pkg_types_include     = optional(list(string), [])
    decision_owners       = optional(list(string), [])
    notify_emails         = optional(list(string), [])
    waivers = optional(list(object({
      pkg_type      = string
      pkg_name      = string
      all_versions  = optional(bool, false)
      pkg_versions  = optional(list(string), [])
      justification = string
    })), [])
    label_waivers = optional(list(object({
      label         = string
      justification = string
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for policy in var.policies :
      (try(policy.condition_id, null) != null && try(policy.condition_ref, null) == null) ||
      (try(policy.condition_id, null) == null && try(policy.condition_ref, null) != null)
    ])
    error_message = "Each curation policy must set exactly one of condition_id (built-in) or condition_ref (custom condition name)."
  }

  validation {
    condition = alltrue([
      for policy in var.policies :
      policy.scope != "specific_repos" || (
        length(try(policy.repo_include, [])) > 0 || length(try(policy.repo_exclude, [])) > 0
      )
    ])
    error_message = "specific_repos scope requires repo_include or repo_exclude."
  }

  validation {
    condition = alltrue([
      for policy in var.policies :
      policy.scope != "pkg_types" || length(try(policy.pkg_types_include, [])) > 0
    ])
    error_message = "pkg_types scope requires pkg_types_include."
  }

  validation {
    condition = alltrue([
      for policy in var.policies :
      try(policy.waiver_request_config, "forbidden") != "manual" ||
      length(try(policy.decision_owners, [])) > 0
    ])
    error_message = "manual waiver_request_config requires decision_owners."
  }
}

variable "condition_ids" {
  description = "Map of custom condition name to API ID from curation_conditions module"
  type        = map(string)
  default     = {}
}

locals {
  policies = {
    for policy in var.policies :
    policy.name => merge(policy, {
      resolved_condition_id = coalesce(
        try(policy.condition_id, null),
        try(policy.condition_ref, null) != null ? lookup(var.condition_ids, policy.condition_ref, null) : null,
      )
    })
  }
}
