# Vulnerable: Custody log records names but omits per-event verification

This fixture should produce forensic custody verification findings.

## Review Context

- Incident: `IR-2026-0609`
- Evidence: disk image `EVD-0042`
- Report conclusion: "chain of custody complete"
- Custody artifact: spreadsheet with collector, analyst, timestamps, and storage path

## Bad Custody Record

| Evidence ID | Date/Time (UTC) | Released By | Received By | Purpose | Location |
|---|---|---|---|---|---|
| `EVD-0042` | `2026-06-09T01:10:00Z` | responder-a | forensics-b | analysis | shared evidence folder |
| `EVD-0042` | `2026-06-09T04:30:00Z` | forensics-b | analyst-c | malware review | analyst workstation |

## Missing Verification

- No SHA-256 before or after either transfer.
- No match result or failure handling exists.
- No ticket, legal hold, or manager approval authorizes analyst access.
- Storage is a mutable shared folder with no object lock, WORM retention, seal number, or audit reference.
- The analyst opens the original disk image directly instead of creating a verified working copy.
- Derived malware strings are later copied into the evidence folder without being marked as derived output.

Expected findings:

- `FOR-CUST-01` because access and analysis-copy events are missing from the verification record.
- `FOR-CUST-02` because before/after hashes are missing.
- `FOR-CUST-03` because match result and failure handling are missing.
- `FOR-CUST-04` because authorization source is missing.
- `FOR-CUST-05` because tamper evidence and immutable storage controls are missing.
- `FOR-CUST-06` because original, working copy, and derived output are not distinguished.
- `FOR-CUST-07` because analysis is performed on original evidence.
- `FOR-CUST-08` because exceptions have no owner, disposition, or court-readiness status.

Expected handling: quarantine the evidence chain as incomplete, re-verify hashes where possible, move originals to immutable storage, create a verified working copy, and document authorization and disposition.
