# Vulnerable: Stale Recorded Flow and Shared Seed Data Drift

## Review Target

```yaml
scan:
  tool: zap
  target_build: web-2026.06.08.4
  active_scan: true
  context: staging

recorded_flows:
  - name: checkout-har
    type: har
    recorded_at: 2026-05-17T10:21:33Z
    recorded_against_build: web-2026.05.17.2
    replay_before_scan: true
    fail_on_replay_error: false
    requests:
      - method: POST
        path: /oauth/callback
        body:
          state: static-state-from-har
          code_verifier: static-pkce-verifier
      - method: POST
        path: /checkout
        headers:
          x-csrf-token: csrf-2026-05-17

auth_assertion:
  logged_in_regex: "200 OK"
  expected_role: customer
  logged_out_regex: null

seed_data:
  tenant: shared-staging
  records:
    - id: shared-cart-001
      owner: qa-team
  restore_after_scan: false
  cleanup_job: none

roles:
  - name: customer
    cookie_jar: shared-browser-profile
  - name: support-admin
    cookie_jar: shared-browser-profile

scope:
  include:
    - https://staging.example.test/.*
  exclude:
    - https://staging.example.test/logout.*
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| DAST-STATE-01 | Medium | `checkout-har` predates `web-2026.06.08.4` and has no route coverage validation. |
| DAST-STATE-02 | High | The HAR replays static OAuth `state`, PKCE verifier, and CSRF token values. |
| DAST-STATE-03 | Critical | `fail_on_replay_error: false` lets the scanner continue after setup failure, and `logged_in_regex` only checks for a generic status string. |
| DAST-STATE-04 | High | Active scan mutates `shared-staging` seed data without restore, cleanup, or tenant isolation. |
| DAST-STATE-05 | High | Customer and support-admin scans reuse `shared-browser-profile`. |
| DAST-STATE-06 | High | The checkout POST remains in active-scan scope without idempotency, rollback, or disposable fixtures. |

## Reviewer Notes

This scan can report authenticated coverage while testing stale state, shared data, and a collapsed role context. Require a fresh recorded flow, dynamic token regeneration, fail-closed auth assertions, isolated seed data, and separate browser/session contexts before treating the DAST result as valid.
