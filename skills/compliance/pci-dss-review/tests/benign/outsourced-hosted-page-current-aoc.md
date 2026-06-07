---
case: outsourced-hosted-page-current-aoc
expected: no-finding
skill: pci-dss-review
---

# Benign Case: Hosted Payment Page Scope Reduction Is Evidence-Backed

## Evidence

```yaml
merchant_validation_type: SAQ-A
payment_integration:
  provider: ExamplePay
  consumed_services:
    - hosted_payment_page
    - token_vault
provider_aoc:
  version: PCI DSS v4.0
  status: current
  reviewed_on: 2026-01-15
  covered_services:
    - hosted_payment_page
    - token_vault
responsibility_matrix:
  req_6_4_3:
    provider: hosted_payment_page_script_inventory_and_integrity
    merchant: iframe_integration_change_approval
  req_11_6_1:
    provider: hosted_page_tamper_detection_and_alerting
    merchant: alert_recipient_testing
  req_12_8_5:
    provider: written_responsibility_acknowledgment
    merchant: annual_aoc_review_and_matrix_retention
data_flow:
  merchant_systems_store_process_transmit_pan_or_sad: false
  evidence: "network trace and architecture diagram show browser posts PAN only to ExamplePay hosted page."
provider_changes_since_review:
  - date: 2026-04-18
    change: "Checkout CSS-only release, no payment script/domain/API/webhook change."
    merchant_scope_review_triggered: true
    saq_impact: none
```

## Why This Should Not Trigger

The consumed services match the current AOC coverage, the merchant has evidence that its systems do not store/process/transmit PAN or SAD, and the responsibility matrix maps Req 6.4.3, 11.6.1, and 12.8.5 to concrete provider and merchant obligations. Provider change review was performed and documented with no SAQ impact.

Expected result: do not over-expand scope solely because a payment-page integration exists.
