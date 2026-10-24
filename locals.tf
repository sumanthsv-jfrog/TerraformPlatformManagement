locals {
  # One file per project team under projects/. A file may create new
  # repositories and may manage one "project" block: roles and repository
  # assignments for a JFrog project that platform.yaml already declares.
  # The directory is optional by design — a missing or empty projects/
  # folder means no extra repos, roles, or assignments, never that the
  # projects themselves stop being created. A repository shared by more
  # than one file (for example projects/shared.yaml) is declared once;
  # Terraform fails the plan if the same repository name is declared twice,
  # or if two files manage the same project key.
  project_files   = sort(fileset("${path.module}/projects", "*.yaml"))
  project_configs = [for f in local.project_files : yamldecode(file("${path.module}/projects/${f}"))]

  project_repositories = flatten(concat(
    [for cfg in local.project_configs : try(cfg.repositories, [])],
    [try(local.config.repositories, [])]
  ))

  # A repository this file creates (its own "repositories" list) is
  # assigned to this file's project automatically. "project.repositories"
  # is only for repository keys this file does not create itself — an
  # existing, imported, or another file's repository.
  team_projects = [
    for cfg in local.project_configs : {
      key    = cfg.project.key
      roles  = try(cfg.project.roles, [])
      # Users and groups themselves are owned by SCIM. A project can only
      # assign a role to a user or group that already exists; it never
      # creates one.
      users  = try(cfg.project.users, [])
      groups = try(cfg.project.groups, [])
      repositories = distinct(concat(
        try(cfg.project.repositories, []),
        [for repo in try(cfg.repositories, []) : repo.name]
      ))
    }
    if try(cfg.project, null) != null
  ]

  team_projects_by_key = { for p in local.team_projects : p.key => p }

  # Platform-wide objects: groups, users, permissions, Xray, curation, and
  # the JFrog projects themselves (key, display_name, admin settings,
  # environments). Users and groups are owned by SCIM; the lists below are
  # the ones Terraform already manages and are not meant to grow here.
  config = yamldecode(file("${path.module}/platform.yaml"))

  project_stubs = { for p in try(local.config.projects, []) : p.key => p }

  # A project can declare its own roles, user/group role assignments, and
  # repository assignments right here in platform.yaml. A project can
  # instead delegate those same fields to one file under projects/ — see
  # the "only one side may manage a given project key" precondition in
  # main.tf. Never both for the same project: whichever side actually
  # manages the project wins outright, with no partial merge between them.
  merged_projects = [
    for key, stub in local.project_stubs : merge(stub, {
      roles        = try(local.team_projects_by_key[key].roles, try(stub.roles, []))
      users        = try(local.team_projects_by_key[key].users, try(stub.users, []))
      groups       = try(local.team_projects_by_key[key].groups, try(stub.groups, []))
      repositories = try(local.team_projects_by_key[key].repositories, try(stub.repositories, []))
    })
  ]

  # YAML params mix types (list, bool, map) — jsonencode here so the module gets a uniform shape
  curation_conditions = [
    for condition in try(local.config.curation_conditions, []) : {
      name        = condition.name
      template_id = condition.template_id
      param_values = jsonencode([
        for param in condition.params : {
          param_id = param.param_id
          value    = param.value
        }
      ])
    }
  ]
}
