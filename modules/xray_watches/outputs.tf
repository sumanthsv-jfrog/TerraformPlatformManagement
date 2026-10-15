output "names" {
  description = "Xray watch names managed by this module"
  value       = sort(keys(xray_watch.this))
}
