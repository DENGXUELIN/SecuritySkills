# Vulnerable fixture: a resource policy allows an external principal while the
# only Organizations evidence is a principal-side SCP that does not prove
# resource-side denial for the external access path.

locals {
  organization_id   = "o-exampleorg"
  member_account_id = "111111111111"
  reviewed_resource = "arn:aws:s3:::customer-exports/*"

  expected_aws_review_result = {
    finding_state        = "high"
    guardrail_confidence = "not_evaluable"
    rationale            = "The SCP constrains principals in member accounts, but no enabled, attached, applicable RCP or effective-deny evidence constrains the external principal reading the resource policy."
  }
}

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
}

resource "aws_organizations_policy" "deny_unapproved_regions" {
  name = "deny-unapproved-regions"
  type = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyOutsideApprovedRegions"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = [
              "us-east-1",
              "us-west-2"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "prod_account_scp" {
  policy_id = aws_organizations_policy.deny_unapproved_regions.id
  target_id = local.member_account_id
}

resource "aws_s3_bucket" "customer_exports" {
  bucket = "customer-exports"
}

resource "aws_s3_bucket_policy" "external_export_reader" {
  bucket = aws_s3_bucket.customer_exports.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowExternalExportReader"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::222222222222:role/external-export-reader"
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::customer-exports",
          local.reviewed_resource
        ]
      }
    ]
  })
}
