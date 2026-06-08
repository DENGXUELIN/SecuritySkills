# Vulnerable: Dirty Role-Mining Dataset Promotes Privilege Creep

## Review Target

```yaml
role_mining:
  source_systems:
    - idp-groups
    - finance-app-rbac
  extraction_date: null
  observation_window: unknown
  population_denominator:
    users: 420
    groups: null
    roles: 38
    permissions: 1800
    resources: null
  coverage_gaps:
    - cloud-iam-direct-grants-not-exported
    - nested-groups-not-expanded
    - saas-admin-roles-missing
  entitlement_normalization:
    direct_assignments: false
    inherited_groups: partial
    nested_groups: false
    jit_assignments: false
    temporary_roles: false
    break_glass_accounts: false
  account_filtering:
    dormant_accounts_removed: false
    orphaned_users_removed: false
    service_accounts_separated: false
    contractors_separated: false
    test_users_removed: false
    emergency_accounts_separated: false
  permission_use_evidence:
    last_used_available: false
    access_logs_reviewed: false
    ticket_history_reviewed: false
  clustering:
    overlap_threshold: "80%"
    candidate_roles: 38
    algorithm: jaccard-permission-overlap
    rationale: "default threshold"
  candidate_roles:
    - name: finance-power-user
      members:
        - alice
        - bob
        - contractor-temp-17
        - breakglass-finance
      permissions:
        - invoice.read
        - invoice.approve
        - vendor.create
        - payment.release
      owner_signoff: missing
      outlier_disposition: none
      direct_assignment_remediation: none
      sod_review: missing
  confidence_claim: High
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| RBAC-MINE-07 | Medium | Dataset lacks extraction date, observation window, group/resource denominators, and full source coverage. |
| RBAC-MINE-08 | High | Direct, nested-group, JIT, temporary, and break-glass entitlements are not normalized before clustering. |
| RBAC-MINE-09 | High | Contractor and break-glass identities are mixed into a standard finance candidate role. |
| RBAC-MINE-10 | Medium | Payment and vendor permissions are promoted without last-used, log, or ticket evidence. |
| RBAC-MINE-11 | High | Finance candidate role lacks owner signoff, outlier disposition, direct-assignment remediation, and SoD review. |

## Reviewer Notes

Do not accept the claimed high confidence. Mark role mining as Not Evaluable until the dataset is re-extracted with dated coverage, expanded entitlements, filtered account populations, permission-use evidence, owner validation, and outlier remediation.
