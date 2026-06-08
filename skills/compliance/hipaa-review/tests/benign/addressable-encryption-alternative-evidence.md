---
case: addressable-encryption-alternative-evidence
expected: pass
skill: hipaa-review
---

# Benign Case: Addressable Encryption Alternative With Evidence

## Safeguard Evidence

- CFR citation: `164.312(a)(2)(iv)` Encryption and Decryption.
- Specification type: Addressable.
- Decision type: Alternative Measure.
- ePHI system: managed care-coordination SaaS used for intake notes and treatment-plan messages.
- Rationale: storage encryption is implemented and operated by the SaaS Business Associate; the Covered Entity does not manage the database layer directly.
- Evidence source:
  - Executed BAA covering the SaaS platform and support access.
  - SOC 2 report section covering encryption, logical access, and change management.
  - Vendor bridge letter covering the current period.
  - Data-flow diagram showing all ePHI remains inside the SaaS platform and encrypted export channel.
  - Security official approval ticket `HIPAA-7421`.
- Evidence owner: compliance contract owner and security official.
- Freshness: BAA effective 2026-01-01; SOC 2 report covers 2025-10-01 through 2026-03-31; bridge letter dated 2026-05-15.
- Scope: production SaaS tenant, support exports, backups, and analytics feed are covered; no local database copy is in scope.

## Expected Skill Behavior

The review may classify this addressable specification as compliant through an alternative measure if the matrix preserves the decision type, rationale, BAA/vendor evidence, owner, freshness, ePHI scope, and confidence. It should not mark this as missing encryption merely because the Covered Entity does not operate the encryption control directly.
