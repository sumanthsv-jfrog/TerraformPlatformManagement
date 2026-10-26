resource "platform_oidc_configuration" "this" {
  for_each = {
    for config in var.oidc_configurations :
    config.name => config
  }

  name                            = each.value.name
  description                     = each.value.description
  issuer_url                      = each.value.issuer_url
  provider_type                   = each.value.provider_type
  audience                        = each.value.audience
  organization                    = each.value.organization
  azure_app_id                    = each.value.azure_app_id
  token_issuer                    = each.value.token_issuer
  enable_permissive_configuration = each.value.enable_permissive_configuration
  use_default_proxy               = each.value.use_default_proxy
}
