output "names" {
  description = "Group names managed by this module"
  value       = sort(keys(platform_group.this))
}
