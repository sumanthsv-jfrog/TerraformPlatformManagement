locals {
  config = yamldecode(file("${path.module}/environments/${var.environment}.yaml"))

  # YAML params mix types (list, bool, map) — jsonencode here so the module gets a uniform shape
  curation_conditions = [
    for condition in try(local.config.curation_conditions, []) : {
      name         = condition.name
      template_id  = condition.template_id
      param_values = jsonencode([
        for param in condition.params : {
          param_id = param.param_id
          value    = param.value
        }
      ])
    }
  ]
}
