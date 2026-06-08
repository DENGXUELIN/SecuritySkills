# Benign Fixture: Conversion Parity With TP/TN Evidence

## Scenario

A Sigma PowerShell rule is converted to Sentinel KQL and Splunk SPL. The detection
engineer records converter versions, backend configs, field mapping, unsupported
operator status, logic parity, manual edit status, known-positive and
known-negative execution, and query performance before deployment.

## Evidence Snapshot

| Field | Value |
|---|---|
| Sigma rule ID | `7f7d1f0e-1111-4a22-9f00-000000000179` |
| Target backends | Microsoft Sentinel KQL, Splunk SPL |
| Converter | `sigma-cli 0.10.0`, `pysigma-backend-sentinel 0.4.1`, `pysigma-backend-splunk 1.1.0` |
| Commands | `sigma convert -t sentinel -p sentinel/mde ...`; `sigma convert -t splunk -p splunk/sysmon ...` |
| Generated query evidence | Saved as `converted/sentinel.kql` and `converted/splunk.spl` |
| Field mapping | `CommandLine -> ProcessCommandLine` for Sentinel, `CommandLine -> CommandLine` for Splunk |
| Operators | `contains|all` preserved as `has_all` in KQL and `AND` token checks in SPL |
| Logic parity | Selections, filters, negation, and grouping reviewed against fixture expectations |
| Manual edits | None; conversion output deployed verbatim |
| Known-positive fixture | `tp-powershell-encoded-001.json`, matched in both backends |
| Known-negative fixture | `tn-admin-getprocess-001.json`, no match in both backends |
| Runtime | Sentinel `0.8s`, Splunk `1.3s`, scanned volume within rule budget |
| Deployment decision | Stable for test workspace; production deploy after 7-day burn-in |

## Positive Controls

- `DE-CONV-01`: Backend, converter versions, profile, and exact commands are
  recorded.
- `DE-CONV-02`: Generated queries and warning output are preserved.
- `DE-CONV-03`: Field mapping evidence matches the active data model.
- `DE-CONV-04`: Modifier behavior is explicitly checked.
- `DE-CONV-05`: Logic parity covers selections, filters, negation, grouping, and
  list handling.
- `DE-CONV-06`: Manual-edit status is documented.
- `DE-CONV-07`: Known-positive and known-negative fixtures both execute with
  expected results.
- `DE-CONV-08`: Runtime and scanned-volume evidence support deployment.

## Expected Result

Accept the converted queries as deployment-ready for the scoped test workspace.
Retain the conversion evidence with the Sigma rule so future backend upgrades or
data-model changes can be regression-tested.
