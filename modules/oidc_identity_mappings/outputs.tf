output "names" {
  description = "OIDC identity mapping names managed by this module"
  value       = sort(keys(platform_oidc_identity_mapping.this))
}
