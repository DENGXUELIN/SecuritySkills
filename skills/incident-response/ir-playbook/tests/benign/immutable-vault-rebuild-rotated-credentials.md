---
case: immutable-vault-rebuild-rotated-credentials
expected: pass
skill: ir-playbook
---

# Benign Case: Immutable Vault Recovery With Rotated Credentials

## Incident Facts

- Earliest confirmed attacker access: 2026-05-18 03:22 UTC.
- Selected recovery source: immutable backup vault snapshot from 2026-05-17 23:00 UTC.
- Integrity evidence: restore test passed in isolated recovery network; provider integrity status is clean; restored image hash matches the vault manifest.
- Immutability evidence: WORM retention lock active through 2026-06-17; failed deletion attempt logged from the compromised admin account.
- Backup control plane: separate backup-admin tenant, hardware MFA, break-glass approval record, and vault access logs reviewed.
- Credentials rotated: domain admin, cloud admin, backup admin, service account, restore API key, and TLS certificate were reissued before reconnect.
- Image provenance: golden image signature, IaC commit, package manifest, and restore automation version are recorded.
- Persistence scan: EDR full scan, IOC sweep, local account review, scheduled task/service review, web shell scan, and remote-management tool inventory passed.
- Reconnect plan: isolated validation, limited VLAN canary phase, then production phase with egress monitoring and authentication anomaly alerts.
- Rollback criteria: any post-restore beaconing, use of old credentials, unexpected admin creation, or destructive file activity returns the workload to containment.

## Expected Skill Behavior

The recovery decision may be `Proceed` for limited reconnect, with continued monitoring.

The report should preserve:

- last known-good timeline basis;
- integrity and immutability evidence;
- backup control-plane isolation proof;
- credential rotation summary;
- image and automation provenance;
- persistence scan result;
- phased reconnect monitoring window and rollback criteria.
