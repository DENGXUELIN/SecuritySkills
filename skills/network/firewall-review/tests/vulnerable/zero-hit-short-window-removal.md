# Vulnerable: Zero-hit rule is removed from a short counter window

This fixture should produce unused-rule evidence findings.

## Review Context

- Firewall: `fw-prod-east`
- Policy: perimeter egress
- Rule under review: `EG-442`
- Review conclusion: "remove rule because hit count is zero"

## Bad Evidence

| Rule ID / Device | Source | Destination | Service / Port | Hit Count | Counter Baseline | Last Hit | Observation Window | Secondary Evidence | Removal Confidence |
|---|---|---|---|---|---|---|---|---|---|
| `EG-442` / `fw-prod-east` | `app-prod` | `dr-vault` | `tcp/443` | `0` | unknown, firewall failed over last week | unavailable | 7 days | none | High |

## Missing Review

- The rule supports a quarterly disaster-recovery vault sync.
- Firewall counters reset during a failover 7 days ago.
- No SIEM or flow-log search covers the previous quarter.
- No owner attestation confirms the flow is retired.
- No staged disable, change ticket, rollback plan, or monitoring window is recorded.

Expected findings:

- `FW-UNUSED-02` because counter baseline and failover history are missing or unreliable.
- `FW-UNUSED-03` because the observation window is too short for quarterly flows.
- `FW-UNUSED-04` because last-hit data is unavailable without a platform limitation rationale.
- `FW-UNUSED-05` because secondary evidence is missing.
- `FW-UNUSED-06` because a disaster-recovery flow lacks owner-approved validation.
- `FW-UNUSED-07` because High confidence is unsupported.
- `FW-UNUSED-08` because removal lacks change, rollback, and retest evidence.

Expected handling: downgrade confidence, collect flow/SIEM evidence over a business cycle, obtain owner validation, stage-disable with monitoring, and document rollback.
