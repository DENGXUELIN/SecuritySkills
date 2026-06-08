# Vulnerable: Pattern-Only High Finding

## Scenario

The review flags a High severity deserialization issue after seeing a risky API call.

## Reported Finding

| Field | Value |
|---|---|
| Severity | High |
| CWE | CWE-502 |
| ASVS Control | V5.5.1 |
| Location | `tools/dev_importer.py:42` |
| Evidence | `pickle.loads(payload)` |
| Status | Open |

## Missing Validation Evidence

- `SCR-EXP-01`: no route, CLI command, webhook, worker, parser, or trust-boundary crossing is shown to reach `dev_importer.py`.
- `SCR-EXP-02`: no attacker-controlled payload source is identified.
- `SCR-EXP-04`: no call chain shows input flowing into `pickle.loads`.
- `SCR-EXP-05`: no deployment preconditions are documented; the file may be a disabled local developer tool.
- `SCR-EXP-06`: no missing or bypassed type/schema validation control is identified.
- `SCR-EXP-07`: no false-positive checks cover feature flags, test-only paths, admin-only unreachable routes, or framework controls.
- `SCR-EXP-08`: no safe exploit sketch, test reference, downgrade rationale, or negative evidence is included.

## Expected Review Result

The skill should not report this as a high-confidence High finding based only on a risky API call. It should require validation evidence or downgrade/discard the finding until `SCR-EXP-01` through `SCR-EXP-08` are satisfied.
