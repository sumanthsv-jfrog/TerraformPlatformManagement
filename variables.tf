variable "jfrog_token" {
  description = "Optional JFrog access token for local runs. GitHub Actions supplies JFROG_ACCESS_TOKEN from OIDC instead."
  type        = string
  sensitive   = true
  default     = null
}

variable "environment" {
  description = "Target environment — selects environments/<name>.yaml"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "environment must be one of: staging, prod."
  }
}
