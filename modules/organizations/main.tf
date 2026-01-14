resource "aws_organizations_organization" "main" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com"
  ]
  enabled_policy_types = ["SERVICE_CONTROL_POLICY", "TAG_POLICY"]
  feature_set          = "ALL"
}

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_account" "logging" {
  name  = "Logging"
  email = "aws-logging@${var.domain_name}"
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_account" "security" {
  name  = "Security-Audit"
  email = "aws-security@${var.domain_name}"
  parent_id = aws_organizations_organizational_unit.security.id
}
