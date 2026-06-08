# Vulnerable: Weak Privileged MFA and Bypass Paths

## Review Target

```yaml
pam_platform: cyberark
idp: entra-id
privileged_paths:
  - path: pam_console_login
    required_mfa: any
    observed_method: sms_otp
    method_audit: "MFA satisfied"
  - path: vault_checkout_domain_admin
    required_mfa: none_after_login
    observed_method: inherited_idp_session
    step_up_policy: disabled
  - path: jit_activation_global_admin
    required_mfa: push
    observed_method: simple_push
    number_matching: false
    request_context: false
    push_rate_limit: none
  - path: privileged_session_launch
    required_mfa: none_after_checkout
    observed_method: inherited_pam_session
  - path: vendor_admin_access
    required_mfa: external_tenant_claim
    observed_method: unknown
    tenant_trust_reviewed: false
  - path: helpdesk_recovery
    required_mfa: knowledge_based_verification
    can_replace_factor_without_manager_approval: true
  - path: break_glass_use
    required_mfa: none
    dual_control: false
    immediate_alerting: false
    session_recording: false
    post_use_rotation: manual_next_quarter

authenticator_binding:
  fido2_available: true
  required_for_tier0_admins: false
  managed_device_binding: false

logs:
  idp_policy_result: "MFA required: satisfied"
  pam_checkout_event: "credential checked out"
  method_detail_present: false
  device_credential_id_present: false
  enforcement_point_present: false
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| PAM-MFA-01 | High | PAM console and JIT allow SMS/simple push while FIDO2 is available for Tier 0 admins. |
| PAM-MFA-02 | High | Vault checkout and session launch inherit the initial login session with no step-up. |
| PAM-MFA-03 | High | Push approval lacks number matching, request context, and rate limits. |
| PAM-MFA-04 | High | Helpdesk recovery can replace privileged factors using knowledge-based verification without manager approval. |
| PAM-MFA-05 | High | Vendor admin access relies on an unreviewed external tenant MFA claim. |
| PAM-MFA-06 | Critical | Break-glass has no MFA, no dual control, no immediate alerting, no session recording, and delayed rotation. |
| PAM-MFA-07 | Medium | Logs show only "MFA satisfied" and do not record authenticator method, device, challenge, or enforcement point. |
| PAM-MFA-08 | Medium | Phishing-resistant FIDO2 is available but not required for highest-risk roles. |

## Reviewer Notes

This environment should not pass CIS 6.5 for privileged access. Require phishing-resistant or compensated MFA at each privileged chokepoint, hardened recovery, vendor parity, controlled break-glass, and method-level audit proof before marking privileged MFA assurance complete.
