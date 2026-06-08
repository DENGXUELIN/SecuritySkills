# Benign Fixture: Terraform State Backend Governed with Drift Evidence

## Scenario

A Terraform production stack uses a governed remote backend. The review collects
backend security, state access, secret minimization, drift detection, and audit
evidence before marking the IaC control-plane posture acceptable.

## Evidence Snapshot

| Field | Value |
|---|---|
| Stack | `payments-prod` |
| Backend | S3 backend with workspace-specific prefix `payments/prod/terraform.tfstate` |
| Backend encryption | SSE-KMS using `alias/tfstate-prod`, key owned by platform security |
| Public access block | Enabled for bucket and account |
| Network restriction | Backend access through CI and approved admin network only |
| State locking | DynamoDB lock table with point-in-time recovery |
| Versioning / recovery | Bucket versioning enabled; restore drill completed `2026-05-31` |
| State readers | Read-only break-glass group separate from plan/apply roles |
| Apply permissions | CI OIDC role can plan/apply only after protected-branch approval |
| Sensitive values | Provider state reviewed; database secret is referenced by secret ARN, not plaintext value |
| Drift evidence | Weekly drift plan completed `2026-06-06`; no unresolved prod drift |
| Audit logs | S3 data events, KMS decrypt events, and lock table writes retained in SIEM |
| Workspace separation | Dev, staging, and prod use separate prefixes, roles, and KMS conditions |

## Positive Controls

- `IAC-STATE-01`: Backend type, location, and workspace coverage are documented.
- `IAC-STATE-02`: Encryption, public access block, IAM, and network controls are evidenced.
- `IAC-STATE-03`: Locking, versioning, retention, and restore evidence are present.
- `IAC-STATE-04`: State read, plan, apply, and backend admin privileges are separated.
- `IAC-STATE-05`: Sensitive state attributes are inventoried and minimized.
- `IAC-STATE-06`: Drift detection has cadence, recent run evidence, and owner sign-off.
- `IAC-STATE-07`: Backend audit logs cover reads, writes, decrypts, and locks.
- `IAC-STATE-08`: Workspace separation and recovery paths are documented and tested.

## Expected Result

Do not flag the backend as exposing state or overstating IaC posture. Any
remaining IaC findings should focus on resource-level misconfigurations, not
state backend governance or drift evidence.
