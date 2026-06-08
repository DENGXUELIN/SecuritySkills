# Vulnerable Fixture: Converted Query Misses Known Positive

## Scenario

A Sigma rule for suspicious PowerShell command execution passes YAML validation
and converts to Microsoft Sentinel KQL. The conversion silently maps
`CommandLine|contains|all` to a backend field that is not populated in the
tenant's active data model. The generated query is syntactically valid but misses
the known-positive sample event.

## Evidence Snapshot

| Field | Value |
|---|---|
| Sigma rule ID | `7f7d1f0e-1111-4a22-9f00-000000000179` |
| Target backend | Microsoft Sentinel KQL |
| Converter | `sigma-cli 0.10.0`, backend `sentinel` |
| Command | `sigma convert -t sentinel -p sentinel/sysmon powershell_encoded.yml` |
| Generated query | `DeviceProcessEvents | where CommandLine has_all (...)` |
| Warning output | `field CommandLine mapped by default profile` |
| Field mapping evidence | Not checked against active table schema |
| Unsupported operator handling | `contains|all` accepted without parity test |
| Manual edits | None |
| Known-positive fixture | `tp-powershell-encoded-001.json` |
| Known-positive result | `0 rows` |
| Known-negative fixture | Not executed |
| Runtime evidence | Not captured |
| Deployment decision | Marked stable |

## Problem Indicators

- `DE-CONV-01`: Backend config is recorded, but active SIEM table/schema is not.
- `DE-CONV-03`: Field mapping points to `CommandLine`, while the tenant emits
  `ProcessCommandLine`.
- `DE-CONV-04`: `contains|all` is not proven equivalent after conversion.
- `DE-CONV-05`: Logic parity is assumed from conversion success.
- `DE-CONV-07`: Known-positive execution misses the expected event and no
  known-negative test is run.
- `DE-CONV-08`: Runtime and backend constraints are not captured.

## Expected Finding

Classify as **High** if the rule is deployment-bound for a priority ATT&CK
technique. The Sigma source is valid, but the converted query is not deployment
ready because it misses a known-positive event.

## Required Remediation

Record backend schema evidence, correct the field mapping, preserve warnings,
run known-positive and known-negative fixtures, document any manual edits, and
capture runtime/scanned-volume evidence before marking the rule stable.
