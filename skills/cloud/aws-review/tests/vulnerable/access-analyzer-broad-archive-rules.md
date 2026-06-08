# Vulnerable: Access Analyzer Enabled but Findings Hidden

## Review Target

```yaml
account: "123456789012"
organization: o-example
regions:
  - us-east-1
  - us-west-2

analyzers:
  - name: account-analyzer-use1
    region: us-east-1
    scope: ACCOUNT
    intended_boundary: ORGANIZATION
    type: EXTERNAL_ACCESS
    active_findings:
      - id: finding-public-s3-prod
        resource: arn:aws:s3:::prod-customer-exports
        principal: "*"
        finding_type: external_access
        first_observed: 2026-04-15
        age_days: 54
        owner: none
    archived_findings:
      - id: finding-cross-account-kms
        resource: arn:aws:kms:us-east-1:123456789012:key/prod-data
        principal: arn:aws:iam::999999999999:root
        archive_rule: archive-approved-partners
    archive_rules:
      - name: archive-approved-partners
        filter: principal.account != "123456789012"
        owner: none
        approver: none
        justification: "known partners"
        expiry: none
        example_findings_reviewed: false
  - name: missing-usw2
    region: us-west-2
    scope: none

unused_access:
  expected: true
  analyzer_enabled: false
  review_claim: "unused role and access key review handled by Access Analyzer"

resolved_findings:
  - id: finding-old-public-role
    status: RESOLVED
    linked_policy_change: none
    validation_timestamp: none

reporting:
  cis_1_20_status: Pass
  raw_active_count_reported: false
  archived_count_reported: false
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| AWS-AA-01 | Medium | Active external-access findings exist but are not owned or reviewed. |
| AWS-AA-02 | Medium | Analyzer is `ACCOUNT` scoped even though the intended trust boundary is the organization, and `us-west-2` has no analyzer evidence. |
| AWS-AA-03 | Medium | Unused access review is claimed but unused-access analyzer coverage is disabled. |
| AWS-AA-04 | High | Archive rule suppresses any external principal outside the account, broad enough to hide unapproved cross-account access. |
| AWS-AA-05 | Medium | Archive rule and archived findings lack owner, approver, expiry, and example review evidence. |
| AWS-AA-06 | Medium | Resolved finding has no linked policy/resource change or validation timestamp. |
| AWS-AA-07 | Low | CIS 1.20 is marked Pass while raw active and archived counts are not reported. |

## Reviewer Notes

This environment should not treat Access Analyzer enablement as full CIS 1.20 effectiveness. Require organization/region scope evidence, active finding ownership, narrow archive rules, unused-access coverage, resolved-finding proof, and separate raw finding counts.
