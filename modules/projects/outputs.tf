output "keys" {
  description = "Project keys managed by this module"
  value       = sort(keys(project_project.this))
}

output "user_ids" {
  description = "Project memberships for users, as project_key:username"
  value       = sort(keys(project_user.this))
}

output "group_ids" {
  description = "Project memberships for groups, as project_key:groupname"
  value       = sort(keys(project_group.this))
}

output "repository_ids" {
  description = "Repositories assigned to projects, as project_key:repository_key"
  value       = sort(keys(project_repository.this))
}
