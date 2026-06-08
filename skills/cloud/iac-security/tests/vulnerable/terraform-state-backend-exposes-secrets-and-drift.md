# Vulnerable Fixture: Terraform State Backend Exposes Secrets and Drift

## Scenario

A Terraform review passes because the current `.tf` files use variables and
secure-looking resources. The production state backend is a shared S3 bucket
without a complete access boundary, and the state still contains historical
database credentials plus drifted live infrastructure.

## Evidence Snapshot

| Field | Value |
|---|---|
| Stack | `payments-prod` |
| Backend | `s3://shared-state/prod.tfstate` |
| Backend encryption | `encrypt = false`; no CMK evidence |
| Public access block | Not evidenced |
| State locking | No DynamoDB lock table / no native lock evidence |
| Versioning / recovery | Disabled; no restore test |
| State readers | `Developers` group can `s3:GetObject` on all state prefixes |
| Apply permissions | Same `Developers` group can assume `TerraformApplyRole` |
| Sensitive values | State includes `aws_db_instance.master_password` and generated kubeconfig output |
| Drift evidence | Last drift run unknown; live security group has manual `0.0.0.0/0` ingress |
| Audit logs | S3 data events disabled; state reads not attributable |
| Workspace separation | Dev and prod states share the same bucket prefix |

## Problem Indicators

- `IAC-STATE-01`: Production state backend is not governed per workspace.
- `IAC-STATE-02`: Backend encryption, public block, and access boundaries are missing.
- `IAC-STATE-03`: Locking, versioning, retention, and recovery evidence are absent.
- `IAC-STATE-04`: State read and production apply permissions are not separated.
- `IAC-STATE-05`: Sensitive provider attributes persist in state.
- `IAC-STATE-06`: Live infrastructure drift is not detected or reviewed.
- `IAC-STATE-07`: Backend audit logs do not cover state reads and writes.
- `IAC-STATE-08`: Shared workspace and recovery paths are undocumented.

## Expected Finding

Classify as **High** because state compromise can reveal secrets and enable
control-plane manipulation even when the current IaC source appears clean.

## Required Remediation

Move state to a governed backend, enable encryption with owned keys, block
public/cross-account access, enforce locking/versioning/recovery, separate
read/plan/apply/admin permissions, rotate secrets found in state, run drift
detection, and enable backend data-event auditing.
