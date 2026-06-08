# Vulnerable: Shadow SaaS and VPN-Only Private Apps

## Review Target

```yaml
zero_trust_program:
  ztna_product: deployed
  private_apps_onboarded_to_ztna: 35
  idp_sso_enabled: true
  conditional_access: enabled
  claimed_applications_maturity: Advanced

application_discovery:
  idp_catalog:
    sanctioned_saas_apps: 86
    apps_with_enterprise_sso: 61
    apps_with_local_login_disabled: 24
  ztna_inventory:
    protected_private_apps: 35
    private_apps_vpn_only: 48
    direct_internal_network_apps: 19
    owner_missing_private_apps: 22
  casb_swg_proxy_dns_30d:
    observed_saas_apps: 412
    high_risk_unsanctioned_apps: 27
    personal_storage_users: 84
    unmanaged_collaboration_users: 52
    unknown_file_sharing_users: 31
  oauth_consent_review:
    unmanaged_oauth_apps_with_data_access: 14
    high_privilege_oauth_apps_without_owner: 5
  governance:
    reconciliation_between_idp_ztna_and_discovery: missing
    shadow_saas_owner_mapping: missing
    dlp_logging_decisions: partial
    exception_register: not_maintained

examples:
  - application: personal-drive.example
    type: SaaS
    discovery_source: swg_proxy
    users_30d: 84
    data_sensitivity: high
    owner: null
    access_path: direct_saas
    idp_sso: bypass
    dlp_logging: missing
    exception_decision: none
  - application: finance-reports-internal
    type: private_app
    discovery_source: vpn_logs
    users_30d: 47
    data_sensitivity: high
    owner: finance-it
    access_path: vpn_only
    ztna_status: not_onboarded
    compensating_control: none
  - application: crm-export-helper
    type: oauth_app
    discovery_source: saas_admin_export
    data_access:
      - contacts.read
      - files.read
      - offline_access
    owner: null
    publisher_verified: false
    revocation_path: unknown
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| ZT-APP-11 | High | CASB/SWG/proxy/DNS discovery shows 412 observed SaaS apps, including high-risk apps absent from governance. |
| ZT-APP-12 | High | Sanctioned SaaS has enterprise SSO for only 61 of 86 apps and local login disabled for only 24 apps. |
| ZT-APP-13 | High | 48 private apps remain VPN-only and 19 are directly reachable after ZTNA rollout. |
| ZT-APP-14 | Medium | Shadow SaaS exceptions lack owner, expiry, DLP/logging decision, and compensating controls. |
| ZT-APP-15 | High | Unmanaged OAuth apps retain data access with no owner, publisher trust, or revocation path. |
| ZT-VIS-06 | Medium | No reconciliation exists between IdP/ZTNA inventory and CASB/SWG/proxy/DNS discovery. |

## Reviewer Notes

Do not score Applications & Workloads as Advanced based only on a deployed ZTNA product and 35 onboarded apps. Require discovered app denominator, direct-to-SaaS bypass review, OAuth consent governance, VPN-only private app disposition, and exception decisions before raising maturity.
