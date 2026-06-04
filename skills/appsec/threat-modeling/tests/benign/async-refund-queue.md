# Benign Design Sample: Async Refund Queue

## System

An ecommerce platform uses a queue to decouple refund approval from payment-provider calls. The user-facing API validates the refund request, stores an approved refund record, and publishes a minimal event for asynchronous processing.

## Queue Configuration

- Queue: `refund.approved`
- Broker: SQS FIFO queue for account-level ordering
- Producer: `refund-api` only
- Producer auth: service identity mapped to a broker policy allowing `SendMessage` only on `refund.approved`
- Consumer: `refund-worker`
- Retry policy: 5 retries with exponential backoff, then DLQ
- DLQ: `refund.approved.dlq`, encrypted with KMS, 7 day retention
- Redrive: requires on-call SRE approval, replay validation, and per-message audit log entries

## Payload

```json
{
  "messageId": "evt-91d",
  "schema": "RefundApproved.v3",
  "refundId": "r-1007",
  "idempotencyKey": "refund:r-1007:v3"
}
```

## Consumer Behavior

- The worker validates the schema version before processing.
- The worker loads tenant, amount, payment ID, and approval state from the refund database by `refundId`.
- The worker writes a durable processed-message record with the idempotency key before the payment-provider side effect.
- The payment-provider call uses the same idempotency key.
- DLQ access is limited to the on-call payment SRE group and does not include raw card data or secrets.
- Publish, consume, retry, DLQ move, and redrive events are logged with message ID, refund ID, actor, and reason.

## Expected review signal

- Safe signal: producer is allow-listed and scoped to a single queue.
- Safe signal: the message is a pointer to authoritative state, not the authorization source.
- Safe signal: idempotency and provider deduplication prevent duplicate side effects.
- Safe signal: DLQ and redrive are access-controlled, retained for a limited period, and audited.
- Non-finding: at-least-once or FIFO delivery should not be flagged by itself when idempotency and replay controls are documented.
