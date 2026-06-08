# Benign: Documented addressable decisions and resilient ePHI operations

This fixture should avoid false positives and be classified as **Compliant**, **Partial Compliance**, or **Conditional Compliance** only where the evidence supports that status.

## Entity

- Covered Entity: Multisite specialty provider
- ePHI systems: EHR, billing SaaS, telehealth, PACS archive, analytics warehouse
- Latest risk analysis: 2026-03-15, updated after telehealth vendor onboarding and backup-vault migration
- Security official: named in the policy set with approval authority

## Addressable Encryption Decision

The provider does not encrypt one legacy PACS metadata index because the application cannot support field-level encryption without corrupting signed study references.

- CFR citation: 164.312(a)(2)(iv)
- Affected ePHI systems: PACS metadata index only
- Risk-analysis reference: RA-2026-0315, section 7.4
- Equivalent alternative control: isolated subnet, dedicated jump host, MFA, privileged-session recording, signed object integrity checks, database activity monitoring, and quarterly compensating-control review
- Approver/date: Security Official, 2026-03-18
- Review trigger: PACS version upgrade, new storage backend, material incident, or 2026-09-18

Expected review outcome: do not flag missing encryption as automatic non-compliance. Classify as **Conditional Compliance** or **Addressable - Alternative Implemented** because the decision is documented, approved, scoped, and reviewable.

## Destructive Malware and Backup Resilience

- EHR and PACS backups are copied to immutable object storage with 35-day retention lock
- Monthly offline export is stored under dual-control custody
- Backup administrators are separate from domain administrators and require phishing-resistant MFA
- Retention-change and deletion attempts generate SIEM alerts
- Last restore test: 2026-05-20, recovered sample patient records and billing attachments within RTO
- Tabletop test: 2026-04-12 covered domain-admin compromise, snapshot deletion, cloud-sync deletion, and backup-console credential abuse

Expected review outcome: no destructive-malware backup gap for 164.308(a)(7)(ii)(A). Any remaining issue should be limited to specific untested systems, not a blanket failure.

## Business Associate Supply Chain

- Telehealth vendor: CareVideoCo
- BAA status: executed 2026-02-01 and mapped to video, chat, AI transcription, storage, support access, and analytics exports
- Subcontractor list: included as Schedule B with cloud hosting and transcription subprocessors
- Flowdown evidence: vendor attestation and subcontractor BAA flowdown summary dated 2026-02-15
- Right to audit or assurance mechanism: annual SOC 2 plus CE audit-on-request clause
- Breach notice SLA: security incident notice within 24 hours, breach notice without unreasonable delay and no later than 10 calendar days
- Return/destruction terms: covers recordings, transcripts, support exports, and backups

Expected review outcome: do not flag the BA relationship solely because subprocessors exist. The assessment should report the supply-chain evidence and only raise gaps if evidence is stale or outside service scope.

## Remote-Work Physical Safeguards

- Workforce group: billing and care-coordination staff
- Approved locations: home offices listed in annual attestation
- Devices: managed laptops with full-disk encryption, EDR, automatic lock, and MDM inventory
- Local storage: ePHI downloads blocked except approved encrypted export workflow
- Printing: prohibited for remote staff
- Shared-household controls: separate OS accounts prohibited; privacy screen and lock-screen attestation required
- Lost-device process: tested in 2026-05 tabletop

Expected review outcome: no false positive for remote work merely because staff work from home. Evaluate the documented workstation-use and workstation-security evidence.

## HITECH Recognized Security Practices Claim

- Practice set: NIST CSF and NIST SP 800-66-aligned HIPAA security program
- Evidence period: 2025-03-01 through 2026-05-31
- Evidence: risk-register snapshots, policy exceptions, MFA rollout records, backup restore tests, incident tabletop records, vendor-review log, and internal audit report
- Exceptions: two medium findings with accepted remediation plans

Expected review outcome: map this as HITECH recognized security-practice evidence for OCR consideration, while still reporting open findings and avoiding any guarantee of penalty reduction.
