variable "projects" {
  description = "JFrog project definitions from environment YAML"
  type = list(object({
    key          = string
    display_name = string
    description  = optional(string, "")
    admin_privileges = optional(object({
      manage_members           = optional(bool, true)
      manage_resources         = optional(bool, true)
      manage_remote_repository = optional(bool, true)
      index_resources          = optional(bool, true)
      }), {
      manage_members           = true
      manage_resources         = true
      manage_remote_repository = true
      index_resources          = true
    })
    max_storage_in_gibibytes   = optional(number)
    block_deployments_on_limit = optional(bool)
    email_notification         = optional(bool)
    environments               = optional(list(string), [])
    roles = optional(list(object({
      name         = string
      environments = list(string)
      actions      = list(string)
    })), [])
    users = optional(list(object({
      name  = string
      roles = list(string)
    })), [])
    groups = optional(list(object({
      name  = string
      roles = list(string)
    })), [])
    repositories = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for project in var.projects :
      can(regex("^[a-z][a-z0-9-]{1,31}$", project.key))
    ])
    error_message = "Project key must be 2-32 characters, start with a letter, and contain only lowercase letters, digits, and hyphens."
  }

  validation {
    condition     = length(var.projects) == length(distinct([for project in var.projects : project.key]))
    error_message = "Project keys must be unique."
  }

  validation {
    condition = alltrue(flatten([
      for project in var.projects : [
        for env in project.environments :
        can(regex("^[A-Za-z][A-Za-z0-9-]*$", env)) && (length(project.key) + 1 + length(env) <= 32)
      ]
    ]))
    error_message = "Custom environment names must start with a letter and contain only letters, digits, and hyphens. project_key + '-' + name must be 32 characters or fewer."
  }

  validation {
    condition = alltrue(flatten([
      for project in var.projects : [
        for role in project.roles :
        alltrue([
          for env in role.environments :
          contains(concat(["DEV", "PROD"], project.environments), env)
        ])
      ]
    ]))
    error_message = "Role environments must be DEV, PROD, or a custom environment declared on the same project."
  }

  validation {
    condition = alltrue(flatten([
      for project in var.projects : [
        for role in project.roles : [
          length(role.actions) > 0,
          alltrue([
            for action in role.actions :
            contains([
              "READ_REPOSITORY",
              "ANNOTATE_REPOSITORY",
              "DEPLOY_CACHE_REPOSITORY",
              "DELETE_OVERWRITE_REPOSITORY",
              "MANAGE_XRAY_MD_REPOSITORY",
              "READ_RELEASE_BUNDLE",
              "ANNOTATE_RELEASE_BUNDLE",
              "CREATE_RELEASE_BUNDLE",
              "DISTRIBUTE_RELEASE_BUNDLE",
              "DELETE_RELEASE_BUNDLE",
              "MANAGE_XRAY_MD_RELEASE_BUNDLE",
              "READ_BUILD",
              "ANNOTATE_BUILD",
              "DEPLOY_BUILD",
              "DELETE_BUILD",
              "MANAGE_XRAY_MD_BUILD",
              "READ_SOURCES_PIPELINE",
              "TRIGGER_PIPELINE",
              "READ_INTEGRATIONS_PIPELINE",
              "READ_POOLS_PIPELINE",
              "MANAGE_INTEGRATIONS_PIPELINE",
              "MANAGE_SOURCES_PIPELINE",
              "MANAGE_POOLS_PIPELINE",
              "TRIGGER_SECURITY",
              "ISSUES_SECURITY",
              "LICENCES_SECURITY",
              "REPORTS_SECURITY",
              "WATCHES_SECURITY",
              "POLICIES_SECURITY",
              "RULES_SECURITY",
              "MANAGE_MEMBERS",
              "MANAGE_RESOURCES",
            ], action)
          ])
        ]
      ]
    ]))
    error_message = "Each custom role needs at least one action from the JFrog project role action list."
  }

  validation {
    condition = alltrue(flatten([
      for project in var.projects : concat(
        [length(project.users) == length(distinct([for user in project.users : user.name]))],
        [length(project.groups) == length(distinct([for group in project.groups : group.name]))],
        [length(project.roles) == length(distinct([for role in project.roles : role.name]))],
        [length(project.repositories) == length(distinct(project.repositories))],
        [for user in project.users : length(user.roles) > 0],
        [for group in project.groups : length(group.roles) > 0],
      )
    ]))
    error_message = "Project users, groups, roles, and repositories must be unique within a project, and each user or group needs at least one role."
  }
}
