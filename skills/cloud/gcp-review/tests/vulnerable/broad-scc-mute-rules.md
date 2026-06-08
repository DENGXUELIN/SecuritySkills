# Vulnerable: Broad SCC Mute Rules Hide Active Findings

## Review Target

```yaml
environment:
  organization: "123456789012"
  folders:
    - name: prod
      id: "456789012345"
  projects:
    - prod-payments
    - prod-data

scc_exports:
  raw_active_findings_exported: false
  dashboard_summary_used: true
  muted_default_view_used: true

active_findings_sample:
  - name: organizations/123456789012/sources/111/findings/public-bucket-prod
    category: PUBLIC_BUCKET_ACL
    severity: HIGH
    state: ACTIVE
    mute: MUTED
    resource_name: //storage.googleapis.com/prod-customer-exports
    finding_class: MISCONFIGURATION
    owner: null
    ticket: null
    remediation_target: null
  - name: organizations/123456789012/sources/111/findings/open-ssh-prod
    category: OPEN_FIREWALL
    severity: HIGH
    state: ACTIVE
    mute: MUTED
    resource_name: //compute.googleapis.com/projects/prod-payments/global/firewalls/allow-ssh
    finding_class: THREAT
    owner: null
    ticket: null
    remediation_target: null

mute_configs:
  - name: organizations/123456789012/muteConfigs/prod-noise
    type: STATIC
    filter: 'resource.project_display_name =~ "prod-.*"'
    owner: null
    approver: null
    justification: "too noisy"
    next_review_date: null
    compensating_control: null
  - name: organizations/123456789012/muteConfigs/temp-threat-noise
    type: DYNAMIC
    filter: 'severity="HIGH" OR severity="CRITICAL"'
    owner: detection-team
    automation_owner: null
    expires_on: null
    recertification_days: null

bulk_mute_events:
  - event_time: "2026-06-05T10:30:00Z"
    requester: cloud-admin@example.com
    approver: null
    affected_categories:
      - PUBLIC_BUCKET_ACL
      - OPEN_FIREWALL
    affected_resource_count: 418
    change_ticket: null
    rollback_plan: null

reporting:
  cis_score: "96%"
  scc_high_findings_reported: 0
  muted_findings_count_reported: false
  raw_active_count_reported: false
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| GCP-SCC-MUTE-01 | Medium | Review evidence starts from dashboard and muted default view, not raw active findings. |
| GCP-SCC-MUTE-02 | High | Static mute rule covers production projects with a broad regex and lacks owner, approver, review date, and compensating control. |
| GCP-SCC-MUTE-03 | High | Dynamic rule mutes High/Critical findings without expiry, recertification, or automation owner. |
| GCP-SCC-MUTE-04 | High | Muted public bucket and open firewall findings are active High findings with no owner, ticket, or remediation target. |
| GCP-SCC-MUTE-05 | High | Bulk mute event affects 418 resources without approval, change ticket, or rollback plan. |
| GCP-SCC-MUTE-06 | Medium | Report shows 0 high SCC findings and high CIS score without raw or muted finding counts. |

## Reviewer Notes

Do not accept the dashboard summary as proof of remediation. Require raw SCC active finding export, narrow mute filters, owner-approved risk decisions, remediation tracking, and bulk mute change evidence.
