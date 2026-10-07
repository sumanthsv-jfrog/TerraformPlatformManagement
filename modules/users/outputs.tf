output "names" {
  description = "User names managed by this module"
  value       = sort(keys(artifactory_unmanaged_user.this))
}
