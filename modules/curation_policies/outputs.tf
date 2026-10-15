output "names" {
  description = "Curation policy names managed by this module"
  value       = sort(keys(xray_curation_policy.this))
}
