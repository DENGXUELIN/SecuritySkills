# Benign: Verified POI tamper inspection and response program

This fixture should avoid PCI DSS Req 9.5.1 POI tamper findings because inventory, field verification, inspection, training, lifecycle, and response evidence are complete.

## Assessment Context

- Merchant: card-present retailer with standalone PTS POI devices
- Validation type: SAQ P2PE
- POI environment: countertop terminals at fixed lanes plus controlled mobile devices
- Evidence period: Q2 2026

## POI Tamper and Substitution Evidence

| Field | Evidence |
|---|---|
| Device ID / Serial | `POS-17-02`, serial `VX820-884112`, merchant ID `MID-77170017` |
| Location / Lane | Store 17, Lane 2, service desk counter |
| Make / Model / Firmware | Verifone VX820, P2PE solution ID `P2PE-ACQ-112`, firmware `3.2.9-approved` |
| Inventory Match | field verifier scanned serial and merchant ID; both match inventory and acquirer portal |
| Last Field Verification | `2026-06-03`, verifier `store-manager-17`, evidence packet `POI-Q2-2026-Store17.pdf` |
| Inspection Cadence | daily opening inspection plus monthly manager spot-check; cadence justified by targeted risk analysis `TRA-POI-2026` |
| Inspection Evidence | checklist covers tamper seal, overlay/skimmer, cable path, casing seams, display/keypad, and unknown-device substitution |
| Personnel Training | cashiers and managers completed `POI-tamper-v2026.2` training with sign-off before operating terminals |
| Lifecycle Status | active; repair and replacement workflow reconciles inventory within one business day |
| Tamper Response Evidence | runbook `IR-POI-TAMPER-01` requires remove from service, preserve device, notify acquirer, open incident, and retain photos/logs |
| Exception / Owner / Due | N/A |

## Verification Samples

| Sample | Result |
|---|---|
| Store 17 Lane 2 spot-check | serial, location, and acquirer portal record match |
| Mobile terminal `MOB-NE-01` | custody log shows checkout/check-in, inspection before use, and locked storage after use |
| Missed inspection test | one missed daily inspection opened exception `POI-EX-2026-051`, remediated same day with manager sign-off |
| Training sample | 18 of 18 assigned personnel completed POI tamper training |
| Tamper-response tabletop | suspected overlay scenario opened incident `IR-2026-POI-04`, terminal removed from service in 6 minutes, acquirer notified |

Expected outcome:

- Do not flag `PCI-POI-01` because inventory fields are complete.
- Do not flag `PCI-POI-02` because deployed serial/location/merchant ID are field-verified.
- Do not flag `PCI-POI-03` because inspections cover tamper and substitution indicators.
- Do not flag `PCI-POI-04` because cadence and missed inspection handling are documented.
- Do not flag `PCI-POI-05` because lifecycle changes are reconciled.
- Do not flag `PCI-POI-06` because POI-specific training evidence exists.
- Do not flag `PCI-POI-07` because response evidence includes removal, escalation, preservation, and incident tracking.
- Do not flag `PCI-POI-08` because exceptions are tracked or N/A.
