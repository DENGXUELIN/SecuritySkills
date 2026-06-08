# Vulnerable: Broad and Expired Defender Exemptions

## Review Target

```yaml
environment:
  tenant: contoso-prod
  management_group: "/providers/Microsoft.Management/managementGroups/prod"
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
    source: portal-summary
    includes_exempted_resources: false
    raw_unhealthy_export_attached: false

policy_exemptions:
  - name: exempt-management-ports-prod
    scope: "/providers/Microsoft.Management/managementGroups/prod"
    policy_assignment_id: "/providers/Microsoft.Management/managementGroups/prod/providers/Microsoft.Authorization/policyAssignments/mcsb"
    recommendation: "Management ports of virtual machines should be protected with just-in-time network access control"
    category: Waiver
    expires_on: "2026-03-31"
    owner: null
    approver: null
    description: "legacy systems"
    ticket: null
    compensating_control: null
    resource_selectors: []
    affected_resources:
      - "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/prod-app/providers/Microsoft.Compute/virtualMachines/app01"
      - "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/prod-db/providers/Microsoft.Compute/virtualMachines/db01"
    raw_status: Unhealthy
    exempted_status: NotApplicable
  - name: exempt-storage-public-access
    scope: "/subscriptions/00000000-0000-0000-0000-000000000001"
    policy_assignment_id: "/subscriptions/00000000-0000-0000-0000-000000000001/providers/Microsoft.Authorization/policyAssignments/mcsb"
    recommendation: "Storage accounts should prevent public access"
    category: Mitigated
    expires_on: null
    owner: cloud-platform
    approver: null
    description: "covered elsewhere"
    ticket: null
    compensating_control: null
    resource_selectors:
      - kind: resourceType
        in:
          - "Microsoft.Storage/storageAccounts"
    affected_resources: all-storage-accounts-in-subscription
    raw_status: Unhealthy
    exempted_status: NotApplicable
  - name: duplicate-storage-public-access
    scope: "/subscriptions/00000000-0000-0000-0000-000000000001"
    policy_assignment_id: "/subscriptions/00000000-0000-0000-0000-000000000001/providers/Microsoft.Authorization/policyAssignments/mcsb"
    recommendation: "Storage accounts should prevent public access"
    category: Waiver
    expires_on: "2026-12-31"
    owner: application-team
    approver: application-team
    description: "same recommendation covered by another exemption"
    ticket: APP-77
    resource_selectors:
      - kind: resourceType
        in:
          - "Microsoft.Storage/storageAccounts"

arg_exports:
  policyresources_exported: true
  securityresources_exempted_filter_exported: true
  securityresources_raw_unhealthy_exported: false
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| AZ-DEF-EXEMPT-01 | Medium | The management-port exemption has no owner, approver, ticket, or compensating evidence. |
| AZ-DEF-EXEMPT-02 | High | The management-port exemption is scoped to the production management group while evidence lists only two affected VMs. |
| AZ-DEF-EXEMPT-03 | High | The management-port exemption expired on 2026-03-31 but still reports `NotApplicable`. |
| AZ-DEF-EXEMPT-04 | High | Internet-management-port and public-storage recommendations are exempted without compensating controls. |
| AZ-DEF-EXEMPT-05 | Medium | The secure-score report omits raw unhealthy recommendation state. |
| AZ-DEF-EXEMPT-06 | Medium | Two storage public-access exemptions overlap on the same policy assignment and resource selector. |

## Reviewer Notes

Do not mark this environment compliant from the post-exemption portal summary. Require raw Defender recommendation exports, remove or renew expired exemptions, narrow the management-group waiver, and attach owner-approved risk or compensating-control evidence before accepting the exemptions.
