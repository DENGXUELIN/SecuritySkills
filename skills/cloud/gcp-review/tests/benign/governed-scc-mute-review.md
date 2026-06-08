# Benign: Governed SCC Mute Review

## Review Target

```yaml
environment:
  organization: "123456789012"
  projects:
    - prod-payments
    - prod-data

scc_exports:
  raw_active_findings_exported: true
  dashboard_summary_used: true
  muted_default_view_used: false
  export_time: "2026-06-08T03:00:00Z"

active_findings_sample:
  - name: organizations/123456789012/sources/111/findings/test-bucket-lab
    category: PUBLIC_BUCKET_ACL
    severity: MEDIUM
    state: ACTIVE
    mute: MUTED
    resource_name: //storage.googleapis.com/security-lab-public-fixture
    finding_class: MISCONFIGURATION
    owner: security-engineering
    ticket: RISK-7112
    remediation_target: "2026-06-30"
    accepted_risk: "lab fixture with synthetic data only"
  - name: organizations/123456789012/sources/111/findings/service-account-key-prod
    category: SERVICE_ACCOUNT_KEY_NOT_ROTATED
    severity: HIGH
    state: ACTIVE
    mute: UNMUTED
    resource_name: //iam.googleapis.com/projects/prod-data/serviceAccounts/importer
    finding_class: VULNERABILITY
    owner: data-platform
    ticket: SEC-8801
    remediation_target: "2026-06-12"

mute_configs:
  - name: organizations/123456789012/muteConfigs/security-lab-fixture
    type: STATIC
    filter: 'resource.name="//storage.googleapis.com/security-lab-public-fixture" AND category="PUBLIC_BUCKET_ACL"'
    owner: security-engineering
    approver: cloud-security
    justification: "Synthetic public bucket used by internal detector tests."
    next_review_date: "2026-07-01"
    compensating_control: "Org policy prevents public access outside the lab project."
    ticket: RISK-7112
  - name: organizations/123456789012/muteConfigs/ephemeral-scanner-findings
    type: DYNAMIC
    filter: 'category="VULNERABILITY_SCAN_INFO" AND resource.project_display_name="scanner-sandbox"'
    owner: vulnerability-management
    automation_owner: scc-mute-controller
    expires_on: "2026-06-30"
    recertification_days: 30
    stale_rule_cleanup_job: "scc-mute-reaper"

bulk_mute_events:
  - event_time: "2026-06-01T12:05:00Z"
    requester: vuln-management@example.com
    approver: cloud-security@example.com
    affected_categories:
      - VULNERABILITY_SCAN_INFO
    affected_resource_count: 12
    change_ticket: CHG-9401
    rollback_plan: "remove ephemeral-scanner-findings mute config if scanner labels drift"
    follow_up_ticket: SEC-8791

reporting:
  cis_score: "88%"
  scc_high_findings_reported: 1
  muted_findings_count_reported: true
  raw_active_count_reported: true
  muted_count: 1
  unmuted_high_count: 1
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Raw active baseline | Pass | Raw SCC active findings were exported before dashboard rollups. |
| Static mute governance | Pass | Static rule is resource- and category-scoped with owner, approver, ticket, next review date, and compensating control. |
| Dynamic mute governance | Pass | Dynamic rule has automation owner, expiry, 30-day recertification, and stale-rule cleanup job. |
| Muted active tracking | Pass | Muted active finding has owner, ticket, remediation target, and accepted-risk context. |
| Bulk mute controls | Pass | Bulk mute event has requester, approver, affected scope, change ticket, rollback plan, and follow-up ticket. |
| Reporting separation | Pass | Raw active, muted, and unmuted high finding counts are reported separately from CIS score. |

## Reviewer Notes

This evidence supports accepting the SCC mute rules as governed exceptions. Keep the high unmuted service account key finding in the remediation plan and revalidate all mute rules at expiry or recertification.
