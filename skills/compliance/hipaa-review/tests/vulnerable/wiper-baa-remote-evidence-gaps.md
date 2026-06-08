# Vulnerable: Online-only backup, stale BAA, remote-work evidence gaps

This fixture should be classified as **Non-Compliance** or **Critical Non-Compliance** for the affected controls.

## Entity

- Covered Entity: Regional clinic network
- ePHI systems: EHR, billing portal, telehealth platform, lab-results file share
- Latest risk analysis: 2024-04-10, before the telehealth migration and before the backup architecture change

## Addressable Encryption Decision

The clinic does not encrypt archived billing exports at rest because the exports are stored on an internal file share.

- Risk-analysis reference: none for the billing export archive
- Equivalent alternative control: "network ACLs"
- Approval: verbal approval from IT manager, no date
- Review trigger: not defined

Expected review outcome: do not treat this as compliant. Missing encryption may be addressable, but this record lacks a current risk-analysis reference, documented rationale, accountable approval, and a review trigger.

## Destructive Malware and Backup Resilience

- EHR backups replicate every 15 minutes to a cloud sync bucket controlled by the same domain-admin group as production
- Volume Shadow Copies are enabled, but no immutable/WORM retention is configured
- Backup deletion and retention changes are not separately logged
- Last successful restore test: 2024-02-02, before the current backup product was deployed
- Contingency-plan tabletop covers ransomware decryption but does not cover wiper malware, snapshot deletion, backup-index destruction, or cloud-sync deletion
- Lab-results file share has no offline copy

Expected review outcome: flag 164.308(a)(1)(ii)(A) risk-analysis and 164.308(a)(7)(ii)(A) data-backup-plan gaps because retrievable exact ePHI copies are not proven under a total-destruction scenario.

## Business Associate Supply Chain

- Telehealth vendor: CareVideoCo
- BAA status: executed in 2022 for video sessions only
- New 2026 service: AI transcription creates and maintains ePHI transcripts
- Subcontractors: vendor states "cloud partners may be used" but does not provide a subcontractor list
- Right to audit or assurance mechanism: absent
- Breach notice SLA: "commercially reasonable efforts"
- Return/destruction terms: not updated for AI transcripts

Expected review outcome: flag 164.314(a)(2)(i) BAA deficiencies because the executed BAA does not match the actual service scope, subcontractor flowdown is not evidenced, and breach-notice timing is not specific enough for review.

## Remote-Work Physical Safeguards

- Billing staff may work from home using personal laptops
- No MDM inventory or full-disk encryption attestation is available
- Local spreadsheet exports are permitted for claims cleanup
- Printing at home is "discouraged" but not prohibited or tracked
- Shared household accounts are not addressed
- Lost-device reporting is not tested

Expected review outcome: flag 164.310(b) workstation-use and 164.310(c) workstation-security gaps because office-centric physical controls do not prove remote ePHI protection.

## HITECH Recognized Security Practices Claim

Management asks the assessor to mention HITECH safe harbor because the organization adopted a NIST CSF-aligned policy last month.

Expected review outcome: mark safe-harbor consideration as **not demonstrated** because there is no evidence that recognized security practices were in place for the prior 12 months.
