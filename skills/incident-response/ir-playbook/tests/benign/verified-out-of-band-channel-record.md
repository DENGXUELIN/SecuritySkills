# Benign: Verified Out-of-Band Channel Record

## Review Target

```yaml
incident:
  id: IR-2026-0608-014
  severity: SEV-1
  category: destructive_malware
  attacker_access:
    mailbox_admin: ruled_out_after_review
    chat_admin: suspect_until_2026-06-08T10:20Z
    ticket_queue_watchers: reviewed_clean
    endpoint_management_admin: suspect

communications:
  normal_channels:
    corporate_email:
      trust_status: restricted
      approved_use: executive_status_only_after_legal_approval
      mailbox_rule_review: completed
      session_review: completed
    teams_war_room:
      trust_status: disabled_for_containment
      membership_export: teams-membership-IR-014.csv
    ticketing:
      trust_status: trusted_after_queue_watcher_review
      approved_use: preservation_record_only
  out_of_band:
    activated: true
    selected_channel: ir_retainer_portal_and_verified_phone_bridge
    trigger: SEV-1 destructive malware plus suspect chat and endpoint-management admin access
    trigger_time: 2026-06-08T09:18:00Z
    approver: incident_commander
    bridge_recording: bridge-rec-IR-014-0918
    portal_case: portal-case-IR-014

participants:
  - name: incident_commander
    role: IC
    verification: pre-established_call_tree
    joined: 2026-06-08T09:19:00Z
    left: 2026-06-08T14:30:00Z
  - name: legal_counsel
    role: legal
    verification: callback_to_retainer_contact
    joined: 2026-06-08T09:23:00Z
  - name: external_ir_lead
    role: external_ir
    verification: retainer_portal_identity
    joined: 2026-06-08T09:25:00Z

decision_records:
  isolate_production_segment:
    channel: verified_phone_bridge
    named_approver: incident_commander
    owner: network_lead
    preserved_record: decision-log-IR-014#D3
  regulatory_notification_hold:
    channel: ir_retainer_portal
    named_approver: legal_counsel
    preserved_record: portal-case-IR-014#legal-2

return_to_normal:
  internal_channels_resumed: true
  time: 2026-06-08T15:10:00Z
  approver: incident_commander
  cleanup_evidence:
    mailbox_rules: clean-export-IR-014
    sessions_revoked: idp-session-review-IR-014
    chat_membership_review: teams-membership-clean-IR-014
    endpoint_management_admin_review: mdm-admin-review-IR-014
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Channel trust status | Pass | Email, Teams, ticketing, phone bridge, portal, and endpoint-management trust states are documented. |
| Switch trigger and timestamp | Pass | SEV-1 destructive malware and suspect channels triggered OOB at `2026-06-08T09:18:00Z` with IC approval. |
| Participant verification | Pass | Participants were verified through call tree, retainer callback, or portal identity. |
| Access control and need-to-know | Pass | Teams was disabled for containment and portal/bridge membership is scoped to response roles. |
| Decision and order preservation | Pass | Containment and legal decisions have named approvers and preserved decision-log or portal records. |
| Adversary visibility review | Pass | Mailbox rules, sessions, ticket watchers, chat membership, and endpoint-management admins were reviewed. |
| Return-to-normal criteria | Pass | Internal channels resumed only after cleanup evidence and IC approval. |

## Reviewer Notes

This record supports communication channel integrity for a SEV-1 incident. Further review should focus on whether containment actions and forensic preservation were technically sufficient.
