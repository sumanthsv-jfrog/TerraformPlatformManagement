# S3 is the default state backend. Bucket, key, and region come from
# backend-configs/*.hcl at init time (paths relative to this directory):
#   cp ../../backend-configs/s3-staging.example.hcl ../../backend-configs/s3-staging.hcl
#   terraform init -reconfigure -backend-config=../../backend-configs/s3-staging.hcl
#
# Credentials are AWS keys in the environment, not the JFrog access token.
# This environment has its own state file, completely separate from prod's —
# a staging apply can never see or change prod's state.
# Comment this block out only if you intentionally want local terraform.tfstate.

terraform {
  backend "s3" {}
}
