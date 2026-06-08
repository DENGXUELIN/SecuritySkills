# Benign: Phishing-Resistant Privileged MFA Evidence

## Review Target

```yaml
pam_platform: delinea
idp: entra-id
privileged_paths:
  - path: pam_console_login
    required_mfa: phishing_resistant
    observed_method: fido2_security_key
    method_audit: method=fido2 credential_id=cred-admin-01 device=managed-admin-laptop
  - path: vault_checkout_domain_admin
    required_mfa: step_up_fido2
    observed_method: fido2_security_key
    step_up_policy: checkout_policy_tier0
  - path: jit_activation_global_admin
    required_mfa: fido2_with_justification
    observed_method: fido2_security_key
    approval_ticket: CHG-8042
  - path: privileged_session_launch
    required_mfa: session_launch_step_up
    observed_method: fido2_security_key
    session_recording: enabled
  - path: vendor_admin_access
    required_mfa: pam_brokered_fido2
    observed_method: fido2_security_key
    tenant_trust_reviewed: true
    vendor_contract: MSP-2026-17
  - path: helpdesk_recovery
    required_mfa: dual_approval_identity_proofing
    can_replace_factor_without_manager_approval: false
    post_recovery_privileged_hold: 24h
  - path: break_glass_use
    required_mfa: sealed_fido2_plus_dual_control
    dual_control: true
    immediate_alerting: true
    session_recording: enabled
    post_use_rotation: immediate
    follow_up_review: BG-REVIEW-2026-06

authenticator_binding:
  fido2_available: true
  required_for_tier0_admins: true
  managed_device_binding: true
  exception_expiry_days: 7

logs:
  idp_policy_result: "phishing-resistant MFA satisfied"
  pam_checkout_event: "checkout step-up completed"
  method_detail_present: true
  device_credential_id_present: true
  enforcement_point_present: true
  session_id: pam-session-2026-06-08-001
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Method strength by admin path | Pass | PAM login, vault checkout, JIT activation, session launch, vendor access, and break-glass require FIDO2 or sealed FIDO2 with compensating controls. |
| Step-up enforcement point | Pass | Checkout, activation, and session launch all require step-up at the sensitive action. |
| Push fatigue resistance | Pass | Push is not used for Tier 0 privileged paths. |
| Authenticator and device binding | Pass | FIDO2 credential IDs are tied to managed admin devices. |
| Recovery and re-enrollment assurance | Pass | Factor replacement requires dual approval and imposes a privileged hold. |
| External and vendor parity | Pass | Vendor admins use PAM-brokered FIDO2 and a reviewed contract. |
| Break-glass exception control | Pass | Break-glass requires dual control, immediate alerting, session recording, immediate rotation, and follow-up review. |
| Method-level audit proof | Pass | Logs include method, credential ID, device, enforcement point, and session ID. |

## Reviewer Notes

This setup provides sufficient evidence to mark privileged MFA assurance as passing. Continue monitoring exception expiry and quarterly break-glass test results.
