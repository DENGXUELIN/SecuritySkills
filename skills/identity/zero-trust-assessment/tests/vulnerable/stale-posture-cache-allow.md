# Vulnerable Fixture: Stale Posture Cache Allow

## Scenario

A ZTNA deployment claims continuous device verification, but the PEP accepts cached `device_compliant=true` for 12 hours. EDR isolated the laptop 20 minutes after the session started, and access to the finance application remained allowed.

## Evidence

```text
access_request:
  subject: user:alice
  device_id: laptop-44
  resource: finance-app/invoices
  pep_id: ztna-gw-03
  pdp_id: pdp-44af
  policy_version: finance-prod-2026-06-08.3
  decision: allow
  decision_time: 2026-06-08T08:57:00Z
  correlation_id: dec-8844

posture:
  source: edr
  value: compliant
  posture_checked_at: 2026-06-08T00:55:00Z
  freshness_threshold_minutes: 30
  edr_isolated_at: 2026-06-08T09:17:00Z

session:
  revocation_on_posture_change: false
  session_terminated_at: none
```

## Expected Skill Behavior

- Flag stale posture risk because the posture signal is far older than the 30 minute threshold.
- Flag missing revocation behavior because EDR isolation did not terminate or step up the session.
- Record the decision trace fields, including subject, device, resource, PDP, PEP, policy version, posture age, and correlation ID.
- Do not treat ZTNA deployment alone as Advanced or Optimal maturity for continuous verification.
