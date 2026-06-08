# Benign: Validated Role-Mining Dataset

## Review Target

```yaml
role_mining:
  source_systems:
    - entra-id-groups
    - okta-app-assignments
    - finance-app-rbac
    - aws-iam-identity-center
  extraction_date: "2026-06-08"
  observation_window:
    start: "2026-03-01"
    end: "2026-05-31"
  population_denominator:
    users: 398
    groups: 112
    roles: 46
    permissions: 1834
    resources: 271
  coverage_gaps:
    - "legacy expense app excluded; owner accepted separate migration review in RISK-9021"
  entitlement_normalization:
    direct_assignments: true
    inherited_groups: true
    nested_groups: true
    jit_assignments: true
    temporary_roles: true
    break_glass_accounts: separated
  account_filtering:
    dormant_accounts_removed: true
    orphaned_users_removed: true
    service_accounts_separated: true
    contractors_separated: true
    test_users_removed: true
    emergency_accounts_separated: true
  permission_use_evidence:
    last_used_available: true
    access_logs_reviewed: true
    ticket_history_reviewed: true
    unavailable_reason: null
  clustering:
    overlap_threshold: "82%"
    candidate_roles: 19
    algorithm: jaccard-permission-overlap-plus-owner-review
    rationale: "selected from elbow analysis and validated by resource owners"
  candidate_roles:
    - name: finance-invoice-reviewer
      members: 31
      permissions:
        - invoice.read
        - vendor.read
        - payment.view
      owner_signoff:
        owner: finance-systems
        date: "2026-06-07"
        decision: approved
      outlier_disposition:
        payment.release: retired
        vendor.create: ABAC_with_manager_approval
      direct_assignment_remediation:
        removed: 14
        converted_to_role: 22
        justified_exception: 2
      sod_review:
        payment_initiator_vs_approver: pass
  confidence_claim: High
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Dataset freshness and coverage | Pass | Extraction date, 90-day window, population denominators, and one documented coverage gap are present. |
| Entitlement normalization | Pass | Direct, inherited, nested, JIT, temporary, and break-glass assignments are expanded or separated. |
| Account filtering | Pass | Dormant, orphaned, service, contractor, test, and emergency accounts are removed or separated. |
| Permission-use evidence | Pass | Last-used, access-log, and ticket evidence are reviewed before role promotion. |
| Owner validation | Pass | Finance owner approved the candidate role and SoD review passed. |
| Outlier remediation | Pass | Excess permissions are retired, converted to ABAC, or tracked as justified exceptions. |

## Reviewer Notes

This dataset can support role-mining recommendations. Keep the legacy expense app gap and justified exceptions in the remediation roadmap, and schedule periodic re-mining to detect drift.
