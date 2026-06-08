---
name: iac-only-stale-pim-ca-evidence
expected: not-evaluable
skill: azure-review
---

# Azure Review Fixture: IaC-Only, Stale PIM, and Conditional Access Drift

Use this fixture to verify that `azure-review` does not mark CIS Azure controls as Pass when evidence is stale, partial, or only describes intended Terraform/Bicep state.

## Review Scope

- Tenant: `contoso.example`
- Management group: `mg-payments-prod`
- Subscriptions in scope: `sub-payments-prod`, `sub-payments-dr`, `sub-analytics-prod`
- Regions in scope: `eastus`, `westus3`, `westeurope`
- Review date: `2026-06-09`

## Evidence Inventory

| Evidence ID | Basis | Source / Query | Collection Date | Scope | Controls Supported | Limitations | Confidence |
|-------------|-------|----------------|-----------------|-------|--------------------|-------------|------------|
| AZ-EVID-01 | IaC intent | `terraform/envs/prod/**/*.tf` at commit `41b1c0d` | 2025-11-17 | `sub-payments-prod` only | RBAC, NSG, Key Vault, Defender | Does not prove deployed state, excludes DR and analytics subscriptions, no management group inheritance proof | Low |
| AZ-EVID-02 | Partial live export | `az role assignment list --subscription sub-payments-prod` | 2025-12-22 | `sub-payments-prod` permanent assignments only | CIS 1.x | No PIM eligible assignment or activation history, no management group inherited RBAC, stale by 169 days | Low |
| AZ-EVID-03 | Partial live export | `az network nsg list --subscription sub-payments-prod --query []` | 2026-01-04 | `sub-payments-prod`, `eastus` | CIS 6.x | Missing `westus3`, `westeurope`, Azure Firewall policy, and peered/shared services subscription | Low |
| AZ-EVID-04 | Missing | Azure Resource Graph subscription-wide inventory | Missing | None | All deployed-state controls | No ARG evidence for full tenant or all subscriptions | Low |
| AZ-EVID-05 | Missing | Defender for Cloud regulatory compliance export | Missing | None | Defender, VM, SQL, Storage, Key Vault | Cannot confirm Defender plan state or recommendations | Low |
| AZ-EVID-06 | Missing | PIM activation and eligible-assignment export | Missing | None | Identity and effective access controls | Cannot distinguish permanent stale RBAC from JIT access path | Low |
| AZ-EVID-07 | Missing | Conditional Access policy inventory and Activity Log review | Missing | None | Identity, access, monitoring | Cannot detect new partner-portal policy or CA drift since old review | Low |
| AZ-EVID-08 | Result confidence | Reviewer conclusion | 2026-06-09 | Full scope requested | All CIS sections | Evidence is stale, partial, and lacks effective-access context | Low |

## Expected Review Behavior

- Do not mark RBAC, PIM, Conditional Access, NSG, Defender, Key Vault, or Storage controls as Pass for the full tenant.
- Mark deployed-state controls as `Not Evaluable` when they rely on `AZ-EVID-01` IaC intent alone.
- Record missing management group inheritance, `sub-payments-dr`, `sub-analytics-prod`, regional coverage, PIM activation history, and Conditional Access drift in limitations.
- Treat the old `az` exports as stale unless Activity Log and change-control evidence proves no relevant drift occurred.
- Require Resource Graph, Defender, Azure Policy, PIM, Conditional Access, or fresh `az` evidence before raising confidence.

## Anti-Pattern Under Test

The review fails this fixture if it says:

```text
Status: Pass
Evidence: Terraform requires MFA and denies public NSG management access.
Coverage: all production subscriptions
Effective Access Context: not needed
Confidence: High
```

That conclusion ignores AZ-EVID-01 through AZ-EVID-08: Terraform is only intended state, the live exports are stale and partial, PIM/Conditional Access evidence is missing, and no management group inheritance or drift evidence supports full-scope confidence.
