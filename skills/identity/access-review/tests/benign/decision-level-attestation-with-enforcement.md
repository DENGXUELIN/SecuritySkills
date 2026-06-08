# Benign Fixture: Decision-Level Attestation With Enforcement

## Scenario

The same quarterly access certification campaign includes decision-level
attestation evidence. Reviewers can prove who certified each entitlement, why
the reviewer had authority, what the permission meant, and whether revoke or
modify decisions were enforced.

## Evidence Snapshot

| Field | Value |
|---|---|
| Campaign | `AR-Q2-2026-PROD-SaaS` |
| Review period | `2026-04-01` to `2026-06-30` |
| System | `FinanceOps SaaS` |
| Source export | `iga-decision-export-2026-06-30.json`, SHA-256 recorded in audit vault |
| Identity | `svc-billing-reconcile`, service account, owner `Billing Platform Team` |
| Entitlement | `FinanceOps-Settlement-Approver` on settlement queue `prod-na` |
| Permission meaning | Can approve settlement adjustments up to the configured workflow limit |
| Certifier | `owner-billing-platform`, resource owner per `SYS-FINOPS-OWNER-2026-Q2` |
| Decision | `modify`, remove settlement approval and keep read-only reconciliation |
| Decision timestamp | `2026-06-18T15:42:31Z` |
| Batch quality | Batch `12`, median decision duration `3m 20s`, sampled by compliance |
| Enforcement | Ticket `IAM-7421`, change `CHG-10933`, executed `2026-06-19T02:14:09Z` |
| Reconciliation | Post-change export confirms no approval permission on `2026-06-19T03:00:00Z` |
| Confidence | High; reviewer authority, permission meaning, decision, and enforcement are linked |

## Positive Controls

- `AR-ATTEST-01`: Campaign evidence identifies campaign ID, period, system, and
  source export.
- `AR-ATTEST-02`: The entitlement record includes identity, role, resource scope,
  criticality, and permission meaning.
- `AR-ATTEST-03`: Certifier authority is proven by the resource-owner record.
- `AR-ATTEST-04`: Decision status, timestamp, and rationale are preserved.
- `AR-ATTEST-05`: Batch size and decision duration do not indicate blind approval;
  compliance sampling is recorded.
- `AR-ATTEST-06`: The modify decision links to execution and post-change
  reconciliation evidence.
- `AR-ATTEST-07`: A service-account owner change during Q2 triggered
  re-attestation before campaign closure.
- `AR-ATTEST-08`: Confidence is high because the evidence chain is complete and fresh.

## Expected Result

Do not flag the campaign as missing attestation evidence. Any remaining finding
should focus on the underlying entitlement risk, not on access-review evidence
quality.
