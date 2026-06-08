# Benign: DNSSEC chain evidence validates parent DS against child KSK

This fixture should avoid DNSSEC chain-of-trust findings because parent, child, digest, rollover, and validation evidence are complete.

## Review Context

- Zone: `example-payments.test`
- DNS host: managed authoritative DNS
- Registrar: registry API with DNSSEC DS export
- Review timestamp: `2026-06-09T00:25:00Z`

## DNSSEC Chain-of-Trust Evidence

| Field | Evidence |
|---|---|
| Zone | `example-payments.test` |
| Review Timestamp | `2026-06-09T00:25:00Z` |
| Parent Evidence Source | `dig DS example-payments.test @parent-ns.test +dnssec` plus registrar DS export `REG-DS-2026-0609.json` |
| Parent DS | key tag `63109`, algorithm `13`, digest type `2`, digest `88BB...BEEF`, TTL `3600` |
| Child DNSKEY / KSK | DNSKEY RRset from authoritative server; KSK key tag `63109`, algorithm `13`, SEP flag set |
| Digest Match | pass; computed SHA-256 digest from child KSK equals parent DS digest |
| Rollover State | steady state; no active rollover |
| Validation Command | `delv www.example-payments.test A` and DNSViz report `dnssec-2026-0609` |
| Validation Result | secure; AD bit present from validating resolver |
| Remediation Owner / ETA | N/A |
| Recheck Timestamp | `2026-06-09T00:31:00Z` |

## Verification Notes

- Parent DS and registrar export agree on key tag, algorithm, digest type, and digest.
- Child DNSKEY key tag and algorithm match the parent DS.
- Independent validation returns secure status for `www.example-payments.test`.
- The report states that new DS evidence is required before the next KSK rollover.

Expected outcome:

- Do not flag `DNSSEC-CHAIN-01` or `DNSSEC-CHAIN-02` because parent DS evidence is recorded.
- Do not flag `DNSSEC-CHAIN-03` because child KSK DNSKEY evidence is recorded.
- Do not flag `DNSSEC-CHAIN-04` because digest comparison passes.
- Do not flag `DNSSEC-CHAIN-05` because rollover state is documented.
- Do not flag `DNSSEC-CHAIN-06` because validation output is current and secure.
- Do not flag `DNSSEC-CHAIN-07` because UI evidence is not the sole basis.
- Do not flag `DNSSEC-CHAIN-08` because no remediation is needed and recheck evidence exists.
