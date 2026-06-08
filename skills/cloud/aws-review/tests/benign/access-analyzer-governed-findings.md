# Benign: Governed Access Analyzer Finding Review

## Review Target

```yaml
account: "123456789012"
organization: o-example
regions:
  - us-east-1
  - us-west-2

analyzers:
  - name: org-external-access-use1
    region: us-east-1
    scope: ORGANIZATION
    intended_boundary: ORGANIZATION
    type: EXTERNAL_ACCESS
    active_findings:
      - id: finding-vendor-readonly-bucket
        resource: arn:aws:s3:::shared-vendor-drop
        principal: arn:aws:iam::222222222222:role/vendor-reader
        finding_type: external_access
        first_observed: 2026-06-06
        age_days: 2
        owner: data-platform
        ticket: SEC-5011
    archived_findings:
      - id: finding-approved-cloudtrail-delivery
        resource: arn:aws:s3:::org-cloudtrail-logs
        principal: cloudtrail.amazonaws.com
        archive_rule: archive-aws-service-cloudtrail
    archive_rules:
      - name: archive-aws-service-cloudtrail
        filter: principal.service == "cloudtrail.amazonaws.com" and resource.type == "AWS::S3::Bucket"
        owner: cloud-security
        approver: security-architecture
        justification: AWS service delivery to centralized CloudTrail bucket
        expiry: 2026-09-30
        example_findings_reviewed: true
  - name: org-external-access-usw2
    region: us-west-2
    scope: ORGANIZATION
    intended_boundary: ORGANIZATION
    type: EXTERNAL_ACCESS
    active_findings: []
    archived_findings: []
    archive_rules: []

unused_access:
  expected: true
  analyzer_enabled: true
  coverage:
    roles: true
    access_keys: true
    passwords: true
    permissions: true
  oldest_unused_finding_days: 9

resolved_findings:
  - id: finding-public-role-old
    status: RESOLVED
    linked_policy_change: iam-policy-pr-884
    validation_timestamp: 2026-06-08T03:15:00Z

reporting:
  cis_1_20_status: Partial_with_operational_evidence
  raw_active_count_reported: true
  archived_count_reported: true
  oldest_active_finding_reported: true
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Analyzer scope and regions | Pass | Organization-scoped analyzers exist in both required regions. |
| Active finding inventory | Pass | Active finding has resource, principal, age, owner, and ticket. |
| Unused access analyzer coverage | Pass | Roles, access keys, passwords, and permissions are covered. |
| Archive-rule governance | Pass | Archive rule has narrow AWS service filter, owner, approver, justification, expiry, and example review. |
| Resolved finding proof | Pass | Resolved finding links to policy PR and validation timestamp. |
| Reporting separation | Pass | Raw active/archived counts and oldest active finding are reported separately from enablement. |

## Reviewer Notes

This evidence supports a mature Access Analyzer review. Continue tracking active finding SLA and archive-rule expiry review.
