provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# Alias for secondary regions or specific accounts if needed
# provider "aws" {
#   alias  = "security"
#   region = var.aws_region
#   assume_role {
#     role_arn = "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
#   }
# }
