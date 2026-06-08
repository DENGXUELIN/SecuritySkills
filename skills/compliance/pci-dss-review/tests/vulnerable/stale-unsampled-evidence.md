# Vulnerable: Stale and Unsampled PCI Evidence

## Scenario

The assessor is reviewing PCI DSS v4.0 evidence for a Level 1 merchant covering the 2026 assessment period.

## Submitted Evidence

| Sub-Req | Claimed Status | Evidence |
|---------|----------------|----------|
| 10.4.1.1 | In Place | Screenshot of SIEM dashboard from 2025-11-15 |
| 8.4.2 | In Place | MFA configuration export for one admin group |
| 11.4.5 | In Place | Segmentation test summary that lists only the primary CDE VLAN |
| 12.8.5 | In Place | TPSP AOC for payment processor, no responsibility matrix |

## Missing Evidence

- `PCI-EVID-01`: no examine/observe/interview/test procedure is mapped to the sub-requirements.
- `PCI-EVID-03`: no evidence owner or collector is recorded.
- `PCI-EVID-04`: the SIEM screenshot predates the assessment period and no period covered is stated.
- `PCI-EVID-05`: sample scope omits connected-to systems, service accounts, secondary CDE segments, and TPSP responsibilities.
- `PCI-EVID-06`: recurring controls do not prove the required cadence across the assessment period.
- `PCI-EVID-07`: freshness is not assessed against control changes or CDE scope.

## Expected Review Result

The skill should not mark these sub-requirements `In Place`. Under `PCI-EVID-08`, missing sample scope, owner, date, period, CDE coverage, frequency proof, or freshness status should produce `Unknown` or `Not in Place`.
