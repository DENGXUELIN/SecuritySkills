# Vulnerable: DLQ replay drops original context

## Scenario

An order service consumes signed `refund.requested` events from a queue. Failed messages are moved to a dead-letter queue and replayed by an operations console after parser bugs are fixed.

## Evidence

| Field | Value |
|-------|-------|
| producer_identity | `payments-service` queue IAM principal |
| event_id | `evt_refund_7f3` |
| event_age | 19 days |
| max_event_age_policy | not documented |
| idempotency_scope | `refund_id` only, not bound to tenant/account/action |
| replay_cache | disabled for DLQ replay |
| dlq_replay_actor | `ops-admin@example.com` |
| dlq_replay_approval | none |
| original_context_preserved | no; replay runs with operations admin tenant bypass |
| side_effect | refund is issued again and entitlement is reopened |

## Expected Result

The threat model should flag this as an asynchronous replay and elevation-of-privilege risk. A poisoned or stale DLQ message can repeat an irreversible refund under an operator context that is broader than the original producer or tenant context.

## Required Mitigation

Require max event age, scoped idempotency, replay-cache checks during DLQ recovery, explicit replay approval, immutable audit logging, and preservation of the original actor/tenant/resource context before side effects.
