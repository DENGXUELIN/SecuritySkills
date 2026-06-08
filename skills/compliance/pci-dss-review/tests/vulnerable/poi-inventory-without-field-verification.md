# Vulnerable: POI inventory exists but deployed terminals are not field-verified

This fixture should produce PCI DSS Req 9.5.1 POI tamper and substitution findings.

## Assessment Context

- Merchant: card-present retailer with 42 stores
- Validation type: SAQ B-IP
- POI environment: countertop PTS terminals and two mobile terminals per region
- Evidence provided: terminal spreadsheet and one policy statement

## Provided POI Inventory

| Device ID | Store | Lane | Model | Serial | Status |
|---|---|---|---|---|---|
| POS-17-01 | Store 17 | Lane 1 | VX820 | missing | active |
| POS-17-02 | Store 17 | Lane 2 | VX820 | VX820-884112 | active |
| MOB-NE-01 | Northeast region | mobile | unknown | MOB-7781 | active |

## Evidence Gaps

- The inventory lacks complete serial numbers, firmware/P2PE identifiers, installation dates, owners, and merchant IDs.
- Store personnel confirmed that lane labels changed after a remodel, but the spreadsheet was not updated.
- There is no field verification showing deployed serial numbers match Store 17 Lane 1/2.
- The inspection checklist says "inspect terminals" but has no fields for tamper seal, overlay/skimmer, cable path, casing, display, keypad, or substitution checks.
- Inspection cadence is "as needed"; no targeted risk analysis or missed-inspection tracking exists.
- Device replacement records are stored in email and are not reconciled to the inventory.
- Store personnel training records cover general security awareness, not POI tamper detection or reporting.
- A suspected skimmer procedure tells staff to "call IT" but does not require removing the terminal from service, preserving evidence, notifying the acquirer/processor, or opening an incident.
- Exceptions are noted in a chat thread with no owner or due date.

Expected findings:

- `PCI-POI-01` because inventory fields are incomplete.
- `PCI-POI-02` because deployed serial/location matching is not verified.
- `PCI-POI-03` because inspection evidence lacks tamper/substitution checks.
- `PCI-POI-04` because cadence and missed inspection handling are missing.
- `PCI-POI-05` because remodel/replacement lifecycle changes are not reconciled.
- `PCI-POI-06` because personnel training is not POI-specific.
- `PCI-POI-07` because tamper response lacks removal, escalation, evidence preservation, and incident tracking.
- `PCI-POI-08` because exceptions lack owner, due date, and remediation status.

Expected handling: mark Req 9.5.1 not in place until the merchant completes per-device field verification, updates inventory fields, implements inspection cadence and checklist, trains personnel, and tests tamper-response handling.
