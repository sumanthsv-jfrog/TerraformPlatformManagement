resource "terraform_data" "project_files_scope" {
  lifecycle {
    precondition {
      condition = alltrue([
        for cfg in local.project_configs :
        length(setsubtract(keys(cfg), ["repositories", "project"])) == 0
      ])
      error_message = "Files under projects/ may declare only 'repositories' and 'project'. A project's key, display_name, and admin settings belong in platform.yaml; groups, users, permissions, Xray, and curation do too."
    }

    precondition {
      condition = alltrue([
        for p in local.team_projects : contains(keys(local.project_stubs), p.key)
      ])
      error_message = "A file under projects/ manages a project key that platform.yaml does not declare. Add that project to platform.yaml's 'projects' list first."
    }

    precondition {
      condition     = length(local.team_projects) == length(distinct([for p in local.team_projects : p.key]))
      error_message = "Only one file under projects/ may manage a given project key."
    }

    precondition {
      condition = alltrue([
        for cfg in local.project_configs :
        try(cfg.project, null) == null || alltrue([
          for repo in try(cfg.repositories, []) :
          startswith(repo.name, "${cfg.project.key}-")
        ])
      ])
      error_message = "A repository created in a file that manages a project must have a name starting with '<project key>-'."
    }

    precondition {
      condition = alltrue([
        for key, stub in local.project_stubs :
        !(contains(keys(local.team_projects_by_key), key) && length(concat(
          try(stub.roles, []), try(stub.users, []), try(stub.groups, []), try(stub.repositories, [])
        )) > 0)
      ])
      error_message = "A project already managed by a file under projects/ must not also declare roles, users, groups, or repositories directly on its platform.yaml entry. Manage that project's roles, users, groups, and repository assignment in exactly one place: platform.yaml, or its file under projects/ — not both."
    }
  }
}

module "repositories" {
  source = "./modules/repositories"

  repositories = local.project_repositories

  depends_on = [terraform_data.project_files_scope]
}

module "groups" {
  source = "./modules/groups"

  groups = try(local.config.groups, [])
}

module "users" {
  source = "./modules/users"

  users = try(local.config.users, [])

  depends_on = [module.groups]
}

module "projects" {
  source = "./modules/projects"

  projects = local.merged_projects

  depends_on = [
    module.repositories,
    module.groups,
    module.users,
  ]
}

module "permissions" {
  source = "./modules/permissions"

  permissions = try(local.config.permissions, [])

  depends_on = [
    module.repositories,
    module.groups,
    module.users,
  ]
}

module "xray_policies" {
  source = "./modules/xray_policies"

  security_policies         = try(local.config.xray_security_policies, [])
  license_policies          = try(local.config.xray_license_policies, [])
  operational_risk_policies = try(local.config.xray_operational_risk_policies, [])
}

module "xray_watches" {
  source = "./modules/xray_watches"

  watches = try(local.config.xray_watches, [])

  depends_on = [
    module.repositories,
    module.xray_policies,
  ]
}

module "curation_conditions" {
  source = "./modules/curation_conditions"

  conditions = local.curation_conditions
}

module "curation_policies" {
  source = "./modules/curation_policies"

  policies      = try(local.config.curation_policies, [])
  condition_ids = module.curation_conditions.ids

  depends_on = [
    module.repositories,
    module.curation_conditions,
    module.groups,
  ]
}
