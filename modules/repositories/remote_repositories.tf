# Remote repositories

resource "artifactory_remote_docker_repository" "this" {
  for_each = local.repos_grouped["remote_docker"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index
  curated     = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_maven_repository" "this" {
  for_each = local.repos_grouped["remote_maven"]

  key             = each.value.name
  url             = each.value.url
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "maven-2-default")
  xray_index      = each.value.xray_index
  curated         = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_gradle_repository" "this" {
  for_each = local.repos_grouped["remote_gradle"]

  key             = each.value.name
  url             = each.value.url
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "maven-2-default")
  xray_index      = each.value.xray_index
  curated         = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_npm_repository" "this" {
  for_each = local.repos_grouped["remote_npm"]

  key             = each.value.name
  url             = each.value.url
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "npm-default")
  xray_index      = each.value.xray_index
  curated         = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_pypi_repository" "this" {
  for_each = local.repos_grouped["remote_pypi"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index
  curated     = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_helm_repository" "this" {
  for_each = local.repos_grouped["remote_helm"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_nuget_repository" "this" {
  for_each = local.repos_grouped["remote_nuget"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index
  curated     = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_generic_repository" "this" {
  for_each = local.repos_grouped["remote_generic"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_go_repository" "this" {
  for_each = local.repos_grouped["remote_go"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index
  curated     = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_debian_repository" "this" {
  for_each = local.repos_grouped["remote_debian"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_rpm_repository" "this" {
  for_each = local.repos_grouped["remote_rpm"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_conan_repository" "this" {
  for_each = local.repos_grouped["remote_conan"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index
  curated     = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_cargo_repository" "this" {
  for_each = local.repos_grouped["remote_cargo"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_gems_repository" "this" {
  for_each = local.repos_grouped["remote_gems"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index
  curated     = each.value.curated

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_composer_repository" "this" {
  for_each = local.repos_grouped["remote_composer"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_terraform_repository" "this" {
  for_each = local.repos_grouped["remote_terraform"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_oci_repository" "this" {
  for_each = local.repos_grouped["remote_oci"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_vcs_repository" "this" {
  for_each = local.repos_grouped["remote_vcs"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_alpine_repository" "this" {
  for_each = local.repos_grouped["remote_alpine"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_remote_ansible_repository" "this" {
  for_each = local.repos_grouped["remote_ansible"]

  key         = each.value.name
  url         = each.value.url
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}
