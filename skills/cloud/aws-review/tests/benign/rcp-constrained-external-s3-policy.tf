# Benign fixture: an external-looking S3 bucket policy is constrained by an
# attached, enabled RCP with evidence that the reviewed resource path is denied.

locals {
  organization_id       = "o-exampleorg"
  member_account_id     = "111111111111"
  production_ou_id      = "ou-abcd-12345678"
  reviewed_resource     = "arn:aws:s3:::example-reports/*"
  effective_deny_signal = "cloudtrail AccessDenied for s3:GetObject by arn:aws:iam::222222222222:role/partner-reader"

  expected_aws_review_result = {
    finding_state        = "informational"
    guardrail_confidence = "high"
    rationale            = "RCP is enabled, attached to the production OU, covers the member account resource, targets S3 object access, and has effective-deny evidence."
  }
}

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"

  aws_service_access_principals = [
    "access-analyzer.amazonaws.com"
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "RESOURCE_CONTROL_POLICY"
  ]
}

resource "aws_organizations_policy" "deny_external_s3_resource_access" {
  name = "deny-external-s3-resource-access"
  type = "RESOURCE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyExternalS3ObjectAccess"
        Effect    = "Deny"
        Principal = "*"
        Action    = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::example-reports/*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalOrgID" = local.organization_id
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "prod_ou_rcp" {
  policy_id = aws_organizations_policy.deny_external_s3_resource_access.id
  target_id = local.production_ou_id
}

resource "aws_s3_bucket" "reports" {
  bucket = "example-reports"
}

resource "aws_s3_bucket_policy" "reports_partner_read" {
  bucket = aws_s3_bucket.reports.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPartnerReadIfNotConstrained"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::222222222222:role/partner-reader"
        }
        Action   = "s3:GetObject"
        Resource = local.reviewed_resource
      }
    ]
  })
}
