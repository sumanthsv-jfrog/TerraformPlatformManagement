# S3 is the default state backend. Bucket, key, and region come from
# backend-configs/*.hcl at init time (paths relative to this directory):
#   cp ../../backend-configs/s3-prod.example.hcl ../../backend-configs/s3-prod.hcl
#   terraform init -reconfigure -backend-config=../../backend-configs/s3-prod.hcl
#
# Credentials are AWS keys in the environment, not the JFrog access token.
# Comment this block out only if you intentionally want local terraform.tfstate.

terraform {
  backend "s3" {}
}
