resource "xray_curation_policy" "this" {
  for_each = local.policies

  name                  = each.value.name
  condition_id          = each.value.resolved_condition_id
  scope                 = each.value.scope
  policy_action         = each.value.policy_action
  waiver_request_config = each.value.waiver_request_config
  repo_include          = length(each.value.repo_include) > 0 ? each.value.repo_include : null
  repo_exclude          = length(each.value.repo_exclude) > 0 ? each.value.repo_exclude : null
  pkg_types_include     = length(each.value.pkg_types_include) > 0 ? each.value.pkg_types_include : null
  decision_owners       = length(each.value.decision_owners) > 0 ? each.value.decision_owners : null
  notify_emails         = length(each.value.notify_emails) > 0 ? each.value.notify_emails : null
  waivers = length(each.value.waivers) > 0 ? [
    for waiver in each.value.waivers : {
      pkg_type      = waiver.pkg_type
      pkg_name      = waiver.pkg_name
      all_versions  = waiver.all_versions
      pkg_versions  = waiver.pkg_versions
      justification = waiver.justification
    }
  ] : null
  label_waivers = length(each.value.label_waivers) > 0 ? [
    for label_waiver in each.value.label_waivers : {
      label         = label_waiver.label
      justification = label_waiver.justification
    }
  ] : null
}
