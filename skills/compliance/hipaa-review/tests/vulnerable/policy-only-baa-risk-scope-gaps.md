---
case: policy-only-baa-risk-scope-gaps
expected: fail
skill: hipaa-review
---

# Vulnerable Case: Policy-Only Safeguard Evidence and BAA Scope Gaps

## Safeguard Evidence

- CFR citation: `164.308(a)(1)(ii)(A)` Risk Analysis.
- Specification type: Required.
- Decision type claimed by requester: Implemented.
- Evidence source: risk-analysis policy template only.
- Missing implementation evidence:
  - No current risk analysis report.
  - No ePHI asset inventory tied to the analysis.
  - No system-level threat, vulnerability, likelihood, or impact assessment.
  - No update after analytics warehouse and support-export workflows were added.
- BAA and subcontractor gaps:
  - Cloud transcription vendor receives ePHI.
  - BAA is described as "in procurement" with no executed agreement.
  - Subcontractor list and downstream assurance evidence are unavailable.
- Scope gaps:
  - EHR and email are listed.
  - Backups, analytics warehouse, device telemetry, support exports, and BA systems are omitted.
- Freshness: last policy review was 2024-03-01; no covered assessment period is documented.
- Evidence owner: unknown.

## Expected Skill Behavior

The review should not count this as compliant based on policy text. It should produce Not Evaluable or Non-Compliance findings for missing risk-analysis scope, missing implementation evidence, missing BAA/subcontractor evidence, stale evidence, and unknown owner. The output should record the specific Not Evaluable reason codes instead of collapsing the gaps into a generic documentation issue.
