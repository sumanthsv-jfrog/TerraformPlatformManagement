variable "identity_mappings" {
  description = "OIDC identity mappings (claims_json pre-encoded as JSON in root locals)"
  type = list(object({
    name        = string
    description = optional(string, "")
    # Name of an oidc_configurations entry this mapping applies to.
    provider_name = string
    # Lower number = higher priority. Left unset, the lowest priority.
    priority    = optional(number, 100)
    claims_json = string
    token_spec = object({
      # Required when scope starts with "applied-permissions/roles:", and
      # not applicable when scope starts with "applied-permissions/groups".
      username = optional(string)
      # Mutually exclusive with "scope": maps the OIDC user claim onto an
      # Artifactory username pattern instead of granting a fixed scope.
      username_pattern = optional(string)
      # Maps OIDC groups onto Artifactory groups.
      groups_pattern = optional(string)
      # Must start with "applied-permissions/user", "applied-permissions/admin",
      # "applied-permissions/roles:", or "applied-permissions/groups:". A
      # "roles:" scope is what actually scopes this mapping to a project —
      # for example "applied-permissions/roles:fstg:\"Developer\"" — not any
      # project_key field on this resource; the provider ignores that.
      scope      = optional(string)
      audience   = optional(string)
      expires_in = optional(number)
    })
  }))
  default = []

  validation {
    condition     = length(var.identity_mappings) == length(distinct([for m in var.identity_mappings : m.name]))
    error_message = "OIDC identity mapping names must be unique."
  }

  validation {
    condition = alltrue([
      for m in var.identity_mappings :
      try(m.token_spec.scope, null) == null || anytrue([
        for prefix in ["applied-permissions/user", "applied-permissions/admin", "applied-permissions/roles:", "applied-permissions/groups:"] :
        startswith(m.token_spec.scope, prefix)
      ])
    ])
    error_message = "token_spec.scope must start with applied-permissions/user, applied-permissions/admin, applied-permissions/roles:, or applied-permissions/groups:."
  }

  validation {
    condition = alltrue([
      for m in var.identity_mappings :
      try(m.token_spec.scope, null) == null || !startswith(m.token_spec.scope, "applied-permissions/roles:") || try(m.token_spec.username, null) != null
    ])
    error_message = "token_spec.username is required when token_spec.scope is a roles scope (applied-permissions/roles:...)."
  }
}
