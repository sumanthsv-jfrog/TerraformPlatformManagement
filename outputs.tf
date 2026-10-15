output "environment" {
  description = "Active environment configuration"
  value       = var.environment
}

output "repository_keys" {
  description = "Keys of repositories managed by Terraform"
  value       = module.repositories.keys
}

output "project_keys" {
  description = "Keys of JFrog projects managed by Terraform"
  value       = module.projects.keys
}

output "group_names" {
  description = "Names of groups managed by Terraform"
  value       = module.groups.names
}

output "user_names" {
  description = "Names of users managed by Terraform"
  value       = module.users.names
}

output "permission_names" {
  description = "Names of permissions managed by Terraform"
  value       = module.permissions.names
}

output "xray_policy_names" {
  description = "Names of Xray policies managed by Terraform"
  value       = module.xray_policies.all_policy_names
}

output "xray_watch_names" {
  description = "Names of Xray watches managed by Terraform"
  value       = module.xray_watches.names
}

output "curation_condition_names" {
  description = "Names of custom curation conditions managed by Terraform"
  value       = module.curation_conditions.names
}

output "curation_policy_names" {
  description = "Names of curation policies managed by Terraform"
  value       = module.curation_policies.names
}
