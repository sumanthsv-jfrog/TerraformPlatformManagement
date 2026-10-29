# Copy to s3-prod.hcl and fill in your bucket details:
#   cp backend-configs/s3-prod.example.hcl backend-configs/s3-prod.hcl
#
# TEST key — does not touch your local terraform.tfstate file.
# Use plan-only until you migrate state (see README).

bucket       = "sum-fortescue-terraform-demo"
key          = "jfrog-management/terraform/sum2/prod/terraform.tfstate"
region       = "ap-south-1"
encrypt      = true
use_lockfile = true
