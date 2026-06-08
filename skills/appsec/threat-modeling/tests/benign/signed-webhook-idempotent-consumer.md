# Benign: signed webhook with scoped idempotency

## Scenario

A billing system receives `invoice.paid` webhooks through a queue that uses at-least-once delivery. Cross-region failover can deliver the same event twice.

## Evidence

| Field | Value |
|-------|-------|
| producer_identity | Stripe webhook signature verified with active signing secret |
| event_id | `evt_7f3` |
| event_age | 3 minutes |
| max_event_age_policy | 15 minutes |
| idempotency_scope | `tenant_id + invoice_id + event_id + side_effect=grant-entitlement` |
| replay_cache | hit on duplicate delivery; consumer returns no-op success |
| consumer_authorization | verifies invoice belongs to tenant before granting entitlement |
| dlq_replay_approval | required for manual replay |
| original_context_preserved | yes; replay uses original tenant and invoice subject |
| side_effect | entitlement grant is applied once |

## Expected Result

The threat model should not flag duplicate delivery by itself. The producer identity is verified, event age is bounded, idempotency is scoped to the side effect, the consumer rechecks authorization, and replay preserves the original context.
