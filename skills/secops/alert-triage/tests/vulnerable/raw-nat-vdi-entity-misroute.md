---
name: raw-nat-vdi-entity-misroute
expected: not-evaluable
skill: alert-triage
---

# Alert Triage Fixture: Raw NAT and VDI Entity Misroute

Use this fixture to verify that `alert-triage` does not close or downgrade an alert when the affected entity is based only on raw alert fields and current-state inventory.

## Alert

- Alert ID: `ALERT-2026-06-09-0142`
- Rule: `Suspicious PowerShell Download Cradle`
- Timestamp: `2026-06-09T01:42:17Z`
- Raw fields:
  - `src_ip=10.20.44.18`
  - `hostname=VDI-WIN-077`
  - `user=svc-print`
  - `edr_device_id=missing`
  - `process=powershell.exe`
  - `command=iex (new-object net.webclient).downloadstring(...)`

## Entity Resolution Matrix

| Resolution ID | Raw Identifier | Candidate Entity | Mapping Source | Source Timestamp | Corroboration | Owner / Asset Context | Confidence | Disposition Impact | Ambiguity / Gap |
|---------------|----------------|------------------|----------------|------------------|---------------|-----------------------|------------|--------------------|-----------------|
| ALERT-ENTITY-01 | `10.20.44.18` | `VDI-WIN-077` | Current CMDB lookup | 2026-06-09T09:00:00Z | None | VDI pool, low criticality | Low | Would downgrade to P4 if trusted | DHCP lease at alert time missing; current lookup is post-alert |
| ALERT-ENTITY-02 | `VDI-WIN-077` | Shared VDI image | Current VDI console | 2026-06-09T09:00:00Z | None | Shared pool | Low | Cannot route to a single user | Recycled VDI hostname, no session mapping |
| ALERT-ENTITY-03 | `svc-print` | Print service account | AD current state | 2026-06-09T09:00:00Z | None | Service account | Low | Could falsely classify as expected automation | No logon/session evidence, service account may be abused |
| ALERT-ENTITY-04 | NAT egress IP | Branch office NAT | Firewall summary | 2026-06-09T09:00:00Z | None | Shared office | Unknown | Cannot identify host | NAT translation at alert timestamp missing |
| ALERT-ENTITY-05 | EDR device ID | Missing | Alert payload | 2026-06-09T01:42:17Z | None | None | Unknown | No endpoint containment target | EDR record absent |
| ALERT-ENTITY-06 | Owner context | Helpdesk VDI pool | CMDB owner field | 2026-06-09T09:00:00Z | None | Helpdesk | Low | Wrong owner likely | Owner is pool owner, not alert-time user |
| ALERT-ENTITY-07 | Disposition impact | Proposed false positive | Analyst assumption | 2026-06-09T09:05:00Z | None | Low-value VDI | Low | Should be blocked | Entity mapping is not strong enough to close |
| ALERT-ENTITY-08 | Escalation guardrail | Continue investigation | Triage decision | 2026-06-09T09:06:00Z | Required | Potential script execution | Medium | Escalate to Tier 2 | Need DHCP, VDI session, VPN/NAT, and EDR lookup |

## Expected Review Behavior

- Do not mark the alert `False Positive` based on the current CMDB host or shared service account alone.
- Do not downgrade priority using low-criticality VDI context until the alert-time user and endpoint are resolved.
- Record missing DHCP lease, VDI session, NAT translation, and EDR device evidence as limitations.
- Keep disposition `Not Evaluable` or continue investigation until `ALERT-ENTITY-01` through `ALERT-ENTITY-08` are resolved.

## Anti-Pattern Under Test

The triage fails this fixture if it says:

```text
Disposition: False Positive
Priority: P4 Low
Reason: src_ip belongs to low-criticality VDI-WIN-077 and user svc-print is expected automation.
Mapping Confidence: High
```

That conclusion trusts current-state and shared identifiers instead of time-aligned DHCP, VDI, NAT, IdP, and EDR evidence.
