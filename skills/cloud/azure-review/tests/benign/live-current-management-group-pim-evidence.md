---
name: live-current-management-group-pim-evidence
expected: high-confidence
skill: azure-review
---

# Azure Review Fixture: Current Live Evidence with Management Group and PIM Scope

Use this fixture to verify that `azure-review` can assign high confidence when live/exported evidence is current, scoped, and reconciled with management group inheritance, PIM, Conditional Access, and Azure Policy state.

## Review Scope

- Tenant: `contoso.example`
- Management group: `mg-payments-prod`
- Subscriptions in scope: `sub-payments-prod`, `sub-payments-dr`, `sub-analytics-prod`
- Regions in scope: `eastus`, `westus3`, `westeurope`
- Review date: `2026-06-09`

## Evidence Inventory

| Evidence ID | Basis | Source / Query | Collection Date | Scope | Controls Supported | Limitations | Confidence |
|-------------|-------|----------------|-----------------|-------|--------------------|-------------|------------|
| AZ-EVID-01 | Live-exported | Azure Resource Graph export `arg-tenant-contoso-2026-06-08.json` | 2026-06-08 | Tenant, `mg-payments-prod`, all three subscriptions, all in-scope regions | RBAC, NSG, Storage, VM, SQL, Key Vault, App Service | Excludes deleted resources outside Activity Log retention | High |
| AZ-EVID-02 | Live-exported | `az policy assignment list --scope /providers/Microsoft.Management/managementGroups/mg-payments-prod` | 2026-06-08 | Management group and inherited child subscriptions | Azure Policy and Defender coverage | Excludes sandbox subscriptions outside review scope | High |
| AZ-EVID-03 | Live-exported | Entra ID Conditional Access policy export plus named-location inventory | 2026-06-08 | Tenant-wide user and workload access policies | CIS 1.x | Break-glass exclusions are separately listed and approved | High |
| AZ-EVID-04 | Live-exported | PIM eligible assignment and activation history export | 2026-06-08 | Privileged roles across management group and child subscriptions | Identity and effective access | Covers 90-day activation history and current eligibilities | High |
| AZ-EVID-05 | Live-exported | Defender for Cloud regulatory compliance export | 2026-06-08 | All in-scope subscriptions | Defender, VM, SQL, Storage, Key Vault posture | Mute rules reviewed separately | High |
| AZ-EVID-06 | Live-exported | Activity Log review for RBAC, policy, CA, NSG, Key Vault, and Defender changes | 2026-06-01 to 2026-06-09 | Tenant and in-scope subscriptions | Drift-sensitive controls | Seven-day window matches daily change-control review | High |
| AZ-EVID-07 | Mixed | Bicep and Terraform pipeline records | 2026-06-08 | Production modules for all in-scope subscriptions | Intended state cross-check | Used only to reconcile live state, not as sole proof | Medium |
| AZ-EVID-08 | Result confidence | Reviewer conclusion | 2026-06-09 | Full review scope | All CIS sections | Live evidence is current and scope gaps are documented | High |

## Expected Review Behavior

- Findings should cite the specific `AZ-EVID-##` rows used for each Passed, Failed, or Not Evaluable control.
- Management group policy and RBAC evidence can support child subscriptions only because `AZ-EVID-01`, `AZ-EVID-02`, and `AZ-EVID-04` document the inheritance path and excluded scope.
- PIM and Conditional Access conclusions should include effective-access context from `AZ-EVID-03` and `AZ-EVID-04`.
- IaC evidence in `AZ-EVID-07` can corroborate live exports but should not override fresher live evidence.
- If any reviewed subscription, region, or service falls outside these rows, the finding should record a limitation instead of claiming full coverage.

## Acceptable High-Confidence Finding Shape

```text
Status: Pass
Evidence ID(s): AZ-EVID-01, AZ-EVID-02, AZ-EVID-03, AZ-EVID-04, AZ-EVID-06
Evidence Source: Azure Resource Graph, Azure Policy, Conditional Access, PIM, and Activity Log exports
Evidence Date: 2026-06-08
Coverage: tenant contoso.example, mg-payments-prod, sub-payments-prod, sub-payments-dr, sub-analytics-prod
Effective Access Context: PIM eligible assignments and 90-day activation history reviewed; break-glass exclusions approved
Limitations: deleted resources outside Activity Log retention are not represented in ARG
Confidence: High
```
