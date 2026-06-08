# Vulnerable Fixture: Push Protection Bypass Without Rotation Proof

## Scenario

A repository has push protection enabled, but a developer bypassed a likely real provider token and marked the alert as "fix later." The review package contains no independent approval or provider-side revocation evidence.

## Evidence

```yaml
repository: payments-api
push_protection:
  enabled: true
  protected_branches:
    - main
    - release/*
audit_log:
  event: secret_scanning_push_protection_bypass
  actor: app-developer
  reviewer: app-developer
  bypass_reason: fix_later
  token_type: cloud-provider-api-token
  commit: 8f4e2b1
  alert: SECRET-4412
  created_at: 2026-06-01T09:12:00Z
fix_later_ticket:
  id: null
  owner: null
  due_date: null
rotation_evidence:
  provider_revoked_at: null
  provider_key_id: null
  redeploy_completed_at: null
allowlist_delta:
  path: config/*.yaml
  justification: temporary until next sprint
```

The review notes say "token removed from the latest commit," but the audit trail does not show provider-side revocation, rotation, consumer redeploy, or a ticket with a due date. The bypass actor also self-approved the exception.

## Expected Assessment

- Flag at least a **High** finding for unreviewed push-protection bypass governance.
- Escalate to **Critical** if provider evidence confirms the token was live or privileged.
- Do not close the finding based only on latest-commit removal.
- Require independent review, scoped allowlist cleanup, owner/due date, and rotation or revocation proof.
- Do not reproduce the secret value in the report.
