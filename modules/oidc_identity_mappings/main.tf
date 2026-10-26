resource "platform_oidc_identity_mapping" "this" {
  for_each = {
    for mapping in var.identity_mappings :
    mapping.name => mapping
  }

  name          = each.value.name
  description   = each.value.description
  provider_name = each.value.provider_name
  priority      = each.value.priority
  claims_json   = each.value.claims_json

  token_spec = {
    username         = each.value.token_spec.username
    username_pattern = each.value.token_spec.username_pattern
    groups_pattern   = each.value.token_spec.groups_pattern
    scope            = each.value.token_spec.scope
    audience         = each.value.token_spec.audience
    expires_in       = each.value.token_spec.expires_in
  }
}
