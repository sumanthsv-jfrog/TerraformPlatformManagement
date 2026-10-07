variable "repositories" {
  description = "Repository definitions from environment YAML"
  type = list(object({
    name            = string
    package_type    = string
    repo_type       = string
    description     = optional(string, "")
    xray_index      = optional(bool, false)
    curated         = optional(bool, false)
    url             = optional(string)
    repositories            = optional(list(string), [])
    default_deployment_repo = optional(string)
    repo_layout_ref = optional(string)
    tag_retention   = optional(number, 3)
    max_unique_tags = optional(number, 10)
    members = optional(list(object({
      url     = string
      enabled = optional(bool, true)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for repo in var.repositories :
      contains(local.supported_combinations, "${repo.repo_type}:${repo.package_type}")
    ])
    error_message = "Unsupported repo_type/package_type combination. See modules/repositories/locals.tf for supported values."
  }

  validation {
    condition = alltrue([
      for repo in var.repositories :
      repo.repo_type != "remote" || (try(repo.url, null) != null && repo.url != "")
    ])
    error_message = "Remote repositories require a non-empty url."
  }

  validation {
    condition = alltrue([
      for repo in var.repositories :
      repo.repo_type != "virtual" || length(try(repo.repositories, [])) > 0
    ])
    error_message = "Virtual repositories require at least one entry in repositories."
  }

  validation {
    condition = alltrue([
      for repo in var.repositories :
      repo.repo_type != "virtual" ||
      try(repo.default_deployment_repo, null) == null ||
      contains(repo.repositories, repo.default_deployment_repo)
    ])
    error_message = "Virtual default_deployment_repo must be one of the repos listed in repositories (typically the local repo)."
  }

  validation {
    condition = alltrue([
      for repo in var.repositories :
      repo.repo_type != "federated" || length(try(repo.members, [])) > 0
    ])
    error_message = "Federated repositories require at least one member with a url."
  }
}
