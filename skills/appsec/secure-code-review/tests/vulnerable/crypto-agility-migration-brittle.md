# Vulnerable: Brittle Crypto Migration

## Review Target

```yaml
module: billing-crypto
language: typescript
artifacts:
  encrypted_payment_token:
    storage_column: payment_tokens.ciphertext
    envelope_format: raw_base64_ciphertext
    algorithm_metadata: absent
    key_id_metadata: absent
    key_version_metadata: absent
    current_algorithm: aes-256-gcm
    legacy_algorithm: aes-128-cbc
    decrypt_logic: try_current_then_try_legacy
  password_hash:
    format: hex_digest
    algorithm_metadata: absent
    current_algorithm: argon2id
    legacy_algorithm: sha256
    upgrade_on_login: false
  signed_webhook:
    header: X-Signature
    key_id: absent
    algorithm: hmac-sha256
    fallback_accepts_sha1: true

crypto_policy:
  central_policy_file: none
  hard_coded_constants:
    - src/crypto/payment.ts:AES_MODE
    - src/auth/passwords.ts:HASH_ALG
    - src/webhooks/verify.ts:ALLOW_SHA1

migration:
  reencryption_job: scripts/reencrypt-payment-tokens.ts
  tests:
    old_format_read: missing
    new_format_write: present
    mixed_version_data: missing
    idempotency: missing
    partial_failure_resume: missing
    rollback: missing
  legacy_fallback:
    owner: none
    expiry_date: none
    removal_ticket: none
    telemetry_threshold: none

fail_closed_tests:
  unknown_algorithm: missing
  retired_key: missing
  malformed_envelope: missing
  downgrade_attempt: missing

telemetry:
  legacy_ciphertexts_remaining: unknown
  sha256_passwords_remaining: unknown
  sha1_webhook_fallback_count: unknown
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| SCR-CRYPTO-AGILITY-01 | High | Payment tokens and password hashes lack algorithm, key ID, version, or KDF metadata. |
| SCR-CRYPTO-AGILITY-02 | Medium | Crypto settings are scattered across hard-coded constants instead of a versioned policy layer. |
| SCR-CRYPTO-AGILITY-03 | High | Re-encryption exists but lacks old-read, mixed-version, idempotency, rollback, and partial-failure tests. |
| SCR-CRYPTO-AGILITY-04 | High | Legacy AES-CBC, SHA-256 password, and SHA-1 webhook fallback paths have no owner, expiry, or removal ticket. |
| SCR-CRYPTO-AGILITY-05 | High | Unknown algorithms, retired keys, malformed envelopes, and downgrade attempts have no fail-closed tests. |
| SCR-CRYPTO-AGILITY-06 | Medium | Migration fixtures cover only the new-format happy path. |
| SCR-CRYPTO-AGILITY-07 | Medium | Legacy artifact and fallback-use telemetry is unknown. |

## Reviewer Notes

This module may use acceptable current primitives, but it is not migration-ready. Require versioned envelopes, central policy, complete migration fixtures, fail-closed behavior, and telemetry before accepting a crypto migration plan.
