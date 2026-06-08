# Benign Fixture: Current Policy Decision Trace

## Scenario

A finance application still has legacy network plumbing, but the actual resource decision is made by a PDP with fresh subject, device, resource, risk, and policy-version evidence.

## Evidence

```text
access_request:
  subject: user:alice
  device_id: laptop-44
  resource: finance-app/invoices
  pep_id: ztna-gw-03
  pdp_id: pdp-44af
  policy_version: finance-prod-2026-06-08.7
  decision: allow
  decision_time: 2026-06-08T08:57:00Z
  correlation_id: dec-9012

signals:
  identity_risk: low at 2026-06-08T08:56:50Z
  device_posture: compliant at 2026-06-08T08:56:40Z
  posture_freshness_threshold_minutes: 30
  resource_sensitivity: confidential
  network_context: corporate_proxy

enforcement:
  pep_applied_policy_version: finance-prod-2026-06-08.7
  revocation_on_posture_change: terminate within 60 seconds
  log_retention_days: 180
```

## Expected Skill Behavior

- Do not over-flag the legacy network plumbing if the resource decision trace proves per-session authorization.
- Record the auditable decision trace outcome because subject, device, resource, PDP, PEP, policy version, risk signals, and decision outcome are linked.
- Treat posture freshness as acceptable because the posture signal is newer than the defined threshold.
- Preserve any separate findings for legacy architecture, but do not confuse them with failed enforcement.
