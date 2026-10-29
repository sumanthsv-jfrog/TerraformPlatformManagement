# Copy to s3-staging.hcl and fill in your bucket details:
#   cp backend-configs/s3-staging.example.hcl backend-configs/s3-staging.hcl

bucket       = "sum-fortescue-terraform-demo"
key          = "jfrog-management/terraform/sum2/staging/terraform.tfstate"
region       = "ap-south-1"
encrypt      = true
use_lockfile = true
