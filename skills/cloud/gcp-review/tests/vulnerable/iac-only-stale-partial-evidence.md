---
name: iac-only-stale-partial-evidence
expected: not-evaluable
skill: gcp-review
---

# GCP Review Fixture: IaC-Only, Stale, and Partial Evidence

Use this fixture to verify that `gcp-review` does not mark CIS GCP controls as Pass when evidence is stale, partial, or only describes intended Terraform state.

## Review Scope

- Organization: `organizations/222222222222`
- Folder: `folders/333333333333`
- Projects in scope: `payments-prod`, `payments-dr`, `analytics-prod`
- Regions in scope: `us-central1`, `us-east1`, `europe-west1`
- Review date: `2026-06-09`

## Evidence Inventory

| Evidence ID | Basis | Source / Query | Collection Date | Scope | Controls Supported | Limitations | Confidence |
|-------------|-------|----------------|-----------------|-------|--------------------|-------------|------------|
| GCP-EVID-01 | IaC intent | `terraform/envs/prod/**/*.tf` at commit `9f2c51a` | 2025-11-03 | `payments-prod` only | IAM, VPC firewall, Cloud SQL | Does not prove deployed state, excludes `payments-dr` and `analytics-prod`, no folder inheritance evidence | Low |
| GCP-EVID-02 | Partial live export | `gcloud projects get-iam-policy payments-prod --format=json` | 2026-01-12 | `payments-prod` IAM only | CIS 1.x | 148 days old, no IAM change log, no service account key export, no folder/org inherited bindings | Low |
| GCP-EVID-03 | Partial live export | `gcloud compute firewall-rules list --project payments-prod --format=json` | 2026-01-12 | `payments-prod`, `us-central1` | CIS 3.x | Missing `us-east1`, `europe-west1`, shared VPC host project, and hierarchical firewall policies | Low |
| GCP-EVID-04 | Missing | Cloud Asset Inventory export | Missing | None | All deployed-state controls | No CAI snapshot is available | Low |
| GCP-EVID-05 | Missing | Security Command Center findings export | Missing | None | Monitoring and posture controls | SCC evidence not provided | Low |
| GCP-EVID-06 | Missing | Policy Analyzer / org policy inheritance query | Missing | None | IAM and org policy controls | Cannot prove parent folder policy applies to children | Low |
| GCP-EVID-07 | Missing | Admin Activity audit log change review | Missing | None | Drift-sensitive controls | No evidence that IAM, firewall, or org policy was unchanged since January | Low |
| GCP-EVID-08 | Result confidence | Reviewer conclusion | 2026-06-09 | Full scope requested | All CIS sections | Evidence is stale and incomplete | Low |

## Expected Review Behavior

- Do not mark IAM, firewall, Cloud SQL, logging, or storage controls as Pass for the full organization.
- Mark deployed-state controls as `Not Evaluable` when they rely on `GCP-EVID-01` IaC intent alone.
- Record `payments-dr`, `analytics-prod`, folder inheritance, shared VPC, and regional service gaps in limitations.
- Treat the January `gcloud` exports as stale unless a change log proves no relevant drift occurred.
- Require Cloud Asset Inventory, SCC, Policy Analyzer, org policy, or fresh `gcloud` evidence before raising confidence.

## Anti-Pattern Under Test

The review fails this fixture if it says:

```text
Status: Pass
Evidence: Terraform denies public SSH and enables audit logging.
Coverage: all production projects
Confidence: High
```

That conclusion ignores GCP-EVID-01 through GCP-EVID-08: Terraform is only intended state, the live exports are stale and partial, and no parent inheritance or drift evidence supports full-scope confidence.
