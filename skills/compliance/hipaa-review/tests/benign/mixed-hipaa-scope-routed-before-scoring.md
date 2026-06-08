# Benign Fixture: Mixed HIPAA Scope Routed Before Scoring

## Scenario

A covered healthcare provider asks for a HIPAA Security Rule review of ePHI
systems and also asks whether Privacy Rule and 42 CFR Part 2 topics are covered.
The assessment routes non-Security-Rule topics before safeguard scoring, then
continues only with ePHI security controls.

## Evidence Snapshot

| Field | Value |
|---|---|
| Entity type | Covered Entity |
| Security Rule scope | EHR access controls, audit logs, backups, endpoint safeguards, BA security assurances |
| Security Rule continuation | Continue with 45 CFR 164.308, 164.310, 164.312, 164.314, and 164.316 |
| Privacy Rule topic | Individual right-of-access workflow and disclosure accounting |
| Privacy routing | Out of Scope - Privacy Rule; assigned to privacy officer |
| Reproductive health topic | Attestation workflow question |
| Legal-status handling | Privacy counsel verifies the June 18, 2025 court order that vacated most of the 2024 reproductive health Privacy Rule and checks remaining NPP obligations |
| Part 2 topic | SUD records received from a Part 2 program |
| Part 2 routing | Out of Scope - Part 2/SUD Confidentiality; assigned to legal/compliance reviewer because the 2024 final rule compliance date has passed |
| Breach notification topic | Individual/HHS notice deadline readiness |
| Breach routing | Adjacent Subpart D readiness check, not counted as Security Rule safeguard compliance |
| Output | Separate scope-routing table plus Security Rule safeguard matrix |

## Positive Controls

- `HIPAA-SCOPE-01`: ePHI safeguards stay in the Security Rule review.
- `HIPAA-SCOPE-02`: Breach Notification readiness is separated from safeguard scoring.
- `HIPAA-SCOPE-03`: Privacy Rule topics are routed out of scope with an owner.
- `HIPAA-SCOPE-04`: Reproductive health attestation is held for current legal-status review.
- `HIPAA-SCOPE-05`: Part 2 / SUD confidentiality is routed to a Part 2 reviewer.
- `HIPAA-SCOPE-06`: Mixed scope is split before scoring.
- `HIPAA-SCOPE-07`: Non-Security-Rule obligations are tracked as external follow-ups.
- `HIPAA-SCOPE-08`: No non-Security-Rule citation is accepted as a safeguard criterion.

## Expected Result

Do not flag the Security Rule assessment for scope overstatement. It correctly
continues with ePHI safeguards while preserving unresolved Privacy Rule,
Breach Notification, and Part 2/SUD follow-ups for the right owners.
