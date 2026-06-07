---
case: tpsp-aoc-service-mismatch
expected: finding
skill: pci-dss-review
---

# Vulnerable Case: Provider AOC Does Not Match Consumed Service

## Evidence

```yaml
merchant_validation_type: SAQ-A
payment_integration:
  provider: ExamplePay
  consumed_services:
    - hosted_fields
    - token_vault
    - dispute_webhook
provider_aoc:
  version: PCI DSS v4.0
  status: current
  covered_services:
    - gateway_api
responsibility_matrix:
  source: vendor_contract
  mapping: "Provider is PCI compliant and owns payment security."
provider_changes_since_review:
  - date: 2026-05-03
    change: "Provider added analytics.js to hosted fields iframe."
    merchant_scope_review_triggered: false
merchant_controls:
  payment_page_script_inventory: missing
  req_6_4_3_owner: unclear
  req_11_6_1_owner: unclear
  req_12_8_5_matrix: generic
```

## Why This Should Trigger

The merchant is reducing scope based on a current provider AOC, but the AOC only covers `gateway_api` while the merchant uses hosted fields, token vault, and dispute webhook services. The responsibility matrix is generic and does not identify ownership for Req 6.4.3, 11.6.1, or 12.8.5. A provider-side script change occurred after the annual review without a scope or SAQ reassessment.

Expected finding: require service-level AOC matching, requirement-level shared responsibility mapping, and provider-change drift review before accepting the SAQ-A scope reduction.
