---
case: effective-privilege-constrained-cross-account-role
expected: pass
skill: iam-review
---

# Benign Case: Constrained Cross-Account Deployment Role

## IAM Evidence

- Principal: `arn:aws:iam::111122223333:role/vendor-ci-deploy`.
- Trusted role: `arn:aws:iam::444455556666:role/prod-release-deploy`.
- Assigned privilege: managed policy includes broad deployment actions for ECS, CloudFormation, S3 artifact reads, and CloudWatch log writes.
- Effective privilege modifiers:
  - Permission boundary denies IAM user, role-policy, KMS key-policy, and organization-management changes.
  - Organization SCP denies all actions outside `us-east-1` and `us-west-2`.
  - Trust policy requires `sts:ExternalId` value tied to ticket `IAM-7421`.
  - Trust policy requires MFA and caps session duration at one hour.
  - Resource conditions restrict deployment actions to stacks tagged `release-approved=true`.
- Enforcement state: boundary and SCP exports are from live AWS Organizations and IAM exports captured on 2026-06-01.
- Activity source: CloudTrail management events and IAM Access Analyzer external-access finding review.
- Last activity confidence: high; CloudTrail retention covers 180 days and shows two assumed-role sessions, both tied to approved release windows.
- Owner and exception: release engineering owns the role; exception expires on 2026-09-01 with monthly Access Analyzer review.

## Expected Skill Behavior

The role should not be reported as an unconstrained cross-account admin finding based only on the broad attached deployment policy. The review may still document the role as sensitive, but it should preserve the effective privilege modifiers, enforcement state, owner, expiry, activity source, and evidence confidence.
