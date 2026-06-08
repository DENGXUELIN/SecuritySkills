# Benign: Validated Break Glass Drill

## Review Target

```yaml
pam_program:
  tool: CyberArk + AWS IAM Identity Center
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
  last_drill_date: 2026-05-15
  scenario_tested: PAM outage + IdP outage during production incident
  participants:
    requester: incident-commander@example.com
    approver: security-director@example.com
    custody_release:
      - vault-admin-a@example.com
      - vault-admin-b@example.com
    session_operator: cloud-platform-lead@example.com
    monitoring_owner: soc-lead@example.com
    post_use_reviewer: pam-control-owner@example.com
  custody:
    sealed_envelope_id: BG-AWS-ROOT
    dual_control_verified: true
    release_log: PAM-BG-2026-05-15-release
  access_path:
    emergency_account: aws-break-glass-admin
    vault_object: cyberark://safe/aws-prod/break-glass-admin
    validation_result: success
    systems_reached:
      - AWS Organizations
      - IAM Identity Center emergency permission set
  scope_duration_termination:
    privileges_granted:
      - IAM Identity Center administrator recovery
      - CloudTrail validation read
    max_duration: 60m
    actual_start: 2026-05-15T09:10:00Z
    actual_end: 2026-05-15T09:42:00Z
    session_terminated_evidence: PAM-BG-2026-05-15-session-end
    role_disabled_after_drill: true
  alerting_logging_recording:
    siem_event: SIEM-884201
    pam_audit_event: CYBR-AUDIT-77201
    cloudtrail_event: CT-2026-05-15-BG
    session_recording: REC-PAM-884201
    management_notification: SEC-NOTIFY-2026-05-15
  recovery_objective:
    rto: 30m
    measured_result: 22m
    status: met
  post_use:
    password_rotated: true
    mfa_seed_resealed: true
    recovery_codes_resealed: true
    rotation_ticket: PAM-ROTATE-9912
  post_drill_review:
    review_document: PIR-PAM-BG-2026-05-15
    issues_found:
      - alert notification group missing deputy CISO
    remediation_owner: soc-lead@example.com
    due_date: 2026-05-30
    closed_at: 2026-05-28

claimed_result: break_glass_tested_with_evidence
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Drill date and scenario | Pass | Drill occurred 2026-05-15 and covered PAM plus IdP outage. |
| Participants and custody | Pass | Request, approval, dual custody, operator, monitoring, and reviewer roles are named. |
| Access path | Pass | CyberArk vault object and AWS break-glass admin path were validated successfully. |
| Scope and termination | Pass | Privileges, start/end times, session termination, and role disable evidence are present. |
| Alerting and logging | Pass | SIEM, PAM audit, CloudTrail, session recording, and management notification IDs are listed. |
| Recovery objective | Pass | Recovery capability was restored in 22 minutes against a 30-minute RTO. |
| Post-use rotation | Pass | Password, MFA seed, and recovery codes were rotated or re-sealed with ticket evidence. |
| Post-drill review | Pass | Issue owner, due date, and closure evidence are documented. |

## Reviewer Notes

This evidence supports marking the AWS production break-glass drill as tested for the review period. Continue to test other critical platforms on the required cadence and verify prior drill findings stay closed.
