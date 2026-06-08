# Vulnerable Fixture: Zero-Hit Rule With Old Baseline and Decommissioned Destination

## Scenario

A firewall rule permits database access to a decommissioned host object. The rule has zero hits, and independent evidence shows the counter is fresh enough to support removal.

## Evidence

```yaml
firewall: edge-fw-01
rule:
  id: 420
  uuid: 2d3b2ec0-0b43-4e82-b15a-001122334455
  action: allow
  source: app-prod-subnet
  destination: old-payment-db
  service: tcp/5432
  hit_count: 0
  last_hit: null
counter_evidence:
  baseline_started: 2026-01-01T00:00:00Z
  policy_installed_at: 2025-12-20T18:00:00Z
  device_uptime_days: 180
  ha_failover_since_baseline: false
flow_log_cross_check:
  source: vpc-flow-logs
  window: 2026-01-01/2026-06-01
  matching_flows: 0
asset_lifecycle:
  destination_object: old-payment-db
  cmdb_status: decommissioned
  decommission_ticket: ASSET-7712
owner_review:
  owner: payments-platform
  removal_ticket: FW-8841
  approved: true
```

## Expected Assessment

- Flag a **High** unused-rule finding because the destination is decommissioned and the evidence supports removal.
- Cite counter baseline, policy install time, HA reset history, flow-log cross-check, and owner/ticket evidence.
- Recommend removing the rule and validating no shadowed or replacement rules preserve the orphaned path.
