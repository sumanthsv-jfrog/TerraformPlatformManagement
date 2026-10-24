# Copy to s3.hcl and fill in your bucket details:
#   cp backend-configs/s3.example.hcl backend-configs/s3.hcl
#
# TEST key — does not touch your local terraform.tfstate file.
# Use plan-only until you migrate state (see README).

bucket  = "sum-fortescue-terraform-demo"
key     = "jfrog-management/terraform/sum2/terraform.tfstate"
region  = "ap-south-1"
encrypt = true

# Optional — enables state locking (recommended for real use)
# dynamodb_table = "terraform-state-lock"
