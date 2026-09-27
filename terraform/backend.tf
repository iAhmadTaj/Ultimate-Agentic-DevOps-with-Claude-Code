# Terraform Backend Configuration
#
# SETUP INSTRUCTIONS:
# 1. First run: `terraform init` (without backend configured)
# 2. Run: `terraform apply` to create initial resources
# 3. Uncomment the backend block below
# 4. Run: `terraform init -migrate-state` to migrate local state to S3
# 5. All subsequent runs will use S3 backend for state management
#
# Uncomment the backend block when you're ready to migrate to remote state:
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
