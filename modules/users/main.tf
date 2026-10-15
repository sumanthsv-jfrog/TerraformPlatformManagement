resource "artifactory_unmanaged_user" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  name                       = each.value.name
  email                      = each.value.email
  password                   = each.value.password
  admin                      = each.value.admin
  disable_ui_access          = each.value.disable_ui_access
  profile_updatable          = each.value.profile_updatable
  internal_password_disabled = each.value.internal_password_disabled
  groups                     = each.value.groups
}
