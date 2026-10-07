locals {
  conditions = {
    for condition in var.conditions :
    condition.name => condition
  }
}

resource "xray_custom_curation_condition" "this" {
  for_each = local.conditions

  name                  = each.value.name
  condition_template_id = each.value.template_id
  param_values          = each.value.param_values
}
