locals {
  permission_actions = {
    for permission in var.permissions :
    permission.name => {
      groups = [
        for group in permission.groups : {
          name        = group.name
          permissions = coalesce(group.permissions, group.operations)
        }
      ]
      users = [
        for user in permission.users : {
          name        = user.name
          permissions = coalesce(user.permissions, user.operations)
        }
      ]
    }
  }

  permissions = {
    for permission in var.permissions :
    permission.name => {
      targets = [
        for target in permission.targets : {
          name             = target.repo
          include_patterns = target.include_patterns
          exclude_patterns = target.exclude_patterns
        }
      ]
      actions = local.permission_actions[permission.name]
    }
  }
}

resource "platform_permission" "this" {
  for_each = local.permissions

  name = each.key

  artifact = {
    targets = each.value.targets
    actions = {
      groups = length(each.value.actions.groups) > 0 ? each.value.actions.groups : null
      users  = length(each.value.actions.users) > 0 ? each.value.actions.users : null
    }
  }
}
