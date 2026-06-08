# Vulnerable: Stale Human-Owned Automation Credentials

## Review Target

```yaml
access_review:
  campaign: Q2 production access certification
  review_period: 2026-04-01 to 2026-06-30
  identity_population:
    human_users: 412
    service_accounts: 37
    nonhuman_credentials_in_population: false

service_account:
  id: svc-ci-deploy
  owner: Platform Team
  backup_owner: null
  certification_decision: approved
  systems:
    - production deploy pipeline
    - payments-api repository
  entitlements:
    - deploy:production
    - repo:write

credentials:
  - id: ci-prod-deploy-token
    type: personal_access_token
    human_owner: alice@example.com
    owner_status: departed_contractor
    system: production deploy pipeline
    scope:
      repo: "*"
      environment: "*"
      actions:
        - repo:write
        - workflow:admin
        - deploy:production
    created: 2024-01-15
    last_used: 2026-05-29
    last_rotated: unknown
    expires: never
    storage: CI variable copied from old incident ticket
    approved_secret_manager_reference: null
    approval_ticket: null
    emergency_revocation_runbook: missing

  - id: vendor-fulfillment-oauth
    type: oauth_grant
    owner: former_project_owner@example.com
    owner_status: transferred_to_other_team
    vendor_status: offboarded
    project_status: shut_down
    scopes:
      - orders.read
      - orders.write
      - customers.read
    tenant_constraint: none
    created: 2023-08-02
    last_used: 2025-11-18
    last_rotated: never
    expires: never
    storage: SaaS native secret field, not inventoried
    approval_ticket: closed-without-revocation

  - id: payments-webhook-secret
    type: webhook_secret
    owner: Payments Ops
    backup_owner: null
    endpoint: https://payments.example.test/webhooks/provider
    created: 2023-03-10
    last_rotated: never
    expires: never
    storage: wiki page visible to engineering group
    signing_algorithm: hmac-sha256
    emergency_revocation_runbook: owner-dependent

observed_review_evidence:
  certifier_notes: "Service account has Platform Team owner; approved."
  credential_level_rows: []
  secret_storage_export: not_requested
  rotation_evidence_export: not_requested
  last_used_export: not_requested
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| AR-SCOPE-07 | High | API keys, PATs, OAuth grants, webhook secrets, and CI/CD tokens were excluded from the review population. |
| AR-NHI-01 | High | Credential inventory is empty even though production automation uses PAT, OAuth, and webhook credentials. |
| AR-NHI-02 | Medium | `svc-ci-deploy`, `ci-prod-deploy-token`, and `payments-webhook-secret` lack named backup owners. |
| AR-NHI-03 | Critical | `ci-prod-deploy-token` has wildcard repository and environment scope with workflow admin and production deploy rights. |
| AR-NHI-04 | Critical | Production credentials have unknown or never rotation evidence and no expiry. |
| AR-NHI-06 | Critical | Production automation depends on a departed contractor's personal access token. |
| AR-NHI-07 | High | Secrets are copied from an incident ticket or stored on a wiki instead of an approved secrets manager. |
| AR-NHI-08 | High | Emergency revocation is missing or dependent on a single owner. |
| AR-NHI-09 | Medium | Offboarded vendor OAuth grant remains active after project shutdown. |

## Reviewer Notes

Do not mark the service account as clean because a team owner approved it. Require credential-level review rows, rotation or revocation of the human-owned PAT, OAuth grant cleanup, migration to approved secret storage, and a tested emergency revocation path before certification.
