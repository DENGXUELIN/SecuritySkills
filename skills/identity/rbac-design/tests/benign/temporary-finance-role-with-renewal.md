# Benign Fixture: Temporary Finance Role With Renewal Controls

## Scenario

A temporary quarter-end finance role exists for a matrix organization. It is legitimate because expiry, owner, approval, reapproval, and attribute freshness controls are enforced.

## Evidence

```text
role_assignment:
  user: user:alice
  role: quarter-end-finance-reviewer
  assigned_at: 2026-06-01T08:00:00Z
  assigned_until: 2026-07-05T23:59:59Z
  expiry_enforced_by: iga-campaign-rule-44
  approver: finance-controller
  role_owner: finance-iam-owner
  reapproval_required: true
  renewal_ticket_required: true

attribute_state:
  attribute: project
  value: fin-close-2026
  source_of_authority: HRIS
  last_updated: 2026-06-08T07:45:00Z
  freshness_threshold_days: 7
  hris_sync_status: healthy

alerting:
  stale_role_alert: enabled at assigned_until minus 7 days
  stale_attribute_action: suspend access and route to owner review
```

## Expected Skill Behavior

- Do not over-flag the temporary role as role explosion when expiry and renewal controls are enforced.
- Record controlled temporary access because owner, approver, enforced expiry, reapproval, and alerts are present.
- Record acceptable attribute freshness because the HRIS attribute is within threshold and sync-failure behavior is defined.
- Preserve any separate findings if the role grants excessive permissions, but do not confuse temporary access with unmanaged access.
