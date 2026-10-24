variable "jfrog_token" {
  description = "Optional JFrog access token for local runs. GitHub Actions supplies JFROG_ACCESS_TOKEN from OIDC instead."
  type        = string
  sensitive   = true
  default     = null
}
