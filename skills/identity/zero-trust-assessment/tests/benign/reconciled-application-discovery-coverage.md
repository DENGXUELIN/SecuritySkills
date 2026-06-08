# Benign: Reconciled Application Discovery Coverage

## Review Target

```yaml
zero_trust_program:
  ztna_product: deployed
  idp_sso_enabled: true
  conditional_access: enabled
  application_maturity_claim: Advanced

application_discovery:
  review_period: 2026-05-01 to 2026-05-31
  sources:
    - idp_application_catalog
    - ztna_private_app_inventory
    - casb_discovery_export
    - swg_proxy_logs
    - dns_query_logs
    - firewall_egress_logs
    - saas_admin_oauth_export
  reconciliation:
    observed_saas_apps_30d: 418
    sanctioned_saas_apps: 103
    sanctioned_apps_with_sso: 101
    sanctioned_apps_with_local_login_disabled_or_monitored: 103
    high_risk_unsanctioned_apps: 3
    high_risk_unsanctioned_disposition:
      blocked: 2
      risk_accepted: 1
    private_apps_total: 126
    ztna_protected_private_apps: 119
    enclave_gateway_private_apps: 7
    vpn_only_private_apps: 0
    unmanaged_oauth_apps_with_data_access: 0

coverage_matrix:
  - application: enterprise-drive.example
    type: SaaS
    discovery_source:
      - idp_application_catalog
      - casb_discovery_export
      - swg_proxy_logs
    owner: collaboration-platform-owner@example.com
    data_sensitivity: high
    access_path: enterprise_sso
    idp_sso: enforced
    local_login: disabled
    pep_ztna: conditional_access_policy_ca-221
    logging_dlp: casb_dlp_policy_drive-high
    exception_decision: none
    status: covered
  - application: legacy-payroll-internal
    type: private_app
    discovery_source:
      - ztna_private_app_inventory
      - firewall_egress_logs
    owner: payroll-platform-owner@example.com
    data_sensitivity: high
    access_path: enclave_gateway
    idp_sso: enforced
    pep_ztna: enclave-gateway-payroll
    logging_dlp: siem:index=ztna-payroll
    exception_decision: compensating_control_until_2026-08-31
    status: covered_with_time_bound_exception
  - application: vendor-whiteboard.example
    type: SaaS
    discovery_source:
      - swg_proxy_logs
      - dns_query_logs
    owner: architecture-team-owner@example.com
    data_sensitivity: low
    access_path: direct_saas
    idp_sso: not_supported
    pep_ztna: swg_category_policy
    logging_dlp: swg_log_and_upload_block
    exception_decision: accepted_until_2026-06-30
    status: accepted_low_risk_exception

oauth_consent_review:
  unmanaged_high_privilege_oauth_apps: 0
  third_party_apps_reviewed: 42
  apps_revoked_this_cycle: 6
  publisher_trust_verified: true
  revocation_runbook: IAM-OAUTH-REVOKE
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Discovery sources | Pass | IdP, ZTNA, CASB, SWG, DNS, firewall, and SaaS OAuth exports are included. |
| Inventory reconciliation | Pass | Observed SaaS, sanctioned SaaS, private app, and OAuth app denominators are documented. |
| Direct-to-SaaS bypass | Pass | Sanctioned apps have SSO enforced and local login disabled or monitored. |
| Private app ZTNA coverage | Pass | All private apps are protected by ZTNA or enclave gateway; none remain VPN-only. |
| Shadow SaaS disposition | Pass | High-risk unsanctioned apps are blocked or risk accepted with owner and expiry. |
| OAuth consent governance | Pass | Third-party OAuth apps are reviewed, revoked when needed, and tied to a revocation runbook. |
| Logging and DLP | Pass | CASB/SWG/DLP/SIEM coverage is recorded per app or exception. |

## Reviewer Notes

This evidence can support an Advanced Applications & Workloads maturity score if other application security capabilities also meet the stage criteria. Keep the discovered app denominator current and expire accepted exceptions on schedule.
