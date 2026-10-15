# S3 is the default state backend. Bucket, key, and region come from
# backend-configs/*.hcl at init time:
#   cp backend-configs/s3.example.hcl backend-configs/s3.hcl
#   terraform init -reconfigure -backend-config=backend-configs/s3.hcl
#
# Credentials are AWS keys in the environment, not the JFrog access token.
# Comment this block out only if you intentionally want local terraform.tfstate.

terraform {
  backend "s3" {}
}

