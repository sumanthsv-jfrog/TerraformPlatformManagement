# Local repositories

resource "artifactory_local_docker_v2_repository" "this" {
  for_each = local.repos_grouped["local_docker"]

  key             = each.value.name
  description     = each.value.description
  tag_retention   = each.value.tag_retention
  max_unique_tags = each.value.max_unique_tags
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_maven_repository" "this" {
  for_each = local.repos_grouped["local_maven"]

  key                       = each.value.name
  description               = each.value.description
  repo_layout_ref           = coalesce(try(each.value.repo_layout_ref, null), "maven-2-default")
  checksum_policy_type      = "client-checksums"
  snapshot_version_behavior = "unique"
  xray_index                = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_gradle_repository" "this" {
  for_each = local.repos_grouped["local_gradle"]

  key                       = each.value.name
  description               = each.value.description
  repo_layout_ref           = coalesce(try(each.value.repo_layout_ref, null), "maven-2-default")
  checksum_policy_type      = "client-checksums"
  snapshot_version_behavior = "unique"
  xray_index                = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_npm_repository" "this" {
  for_each = local.repos_grouped["local_npm"]

  key         = each.value.name
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_pypi_repository" "this" {
  for_each = local.repos_grouped["local_pypi"]

  key         = each.value.name
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_helm_repository" "this" {
  for_each = local.repos_grouped["local_helm"]

  key         = each.value.name
  description = each.value.description
  xray_index  = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_generic_repository" "this" {
  for_each = local.repos_grouped["local_generic"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_go_repository" "this" {
  for_each = local.repos_grouped["local_go"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_debian_repository" "this" {
  for_each = local.repos_grouped["local_debian"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_rpm_repository" "this" {
  for_each = local.repos_grouped["local_rpm"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_nuget_repository" "this" {
  for_each = local.repos_grouped["local_nuget"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_conan_repository" "this" {
  for_each = local.repos_grouped["local_conan"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_cargo_repository" "this" {
  for_each = local.repos_grouped["local_cargo"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_gems_repository" "this" {
  for_each = local.repos_grouped["local_gems"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_composer_repository" "this" {
  for_each = local.repos_grouped["local_composer"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_terraform_module_repository" "this" {
  for_each = local.repos_grouped["local_terraform_module"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_terraform_provider_repository" "this" {
  for_each = local.repos_grouped["local_terraform_provider"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_oci_repository" "this" {
  for_each = local.repos_grouped["local_oci"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_alpine_repository" "this" {
  for_each = local.repos_grouped["local_alpine"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_ansible_repository" "this" {
  for_each = local.repos_grouped["local_ansible"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_local_nix_repository" "this" {
  for_each = local.repos_grouped["local_nix"]

  key             = each.value.name
  description     = each.value.description
  repo_layout_ref = coalesce(try(each.value.repo_layout_ref, null), "simple-default")
  xray_index      = each.value.xray_index

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}
