# Benign Fixture: Current Telemetry With Replay and Schema Proof

## Scenario

A detection engineer reviews a Sigma rule for suspicious PowerShell encoded commands after a SIEM parser upgrade. The converted backend query has a low fire count, but telemetry health and replay evidence show that the data source is current and the rule fields still map correctly.

## Evidence

```yaml
detection:
  technique: T1059.001
  sigma_fields:
    - Image
    - CommandLine
    - ParentImage
  required_data_source: sysmon_process_creation
telemetry_health:
  last_successful_ingestion: "2026-06-08T10:58:00Z"
  review_time: "2026-06-08T11:00:00Z"
  expected_event_volume:
    baseline_window: "same weekday 09:00-11:00"
    baseline_count: 4200
    current_count: 4187
  parser_schema:
    current_version: "sysmon-process-v12"
    schema_change_ticket: "DET-2241"
    required_fields_present:
      Image: true
      CommandLine: true
      ParentImage: true
  collector_health:
    heartbeat_age_minutes: 2
    connector_status: "healthy"
  replay_canary:
    test_id: "ART-T1059.001-encoded-command"
    run_time: "2026-06-08T10:45:00Z"
    result: "matched expected rule"
coverage_decision: "Operational"
```

## Expected Result

The skill should allow operational coverage because fresh ingestion, plausible expected volume, compatible parser schema, required field coverage, healthy collector status, and replay proof are all present. Any remaining low fire count can be treated as a tuning observation rather than a missing-source finding.
