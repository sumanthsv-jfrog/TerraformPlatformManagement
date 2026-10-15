locals {
  project_environments = {
    for item in flatten([
      for project in var.projects : [
        for env in project.environments : {
          id          = "${project.key}:${env}"
          project_key = project.key
          name        = env
        }
      ]
    ]) : item.id => item
  }

  project_roles = {
    for item in flatten([
      for project in var.projects : [
        for role in project.roles : {
          id           = "${project.key}:${role.name}"
          project_key  = project.key
          name         = role.name
          environments = role.environments
          actions      = role.actions
        }
      ]
    ]) : item.id => item
  }

  project_users = {
    for item in flatten([
      for project in var.projects : [
        for user in project.users : {
          id          = "${project.key}:${user.name}"
          project_key = project.key
          name        = user.name
          roles       = user.roles
        }
      ]
    ]) : item.id => item
  }

  project_groups = {
    for item in flatten([
      for project in var.projects : [
        for group in project.groups : {
          id          = "${project.key}:${group.name}"
          project_key = project.key
          name        = group.name
          roles       = group.roles
        }
      ]
    ]) : item.id => item
  }

  project_repositories = {
    for item in flatten([
      for project in var.projects : [
        for repo in project.repositories : {
          id          = "${project.key}:${repo}"
          project_key = project.key
          key         = repo
        }
      ]
    ]) : item.id => item
  }
}

resource "project_project" "this" {
  for_each = {
    for project in var.projects :
    project.key => project
  }

  key                        = each.value.key
  display_name               = each.value.display_name
  description                = each.value.description
  max_storage_in_gibibytes   = each.value.max_storage_in_gibibytes
  block_deployments_on_limit = each.value.block_deployments_on_limit
  email_notification         = each.value.email_notification

  admin_privileges {
    manage_members           = each.value.admin_privileges.manage_members
    manage_resources         = each.value.admin_privileges.manage_resources
    manage_remote_repository = each.value.admin_privileges.manage_remote_repository
    index_resources          = each.value.admin_privileges.index_resources
  }
}

resource "project_environment" "this" {
  for_each = local.project_environments

  project_key = project_project.this[each.value.project_key].key
  name        = each.value.name
}

resource "project_role" "this" {
  for_each = local.project_roles

  project_key  = project_project.this[each.value.project_key].key
  name         = each.value.name
  type = "CUSTOM"
  # JFrog stores a project environment as "<project_key>-<name>".
  # DEV and PROD stay unprefixed.
  environments = [
    for env in each.value.environments :
    contains(["DEV", "PROD"], env) ? env : "${each.value.project_key}-${env}"
  ]
  actions = each.value.actions

  depends_on = [project_environment.this]
}

resource "project_user" "this" {
  for_each = local.project_users

  project_key = project_project.this[each.value.project_key].key
  name        = each.value.name
  roles       = each.value.roles

  depends_on = [project_role.this]
}

resource "project_group" "this" {
  for_each = local.project_groups

  project_key = project_project.this[each.value.project_key].key
  name        = each.value.name
  roles       = each.value.roles

  depends_on = [project_role.this]
}

resource "project_repository" "this" {
  for_each = local.project_repositories

  project_key = project_project.this[each.value.project_key].key
  key         = each.value.key
}
