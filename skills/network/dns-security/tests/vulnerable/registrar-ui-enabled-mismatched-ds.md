# Vulnerable: Registrar UI says DNSSEC enabled but parent DS mismatches child KSK

This fixture should produce DNSSEC chain-of-trust findings.

## Review Context

- Zone: `example-payments.test`
- DNS host: managed authoritative DNS
- Registrar UI: "DNSSEC enabled"
- Assessor conclusion before validation: "DNSSEC in place"
- Review timestamp: `2026-06-09T00:20:00Z`

## Evidence Collected

| Source | Evidence |
|---|---|
| Registrar UI | DNSSEC toggle enabled, no export of active DS RRset |
| Parent query | `example-payments.test. 3600 IN DS 45712 8 2 11AA...DEAD` |
| Child DNSKEY | KSK key tag `63109`, algorithm `13`, public key from authoritative DNSKEY RRset |
| Computed digest | digest type `2`, digest `88BB...BEEF` |
| Validation command | `dig +dnssec www.example-payments.test A @1.1.1.1` |
| Validation result | `SERVFAIL`; no AD bit |

## Gaps

- The review records only "DNSSEC enabled" from the UI.
- Parent DS key tag `45712` does not match child KSK key tag `63109`.
- Parent DS algorithm `8` does not match child KSK algorithm `13`.
- Parent DS digest does not match the computed child KSK digest.
- Rollover state is not documented; no planned overlap window explains the mismatch.
- No registrar ticket, remediation owner, or recheck timestamp is recorded.

Expected findings:

- `DNSSEC-CHAIN-01` because active registrar/parent evidence is incomplete.
- `DNSSEC-CHAIN-02` because parent DS values were not recorded in the original review.
- `DNSSEC-CHAIN-03` because child KSK DNSKEY evidence was not tied to the parent DS.
- `DNSSEC-CHAIN-04` because the DS digest and key tag mismatch the child KSK.
- `DNSSEC-CHAIN-05` because rollover state is unknown.
- `DNSSEC-CHAIN-06` because validation output shows failure and was not used.
- `DNSSEC-CHAIN-07` because UI-enabled DNSSEC is accepted while the chain is broken.
- `DNSSEC-CHAIN-08` because remediation owner and recheck timestamp are missing.

Expected handling: mark the DNSSEC chain as broken/critical, update parent DS through the registrar or registry path, document rollover state, and recheck with parent DS query plus validating resolver output.
