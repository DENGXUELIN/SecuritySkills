# Vulnerable: Attacker-Visible War Room Decisions

## Review Target

```yaml
incident:
  id: IR-2026-0608-001
  severity: SEV-1
  category: data_exfiltration
  attacker_access:
    mailbox_admin: suspected
    chat_admin: confirmed
    ticket_queue_watchers: unknown
    endpoint_management_admin: suspected

communications:
  normal_channels:
    corporate_email:
      trust_status: not_assessed
      used_for: legal_review_and_customer_notice_draft
      mailbox_rule_review: not_done
    teams_war_room:
      trust_status: compromised
      used_for: containment_orders
      participants:
        - incident-commander
        - soc-team
        - all-it-admins
        - disabled-user-still-present
      participant_verification: none
      retention: 7_days
    ticketing:
      trust_status: unknown
      used_for: credential_revocation_orders
      queue_watchers_review: not_done
  out_of_band:
    activated: false
    trigger_time: null
    approver: null

decision_records:
  isolate_database_cluster:
    channel: teams_war_room
    named_approver: none
    preserved_record: chat_scrollback_only
  public_statement:
    channel: corporate_email
    named_approver: legal_counsel_unverified
    preserved_record: draft_email

return_to_normal:
  internal_channels_resumed: true
  cleanup_evidence:
    mailbox_rules: not_checked
    sessions_revoked: partial
    chat_membership_review: not_done
  approver: none
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| IR-COMMS-01 | High | SEV-1 containment and notification work continued in email and Teams while mailbox/chat compromise was suspected or confirmed. |
| IR-COMMS-02 | Medium | No out-of-band activation trigger, timestamp, approver, or selected alternate channel is documented. |
| IR-COMMS-03 | Medium | War-room participants include broad groups and a disabled user without trusted participant verification. |
| IR-COMMS-04 | High | Database isolation and public statement decisions are preserved only in chat scrollback or draft email without trusted authority records. |
| IR-COMMS-05 | High | The team did not review mailbox rules, ticket watchers, IdP sessions, or endpoint-management access before using those channels. |
| IR-COMMS-06 | Medium | War-room access is not limited to need-to-know and stale participants were not removed. |
| IR-COMMS-07 | Medium | Internal channels resumed without cleanup evidence or approver. |

## Reviewer Notes

This incident needs a trusted out-of-band channel, verified roster, named approvers for containment and public communication, preserved decision records, and explicit cleanup evidence before internal channels resume.
