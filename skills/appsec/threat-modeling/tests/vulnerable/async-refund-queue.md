# Vulnerable Design Sample: Async Refund Queue

## System

An ecommerce platform accepts refund approvals from the checkout API, partner webhooks, and a support console. Each producer publishes JSON messages to the `refund.approved` queue. The `refund-worker` consumes the message and calls the payment provider.

## Queue Configuration

- Queue: `refund.approved`
- Broker: SQS standard queue with at-least-once delivery
- Producers: `checkout-api`, `partner-webhook`, `support-console`
- Producer auth: shared broker credential with `sqs:SendMessage` on all `refund.*` queues
- Consumer: `refund-worker`
- Retry policy: immediate retry, max receive count 1, then DLQ
- DLQ: `refund.approved.dlq`, 14 day retention
- Redrive: support users can bulk redrive all DLQ messages to production

## Payload

```json
{
  "messageId": "evt-91d",
  "tenantId": "tenant-a",
  "refundId": "r-1007",
  "paymentId": "pay-778",
  "amount": 49900,
  "approvedByRole": "finance_admin",
  "customerEmail": "customer@example.test",
  "last4": "4242"
}
```

## Consumer Behavior

- The worker trusts `tenantId`, `amount`, and `approvedByRole` from the message.
- The worker calls `issueRefund(paymentId, amount)` before writing a durable processed-message record.
- Duplicate messages can repeat the refund when the provider retry succeeds after the worker times out.
- The worker does not reload the refund approval from the database.
- DLQ messages include customer email and card metadata and are readable by the support team.
- Redrive events are logged only as `support redrove refund queue`; no per-message IDs are captured.

## Expected review signal

- Finding: weak producer authorization because unrelated services and support tooling can publish trusted refund events.
- Finding: payload authority is trusted for tenant, role, and amount instead of being revalidated against authoritative refund state.
- Finding: non-idempotent side effect can repeat on at-least-once delivery or manual redrive.
- Finding: DLQ retains sensitive payload fields with broad support access.
- Finding: redrive lacks approval, validation, and per-message auditability.
