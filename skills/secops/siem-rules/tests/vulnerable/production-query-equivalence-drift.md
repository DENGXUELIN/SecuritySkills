# Vulnerable: Production Query Equivalence Drift

## Review Target

```yaml
platform: splunk
rule_name: Suspicious PowerShell Encoded Command
attack_mapping: T1059.001
reviewed_query: |
  index=endpoint sourcetype=XmlWinEventLog:Microsoft-Windows-Sysmon/Operational EventCode=1
  | search CommandLine="*-enc*" OR CommandLine="*EncodedCommand*"
  | lookup powershell_admin_allowlist user as User output allowed
  | where isnull(allowed)
  | table _time host User CommandLine

production_saved_search:
  app_context: search
  exported_query_available: false
  query: |
    `edr_index` sourcetype=XmlWinEventLog:Microsoft-Windows-Sysmon/Operational EventCode=1
    | tstats summariesonly=true count from datamodel=Endpoint.Processes
      where Processes.process="*-enc*" by Processes.user Processes.dest Processes.process
    | lookup powershell_admin_allowlist user as Processes.user output allowed
    | where isnull(allowed)
  macro_expansion:
    edr_index: index=windows
    reviewed_by_engineer: false
  lookup:
    name: powershell_admin_allowlist.csv
    last_modified: 2026-03-01T00:00:00Z
    owner: unknown
    refresh_cadence: manual
    deployed_to_prod: unknown
  acceleration:
    data_model: Endpoint.Processes
    enabled: true
    latest_build_time: 2026-06-08T18:52:00Z
    rule_lookback: 2h
    summary_range: 15m
    lag: 3h
  runtime_principal:
    reviewer_role: sec_admin
    scheduled_role: splunk_svc_detection
    scheduled_indexes:
      - windows
    expected_indexes:
      - endpoint
      - windows
  suppression:
    enabled: true
    duration: 24h
    throttle_key: User
    incident_grouping: group_all_events
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| SIEM-EQUIV-01 | High | No exported production query is available, and production uses macro plus `tstats` logic that differs from the reviewed raw event search. |
| SIEM-EQUIV-02 | Medium | `powershell_admin_allowlist.csv` is manually refreshed, stale, and has unknown owner/deployment state. |
| SIEM-EQUIV-03 | High | Data-model acceleration lag is 3 hours while the rule lookback is 2 hours, so recent events can be missed. |
| SIEM-EQUIV-04 | High | The scheduled role only has `windows` while reviewer expectations include `endpoint` and `windows`. |
| SIEM-EQUIV-05 | Medium | A 24-hour throttle on `User` plus grouped incidents can collapse distinct hosts and commands. |
| SIEM-EQUIV-06 | Medium | Missing production export evidence was still treated as validated. |

## Reviewer Notes

This rule should not be promoted as validated. Require the expanded saved-search export, fresh lookup ownership and deployment evidence, acceleration health within the lookback window, service-account permission parity, and documented suppression intent.
