# Benign: Governed Non-Human Credential Review

## Review Target

```yaml
access_review:
  campaign: Q2 production access certification
  review_period: 2026-04-01 to 2026-06-30
  identity_population:
    human_users: 412
    service_accounts: 37
    nonhuman_credentials_in_population: true
    nonhuman_credentials_reviewed: 94

service_account:
  id: svc-ci-deploy
  owner: platform-release-owner@example.com
  backup_owner: platform-release-backup@example.com
  certification_decision: approved_with_evidence
  systems:
    - production deploy pipeline
    - payments-api repository
  entitlements:
    - deploy:payments-production

credentials:
  - id: ci-prod-deploy-token-2026q2
    type: ci_cd_token
    owner: platform-release-owner@example.com
    backup_owner: platform-release-backup@example.com
    system: production deploy pipeline
    business_process: approved release deployment
    scope:
      repositories:
        - payments-api
      environments:
        - production
      actions:
        - deploy
      ip_constraints:
        - 203.0.113.10/32
    created: 2026-04-01
    last_used: 2026-06-06
    last_rotated: 2026-04-01
    expires: 2026-07-01
    storage: vault://prod/platform/ci-prod-deploy-token-2026q2
    approval_ticket: IAM-4621
    emergency_revocation_runbook: RUNBOOK-DEPLOY-TOKEN-REVOKE
    revocation_tested: 2026-05-12

  - id: vendor-fulfillment-oauth-2026q2
    type: oauth_grant
    owner: vendor-access-owner@example.com
    backup_owner: platform-release-backup@example.com
    vendor_status: active_contract
    contract_reference: SOW-2026-014
    system: fulfillment integration
    scopes:
      - orders.read
    tenant_constraint: tenant-prod-payments
    created: 2026-04-04
    last_used: 2026-06-05
    last_rotated: 2026-04-04
    expires: 2026-07-04
    storage: saas_managed_secret_reference:fulfillment-prod-oauth
    approval_ticket: IAM-4633
    offboarding_control: vendor-access-quarterly-check

  - id: payments-webhook-secret-2026q2
    type: webhook_secret
    owner: payments-ops-owner@example.com
    backup_owner: platform-release-backup@example.com
    endpoint: https://payments.example.test/webhooks/provider
    event_types:
      - payment.succeeded
      - payment.failed
    created: 2026-04-01
    last_rotated: 2026-04-01
    expires: 2026-07-01
    storage: vault://prod/payments/provider-webhook-secret
    signing_algorithm: hmac-sha256
    emergency_revocation_runbook: RUNBOOK-WEBHOOK-SECRET-ROTATE
    revocation_tested: 2026-05-20

observed_review_evidence:
  credential_level_rows:
    - ci-prod-deploy-token-2026q2
    - vendor-fulfillment-oauth-2026q2
    - payments-webhook-secret-2026q2
  no_human_pat_for_production_automation: true
  stale_vendor_grants: 0
  credentials_missing_expiry: 0
  credentials_outside_approved_storage: 0
  revocation_runbooks_tested: true
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Review population | Pass | Non-human credentials are included in the certification campaign. |
| Owner and backup owner | Pass | Every credential has named primary and backup owners. |
| Scope constraint | Pass | CI/CD token is limited to one repository, production deploy action, and approved runner IP. |
| Lifecycle evidence | Pass | Credentials show created, last-used, last-rotated, and expiry dates. |
| Secret storage | Pass | Secrets reference Vault or managed SaaS secret storage without exposing secret values. |
| Approval evidence | Pass | Each credential has an IAM ticket, contract/SOW, or access approval. |
| Revocation path | Pass | Runbooks exist and revocation tests were completed during the review period. |
| Human-owned automation | Pass | Production automation does not depend on human PATs or deploy keys. |
| Third-party offboarding | Pass | OAuth grant is tied to an active contract and quarterly offboarding control. |

## Reviewer Notes

This evidence supports certifying the non-human credential gate as controlled. Keep the quarterly review cadence, ensure expired credentials fail closed, and preserve credential-level rows without storing secret values in the report.
