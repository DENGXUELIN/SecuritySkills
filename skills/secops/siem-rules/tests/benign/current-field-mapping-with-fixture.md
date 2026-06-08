---
name: benign-current-field-mapping-with-fixture
expected: pass
---

# Benign SIEM schema-drift fixture

## Rule

```kql
DeviceProcessEvents
| where TimeGenerated > ago(1d)
| where ProcessCommandLine has "rundll32"
```

## Evidence

| Field | Value |
|-------|-------|
| Platform | Microsoft Sentinel |
| Source schema | MDE DeviceProcessEvents |
| Normalized schema | ASIM Process |
| Mapping version | 2026-06 |
| Query field | ProcessCommandLine |
| Mapped field | ProcessCommandLine |
| Sample event count | 18422 in last 24h |
| Fixture or unit test | `fixtures/mde-rundll32-process.json` passed |
| Zero-result decision | N/A |
| Last verified | 2026-06-08 |

## Expected review result

Pass the schema-drift check. Field mapping is current, sample events exist, and the fixture validates the production field name.
