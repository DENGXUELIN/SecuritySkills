# Benign: bounded exception with tested compensating controls

This sample should be accepted as a valid short-term exception because it preserves the original SLA, has a specific blocker, includes tested controls, and has an unexpired review date.

## Scenario

- CVE: `CVE-2026-2201`
- SLA tier: `P2 - High`
- Original deadline: `2026-06-12`
- Requested new deadline: `2026-07-19`
- Reason: vendor hotfix is available only in a maintenance release that must be tested against a regulated payment workflow

## Exception excerpt

```yaml
exception_id: EXC-2026-0184
cves:
  - CVE-2026-2201
affected_systems:
  - "payments-api-prod-03"
  - "payments-api-prod-04"
environment: "production"
owner: "Payments Platform"
original_sla: "P2 - High"
original_deadline: "2026-06-12"
requested_deadline: "2026-07-19"
business_justification: "Vendor hotfix requires regression testing for PCI payment authorization flow before deployment."
compensating_control_evidence:
  waf_rule: "WAF-2026-2201 blocks the published exploit path; tested against poc-2026-06-08"
  network_segmentation: "Only payment gateway subnet can reach the vulnerable endpoint; firewall test FW-8842 passed"
  edr_detection: "Detection rule EDR-CVE-2026-2201 fired in staging validation"
residual_risk: "Residual risk is partial bypass through authenticated gateway users; no internet-direct path remains."
approver: "Security Director"
approval_date: "2026-06-08"
expiration_review_date: "2026-07-19"
policy_limit_exceeded: false
status: "Approved"
```

## Expected result

- Decision: `Accept exception`
- Required non-finding: do not report this as an invalid exception because the affected systems are scoped, the blocker is specific, compensating controls were tested, residual risk is documented, approval authority is appropriate, and the review date is within the P2 maximum duration.
- Required recommendation: keep the exception visible in the SLA dashboard and revalidate controls before the review date or if exposure changes.
