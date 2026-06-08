# Vulnerable Fixture: Stale EDR Parser Treated as Coverage

## Scenario

A team marks PowerShell command-line detection coverage as operational because the converted SIEM query returns zero matches across the previous seven days. The ATT&CK mapping and Sigma logic are reasonable, but the EDR process telemetry pipeline changed parser versions during an agent upgrade.

## Evidence

```yaml
detection:
  technique: T1059.001
  sigma_fields:
    - Image
    - CommandLine
    - ParentImage
  required_data_source: edr_process_creation
telemetry_health:
  last_successful_ingestion: "2026-06-01T03:10:00Z"
  review_time: "2026-06-08T11:00:00Z"
  expected_event_volume:
    baseline_window: "previous 7 daily business windows"
    baseline_count_per_day: 18000
    current_count_per_day: 0
  parser_schema:
    previous_version: "edr-process-v4"
    current_version: "edr-process-v5"
    field_drift:
      CommandLine: "renamed to process.command_line"
      ParentImage: "renamed to parent.process.path"
  collector_health:
    forwarder_heartbeat: "stale"
    health_ticket: null
  replay_canary:
    last_test: "2026-05-15"
    result: "not rerun after parser migration"
coverage_decision: "Operational"
```

## Expected Result

The skill should not accept `Operational` coverage. The zero-match result is evidence of a telemetry or parser failure until fresh ingestion, expected volume, field mapping, collector health, and replay proof are provided. This should remain P2/High when the technique is relevant to active threat intelligence.
