locals {
  watches = {
    for watch in var.watches :
    watch.name => watch
  }
}

resource "xray_watch" "this" {
  for_each = local.watches

  name             = each.value.name
  description      = each.value.description
  active           = each.value.active
  watch_recipients = each.value.recipients

  dynamic "watch_resource" {
    for_each = each.value.resources
    content {
      type       = watch_resource.value.type
      name       = try(watch_resource.value.name, null)
      repo_type  = try(watch_resource.value.repo_type, null)
      bin_mgr_id = watch_resource.value.bin_mgr_id
    }
  }

  dynamic "assigned_policy" {
    for_each = each.value.policies
    content {
      name = assigned_policy.value.name
      type = assigned_policy.value.type
    }
  }
}
