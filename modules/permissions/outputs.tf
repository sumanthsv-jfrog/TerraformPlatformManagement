output "names" {
  description = "Permission names managed by this module"
  value       = sort(keys(platform_permission.this))
}
