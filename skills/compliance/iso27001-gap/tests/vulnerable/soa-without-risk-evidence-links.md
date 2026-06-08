# Vulnerable: SoA Rows Without Risk and Evidence Links

## Scenario

The organization is preparing for ISO 27001 certification and exports a Statement of Applicability spreadsheet for the cloud analytics platform.

## Provided SoA Rows

| Control ID | Decision | Rationale | Implementation Status | Evidence |
|------------|----------|-----------|-----------------------|----------|
| A.5.23 | Included | Cloud security is handled by the platform team | Implemented | Cloud security policy |
| A.8.16 | Included | Monitoring exists | Implemented | SIEM screenshot |
| A.5.31 | Excluded | Legal does not apply to this product | Not applicable | N/A |

## Missing Evidence

- `ISO-SOA-02`: no risk register item, legal requirement, contractual requirement, interested-party requirement, or business objective is linked to the decisions.
- `ISO-SOA-03`: no risk treatment decision or risk owner approval is recorded.
- `ISO-SOA-04`: the rows do not define the business unit, platform, region, or asset boundary covered by each decision.
- `ISO-SOA-05`: the evidence only includes design artifacts and screenshots; there is no operating evidence such as samples, logs, tickets, or review records.
- `ISO-SOA-06`: no evidence owner, evidence date, or period covered is recorded.
- `ISO-SOA-07`: the excluded legal control has no scope, obligation, or risk-treatment support.

## Expected Review Result

The skill should not mark these SoA rows as audit-ready. The result should be `Unknown` or a finding because `ISO-SOA-08` requires missing risk linkage, treatment decision, owner, date, scope boundary, or evidence currentness to block implied conformity.
