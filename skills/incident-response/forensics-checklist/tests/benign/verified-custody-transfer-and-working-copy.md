# Benign: Custody transfer and analysis copy include verification evidence

This fixture should avoid forensic custody verification findings because every transfer and analysis-copy event records hashes, authorization, tamper evidence, and copy state.

## Review Context

- Incident: `IR-2026-0609`
- Evidence: memory image `EVD-0101`
- Storage: object bucket with legal hold and object lock
- Review date: `2026-06-09`

## Custody Verification Evidence

| Evidence ID | Evidence State | Event Type | Event Time (UTC) | Released By | Received / Accessed By | Purpose | Authorization Source | Storage / Location | SHA-256 Before | SHA-256 After | Match Result | Tamper Evidence | Failure Handling | Owner / Disposition |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `EVD-0101` | Original | Collection | `2026-06-09T00:20:00Z` | responder-a | case vault | memory acquisition | `IR-2026-0609`, legal hold `LH-442` | bucket `forensics-ir`, object version `v001` | N/A | `aaaaaaaa11111111bbbbbbbb22222222cccccccc33333333dddddddd44444444` | Not Applicable | object lock compliance mode, audit `OBJ-1001` | N/A | custody lead, court-ready |
| `EVD-0101` | Original | Transfer | `2026-06-09T01:00:00Z` | case vault | forensics-b | verified analysis copy creation | ticket `IR-2026-0609-COPY` | bucket `forensics-ir`, object version `v001` | `aaaaaaaa11111111bbbbbbbb22222222cccccccc33333333dddddddd44444444` | `aaaaaaaa11111111bbbbbbbb22222222cccccccc33333333dddddddd44444444` | Match | object lock compliance mode, audit `OBJ-1009` | N/A | custody lead, court-ready |
| `EVD-0101-WC1` | Verified Working Copy | Analysis Copy | `2026-06-09T01:08:00Z` | forensics-b | analyst-c | volatile-artifact review | ticket `IR-2026-0609-ANALYSIS` | case workstation encrypted volume | `aaaaaaaa11111111bbbbbbbb22222222cccccccc33333333dddddddd44444444` | `aaaaaaaa11111111bbbbbbbb22222222cccccccc33333333dddddddd44444444` | Match | copy manifest `MAN-0101-WC1` | N/A | analyst-c, analysis copy |

## Review Notes

- Initial collection has no before-hash, which is acceptable because the immediate acquisition hash begins the chain.
- Each transfer or analysis-copy event records SHA-256 before and after the event.
- Original evidence, verified working copy, and derived output are distinguished.
- Access is tied to incident and legal-hold tickets.
- Immutable storage evidence includes object version and audit references.

Expected outcome:

- Do not flag `FOR-CUST-01` because each event is present.
- Do not flag `FOR-CUST-02` or `FOR-CUST-03` because hashes and match results are recorded.
- Do not flag `FOR-CUST-04` or `FOR-CUST-05` because authorization and tamper evidence are present.
- Do not flag `FOR-CUST-06` or `FOR-CUST-07` because original and working copy handling is clear.
- Do not flag `FOR-CUST-08` because no unresolved exception remains.
