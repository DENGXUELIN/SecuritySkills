# Benign Fixture: Risk-Scoped Profile Confidence Evidence

## Scenario

The assessment scores `PR.PS-01` for a non-critical internal reporting service.
The evidence is a signed owner attestation backed by a configuration export and
recent vulnerability-scan sample. The target profile remains higher, but the
current score and confidence are documented separately.

## Evidence Snapshot

| Field | Value |
|---|---|
| Subcategory | `PR.PS-01` managed asset configuration is established and maintained |
| Profile side | Current profile |
| Current score | `2` |
| Target score | `3` |
| Evidence type | Owner attestation with corroborating artifacts |
| Source artifact | `cfg-export-reporting-2026-06-20.json` |
| Attestation | `control-owner-signoff-PRPS01-2026-Q2.pdf` |
| Scan sample | `vm-scan-reporting-2026-06-22.csv` |
| Owner | Reporting Platform Manager |
| Evidence date | `2026-06-22` |
| Scope | Internal reporting service, low inherent risk, no regulated data |
| Coverage | 11 of 11 reporting hosts and IaC baseline |
| Score rationale | Configuration baseline exists and is approved, but enforcement is not fully automated |
| Risk context | Low criticality lowers required evidence threshold for current score `2` |
| Confidence | Medium; acceptable for low-risk current score, validation needed for target `3` |
| Validation needed | Prove automated drift detection before target score `3` |

## Positive Controls

- `CSF-CONF-01`: Evidence source, owner, date, and assessed scope are recorded.
- `CSF-CONF-02`: Evidence type is classified and supported by artifacts.
- `CSF-CONF-03`: Current score `2` is separate from target score `3`.
- `CSF-CONF-04`: Evidence freshness is current for the quarterly assessment.
- `CSF-CONF-05`: Coverage is explicit for all reporting hosts in scope.
- `CSF-CONF-06`: Confidence considers low inherent risk and corroborating evidence.
- `CSF-CONF-07`: Validation needed for target maturity is documented.
- `CSF-CONF-08`: Remediation priority can account for both score gap and medium confidence.

## Expected Result

Accept current score `2` with medium confidence for the low-risk scope. Do not
flag the owner attestation as invalid by itself, because it is scoped, dated,
signed, corroborated, and paired with validation needed for the higher target.
