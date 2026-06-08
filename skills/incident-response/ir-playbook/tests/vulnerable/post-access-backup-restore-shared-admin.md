---
case: post-access-backup-restore-shared-admin
expected: fail
skill: ir-playbook
---

# Vulnerable Case: Restoring a Post-Access Snapshot With Shared Backup Admin

## Incident Facts

- Earliest confirmed attacker access: 2026-05-18 03:22 UTC through a VPN account.
- Domain admin compromise: 2026-05-18 05:47 UTC.
- Selected VM snapshot: 2026-05-18 09:15 UTC.
- Backup console admin: same domain group that was compromised during the incident.
- Backup vault audit logs: not reviewed; retention lock status unknown.
- Restore automation credential: reused the pre-incident service account.
- Persistence scan: EDR quick scan only; no local account, scheduled task, web shell, or remote-management tool review.
- Reconnect plan: restore directly into production VLAN after the VM boots.

## Expected Skill Behavior

The recovery decision should be `Hold` or `Not Evaluable`, not `Proceed`.

The report should flag:

- the snapshot postdates earliest access and may contain attacker persistence;
- backup control-plane isolation is not proven because the backup admin identity shares the compromised domain plane;
- immutability and failed-deletion audit evidence are missing;
- restore automation credentials were not rotated;
- persistence scanning is incomplete before production promotion;
- direct production reconnect lacks a phased monitoring and rollback gate.

## Required Evidence Gate

This case is only acceptable after the responder selects a pre-access or clean rebuild source, proves backup integrity and immutability, rotates recovery credentials, verifies backup console isolation, completes persistence checks, and reconnects in a limited monitored phase with rollback criteria.
