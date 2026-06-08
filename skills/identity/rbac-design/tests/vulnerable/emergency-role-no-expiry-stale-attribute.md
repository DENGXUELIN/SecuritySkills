# Vulnerable Fixture: Emergency Role Without Expiry and Stale Attribute

## Scenario

An emergency finance role was granted during quarter-end close. The role hierarchy and SoD constraints are otherwise well designed, but the emergency assignment never expires and the ABAC project attribute stopped syncing after a department transfer.

## Evidence

```text
role_assignment:
  user: user:bob
  role: emergency-finance-reviewer
  assigned_at: 2026-03-28T16:00:00Z
  assigned_until: none
  approver: finance-controller
  reapproval_required: false
  role_owner: finance-iam-owner

attribute_state:
  attribute: project
  value: fin-close-2026
  source_of_authority: HRIS
  last_updated: 2026-03-29T02:00:00Z
  freshness_threshold_days: 7
  hris_sync_status: failed since 2026-04-02T01:00:00Z

access_result:
  policy: allow if role=emergency-finance-reviewer and project=fin-close-2026
  current_date: 2026-06-08
  stale_entitlement_alert: none
```

## Expected Skill Behavior

- Flag privilege creep risk because the emergency role lacks enforced expiry and renewal approval.
- Flag stale attribute risk because the project attribute is far older than the freshness threshold and HRIS sync is failed.
- Require owner, approver, intended expiry, enforced expiry, renewal workflow, sync-failure behavior, and stale-entitlement alert evidence.
- Do not give the design full credit solely because role hierarchy and SoD constraints exist.
