output "names" {
  description = "Custom curation condition names"
  value       = sort(keys(xray_custom_curation_condition.this))
}

output "ids" {
  description = "Map of condition name to API condition ID for use in curation policies"
  value       = { for name, condition in xray_custom_curation_condition.this : name => condition.id }
}
