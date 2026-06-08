---
case: attached-policy-effective-privilege-overclaim
expected: fail
skill: iam-review
---

# Vulnerable Case: Attached Policy Treated as Effective Privilege

## IAM Evidence

- Principal: `build-bot`.
- Provider scope: hybrid AWS and Entra ID review.
- Assigned privilege: `AdministratorAccess` attached to the AWS IAM user and Global Administrator eligible role in Entra PIM.
- Missing effective privilege modifiers:
  - Permission boundary status is unknown.
  - SCP and account-level deny policies were not exported.
  - IAM policy simulator output is missing.
  - Entra PIM assignment is eligible, but activation logs and approval requirements are not exported.
  - Conditional Access policy is report-only and excludes service principals.
- Activity source gap:
  - AWS credential report says `password_last_used: N/A`.
  - Access key last-used evidence is missing.
  - CloudTrail retention is seven days, but the stale-account conclusion covers 90 days.
  - Entra sign-in logs are unavailable because the export lacks the required license scope.
- Owner and exception gap: no business owner, break-glass classification, monitoring alert, or exception expiry is documented.

## Expected Skill Behavior

The review must not conclude either "confirmed active admin" or "confirmed stale/inactive admin" from attached policy and `N/A` password data alone. It should classify the effective privilege and stale-account dimensions as Not Evaluable, record missing boundary/SCP/PIM/activity evidence, and require live exports or audit logs before assigning final severity or accepting the account as safe.
