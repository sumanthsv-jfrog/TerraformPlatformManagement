output "names" {
  description = "OIDC configuration names managed by this module"
  value       = sort(keys(platform_oidc_configuration.this))
}
