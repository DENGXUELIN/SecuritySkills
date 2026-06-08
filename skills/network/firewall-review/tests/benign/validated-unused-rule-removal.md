# Benign: Unused rule removal is supported by counter baseline and secondary evidence

This fixture should avoid unused-rule evidence findings because removal confidence is backed by a reliable counter window, secondary evidence, and owner-approved staged disable.

## Review Context

- Firewall: `fw-prod-west`
- Policy: internal east-west
- Rule under review: `EW-118`
- Review date: `2026-06-09`

## Unused Rule Evidence

| Rule ID / Device | Direction | Source | Destination | Service / Port | Hit Count / Source | Counter Baseline | Last Hit | Observation Window | Secondary Evidence | Business Criticality | Removal Confidence | Change / Rollback |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `EW-118` / `fw-prod-west` | east-west | `legacy-app-subnet` | `retired-db-subnet` | `tcp/1521` | `0`, firewall policy counter export `FWCNT-2026-0609` | counters reset at policy install `2026-02-01T00:00:00Z`; no failover since | never | 128 days covering month-end and quarter-end | SIEM query `SIEM-771`, VPC flow logs `FLOW-884`, CMDB retired asset `CMDB-991`, owner approval `CHG-5501` | none, application retired | High, counter and independent logs agree | staged disable `CHG-5502`, rollback within 30 minutes, retest `2026-06-16` |

## Review Notes

- Counter baseline is known and covers more than one business cycle.
- Last-hit status and platform source are documented.
- Flow logs, SIEM query, CMDB, and owner approval support retirement.
- Staged disable and rollback plan are recorded before permanent removal.

Expected outcome:

- Do not flag `FW-UNUSED-01` because rule identity and scope are present.
- Do not flag `FW-UNUSED-02` through `FW-UNUSED-04` because counter baseline, last-hit status, and observation window are documented.
- Do not flag `FW-UNUSED-05` because independent secondary evidence is present.
- Do not flag `FW-UNUSED-06` because no critical/scheduled flow remains.
- Do not flag `FW-UNUSED-07` or `FW-UNUSED-08` because confidence, change, rollback, and retest are recorded.
