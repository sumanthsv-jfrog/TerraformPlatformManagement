variable "jfrog_token" {
  description = "JFrog access token for the staging JPD (172.18.96.199:8082) for local runs. GitHub Actions supplies the staging token from OIDC or a secret instead."
  type        = string
  sensitive   = true
  default     = null
}
