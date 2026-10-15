# Virtual repositories

resource "artifactory_virtual_maven_repository" "this" {
  for_each = local.repos_grouped["virtual_maven"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repo_layout_ref         = coalesce(try(each.value.repo_layout_ref, null), "maven-2-default")
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_gradle_repository" "this" {
  for_each = local.repos_grouped["virtual_gradle"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repo_layout_ref         = coalesce(try(each.value.repo_layout_ref, null), "maven-2-default")
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_generic_repository" "this" {
  for_each = local.repos_grouped["virtual_generic"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_docker_repository" "this" {
  for_each = local.repos_grouped["virtual_docker"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_npm_repository" "this" {
  for_each = local.repos_grouped["virtual_npm"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_pypi_repository" "this" {
  for_each = local.repos_grouped["virtual_pypi"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_helm_repository" "this" {
  for_each = local.repos_grouped["virtual_helm"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_go_repository" "this" {
  for_each = local.repos_grouped["virtual_go"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_nuget_repository" "this" {
  for_each = local.repos_grouped["virtual_nuget"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_conan_repository" "this" {
  for_each = local.repos_grouped["virtual_conan"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_debian_repository" "this" {
  for_each = local.repos_grouped["virtual_debian"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_rpm_repository" "this" {
  for_each = local.repos_grouped["virtual_rpm"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_alpine_repository" "this" {
  for_each = local.repos_grouped["virtual_alpine"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_virtual_oci_repository" "this" {
  for_each = local.repos_grouped["virtual_oci"]

  depends_on = [terraform_data.local_and_remote_ready]

  key                     = each.value.name
  description             = each.value.description
  repositories            = each.value.repositories
  default_deployment_repo = try(each.value.default_deployment_repo, null)

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}
