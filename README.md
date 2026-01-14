# AWS Secure Landing Zone (Terraform)

This project provides a comprehensive, enterprise-grade AWS Landing Zone implementation using Terraform. It establishes a multi-account environment following AWS best practices for security, scalability, and governance.

## Architecture Highlights

The architecture is built on AWS Organizations and includes:

- **Organizational Units (OUs)**: Separation of concerns between `Security`, `Workloads`, and `Infrastructure`.
- **Core Accounts**:
    - **Logging Account**: Centralized storage for CloudTrail and Config logs.
    - **Security Account**: For auditing, guardrails, and centralized security tooling.
- **Centralized Logging**: CloudTrail is enabled at the Organization level, streaming logs to a secured bucket in the Logging account.
- **Networking Baseline**: Standard VPC structure with public and private subnets across multiple Availability Zones.
- **Governance**: Service Control Policies (SCPs) and tagging standards.

## Project Structure

```text
├── main.tf                 # Root orchestration
├── providers.tf            # AWS provider configuration
├── terraform.tf            # Backend and Terraform settings
├── variables.tf            # Root variables
├── environments/           # Environment-specific .tfvars
└── modules/
    ├── organizations/      # AWS Organizations, OUs, and Accounts
    ├── logging/            # S3 buckets and CloudTrail
    ├── networking/         # VPC, Subnets, and IGW
    └── iam/                # IAM Roles and Guardrails (Extension point)
```

## Security Design

1. **Least Privilege**: All IAM roles and policies follow the principle of least privilege.
2. **Auditability**: Organization-wide CloudTrail ensures every API call is logged and immutable.
3. **Data Protection**: All S3 buckets use server-side encryption and public access blocks.
4. **OIDC Authentication**: CI/CD pipelines use OpenID Connect (OIDC) to assume AWS roles, eliminating the need for long-lived secrets.

## Getting Started

### Prerequisites
- AWS Management Account access.
- Terraform CLI (v1.5+).
- An S3 bucket for the Terraform state.

### Deployment

1. **Initialize**:
   ```bash
   terraform init -backend-config="bucket=<YOUR_STATE_BUCKET>" -backend-config="key=prod.tfstate" -backend-config="region=us-east-1"
   ```
2. **Plan**:
   ```bash
   terraform plan -var-file="environments/prod.tfvars"
   ```
3. **Apply**:
   ```bash
   terraform apply -var-file="environments/prod.tfvars"
   ```

## CI/CD with GitHub Actions

Automated workflows are provided in `.github/workflows/`:
- `terraform-plan.yml`: Validates and plans infrastructure on Pull Requests.
- `terraform-apply.yml`: Deploys infrastructure on merge to `main` (requires `prod` environment approval).

### Required GitHub Secrets
- `AWS_ROLE_ARN`: The ARN of the IAM role for GitHub to assume via OIDC.
- `TF_BACKEND_BUCKET`: The S3 bucket name for Terraform state.
- `AWS_REGION`: (Variable) Target region.

## Reusability

To adapt this for consulting or multiple environments:
1. Update `environments/*.tfvars` with client-specific values.
2. Extend the `modules/iam` for specific compliance frameworks (NIST, CIS, etc.).
3. Modify the OU structure in `modules/organizations/main.tf` to match organizational needs.
