# Benign Fixture: Zero-Hit Counter After Failover With Active Flow Logs

## Scenario

A database permit rule shows zero local firewall hits, but the firewall cluster failed over recently and independent flow logs show legitimate traffic during the review period.

## Evidence

```yaml
firewall: internal-fw-cluster
rule:
  id: 88
  uuid: 7f3d1d8d-7788-4900-89c3-aabbccddeeff
  action: allow
  source: billing-api
  destination: billing-db
  service: tcp/5432
  hit_count: 0
  last_hit: null
counter_evidence:
  baseline_started: 2026-05-29T04:10:00Z
  policy_installed_at: 2026-05-29T04:08:00Z
  device_uptime_days: 10
  ha_failover_since_baseline: true
  failover_ticket: NET-5521
flow_log_cross_check:
  source: siem-netflow
  window: 2026-03-01/2026-06-01
  matching_flows: 12740
  latest_flow: 2026-06-01T22:14:00Z
owner_review:
  owner: billing-platform
  keep_ticket: FW-8902
  expiry_review: 2026-09-01
```

## Expected Assessment

- Do not flag the rule as unused based only on the zero local hit counter.
- Mark hit-counter freshness as missing or partial because the counter was reset after failover and policy install.
- Keep the rule pending owner review because independent flow logs show active traffic.
- Recommend rechecking counters after a full review window or using flow-log evidence for disposition.
