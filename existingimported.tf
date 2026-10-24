# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "testpolicy"
resource "xray_security_policy" "testpolicy" {
  description = null
  name        = "testpolicy"
  project_key = null
  type        = "security"
  rule {
    name     = "high"
    priority = 1
    actions {
      block_release_bundle_distribution  = false
      block_release_bundle_promotion     = false
      build_failure_grace_period_in_days = 0
      create_ticket_enabled              = false
      fail_build                         = false
      fail_pull_request                  = false
      mails                              = null
      notify_deployer                    = true
      notify_watch_recipients            = false
      webhooks                           = null
      block_download {
        active            = false
        grace_period_days = 0
        unscanned         = false
      }
    }
    criteria {
      applicable_cves_only  = null
      fix_version_dependant = false
      malicious_package     = false
      min_severity          = "High"
      package_name          = null
      package_type          = null
      package_versions      = null
      vulnerability_ids     = null
    }
  }
}

# __generated__ by Terraform from "1"
resource "xray_curation_policy" "malicious" {
  block_from_cache      = false
  condition_id          = "1"
  decision_owners       = null
  label_waivers         = null
  name                  = "malicious"
  notify_emails         = null
  pkg_types_include     = null
  policy_action         = "block"
  repo_exclude          = null
  repo_include          = null
  scope                 = "all_repos"
  share_with_federation = false
  waiver_request_config = "forbidden"
  waivers               = null
}

# __generated__ by Terraform from "2"
resource "xray_curation_policy" "critical" {
  block_from_cache      = false
  condition_id          = "2"
  decision_owners       = null
  label_waivers         = null
  name                  = "critical"
  notify_emails         = null
  pkg_types_include     = null
  policy_action         = "block"
  repo_exclude          = null
  repo_include          = ["npm-remote2"]
  scope                 = "specific_repos"
  share_with_federation = false
  waiver_request_config = "auto_approved"
  waivers               = null
}

