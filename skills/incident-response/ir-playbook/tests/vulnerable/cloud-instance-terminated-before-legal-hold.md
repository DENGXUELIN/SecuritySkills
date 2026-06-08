# Vulnerable Fixture: Cloud Instance Terminated Before Legal Hold

## Scenario

An EDR alert shows suspected credential theft on a production cloud instance. The response team terminates the instance to stop lateral movement before legal hold, snapshot, memory capture, or cloud audit-log export is recorded.

## Evidence

```text
incident_id: IR-2026-0441
asset: i-0abc1234-prod-payments
alert: EDR credential theft and outbound C2
first_seen: 2026-06-08T02:14:00Z

actions:
  - time: 2026-06-08T02:21:00Z
    action: terminate instance
    performed_by: cloud-ops-oncall
    approval: slack verbal approval from incident lead

missing_preservation:
  legal_hold_ticket: none
  counsel_notified: no
  evidence_custodian: unassigned
  memory_capture: none
  disk_snapshot: none
  cloudtrail_export: not started
  edr_timeline_export: pending
  destructive_exception: not documented
```

## Expected Skill Behavior

- Flag a custody and preservation gap before the incident can be handed to post-incident review.
- Require legal hold review, custodian assignment, and a destructive containment exception with approver, urgency, skipped evidence, and recovery plan.
- Require post-action recovery of cloud control-plane logs, EDR timeline, and any remaining snapshots or backups.
- Do not treat fast containment as automatically successful when it destroyed evidence needed for breach notification, insurance, litigation, or law-enforcement coordination.
