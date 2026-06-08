---
name: vulnerable-stale-field-zero-result
expected: fail
---

# Vulnerable SIEM schema-drift fixture

## Rule

```kql
DeviceProcessEvents
| where TimeGenerated > ago(1d)
| where CommandLine has "rundll32"
```

## Evidence

| Field | Value |
|-------|-------|
| Platform | Microsoft Sentinel |
| Source schema | MDE DeviceProcessEvents |
| Normalized schema | ASIM Process |
| Mapping version | Unknown |
| Query field | CommandLine |
| Mapped field | ProcessCommandLine |
| Sample event count | 0 after connector migration |
| Fixture or unit test | Missing |
| Zero-result decision | Undocumented |
| Last verified | Unknown |

## Expected review result

Fail the review. The rule parses, but it references a stale field and returns zero events after the connector migration without mapping evidence or a fixture.
