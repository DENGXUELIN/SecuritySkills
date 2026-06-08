# Benign: Fresh Recorded Flow with Isolated Seed Reset Evidence

## Review Target

```yaml
scan:
  tool: zap
  target_build: web-2026.06.08.4
  active_scan: true
  context: ephemeral-staging

recorded_flows:
  - name: checkout-browser-flow
    type: playwright
    recorded_at: 2026-06-08T05:40:12Z
    recorded_against_build: web-2026.06.08.4
    route_coverage_diff: no_removed_or_changed_routes
    replay_before_scan: true
    fail_on_replay_error: true
    dynamic_values:
      csrf_token: extracted_from_dom_per_request
      oauth_state: generated_per_run
      pkce_verifier: generated_per_run
      signed_urls: generated_from_fixture_api

auth_assertion:
  logged_in_regex: "data-testid=\"customer-dashboard\""
  logged_out_regex: "data-testid=\"login-form\""
  expected_role: customer
  fail_pipeline_on_mismatch: true

seed_data:
  tenant: dast-run-${RUN_ID}
  records:
    - id: cart-${RUN_ID}
      owner: dast-customer-${RUN_ID}
  create_before_scan: scripts/dast_seed_create.sh
  restore_after_scan: snapshot_restore
  cleanup_job: scripts/dast_seed_destroy.sh

roles:
  - name: customer
    user: dast-customer-${RUN_ID}
    cookie_jar: customer-context-${RUN_ID}
    browser_storage: customer-storage-${RUN_ID}
  - name: support-admin
    user: dast-support-${RUN_ID}
    cookie_jar: support-context-${RUN_ID}
    browser_storage: support-storage-${RUN_ID}

scope:
  include:
    - https://ephemeral-${RUN_ID}.example.test/.*
  exclude:
    - https://ephemeral-${RUN_ID}.example.test/logout.*
    - https://ephemeral-${RUN_ID}.example.test/account/delete.*
    - https://ephemeral-${RUN_ID}.example.test/admin/reset.*
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Flow-to-build freshness | Pass | Recording and scan target both reference `web-2026.06.08.4`, with route diff evidence. |
| Dynamic one-time values | Pass | CSRF, OAuth state, PKCE, and signed URL values are regenerated or extracted during each replay. |
| Auth state fail-closed behavior | Pass | Specific customer dashboard and login-form detectors are configured, and mismatch fails the pipeline. |
| Seed data isolation | Pass | Per-run tenant, setup script, snapshot restore, and cleanup job are documented. |
| State-changing request safety | Pass | Destructive account/admin routes are excluded and mutable checkout data is disposable. |
| Multi-role separation | Pass | Customer and support-admin roles use distinct users, cookie jars, and browser storage. |

## Reviewer Notes

This setup provides enough evidence to treat the recorded authenticated flow as current and safe for active DAST. Findings should focus on scan results instead of discounting coverage for stale recordings or contaminated seed state.
