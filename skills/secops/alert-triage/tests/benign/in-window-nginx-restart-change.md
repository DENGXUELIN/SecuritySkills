# Benign Fixture: In-Window Nginx Restart Change

## Scenario

An EDR alert detects sensitive service-control activity on a production API host. The activity is authorized, in-window, in-scope, and matches the deployment plan.

## Evidence

```text
alert:
  rule: EDR service-control event
  timestamp: 2026-06-08T02:14:00Z
  host: prod-api-03
  user: svc-deploy
  action: restart nginx and deploy release artifact api-2026.06.08.1

change_ticket:
  id: CHG-48291
  approver: service owner and on-call incident commander
  approved_window_start: 2026-06-08T02:00:00Z
  approved_window_end: 2026-06-08T03:00:00Z
  timezone: UTC
  approved_assets: prod-api-01 through prod-api-05
  approved_actor: svc-deploy
  expected_actions: package install, nginx restart, health check
  rollback_status: no rollback needed

related_events:
  - 2026-06-08T02:16:00Z health check passed
  - no privilege escalation, lateral movement, persistence, or exfiltration follow-on
```

## Expected Skill Behavior

- Classify as authorized in-scope BTP when ticket, approver, window, asset, actor, and action all match.
- Preserve the authorization evidence in the triage report.
- Do not recommend broad suppression unless the rule can safely filter the exact approved deployment pattern.
- Continue investigation if any out-of-scope follow-on event appears after the deployment action.
