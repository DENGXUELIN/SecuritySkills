# Benign: Exported Production Equivalence Evidence

## Review Target

```yaml
platform: microsoft_sentinel
rule_name: Password Spray From Single Source
attack_mapping: T1110.003
reviewed_query_hash: sha256:5b1f7f22-reviewed
production_rule_export:
  artifact: sentinel-analytics-password-spray-2026-06-08.json
  exported_at: 2026-06-08T20:15:00Z
  query_hash: sha256:5b1f7f22-reviewed
  query_frequency: 5m
  query_period: 1h
  event_grouping: trigger_alert_for_each_event
  suppression:
    enabled: true
    duration: 30m
    key:
      - IPAddress
      - TargetAccounts
  entity_mapping:
    Account: TargetAccounts
    IP: IPAddress

dependencies:
  watchlists:
    - name: corporate_nat_allowlist
      owner: soc-detections
      last_modified: 2026-06-08T18:00:00Z
      refresh_cadence: daily
      deployed_to_workspace: prod-sentinel
      change_ticket: SEC-4821
  materialized_views: []
  splunk_data_model_acceleration: not_applicable

runtime_principal:
  reviewer_identity: soc-detection-reviewer
  scheduled_identity: sentinel-analytics-managed-identity
  workspace: prod-sentinel
  tables:
    - SigninLogs
    - AADNonInteractiveUserSignInLogs
  permission_diff: none

validation:
  true_positive_test: replayed_password_spray_fixture
  fired_alert_id: alert-2026-06-08-pspray-001
  lookup_version_checked: corporate_nat_allowlist@SEC-4821
  production_export_attached: true
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Expanded production query | Pass | Production export hash matches the reviewed query hash. |
| Lookup/watchlist freshness | Pass | Watchlist owner, daily cadence, same-day modification time, workspace deployment, and change ticket are documented. |
| Acceleration and summary freshness | Pass | No acceleration or materialized view dependency exists for this Sentinel rule. |
| Runtime principal equivalence | Pass | Scheduled identity has the same required Sentinel tables as the reviewer. |
| Suppression and incident settings | Pass | Suppression is bounded to 30 minutes and keyed by IP plus target account set, preserving distinct entities. |
| Production dependency evidence | Pass | Production export and dependency evidence are attached before validation. |

## Reviewer Notes

This rule has sufficient production-equivalence evidence. Further review can focus on detection logic quality, threshold tuning, and response workflow rather than deployment drift.
