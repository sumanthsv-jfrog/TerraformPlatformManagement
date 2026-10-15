output "security_policy_names" {
  description = "Xray security policy names"
  value       = sort(keys(xray_security_policy.this))
}

output "license_policy_names" {
  description = "Xray license policy names"
  value       = sort(keys(xray_license_policy.this))
}

output "operational_risk_policy_names" {
  description = "Xray operational risk policy names"
  value       = sort(keys(xray_operational_risk_policy.this))
}

output "all_policy_names" {
  description = "All Xray policy names managed by this module"
  value = sort(concat(
    keys(xray_security_policy.this),
    keys(xray_license_policy.this),
    keys(xray_operational_risk_policy.this),
  ))
}
