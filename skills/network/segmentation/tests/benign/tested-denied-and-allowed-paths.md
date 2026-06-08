# Benign: Segmentation review records denied and allowed path validation evidence

This fixture should avoid segmentation path validation findings because representative high-risk denied paths and business-critical allowed paths are tested and documented.

## Review Context

- Environment: hybrid cloud with hub-and-spoke VPCs
- Zones: user, DMZ, app, data, management, PCI CDE
- Sampling plan: all high-risk boundaries plus critical production flows
- Review date: `2026-06-09`

## Path Validation Evidence

| Path ID | Source Zone / Asset | Destination Zone / Asset | Protocol / Port | Expected Result | Actual Result | Test Method | Evidence Reference | Timestamp / Tester | Confidence | Owner / Retest |
|---|---|---|---|---|---|---|---|---|---|---|
| PV-001 | user / `vdi-12` | PCI CDE / `cde-db-01` | tcp/1433 | Denied | Denied | `nc -vz` plus firewall deny log | FWLOG-88211 | `2026-06-09T00:30:00Z` / netsec | High | N/A |
| PV-002 | DMZ / `web-02` | data / `db-01` | tcp/5432 | Denied | Denied | packet capture and flow log | PCAP-2026-0609-02 | `2026-06-09T00:37:00Z` / netsec | High | N/A |
| PV-003 | app / `api-01` | data / `db-01` | tcp/5432 | Allowed | Allowed | `psql` health check and flow log | FLOW-77190 | `2026-06-09T00:41:00Z` / appsec | High | N/A |
| PV-004 | workload / `orders-pod` | management / `bastion-01` | tcp/22 | Denied | Denied | Cilium policy trace plus flow drop | CILIUM-TRACE-44 | `2026-06-09T00:47:00Z` / platform | Medium | N/A |
| PV-005 | app spoke / `api-01` | audit spoke / `siem-ingest` | tcp/443 | Allowed | Allowed | policy simulator plus TLS probe | SIM-551, CURL-551 | `2026-06-09T00:53:00Z` / netsec | Medium | N/A |

## Review Notes

- High-risk denied paths include user-to-CDE, DMZ-to-data, and workload-to-management.
- Allowed paths include database access and SIEM ingestion needed for production.
- Policy simulator output is paired with traffic or flow-log validation.
- Evidence includes source, destination, port, expected result, actual result, test method, timestamp, tester, and confidence.
- No unexpected results remain open; prior finding `SEG-2026-14` was retested and closed.

Expected outcome:

- Do not flag `SEG-PATH-01` through `SEG-PATH-04` because each path is repeatable and evidence-backed.
- Do not flag `SEG-PATH-05` because high-risk denied paths are sampled.
- Do not flag `SEG-PATH-06` because business-critical allowed paths are tested.
- Do not flag `SEG-PATH-07` because timestamp, tester, evidence, and confidence are recorded.
- Do not flag `SEG-PATH-08` because unexpected results have no open owner/retest gap.
