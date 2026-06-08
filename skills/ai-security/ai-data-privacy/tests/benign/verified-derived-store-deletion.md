# Benign: Verified deletion propagation across active AI stores

This fixture should avoid DSAR deletion propagation findings because active AI stores are mapped, purged, verified, and protected against re-ingestion.

## System Context

- Product: support assistant with RAG
- Request ID: `DSAR-2026-0617-082`
- Request type: CCPA delete request and consent withdrawal
- Subject: customer `cust_5022`, email `morgan.lee@example.test`
- SLA due date: `2026-07-01`
- Owner: privacy engineering

## Deletion Propagation Evidence

| Field | Evidence |
|---|---|
| Subject scope | customer profile `cust_5022`, support tickets `SUP-90110` and `SUP-90144`, document IDs `doc_77` and `doc_81` |
| Regulatory basis | CCPA delete request plus withdrawal of AI training consent |
| Source stores | customer profile, support ticket DB, document store |
| Derived AI stores | prompt logs, vector DB, vector metadata, RAG chunks, retrieval cache, analytics export, SFT candidate dataset, backup catalogue |
| Propagation actions | source delete, vector chunk tombstone, prompt-log token redaction, cache purge, analytics unlinking, SFT candidate row removal, backup restore-time purge marker |
| Verification evidence | vector query by email/account/doc IDs returned zero active chunks; prompt-log search returned only redacted audit rows; SFT dataset hash changed after row removal |
| Exceptions / holds | immutable backup retained until 30-day expiry; restore runbook applies purge marker before service recovery |
| Re-ingestion guard | subject tombstone `privacy_tombstone_5022` blocks source connector, embedding job, and dataset export |
| SLA status | met; closed after verification on `2026-06-20` |

## Verification Queries

| Query | Result |
|---|---|
| vector metadata search for `cust_5022` | zero active chunks, two tombstone records |
| full-text search for `morgan.lee@example.test` in prompt logs | zero raw hits, one redacted audit reference |
| SFT candidate dataset scan for support ticket IDs | zero rows after removal |
| retrieval cache lookup for document IDs | cache miss after purge |
| source connector dry run | skipped tombstoned IDs and wrote audit event `privacy-skip-5022` |

Expected outcome:

- Do not flag `DSAR-DEL-01` because request tracking includes scope, basis, owner, SLA, and completion evidence.
- Do not flag `DSAR-DEL-02` because source and derived AI stores are mapped.
- Do not flag `DSAR-DEL-03` through `DSAR-DEL-05` because active derived stores are purged, tombstoned, redacted, unlinked, or removed.
- Do not flag `DSAR-DEL-06` because backup retention and restore-time purge controls are documented.
- Do not flag `DSAR-DEL-07` because verification queries are tied to the request.
- Do not flag `DSAR-DEL-08` because tombstones block re-ingestion.
- Do not flag `DSAR-DEL-09` because SLA and exception handling are recorded.
