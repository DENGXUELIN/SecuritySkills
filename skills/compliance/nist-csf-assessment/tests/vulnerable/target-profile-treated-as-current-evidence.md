# Vulnerable Fixture: Target Profile Treated as Current Evidence

## Scenario

The assessment scores `DE.CM-01` at current score `3` because leadership says the
organization is targeting Tier 3 monitoring this year. The only artifact is a
roadmap slide. There is no current telemetry, monitoring coverage inventory, or
validation that monitored services match the assessment scope.

## Evidence Snapshot

| Field | Value |
|---|---|
| Subcategory | `DE.CM-01` networks and network services are monitored |
| Profile side | Current profile |
| Current score assigned | `3` |
| Target score | `3` |
| Evidence type | Target-state plan |
| Source | `2026-security-roadmap.pptx` |
| Owner | VP Security |
| Evidence date | `2026-01-10` |
| Assessment date | `2026-06-30` |
| Scope claimed | Enterprise network monitoring |
| Coverage proof | Not provided |
| Telemetry proof | Not provided |
| Assumptions | Not recorded |
| Confidence | Not recorded |

## Problem Indicators

- `CSF-CONF-01`: The score lacks an implementation artifact, collection method,
  and scoped evidence supporting the current state.
- `CSF-CONF-02`: A target-state plan is not classified separately from current
  implementation evidence.
- `CSF-CONF-03`: Current profile score is inflated by target profile intent.
- `CSF-CONF-04`: Evidence freshness is weak for a monitoring capability.
- `CSF-CONF-05`: Enterprise coverage is claimed without asset/service scope.
- `CSF-CONF-07`: Assumptions and validation-needed items are omitted.
- `CSF-CONF-08`: Priority is understated because the low-confidence evidence is
  not included in remediation ranking.

## Expected Finding

Classify as **Significant Gap** or mark current score as low-confidence until
fresh monitoring telemetry, service coverage, owner attestation, and validation
evidence are collected. The target score can remain `3`, but the current score
should not be raised by roadmap intent.

## Required Remediation

Separate current and target evidence. Add source owner/date/scope, evidence type,
coverage, confidence, assumptions, and validation-needed fields for `DE.CM-01`.
