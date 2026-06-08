# Benign: Validated High Finding

## Scenario

The review reports a High severity command injection in a production report export endpoint and includes full validation evidence.

## Finding Validation Evidence Matrix

| Finding | Entry Point | Attacker Source | Sink | Source-to-Sink Trace | Preconditions | Missing/Bypassed Control | FP Checks | Proof/Severity Rationale |
|---------|-------------|-----------------|------|----------------------|---------------|--------------------------|-----------|--------------------------|
| SCR-014 | `POST /api/reports/export` handled by `ReportExportController.create` | Authenticated user controls JSON field `format` | `subprocess.run("reportgen --format " + format, shell=True)` | request body -> DTO `ExportRequest.format` -> service `build_export_command` -> shell string -> `subprocess.run(..., shell=True)` | Any analyst role can call export; feature flag `reports_v2=true` in production | Missing enum allowlist and use of shell string instead of argv array | Auth middleware verified only login; WAF does not inspect JSON field; no centralized validator for `format`; endpoint is present in production route table; unit tests show arbitrary format passes | Safe test `test_report_export_rejects_shell_metacharacters` fails before fix; severity High because command injection is authenticated but low-complexity and reaches production worker |

## Expected Review Result

The skill should accept this as a validated High finding because `SCR-EXP-01` through `SCR-EXP-08` are documented: reachable entry point, attacker source, sink, trace, preconditions, missing control, false-positive checks, proof, and severity rationale.
