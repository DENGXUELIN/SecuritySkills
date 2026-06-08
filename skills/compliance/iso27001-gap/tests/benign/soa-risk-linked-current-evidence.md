# Benign: Risk-Linked SoA With Current Evidence

## Scenario

The organization reviews the SoA for the customer data platform during the 2026 certification readiness cycle.

## SoA Evidence Linkage Matrix

| Control ID | Decision | Rationale | Risk/Requirement Link | Treatment Decision | Scope/Asset Boundary | Design Evidence | Operating Evidence | Evidence Owner | Evidence Date/Period | Currentness | Result |
|------------|----------|-----------|-----------------------|--------------------|----------------------|-----------------|--------------------|----------------|----------------------|-------------|--------|
| A.5.23 | Included | Cloud service controls are required for customer analytics workloads | RISK-014 cloud misconfiguration; contract CT-442 security schedule | Treat via cloud service governance controls | Customer data platform, AWS prod accounts 1001 and 1002, EU and US regions | Cloud service security policy CSSP-2026-04 | CSPM exception review CHG-8841; supplier assurance review VR-221 | Cloud Security Manager | 2026-05-01 through 2026-05-31 | Current | Pass |
| A.8.16 | Included | Monitoring is required for production data access and incident detection | RISK-027 privileged misuse; customer SLA-18 logging obligation | Treat via SIEM monitoring and escalation | Production analytics clusters and identity logs | Logging standard LOG-2026-02 | SIEM alert samples SIEM-1221 through SIEM-1236; weekly review tickets SECOPS-771 to SECOPS-774 | SecOps Lead | 2026-05-06 through 2026-06-03 | Current | Pass |
| A.7.3 | Excluded | No office, visitor area, or physical secure zone is in the ISMS scope | Scope statement SCOPE-2026 excludes physical premises; RISK-031 accepted for remote-only workforce | Not applicable approved by ISMS owner | Remote-only SaaS team; no physical offices in scope | ISMS scope statement SCOPE-2026 | Management review MR-2026-05 approval of physical-scope exclusion | ISMS Manager | 2026-05-20 | Current | Pass |

## Expected Review Result

The skill should treat these rows as SoA-ready because they satisfy `ISO-SOA-01` through `ISO-SOA-08`: every decision has a rationale, risk or requirement link, treatment decision, scope boundary, design evidence, operating evidence where applicable, owner, date or period, currentness, and explicit result.
