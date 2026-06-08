# Benign Fixture: Containment After Approved Evidence Capture

## Scenario

A ransomware incident on a file server appears slower than expected because containment waited 18 minutes for counsel-approved evidence preservation. The delay was intentional and documented.

## Evidence

```text
incident_id: IR-2026-0442
asset: fs-17
category: malware
severity: SEV-1

legal_hold:
  ticket: LH-2026-184
  counsel_owner: legal-ir@example.invalid
  approved_at: 2026-06-08T04:05:00Z
  preservation_scope: memory, disk image, EDR timeline, file access logs

evidence_package:
  package_id: EVID-IR-2026-0442-A
  memory_sha256: 6f7b2d0e3a8a5b0e0e1b3c5f9112e5f1a7b0c3d4e5f60718293a4b5c6d7e8f90
  disk_image_sha256: 8a8b2d0e3a8a5b0e0e1b3c5f9112e5f1a7b0c3d4e5f60718293a4b5c6d7e8f91
  collected_by: dfir-oncall
  custodian: ir-evidence-vault

containment:
  isolated_at: 2026-06-08T04:23:00Z
  action: EDR network isolate
  performed_by: soc-lead

handoff:
  recipient: external-ir-case-team
  method: encrypted portal
  received_at: 2026-06-08T05:10:00Z
  checksum_verified: true
  scope_of_work: SOW-2026-77
```

## Expected Skill Behavior

- Do not over-flag the containment delay as uncontrolled slowness.
- Record preservation as complete because legal hold, custodian, hashes, collection time, and containment time are present.
- Record the external handoff as complete because recipient, method, receipt time, checksum verification, and scope-of-work reference are present.
- Still keep SEV-1 response urgency because ransomware is destructive, but distinguish preservation-driven delay from process failure.
