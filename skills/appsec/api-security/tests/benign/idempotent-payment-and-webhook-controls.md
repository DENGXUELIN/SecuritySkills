# Benign: Idempotent Payment and Webhook Controls

## Review Target

```yaml
api:
  style: REST + GraphQL + Webhook
  state_changing_operations:
    - operation: POST /api/v1/payments
      side_effect: create_charge
      idempotency_key_required: true
      idempotency_key_header: Idempotency-Key
      binding:
        actor: user_123
        tenant: tenant_a
        operation: create_payment
        resource: cart_456
        payload_hash: sha256:7d9c
      duplicate_detection:
        storage: payments_idempotency_ledger
        unique_constraint: tenant_id + actor_id + operation + key
        atomic: true
        cross_replica: true
        failover_safe: true
      retry_response: original_result
      replay_window: "24h"
      concurrency_test: "tests/payments/test_idempotent_double_submit.py"
      logging:
        duplicate_rejects: true
        retry_storm_alert: true
    - operation: mutation approveInvoice
      side_effect: approval_transition
      nonce_required: true
      version_check: invoice_version_compare_and_swap
      binding:
        actor: approver_id
        tenant: tenant_id
        operation: approve_invoice
        resource: invoice_id
        payload_hash: mutation_hash
      retry_response: conflict_on_version_mismatch
      concurrency_test: "tests/graphql/test_approve_invoice_race.js"
    - operation: POST /webhooks/provider
      side_effect: fulfill_order
      provider_event_id_stored: true
      event_id_store: webhook_event_ledger
      signature_timestamp_window: "5m"
      duplicate_event_behavior: return_204_noop
      queue_redelivery_dedup: true
      logging:
        replay_rejects: true

observed_evidence:
  mobile_double_tap:
    requests: 2
    charges_created: 1
    second_response: original_result
  webhook_redelivery:
    event_id: evt_999
    deliveries: 3
    fulfillments_created: 1
    duplicate_responses: noop
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Operation inventory | Pass | Payment, GraphQL approval, and webhook operations are inventoried. |
| Replay control | Pass | Payment uses idempotency key, GraphQL uses nonce/version check, webhook uses provider event ID. |
| Binding | Pass | Controls bind actor, tenant, operation, resource, and payload hash. |
| Atomicity | Pass | Payment ledger has unique constraint and is replica/failover safe. |
| Retry behavior | Pass | Payment retry returns original result; GraphQL conflict blocks stale approval. |
| Replay window | Pass | Payment window is documented and webhook timestamp window is five minutes. |
| Concurrency evidence | Pass | Payment and GraphQL race tests are referenced. |
| Logging and alerting | Pass | Duplicate rejects, replay rejects, and retry storms are logged or alerted. |

## Reviewer Notes

This evidence supports marking the idempotency/replay gate as controlled. Continue monitoring retry storm alerts and ensure idempotency keys are not reused across actors, tenants, operations, resources, or payloads.
