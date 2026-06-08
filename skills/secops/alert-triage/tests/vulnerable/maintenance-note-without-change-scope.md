# Vulnerable Fixture: Maintenance Note Without Change Scope

## Scenario

An analyst note says an EDR service-control alert is maintenance, but no change ticket, approver, approved asset list, or expected command list is attached.

## Evidence

```text
alert:
  rule: EDR service-control event
  timestamp: 2026-06-08T04:12:00Z
  host: prod-db-02
  user: svc-deploy
  action: restart database service and install package db-hotfix-unknown

analyst_note:
  disposition_hint: maintenance
  ticket: none
  approver: none
  approved_window: none
  approved_assets: none
  expected_actions: none

related_events:
  - 2026-06-08T04:17:00Z svc-deploy enumerated admin shares on prod-api-03
```

## Expected Skill Behavior

- Do not close as BTP based on the free-text maintenance note.
- Classify the authorized-change state as unproven maintenance.
- Keep the alert open or escalate because host, actor, action, and follow-on activity are not bound to an approved change.
- Require ticket ID, approver, approved window, approved assets/users, expected actions, and follow-on review.
