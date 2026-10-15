output "keys" {
  description = "Repository keys managed by this module"
  value       = sort(keys(local.repo_map))
}
