module "repositories" {
  source = "./modules/repositories"

  repositories = try(local.config.repositories, [])
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

  projects = try(local.config.projects, [])

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
