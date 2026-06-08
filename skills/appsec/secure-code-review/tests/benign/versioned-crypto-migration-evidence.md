# Benign: Versioned Crypto Migration Evidence

## Review Target

```yaml
module: billing-crypto
language: typescript
artifacts:
  encrypted_payment_token:
    envelope_format: json
    fields:
      alg: AES-256-GCM
      kid: kms-prod-payments-v4
      version: 4
      nonce: present
      aad: tenant_id:artifact_type:version
    legacy_supported:
      - version: 3
        alg: AES-256-CBC-HMAC
        expiry: 2026-07-31
        removal_ticket: SEC-4920
  password_hash:
    format: modular
    examples:
      - $argon2id$v=19$m=65536,t=3,p=2$...
    upgrade_on_login: true
    legacy_bcrypt_expiry: 2026-08-15
  signed_webhook:
    header: X-Signature
    protected_header:
      alg: hmac-sha256
      kid: webhook-signing-v3
      issued_at: present

crypto_policy:
  central_policy_file: src/security/cryptoPolicy.ts
  owner: appsec-platform
  approved_algorithms:
    encryption: AES-256-GCM
    password_hash: Argon2id
    webhook_signature: HMAC-SHA256
  deprecations:
    AES-256-CBC-HMAC: 2026-07-31
    bcrypt: 2026-08-15

migration:
  reencryption_job: scripts/reencrypt-payment-tokens.ts
  token_reissue_job: scripts/reissue-webhook-signatures.ts
  tests:
    old_format_read: test_reads_v3_envelopes
    new_format_write: test_writes_v4_envelopes
    mixed_version_data: test_mixed_v3_v4_batch
    idempotency: test_reencrypt_idempotent
    partial_failure_resume: test_reencrypt_resume_from_checkpoint
    rollback: test_policy_rollback_blocks_new_writes_only
  legacy_fallback:
    owner: appsec-platform
    expiry_date: 2026-07-31
    removal_ticket: SEC-4920
    telemetry_threshold: legacy_v3_tokens == 0 for 14 days

fail_closed_tests:
  unknown_algorithm: test_rejects_unknown_alg
  retired_key: test_rejects_retired_kid
  malformed_envelope: test_rejects_missing_version
  downgrade_attempt: test_rejects_v2_write_attempt

telemetry:
  legacy_ciphertexts_remaining: crypto_legacy_artifacts{type="payment-token",version="3"}
  password_hash_upgrade_rate: password_hash_upgrade_total
  webhook_fallback_count: webhook_signature_legacy_verify_total
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Artifact metadata | Pass | Envelopes, hashes, and signatures carry algorithm, key ID, version, and KDF metadata. |
| Central crypto policy | Pass | `src/security/cryptoPolicy.ts` owns algorithms and deprecation dates. |
| Migration path coverage | Pass | Re-encryption, token reissue, old-read, new-write, mixed-version, idempotency, resume, and rollback tests are documented. |
| Legacy compatibility window | Pass | Legacy v3 and bcrypt support have owners, expiry dates, removal tickets, and telemetry thresholds. |
| Fail-closed behavior | Pass | Unknown algorithms, retired keys, malformed envelopes, and downgrade attempts are rejected in tests. |
| Migration test fixtures | Pass | Fixtures cover old reads, new writes, mixed data, idempotency, rollback, and partial failures. |
| Legacy telemetry | Pass | Metrics track legacy ciphertexts, password upgrades, and webhook fallback use. |

## Reviewer Notes

This module has sufficient crypto agility evidence. Further review should focus on implementation correctness of the crypto wrapper and migration jobs.
