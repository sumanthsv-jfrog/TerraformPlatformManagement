variable "conditions" {
  description = "Custom curation conditions (param_values pre-encoded as JSON in root locals)"
  type = list(object({
    name         = string
    template_id  = string
    param_values = string
  }))
  default = []
}
