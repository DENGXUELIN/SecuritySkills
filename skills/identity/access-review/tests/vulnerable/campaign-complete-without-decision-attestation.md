# Vulnerable Fixture: Campaign Complete Without Decision Attestation

## Scenario

The quarterly access certification campaign is marked complete in the IGA tool.
Auditors receive only a dashboard export and a summary count, so the review cannot
prove that reviewers understood the entitlements, had authority to certify them,
or enforced revoke decisions.

## Evidence Snapshot

| Field | Value |
|---|---|
| Campaign | `AR-Q2-2026-PROD-SaaS` |
| Review period | `2026-04-01` to `2026-06-30` |
| System | `FinanceOps SaaS` |
| Completion | `100% complete` |
| Population | `184 users, 612 entitlements` |
| Export evidence | `iga-dashboard-summary-2026-06-30.csv` |
| Approval count | `609 approved, 3 revoked` |
| Reviewer evidence | `manager column present, no authority proof` |
| Decision evidence | `bulk complete event only` |
| Enforcement evidence | `no ticket IDs or post-change reconciliation` |

## Problem Indicators

- `AR-ATTEST-02`: The export lists role names but not permission meaning or
  resource scope, so certifiers may have approved labels they did not understand.
- `AR-ATTEST-03`: Delegated reviews are accepted without manager, resource owner,
  or approved-delegate authority evidence.
- `AR-ATTEST-04`: Individual decisions lack timestamp, rationale, and decision
  actor per entitlement.
- `AR-ATTEST-05`: One certifier approved `143` entitlements in `4 minutes` with no
  sampling follow-up.
- `AR-ATTEST-06`: Three revoke decisions have no enforcement ticket or
  post-removal access state.
- `AR-ATTEST-08`: Confidence is low because the evidence source is a summary
  dashboard rather than immutable decision-level records.

## Expected Finding

Classify as **Medium** or **High** depending on entitlement criticality. The
review may satisfy a completion metric, but it does not prove meaningful access
certification or revocation enforcement.

## Required Remediation

Export decision-level attestation records with campaign ID, identity,
entitlement, permission meaning, certifier authority, decision timestamp, batch
quality signals, enforcement ticket, reconciliation result, and confidence.
