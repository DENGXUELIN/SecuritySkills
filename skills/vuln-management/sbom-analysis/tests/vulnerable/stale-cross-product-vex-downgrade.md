# Vulnerable: Stale cross-product VEX used to downgrade a live vulnerability

This fixture should produce VEX evidence validation findings.

## Assessment Context

- Product under review: `Acme Payments Gateway Enterprise`
- Product version: `4.8.2`
- Supplier: `Acme Financial Software`
- Release date: `2026-05-30`
- SBOM format: CycloneDX 1.5
- SBOM timestamp: `2026-05-30T14:12:00Z`
- Vulnerability under review: `CVE-2026-43110`, alias `GHSA-payg-xml-xxe`
- Component in SBOM: `pkg:maven/com.acme/payments-xml@2.9.1`, bom-ref `pkg:maven/com.acme/payments-xml@2.9.1`

## VEX Statement Presented

- VEX source: copied from a customer-support ticket attachment
- VEX product name: `Acme Payments Gateway Community`
- VEX product version: `4.7.0`
- VEX supplier: `Acme Labs`
- VEX component: `payments-xml`
- VEX component version: `2.6.0`
- VEX vulnerability ID: `ACME-2025-XML-17`
- VEX status text: "Enterprise builds should not be impacted in the default profile."
- VEX explicit status field: missing
- VEX justification: missing
- VEX timestamp: `2026-03-01T09:00:00Z`
- Signature or release channel: none

## Incorrect Review Outcome

The review marks `CVE-2026-43110` as low priority because a VEX-like document says the product is "not impacted." The report does not map `ACME-2025-XML-17` to `CVE-2026-43110`, does not check whether Community 4.7.0 applies to Enterprise 4.8.2, does not compare component version `2.6.0` against SBOM component `2.9.1`, and does not require an explicit `not_affected` status or justification.

Expected findings:

- `SBOM-VEX-01` because product edition, supplier, and version do not match the assessed release.
- `SBOM-VEX-02` because the VEX component version does not map to the SBOM component identifier.
- `SBOM-VEX-03` because the vulnerability alias set is not validated.
- `SBOM-VEX-04` because the status is inferred from narrative text.
- `SBOM-VEX-05` because `not_affected` has no justification.
- `SBOM-VEX-06` because the VEX predates the SBOM and product release.
- `SBOM-VEX-07` because the source is an unauthenticated ticket attachment.
- `SBOM-VEX-08` because no code-path, configuration, runtime, mitigation, or supplier evidence supports the claim.
- `SBOM-VEX-09` because the review downgrades priority despite failed validation.

Expected handling: do not downgrade the vulnerability. Treat the VEX as insufficient evidence, request a supplier-published or signed statement for Enterprise 4.8.2 and component `2.9.1`, and continue remediation or compensating controls until the VEX validation checks pass.
