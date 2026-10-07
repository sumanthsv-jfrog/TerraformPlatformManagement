variable "jfrog_token" {
  description = "JFrog access token"
  type        = string
  sensitive   = true
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
