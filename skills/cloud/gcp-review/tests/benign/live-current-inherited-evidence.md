---
name: live-current-inherited-evidence
expected: high-confidence
skill: gcp-review
---

# GCP Review Fixture: Current Live Evidence with Inherited Scope

Use this fixture to verify that `gcp-review` can assign high confidence when live/exported evidence is current, scoped, and reconciled with inherited organization and folder policies.

## Review Scope

- Organization: `organizations/222222222222`
- Folder: `folders/333333333333`
- Projects in scope: `payments-prod`, `payments-dr`, `analytics-prod`
- Regions in scope: `us-central1`, `us-east1`, `europe-west1`
- Review date: `2026-06-09`

## Evidence Inventory

| Evidence ID | Basis | Source / Query | Collection Date | Scope | Controls Supported | Limitations | Confidence |
|-------------|-------|----------------|-----------------|-------|--------------------|-------------|------------|
| GCP-EVID-01 | Live-exported | Cloud Asset Inventory snapshot `cai-org-222222222222-2026-06-08.json` | 2026-06-08 | Org, folder, all three projects, global and regional assets | IAM, org policy, firewall, storage, Cloud SQL, BigQuery | Excludes deleted assets older than 35 days | High |
| GCP-EVID-02 | Live-exported | `gcloud asset search-all-iam-policies --scope=organizations/222222222222` | 2026-06-08 | Org, folder, project inherited IAM | CIS 1.x | Read-only export, reconciled with CAI | High |
| GCP-EVID-03 | Live-exported | Policy Analyzer query for effective allow policies | 2026-06-08 | `folders/333333333333` descendants | IAM inheritance and effective access | Covers included child projects, excludes sandbox folder by documented scope | High |
| GCP-EVID-04 | Live-exported | Hierarchical firewall policy and VPC firewall export | 2026-06-08 | Shared VPC host plus service projects in all three regions | CIS 3.x | None for reviewed scope | High |
| GCP-EVID-05 | Live-exported | Security Command Center posture findings export | 2026-06-08 | All in-scope projects | Logging, storage, VM, SQL, BigQuery posture | SCC mute rules reviewed separately | High |
| GCP-EVID-06 | Live-exported | Admin Activity audit logs for IAM, org policy, firewall, and service account key changes | 2026-06-01 to 2026-06-09 | Org, folder, all in-scope projects | Drift-sensitive controls | Seven-day window matches daily change-control review | High |
| GCP-EVID-07 | Mixed | Terraform plan and deployment pipeline records | 2026-06-08 | Production modules for all in-scope projects | Intended state cross-check | Used only to reconcile live state, not as sole proof | Medium |
| GCP-EVID-08 | Result confidence | Reviewer conclusion | 2026-06-09 | Full review scope | All CIS sections | Live evidence is current and scope gaps are documented | High |

## Expected Review Behavior

- Findings should cite the specific `GCP-EVID-##` rows used for each Passed, Failed, or Not Evaluable control.
- Parent folder and organization policy evidence can support child projects only because `GCP-EVID-01`, `GCP-EVID-02`, and `GCP-EVID-03` document the inheritance path and excluded scope.
- Terraform evidence in `GCP-EVID-07` can corroborate live exports but should not override fresher live evidence.
- Controls with matching CAI, SCC, Policy Analyzer, firewall, and audit-log evidence may be High confidence.
- If any reviewed project, folder, region, or service falls outside these rows, the finding should record a limitation instead of claiming full coverage.

## Acceptable High-Confidence Finding Shape

```text
Status: Pass
Evidence ID(s): GCP-EVID-01, GCP-EVID-02, GCP-EVID-03, GCP-EVID-06
Evidence Source: Cloud Asset Inventory, Policy Analyzer, and Admin Activity logs
Evidence Date: 2026-06-08
Coverage: organizations/222222222222, folders/333333333333, payments-prod, payments-dr, analytics-prod
Limitations: deleted assets older than 35 days are outside the CAI snapshot
Confidence: High
```
