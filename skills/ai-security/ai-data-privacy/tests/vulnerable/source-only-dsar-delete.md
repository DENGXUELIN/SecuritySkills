# Vulnerable: DSAR closed after source deletion while AI-derived stores retain personal data

This fixture should produce DSAR deletion propagation findings.

## System Context

- Product: support assistant with RAG and fine-tuning experiments
- Request ID: `DSAR-2026-0616-144`
- Request type: GDPR erasure request
- Subject: customer `cust_4817`, email `alex.rivera@example.test`
- SLA due date: `2026-06-30`
- Source systems: customer profile table, support ticket system, document store

## Claimed Completion

The privacy ticket was closed after the application deleted `cust_4817` from the customer profile table and removed the visible support ticket. The completion note says "user deleted from app database."

## Residual AI Stores

| Store | Residual Data |
|---|---|
| Vector database | chunks from ticket `SUP-88210` still retrievable by email and account ID metadata |
| Prompt logs | 18 prompt/completion rows include the subject email and billing dispute text |
| Analytics events | raw event export contains `cust_4817` and support-ticket category |
| Fine-tuning snapshot | `sft-support-2026-05.jsonl` includes the support ticket transcript |
| Evaluation dataset | regression test `rag-support-eval-42` includes the same ticket chunk |
| Cache | retrieval cache key `ticket:SUP-88210` returns the deleted text for 7 days |
| Backups | restore runbook has no purge step for erased subjects |

## Control Gaps

- Request tracking does not record verified identity, data scope, regulatory basis, or linked AI stores.
- No source-to-derived data map exists for prompts, embeddings, datasets, caches, or backups.
- Vector IDs were not deleted or tombstoned.
- The fine-tuning snapshot and evaluation data keep full personal data with no exception owner.
- There is no post-delete query proving the subject data is absent.
- No tombstone or blocklist prevents the source connector from re-embedding the restored ticket.
- SLA status is marked complete even though derived stores still contain personal data.

Expected findings:

- `DSAR-DEL-01` because request tracking lacks scope and completion evidence.
- `DSAR-DEL-02` because the source-to-derived AI data map is missing.
- `DSAR-DEL-03` and `DSAR-DEL-04` because vector chunks and metadata remain retrievable.
- `DSAR-DEL-05` because fine-tuning, evaluation, and analytics copies remain.
- `DSAR-DEL-06` because backup restore can reintroduce erased data.
- `DSAR-DEL-07` because post-delete verification evidence is missing.
- `DSAR-DEL-08` because no re-ingestion guard exists.
- `DSAR-DEL-09` because partial deletion is marked complete with no exception owner.

Expected handling: reopen the request, map all derived stores, purge or tombstone vector and cache data, remove or exception-own datasets, add restore-time purge controls, run verification queries, and close only after SLA and exception evidence are recorded.
