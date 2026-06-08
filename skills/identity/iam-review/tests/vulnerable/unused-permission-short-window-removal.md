# Vulnerable Fixture: Unused Permission Removed From Short Window

## Scenario

An IAM role is downscoped because the provider access summary reports no use of
`kms:Decrypt` in the last 30 days. The role supports a quarterly disaster
recovery restore job, so the permission is periodic rather than unused.

## Evidence Snapshot

| Field | Value |
|---|---|
| Principal | `arn:aws:iam::111122223333:role/prod-backup-restore` |
| Policy | `ProdBackupRestorePolicy` |
| Permission | `kms:Decrypt` |
| Resource scope | `arn:aws:kms:us-east-1:111122223333:key/prod-backup-key` |
| Usage data source | IAM service last accessed summary |
| Observation window | `2026-05-01` to `2026-05-31` |
| Last used | `not reported` |
| Provider limitation | Service summary does not include quarterly job context |
| Secondary evidence | Not checked |
| Business owner | Not contacted |
| Change | Permission removed directly from production role |
| Rollback | None documented |

## Problem Indicators

- `IAM-UPERM-02`: The usage source is too coarse to prove the specific
  action/resource pair is unused.
- `IAM-UPERM-03`: The 30-day observation window is shorter than the quarterly
  disaster recovery process.
- `IAM-UPERM-05`: CloudTrail KMS events, restore job logs, and backup tickets were
  not reviewed.
- `IAM-UPERM-06`: The backup platform owner did not confirm whether the
  permission is still needed.
- `IAM-UPERM-08`: The downscope has no staged rollout, restore-test monitoring, or
  rollback plan.

## Expected Finding

Classify as **Medium** or **High** depending on restore criticality. The role may
look inactive in a short provider summary, but removal can break disaster
recovery and should not be recommended without complete unused-permission
evidence.

## Required Remediation

Rebuild the unused-permission finding using a window that covers the business
process, resource-scoped telemetry, backup job evidence, owner confirmation,
staged downscope, monitoring, and rollback evidence.
