# Vulnerable Fixture: Privacy and Part 2 Topics Scored as Security Rule Controls

## Scenario

A healthcare SaaS vendor asks for "HIPAA readiness" covering cloud ePHI
safeguards, reproductive health care disclosure attestations, and 42 CFR Part 2
SUD record redisclosure limits. The review scores all topics as HIPAA Security
Rule controls and marks the engagement complete.

## Evidence Snapshot

| Field | Value |
|---|---|
| Entity type | Business Associate |
| Security Rule scope | ePHI in EHR integration, audit logs, backup, access control |
| Privacy Rule topic | Reproductive health care disclosure attestation workflow |
| Part 2 topic | SUD records received from a Part 2 program and stored in analytics tables |
| Breach topic | Individual/HHS notification deadline checklist |
| Review behavior | All topics scored under 45 CFR 164.308 and 164.312 |
| Legal-status check | None documented for the June 18, 2025 court order affecting the 2024 reproductive health Privacy Rule |
| Part 2 owner | Not assigned |
| Privacy owner | Not assigned |
| Output | "HIPAA compliant after Security Rule safeguards pass" |

## Problem Indicators

- `HIPAA-SCOPE-01`: Security Rule ePHI safeguards are mixed with non-Security-Rule obligations.
- `HIPAA-SCOPE-02`: Breach notification readiness is counted as safeguard compliance.
- `HIPAA-SCOPE-03`: Privacy Rule use/disclosure work is not routed out of scope.
- `HIPAA-SCOPE-04`: Reproductive health care attestation is scored without checking the June 18, 2025 vacatur status.
- `HIPAA-SCOPE-05`: Part 2 / SUD confidentiality is not handed to a Part 2 reviewer even though the 2024 final rule compliance date has passed.
- `HIPAA-SCOPE-06`: Mixed scope is not split before scoring.
- `HIPAA-SCOPE-07`: External privacy obligations are treated as HIPAA Security Rule controls.
- `HIPAA-SCOPE-08`: Citations outside 45 CFR 164.302-164.318 are accepted as safeguard criteria.

## Expected Finding

Classify the report as **Partial Compliance / scope overstatement**. The
Security Rule review may continue for ePHI safeguards, but the Privacy Rule,
Part 2, Breach Notification, and legal-status questions remain unresolved
follow-ups.

## Required Remediation

Split the request before scoring. Map ePHI safeguards to Security Rule sections,
route reproductive health care attestation and general Privacy Rule questions to
privacy counsel, route SUD record questions to a Part 2 reviewer, and list
Breach Notification readiness separately from Security Rule compliance.
