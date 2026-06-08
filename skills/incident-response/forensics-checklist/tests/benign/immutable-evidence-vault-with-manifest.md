# Benign: Immutable evidence vault with manifest re-verification

This fixture should avoid immutable evidence storage findings because preservation, access, audit, key custody, and verification evidence are recorded.

## Incident Context

- Incident ID: IR-2026-0615
- Matter: ransomware intrusion on `app-04` and `db-02`
- Legal hold: `LH-2026-0615`, issued by counsel before collection
- Evidence destination: dedicated cloud evidence vault plus sealed offline copy

## Immutable Evidence Storage Record

| Control | Evidence |
|---|---|
| Storage location | `s3://corp-forensics-evidence/IR-2026-0615/` and sealed drive `OFF-EVD-0615-A` |
| Evidence IDs covered | `EVD-0301` through `EVD-0310` |
| Write protection | S3 Object Lock compliance mode enabled on the bucket, default retention 7 years; offline drive sealed after write-once copy |
| Retention / legal hold | Legal hold `LH-2026-0615` applied to case prefix; retention expiry `2033-06-15`; counsel approval required for release |
| Authorized custodians | `forensics-custodian-primary`, `forensics-custodian-backup`, and `legal-discovery-readonly`; no ordinary domain admins |
| Deletion protection | Lifecycle rules reviewed: no expiration or transition rule on `IR-2026-0615`; privileged delete blocked while retention is active |
| Audit logging | Object read, write, delete, retention, legal hold, and bucket policy events sent to separate log account `security-audit-archive` |
| Encryption / key custody | SSE-KMS with key `forensics-evidence-kms`; key admins are security governance, not investigated operations team |
| Verification manifest | `manifest-IR-2026-0615.sha256` signed by `forensics-custodian-primary`; hashes verified after upload, after offline copy, and before analysis |
| Exception / risk owner | N/A |

## Verification Events

| Time (UTC) | Action | Result |
|---|---|---|
| 2026-06-15T04:12:00Z | Acquisition hash computed for `EVD-0301` memory image | match recorded in custody log |
| 2026-06-15T04:27:00Z | Upload completed to locked case prefix | object version ID and retention timestamp recorded |
| 2026-06-15T04:31:00Z | Manifest re-verified from a separate custodian workstation | all hashes match |
| 2026-06-15T05:10:00Z | Offline sealed copy created and verified | all hashes match; seal ID recorded |
| 2026-06-16T09:00:00Z | Pre-analysis verification from vault download | all hashes match; analyst has read-only temporary access |

## False-Positive Boundaries

- Temporary local staging was used for 14 minutes during memory acquisition, but the staging path, hash, transfer time, and deletion of the temporary copy are documented.
- Legal counsel has read-only access, but access is named, role-based, time-bounded, and fully logged.
- The cloud bucket uses provider-managed object immutability rather than physical WORM media, which is acceptable because configuration and retention evidence are captured.

Expected outcome:

- Do not flag `FOR-IMMUT-01` because write protection and object retention are enabled before evidence upload.
- Do not flag `FOR-IMMUT-02` because retention and legal hold match the preservation directive.
- Do not flag `FOR-IMMUT-03` because custodian access is narrow and separated from investigated administrators.
- Do not flag `FOR-IMMUT-04` or `FOR-IMMUT-05` because deletion paths and storage audit logs are reviewed and protected.
- Do not flag `FOR-IMMUT-06` because encryption and key custody are documented.
- Do not flag `FOR-IMMUT-07` because hashes are re-verified after upload, after offline copy, and before analysis.
