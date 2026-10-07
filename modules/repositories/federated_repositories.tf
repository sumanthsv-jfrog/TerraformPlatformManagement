# Federated repositories

resource "artifactory_federated_docker_v2_repository" "this" {
  for_each = local.repos_grouped["federated_docker"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_generic_repository" "this" {
  for_each = local.repos_grouped["federated_generic"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_maven_repository" "this" {
  for_each = local.repos_grouped["federated_maven"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_npm_repository" "this" {
  for_each = local.repos_grouped["federated_npm"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_helm_repository" "this" {
  for_each = local.repos_grouped["federated_helm"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_go_repository" "this" {
  for_each = local.repos_grouped["federated_go"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_gradle_repository" "this" {
  for_each = local.repos_grouped["federated_gradle"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_nuget_repository" "this" {
  for_each = local.repos_grouped["federated_nuget"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_conan_repository" "this" {
  for_each = local.repos_grouped["federated_conan"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_cargo_repository" "this" {
  for_each = local.repos_grouped["federated_cargo"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_debian_repository" "this" {
  for_each = local.repos_grouped["federated_debian"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_rpm_repository" "this" {
  for_each = local.repos_grouped["federated_rpm"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_alpine_repository" "this" {
  for_each = local.repos_grouped["federated_alpine"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

resource "artifactory_federated_oci_repository" "this" {
  for_each = local.repos_grouped["federated_oci"]

  key         = each.value.name
  description = each.value.description

  dynamic "member" {
    for_each = each.value.members
    content {
      url     = member.value.url
      enabled = member.value.enabled
    }
  }

  # Set by project_repository. Ignore so assignment does not drift the Artifactory resource.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}
