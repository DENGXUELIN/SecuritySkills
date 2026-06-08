# Vulnerable: expired risk exception missing revalidation evidence

This sample should be rejected as an invalid patch exception even if the ticket says the risk was accepted.

## Scenario

- CVE: `CVE-2026-1442`
- SLA tier: `P1 - Critical`
- Original deadline: `2026-06-04`
- Requested new deadline: `2026-09-30`
- Exception status in ticket: `Approved`

## Exception excerpt

```yaml
exception_id: EXC-2026-0177
cves:
  - CVE-2026-1442
affected_systems: "all customer portal servers"
original_sla: "P1 - Critical"
original_deadline: "2026-06-04"
requested_deadline: "2026-09-30"
business_justification: "Too busy this quarter"
compensating_control_evidence: ""
residual_risk: ""
approver: "Application Team Lead"
approval_date: ""
expiration_review_date: "2026-06-01"
policy_limit_exceeded: true
status: "Approved"
```

## Expected result

- Decision: `Reject exception`
- Required finding: the exception is expired, exceeds the P1 maximum exception duration, lacks compensating-control evidence, lacks residual-risk analysis, lacks an approval date, and uses an insufficient approval authority for a critical exception.
- Required recommendation: report the finding as an SLA breach until a valid authority approves a bounded extension with tested controls and residual-risk evidence.
