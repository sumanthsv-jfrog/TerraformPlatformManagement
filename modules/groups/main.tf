resource "platform_group" "this" {
  for_each = {
    for group in var.groups :
    group.name => group
  }

  name                   = each.value.name
  description            = each.value.description
  auto_join              = each.value.auto_join
  admin_privileges       = each.value.admin_privileges
  policy_manager         = each.value.policy_manager
  policy_viewer          = each.value.policy_viewer
  watch_manager          = each.value.watch_manager
  reports_manager        = each.value.reports_manager
  manage_resources       = each.value.manage_resources
  manage_webhook         = each.value.manage_webhook
  use_group_members_resource = true
}
