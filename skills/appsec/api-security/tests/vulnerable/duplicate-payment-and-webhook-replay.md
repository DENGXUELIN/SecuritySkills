# Vulnerable: Duplicate Payment and Webhook Replay

## Review Target

```yaml
api:
  style: REST + Webhook
  state_changing_operations:
    - operation: POST /api/v1/payments
      side_effect: create_charge
      idempotency_key_required: false
      event_id_required: false
      nonce_required: false
      binding:
        actor: false
        tenant: false
        operation: false
        resource: false
        payload_hash: false
      duplicate_detection:
        storage: none
        atomic: false
        cross_replica: false
        failover_safe: false
      retry_response: creates_new_charge
      replay_window: none
      concurrency_test: missing
      logging:
        duplicate_rejects: false
        retry_storm_alert: false
    - operation: POST /webhooks/provider
      side_effect: fulfill_order
      provider_event_id_stored: false
      signature_timestamp_window: "24h"
      duplicate_event_behavior: fulfill_again
      queue_redelivery_dedup: false
      logging:
        replay_rejects: false

observed_evidence:
  mobile_double_tap:
    requests: 2
    charges_created: 2
    same_user: user_123
    same_cart: cart_456
  webhook_redelivery:
    event_id: evt_999
    deliveries: 3
    fulfillments_created: 3
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| API-REPLAY-01 | High | Payment operation lacks idempotency key, event ID, nonce, version check, or equivalent duplicate control. |
| API-REPLAY-02 | High | No replay control is bound to actor, tenant, operation, resource, or payload hash. |
| API-REPLAY-03 | High | Duplicate detection has no durable atomic storage and is not safe across replicas or failover. |
| API-REPLAY-04 | High | Retrying the payment creates a second charge instead of original result, conflict, or reject. |
| API-REPLAY-05 | High | Webhook handler accepts the same provider event ID and fulfills the order repeatedly. |
| API-REPLAY-06 | Medium | Signature timestamp replay window is 24 hours with no event-ID deduplication. |
| API-REPLAY-07 | High | Payment and fulfillment paths lack concurrency or transaction evidence. |
| API-REPLAY-08 | Medium | Duplicate/replay rejects and retry storms are not logged or alerted. |

## Reviewer Notes

This should be reported under API6 for duplicate business actions and API4 where redelivery can exhaust downstream resources. Require a durable idempotency ledger, event-ID store, actor/tenant/payload binding, bounded replay windows, and retry-safe responses.