# __generated__ by Terraform from "generec2-virtual"
resource "artifactory_virtual_generic_repository" "generec2_virtual" {
  artifactory_requests_can_retrieve_remote_artifacts = false
  default_deployment_repo                            = null
  description                                        = null
  excludes_pattern                                   = null
  hide_unauthorized_resources                        = false
  includes_pattern                                   = "**/*"
  key                                                = "generec2-virtual"
  notes                                              = null
  project_environments                               = []
  project_key                                        = null
  repo_layout_ref                                    = "simple-default"
  repositories                                       = ["generec2-local"]

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "generec2-local"
resource "artifactory_federated_generic_repository" "generec2_local" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  cleanup_on_delete        = null
  description              = null
  disable_proxy            = false
  download_direct          = false
  excludes_pattern         = null
  includes_pattern         = "**/*"
  key                      = "generec2-local"
  notes                    = null
  priority_resolution      = false
  project_environments     = []
  project_key              = null
  property_sets            = ["artifactory"]
  proxy                    = null
  repo_layout_ref          = "simple-default"
  xray_index               = false
  member {
    access_token = null # sensitive
    enabled      = true
    url          = "http://sum2.jfps.team/artifactory/generec2-local"
  }

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "example-repo-local"
resource "artifactory_local_generic_repository" "example_repo_local" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  description              = "Example artifactory repository"
  download_direct          = false
  includes_pattern         = "**/*"
  key                      = "example-repo-local"
  priority_resolution      = false
  project_environments     = []
  property_sets            = null
  repo_layout_ref          = "simple-default"
  xray_index               = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "docker-inst-local"
resource "artifactory_federated_generic_repository" "docker_inst_local" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  cleanup_on_delete        = null
  description              = null
  disable_proxy            = false
  download_direct          = false
  excludes_pattern         = null
  includes_pattern         = "**/*"
  key                      = "docker-inst-local"
  notes                    = null
  priority_resolution      = false
  project_environments     = []
  property_sets            = ["artifactory"]
  proxy                    = null
  repo_layout_ref          = "simple-default"
  xray_index               = false
  member {
    access_token = null # sensitive
    enabled      = true
    url          = "http://sum2.jfps.team/artifactory/docker-inst-local"
  }

  # Set by project_repository (projects/fstg.yaml). Ignore so the next plan
  # does not undo the assignment.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "newreplication2"
resource "artifactory_local_generic_repository" "newreplication2" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  download_direct          = false
  includes_pattern         = "**/*"
  key                      = "newreplication2"
  priority_resolution      = false
  project_environments     = []
  property_sets            = ["artifactory"]
  repo_layout_ref          = "simple-default"
  xray_index               = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "fstg-libs-release-local"
resource "artifactory_local_maven_repository" "fstg_libs_release_local" {
  archive_browsing_enabled        = false
  blacked_out                     = false
  cdn_redirect                    = false
  checksum_policy_type            = "client-checksums"
  description                     = "Staging Maven local repository"
  download_direct                 = false
  handle_releases                 = true
  handle_snapshots                = true
  includes_pattern                = "**/*"
  key                             = "fstg-libs-release-local"
  max_unique_snapshots            = 0
  priority_resolution             = false
  project_environments            = []
  property_sets                   = null
  repo_layout_ref                 = "maven-2-default"
  snapshot_version_behavior       = "unique"
  suppress_pom_consistency_checks = false
  xray_index                      = true

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "generec3-local"
resource "artifactory_local_generic_repository" "generec3_local" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  download_direct          = false
  includes_pattern         = "**/*"
  key                      = "generec3-local"
  priority_resolution      = false
  project_environments     = []
  property_sets            = ["artifactory"]
  repo_layout_ref          = "simple-default"
  xray_index               = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "npm-remote2"
resource "artifactory_remote_npm_repository" "npm_remote2" {
  allow_any_host_auth                   = false
  archive_browsing_enabled              = false
  assumed_offline_period_secs           = 300
  blacked_out                           = false
  block_mismatching_mime_types          = true
  bypass_head_requests                  = false
  cdn_redirect                          = false
  curated                               = true
  disable_proxy                         = false
  disable_url_normalization             = false
  download_direct                       = false
  enable_cookie_management              = false
  enable_token_authentication           = false
  hard_fail                             = false
  includes_pattern                      = "**/*"
  key                                   = "npm-remote2"
  list_remote_folder_items              = false
  metadata_retrieval_timeout_secs       = 60
  missed_cache_period_seconds           = 1800
  offline                               = false
  pass_through                          = true
  password                              = null # sensitive
  password_wo                           = null # sensitive
  password_wo_version                   = null
  priority_resolution                   = false
  project_environments                  = []
  property_sets                         = ["artifactory"]
  repo_layout_ref                       = "npm-default"
  retrieval_cache_period_seconds        = 7200
  socket_timeout_millis                 = 15000
  store_artifacts_locally               = true
  synchronize_properties                = false
  unused_artifacts_cleanup_period_hours = 0
  url                                   = "https://registry.npmjs.org"
  xray_index                            = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "secondrepo-local"
resource "artifactory_federated_generic_repository" "secondrepo_local" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  cleanup_on_delete        = null
  description              = null
  disable_proxy            = false
  download_direct          = false
  excludes_pattern         = null
  includes_pattern         = "**/*"
  key                      = "secondrepo-local"
  notes                    = null
  priority_resolution      = false
  project_environments     = []
  project_key              = null
  property_sets            = ["artifactory"]
  proxy                    = null
  repo_layout_ref          = "simple-default"
  xray_index               = false
  member {
    access_token = null # sensitive
    enabled      = true
    url          = "http://sum2.jfps.team/artifactory/secondrepo-local"
  }

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "npm-remote"
resource "artifactory_remote_npm_repository" "npm_remote" {
  allow_any_host_auth                   = false
  archive_browsing_enabled              = false
  assumed_offline_period_secs           = 300
  blacked_out                           = false
  block_mismatching_mime_types          = true
  bypass_head_requests                  = false
  cdn_redirect                          = false
  curated                               = true
  disable_proxy                         = false
  disable_url_normalization             = false
  download_direct                       = false
  enable_cookie_management              = false
  enable_token_authentication           = false
  hard_fail                             = false
  includes_pattern                      = "**/*"
  key                                   = "npm-remote"
  list_remote_folder_items              = false
  metadata_retrieval_timeout_secs       = 60
  missed_cache_period_seconds           = 1800
  offline                               = false
  pass_through                          = true
  password                              = null # sensitive
  password_wo                           = null # sensitive
  password_wo_version                   = null
  priority_resolution                   = false
  project_environments                  = []
  property_sets                         = ["artifactory"]
  repo_layout_ref                       = "npm-default"
  retrieval_cache_period_seconds        = 7200
  socket_timeout_millis                 = 15000
  store_artifacts_locally               = true
  synchronize_properties                = false
  unused_artifacts_cleanup_period_hours = 0
  url                                   = "https://registry.npmjs.org"
  xray_index                            = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "docker-remote"
resource "artifactory_remote_docker_repository" "docker_remote" {
  allow_any_host_auth                   = false
  archive_browsing_enabled              = false
  assumed_offline_period_secs           = 300
  blacked_out                           = false
  block_mismatching_mime_types          = true
  block_pushing_schema1                 = true
  bypass_head_requests                  = false
  cdn_redirect                          = false
  curated                               = true
  disable_proxy                         = false
  disable_url_normalization             = false
  download_direct                       = false
  enable_cookie_management              = false
  enable_token_authentication           = true
  external_dependencies_enabled         = false
  external_dependencies_patterns        = null
  hard_fail                             = false
  includes_pattern                      = "**/*"
  key                                   = "docker-remote"
  list_remote_folder_items              = false
  metadata_retrieval_timeout_secs       = 60
  missed_cache_period_seconds           = 1800
  offline                               = false
  pass_through                          = true
  password                              = null # sensitive
  password_wo                           = null # sensitive
  password_wo_version                   = null
  priority_resolution                   = false
  project_environments                  = []
  property_sets                         = ["artifactory"]
  repo_layout_ref                       = "simple-default"
  retrieval_cache_period_seconds        = 21600
  socket_timeout_millis                 = 15000
  store_artifacts_locally               = true
  synchronize_properties                = false
  unused_artifacts_cleanup_period_hours = 0
  url                                   = "https://registry-1.docker.io/"
  xray_index                            = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "amarepo"
resource "artifactory_local_generic_repository" "amarepo" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  download_direct          = false
  includes_pattern         = "**/*"
  key                      = "amarepo"
  priority_resolution      = false
  project_environments     = []
  property_sets            = ["artifactory"]
  repo_layout_ref          = "simple-default"
  xray_index               = false

  # Set by project_repository (projects/fstg.yaml). Ignore so the next plan
  # does not undo the assignment.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "tengbrepo"
resource "artifactory_federated_generic_repository" "tengbrepo" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  cleanup_on_delete        = null
  description              = null
  disable_proxy            = false
  download_direct          = false
  excludes_pattern         = null
  includes_pattern         = "**/*"
  key                      = "tengbrepo"
  notes                    = null
  priority_resolution      = false
  project_environments     = []
  project_key              = null
  property_sets            = ["artifactory"]
  proxy                    = null
  repo_layout_ref          = "simple-default"
  xray_index               = false
  member {
    access_token = null # sensitive
    enabled      = true
    url          = "http://sum2.jfps.team/artifactory/tengbrepo"
  }

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "maven-remote"
resource "artifactory_remote_maven_repository" "maven_remote" {
  allow_any_host_auth                   = false
  archive_browsing_enabled              = false
  assumed_offline_period_secs           = 300
  blacked_out                           = false
  block_mismatching_mime_types          = true
  bypass_head_requests                  = false
  cdn_redirect                          = false
  curated                               = true
  disable_proxy                         = false
  disable_url_normalization             = false
  download_direct                       = false
  enable_cookie_management              = false
  enable_token_authentication           = false
  fetch_jars_eagerly                    = false
  fetch_sources_eagerly                 = false
  handle_releases                       = true
  handle_snapshots                      = true
  hard_fail                             = false
  includes_pattern                      = "**/*"
  key                                   = "maven-remote"
  list_remote_folder_items              = false
  max_unique_snapshots                  = 0
  metadata_retrieval_timeout_secs       = 60
  missed_cache_period_seconds           = 1800
  offline                               = false
  pass_through                          = true
  password                              = null # sensitive
  password_wo                           = null # sensitive
  password_wo_version                   = null
  priority_resolution                   = false
  project_environments                  = []
  property_sets                         = ["artifactory"]
  reject_invalid_jars                   = false
  remote_repo_checksum_policy_type      = "generate-if-absent"
  repo_layout_ref                       = "maven-2-default"
  retrieval_cache_period_seconds        = 7200
  socket_timeout_millis                 = 15000
  store_artifacts_locally               = true
  suppress_pom_consistency_checks       = false
  synchronize_properties                = false
  unused_artifacts_cleanup_period_hours = 0
  url                                   = "https://repo1.maven.org/maven2/"
  xray_index                            = true

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "testreplication"
resource "artifactory_local_generic_repository" "testreplication" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  download_direct          = false
  includes_pattern         = "**/*"
  key                      = "testreplication"
  priority_resolution      = false
  project_environments     = []
  property_sets            = ["artifactory"]
  repo_layout_ref          = "simple-default"
  xray_index               = false

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}

# __generated__ by Terraform from "jfrog-sanity-check"
resource "artifactory_local_generic_repository" "jfrog_sanity_check" {
  archive_browsing_enabled = false
  blacked_out              = false
  cdn_redirect             = false
  download_direct          = false
  includes_pattern         = "**/*"
  key                      = "jfrog-sanity-check"
  priority_resolution      = false
  project_environments     = []
  property_sets            = ["artifactory"]
  repo_layout_ref          = "simple-default"
  xray_index               = true

  # Set by project_repository. Ignore so a project assignment is not undone.
  lifecycle {
    ignore_changes = [project_key, project_environments]
  }
}
