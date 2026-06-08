# Vulnerable: policy-only recognized security practices package

## Scenario

A business associate claims recognized security practices during an OCR investigation after a ransomware incident. The package maps policies to NIST CSF and 405(d) HICP, but most controls were created after the incident and the evidence does not prove prior-12-month operation for ePHI systems.

## Evidence

| Field | Value |
|---|---|
| Practice set | NIST CSF and 405(d) HICP named in a policy appendix |
| Prior-12-month evidence | Missing; endpoint hardening and backup immutability projects opened after the incident |
| Operational artifacts | Policy PDFs and screenshots only; no access review, log review, backup test, or vulnerability remediation tickets |
| ePHI risk linkage | Corporate risk register references "data systems" but does not map to EHR, claims, imaging, or backup ePHI stores |
| Scope | Cloud EHR and subcontractor support portal excluded because the vendor has its own security program |
| Exceptions | Known MFA and backup immutability gaps omitted from the package |
| OCR export readiness | Evidence owner says artifacts are in multiple vendor portals with no export index |
| Continuity | Migration to a new EDR platform created a 45-day coverage gap with no compensating measure |

## Expected Review Outcome

- The recognized security practices overlay is `Non-Compliance` or `Partial Compliance`, not OCR-ready.
- `HIPAA-RSP-02`, `HIPAA-RSP-03`, `HIPAA-RSP-04`, `HIPAA-RSP-05`, `HIPAA-RSP-06`, `HIPAA-RSP-07`, and `HIPAA-RSP-08` fail.
- The Security Rule review must still evaluate each applicable safeguard; the RSP package does not excuse missing controls or unremediated risk analysis gaps.
