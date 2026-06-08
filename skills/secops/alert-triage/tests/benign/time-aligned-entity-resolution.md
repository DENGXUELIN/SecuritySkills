---
name: time-aligned-entity-resolution
expected: high-confidence
skill: alert-triage
---

# Alert Triage Fixture: Time-Aligned Entity Resolution

Use this fixture to verify that `alert-triage` can assign high mapping confidence when time-aligned telemetry resolves the affected user, asset, and containment target.

## Alert

- Alert ID: `ALERT-2026-06-09-0225`
- Rule: `Suspicious PowerShell Download Cradle`
- Timestamp: `2026-06-09T02:25:41Z`
- Raw fields:
  - `src_ip=10.30.12.44`
  - `hostname=FIN-LAP-044`
  - `user=jane.chen@example.test`
  - `sid=S-1-5-21-111-222-333-1044`
  - `edr_device_id=device-7f19`
  - `cloud_instance_id=none`
  - `process=powershell.exe`

## Entity Resolution Matrix

| Resolution ID | Raw Identifier | Candidate Entity | Mapping Source | Source Timestamp | Corroboration | Owner / Asset Context | Confidence | Disposition Impact | Ambiguity / Gap |
|---------------|----------------|------------------|----------------|------------------|---------------|-----------------------|------------|--------------------|-----------------|
| ALERT-ENTITY-01 | `10.30.12.44` | `FIN-LAP-044` | DHCP lease | 2026-06-09T02:20:00Z to 2026-06-09T10:20:00Z | EDR network telemetry | Finance laptop, high criticality | High | Supports P2 | None |
| ALERT-ENTITY-02 | `FIN-LAP-044` | EDR `device-7f19` | EDR inventory | 2026-06-09T02:25:39Z | DHCP lease and SIEM raw event | Finance laptop | High | Identifies containment target | None |
| ALERT-ENTITY-03 | `jane.chen@example.test` | Jane Chen | IdP sign-in log | 2026-06-09T02:24:58Z | SID mapping and HR directory | Finance analyst | High | Confirms affected user | None |
| ALERT-ENTITY-04 | `S-1-5-21-111-222-333-1044` | Jane Chen | Directory SID history | 2026-06-09T02:24:58Z | IdP sign-in log | Standard user, finance data access | High | Increases business impact | None |
| ALERT-ENTITY-05 | `powershell.exe` | User-launched process on `device-7f19` | EDR process tree | 2026-06-09T02:25:41Z | SIEM raw event | Unexpected for finance laptop | High | Supports true positive investigation | None |
| ALERT-ENTITY-06 | Owner context | Finance endpoint owner | CMDB record with update timestamp | 2026-06-08T18:10:00Z | HR manager record | Finance business owner | High | Routes to correct owner | None |
| ALERT-ENTITY-07 | Disposition impact | Suspicious execution on high-context host | Triage decision | 2026-06-09T02:31:00Z | DHCP, EDR, IdP, CMDB | High-value finance endpoint | High | Keep P2 / escalate Tier 2 | None |
| ALERT-ENTITY-08 | Escalation guardrail | Entity confidence sufficient for containment | Analyst decision | 2026-06-09T02:32:00Z | All sources agree | Device isolation target resolved | High | Isolation and user reset can proceed | None |

## Expected Review Behavior

- Cite `ALERT-ENTITY-01` through `ALERT-ENTITY-08` in the triage report.
- Use high-confidence entity mapping to route the alert to the finance endpoint owner and Tier 2.
- Keep the disposition as `True Positive` or `Suspicious / under investigation` unless benign process evidence exists elsewhere.
- Assign priority using the resolved finance endpoint and user context, not only the SIEM rule severity.

## Acceptable High-Confidence Finding Shape

```text
Disposition: True Positive
Priority: P2 High
Affected Host Mapping Confidence: High
Affected User Mapping Confidence: High
Evidence: DHCP lease, EDR device ID, IdP sign-in, SID history, and CMDB owner all agree at the alert timestamp.
Escalation Required: Yes -- Tier 2
```
