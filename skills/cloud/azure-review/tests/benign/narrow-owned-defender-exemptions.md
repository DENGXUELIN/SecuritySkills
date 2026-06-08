# Benign: Narrow and Owned Defender Exemptions

## Review Target

```yaml
environment:
  tenant: contoso-prod
  subscriptions:
    - id: "00000000-0000-0000-0000-000000000001"
      name: prod-shared

defender_for_cloud:
  mcsb_assigned: true
  defender_plans_enabled:
    servers: true
    storage: true
    containers: true
  secure_score_report:
    source: defender-portal-and-arg-export
    includes_exempted_resources: true
    raw_unhealthy_export_attached: true
    post_exemption_summary_attached: true

policy_exemptions:
  - name: exempt-vendor-managed-vm-jit
    scope: "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/prod-vendor"
    policy_assignment_id: "/subscriptions/00000000-0000-0000-0000-000000000001/providers/Microsoft.Authorization/policyAssignments/mcsb"
    recommendation: "Management ports of virtual machines should be protected with just-in-time network access control"
    category: Waiver
    expires_on: "2026-09-30"
    owner: vendor-platform
    approver: cloud-security
    description: "Vendor-managed VM uses private bastion and is being migrated to JIT-capable image."
    ticket: RISK-4821
    compensating_control: "Private endpoint only, NSG source restricted to bastion subnet, weekly Defender review."
    resource_selectors:
      - kind: resourceLocation
        in:
          - eastus
      - kind: resourceWithoutLocation
        in:
          - "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/prod-vendor/providers/Microsoft.Compute/virtualMachines/vendor01"
    affected_resources:
      - "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/prod-vendor/providers/Microsoft.Compute/virtualMachines/vendor01"
    raw_status: Unhealthy
    exempted_status: NotApplicable
  - name: mitigated-storage-legacy-migration
    scope: "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/legacy-storage"
    policy_assignment_id: "/subscriptions/00000000-0000-0000-0000-000000000001/providers/Microsoft.Authorization/policyAssignments/mcsb"
    recommendation: "Storage accounts should prevent public access"
    category: Mitigated
    expires_on: "2026-08-15"
    owner: data-platform
    approver: security-architecture
    description: "Legacy static export account has public access disabled by policy exception after verified CDN migration."
    ticket: SEC-6120
    compensating_control: "Azure Policy denies new public containers; migration evidence attached."
    resource_selectors:
      - kind: resourceWithoutLocation
        in:
          - "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/legacy-storage/providers/Microsoft.Storage/storageAccounts/exportarchive"
    affected_resources:
      - "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/legacy-storage/providers/Microsoft.Storage/storageAccounts/exportarchive"
    raw_status: HealthyWithEvidence
    exempted_status: Healthy

arg_exports:
  policyresources_exported: true
  securityresources_exempted_filter_exported: true
  securityresources_raw_unhealthy_exported: true
  duplicate_exemption_query:
    duplicate_count: 0
  review_date: "2026-06-08"
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Inventory coverage | Pass | Policy exemption and Defender assessment exports are both attached. |
| Ownership | Pass | Each exemption has owner, approver, ticket, description, and expiry evidence. |
| Scope | Pass | Exemptions are scoped to the affected resource group or explicit resource selectors. |
| Expiry | Pass | Expiry dates are future-dated and tied to migration or risk review. |
| Compensating evidence | Pass | Waiver and mitigated cases include concrete alternate controls or migration proof. |
| Reporting separation | Pass | Raw unhealthy state and post-exemption status are reported separately. |
| Duplicate review | Pass | Duplicate exemption query returns zero overlapping policy assignment/resource selector pairs. |

## Reviewer Notes

This evidence supports accepting the exemptions as governed risk decisions. Continue tracking expiry dates and revalidate Defender recommendation state after each exemption renewal or deletion.
