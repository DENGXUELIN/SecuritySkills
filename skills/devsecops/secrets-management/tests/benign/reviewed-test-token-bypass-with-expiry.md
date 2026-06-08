# Benign Fixture: Reviewed Test Token Bypass With Expiry

## Scenario

A test fixture intentionally contains a fake token-shaped value so scanners can validate detection behavior. Push protection was bypassed, but the bypass is independently reviewed, narrowly scoped, and time-bounded.

## Evidence

```yaml
repository: security-fixtures
push_protection:
  enabled: true
  protected_branches:
    - main
audit_log:
  event: secret_scanning_push_protection_bypass
  actor: security-engineer
  reviewer: appsec-lead
  bypass_reason: used_in_tests
  token_type: github_pat_pattern
  commit: 12ab45c
  alert: SECRET-5001
  created_at: 2026-06-03T14:22:00Z
fixture_metadata:
  file: tests/fixtures/fake-github-token.txt
  value_classification: synthetic-placeholder
  provider_lookup: not issued
  entropy_reason: deterministic scanner fixture
allowlist_entry:
  scope: tests/fixtures/fake-github-token.txt
  expires: 2026-07-01
  owner: appsec-lead
  review_ticket: SEC-8821
rotation_evidence:
  required: false
  reason: provider lookup confirms value was never issued
```

## Expected Assessment

- Do not flag a real secret exposure when evidence proves the value is synthetic and never issued.
- Record the bypass as reviewed and low residual risk.
- Verify the allowlist is path-scoped, owned, and expiring.
- Keep the token-shaped fixture value out of the final report.
