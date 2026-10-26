variable "oidc_configurations" {
  description = "OIDC identity provider configurations from environment YAML"
  type = list(object({
    name          = string
    description   = optional(string, "")
    issuer_url    = string
    provider_type = string
    audience      = optional(string)
    # Required when provider_type is GitHub or GitHubEnterprise; not
    # applicable to any other provider_type.
    organization = optional(string)
    # Only applicable when provider_type is Azure.
    azure_app_id = optional(string)
    # Not allowed when provider_type is GitHub or GitHubEnterprise.
    token_issuer = optional(string)
    # Only GitHub accepts false. Left unset, the platform defaults this on.
    enable_permissive_configuration = optional(bool)
    use_default_proxy               = optional(bool)
  }))
  default = []

  validation {
    condition     = length(var.oidc_configurations) == length(distinct([for c in var.oidc_configurations : c.name]))
    error_message = "OIDC configuration names must be unique."
  }

  validation {
    condition = alltrue([
      for c in var.oidc_configurations :
      contains(["generic", "GitHub", "GitHubEnterprise", "Azure"], c.provider_type)
    ])
    error_message = "provider_type must be one of: generic, GitHub, GitHubEnterprise, Azure."
  }

  validation {
    condition = alltrue([
      for c in var.oidc_configurations :
      contains(["GitHub", "GitHubEnterprise"], c.provider_type) ? c.organization != null : true
    ])
    error_message = "organization is required when provider_type is GitHub or GitHubEnterprise."
  }

  validation {
    condition = alltrue([
      for c in var.oidc_configurations :
      c.organization == null || contains(["GitHub", "GitHubEnterprise"], c.provider_type)
    ])
    error_message = "organization is only applicable when provider_type is GitHub or GitHubEnterprise."
  }

  validation {
    condition = alltrue([
      for c in var.oidc_configurations :
      c.azure_app_id == null || c.provider_type == "Azure"
    ])
    error_message = "azure_app_id is only applicable when provider_type is Azure."
  }

  validation {
    condition = alltrue([
      for c in var.oidc_configurations :
      c.token_issuer == null || !contains(["GitHub", "GitHubEnterprise"], c.provider_type)
    ])
    error_message = "token_issuer is not allowed when provider_type is GitHub or GitHubEnterprise."
  }
}
