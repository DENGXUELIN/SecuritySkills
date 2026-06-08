# Vulnerable: Runbook-Only Break Glass

## Review Target

```yaml
pam_program:
  tool: CyberArk
  platforms:
    - AWS production
    - Active Directory
  break_glass_policy:
    runbook: PAM-RUNBOOK-BG-001
    required_test_cadence: quarterly
    split_custody_required: true
    post_use_rotation_required: true

break_glass_drill_evidence:
  platform: AWS production
  last_drill_date: null
  last_real_use: 2024-11-02
  scenario_tested: null
  participants:
    requester: null
    approver: null
    custody_release: null
    session_operator: null
    monitoring_owner: null
    post_use_reviewer: null
  custody:
    sealed_envelope_id: BG-AWS-ROOT
    dual_control_verified: false
    release_log: missing
  access_path:
    emergency_account: aws-root
    vault_object: root-account-password
    validation_result: not_tested
  scope_duration_termination:
    max_duration: 4h
    actual_start: null
    actual_end: null
    session_terminated_evidence: missing
  alerting_logging_recording:
    siem_event: missing
    pam_audit_event: missing
    session_recording: missing
    management_notification: missing
  recovery_objective:
    rto: 30m
    measured_result: not_measured
  post_use:
    password_rotated: false
    mfa_seed_resealed: false
    recovery_codes_resealed: false
  post_drill_review:
    review_document: missing
    issues_found: unknown
    remediation_owner: null
    due_date: null

claimed_result: break_glass_tested
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| PAM-BG-11 | High | Break-glass runbook exists, but no recent drill or real-use evidence is available for AWS production. |
| PAM-BG-12 | High | No participant, release log, or dual-control evidence proves authorized custody. |
| PAM-BG-13 | High | Emergency root account and vault object were not validated during the review period. |
| PAM-BG-14 | High | Scope, actual duration, and termination evidence are missing. |
| PAM-BG-15 | High | No SIEM event, PAM audit event, session recording, or management notification proves detection. |
| PAM-BG-16 | Medium | Recovery objective was not measured. |
| PAM-BG-17 | High | Credentials and recovery material were not rotated or re-sealed after last real use. |
| PAM-BG-18 | Medium | No post-drill review, issue owner, due date, or closure evidence exists. |

## Reviewer Notes

Do not accept the written runbook as drill evidence. Require a timestamped drill package or real-use package that proves custody, access, detection, termination, recovery objective, and post-use rotation.
