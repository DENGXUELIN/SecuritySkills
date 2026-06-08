# Benign: Matched VEX statement with sufficient validation evidence

This fixture should avoid VEX evidence validation findings when the VEX statement is scoped, fresh, authentic, and supported.

## Assessment Context

- Product under review: `Acme Payments Gateway Enterprise`
- Product version: `4.8.2`
- Supplier: `Acme Financial Software`
- Release date: `2026-05-30`
- SBOM format: CycloneDX 1.5
- SBOM timestamp: `2026-05-30T14:12:00Z`
- Component in SBOM: `pkg:maven/com.acme/payments-xml@2.9.1`, bom-ref `pkg:maven/com.acme/payments-xml@2.9.1`
- Vulnerability under review: `CVE-2026-43110`, alias `GHSA-payg-xml-xxe`

## VEX Statement Presented

- VEX format: CSAF 2.0 VEX profile
- VEX source: `https://security.acme.example/advisories/acme-vex-2026-43110.json`
- Signature: detached signature verified against Acme security advisory key
- VEX product name: `Acme Payments Gateway Enterprise`
- VEX product version: `4.8.2`
- Product identifiers: `cpe:2.3:a:acme:payments_gateway_enterprise:4.8.2:*:*:*:*:*:*:*`
- VEX component identifier: `pkg:maven/com.acme/payments-xml@2.9.1`
- VEX vulnerability IDs: `CVE-2026-43110`, `GHSA-payg-xml-xxe`, `ACME-2026-XML-02`
- VEX status: `not_affected`
- Justification: `vulnerable_code_not_in_execute_path`
- Statement timestamp: `2026-05-31T10:00:00Z`

## Supporting Evidence

| Validation Check | Evidence |
|---|---|
| Product identity | Product name, supplier, version, CPE, and release notes match the SBOM software under review |
| Component identity | VEX purl exactly matches CycloneDX component purl and bom-ref |
| Vulnerability aliases | CSAF tracking lists CVE, GHSA, and vendor advisory IDs used by the scanner |
| Explicit status | CSAF product status field is `not_affected` for product `4.8.2` |
| Justification | CSAF remediations/flags include `vulnerable_code_not_in_execute_path` |
| Freshness | VEX timestamp is after the SBOM build and the product release |
| Source authenticity | Advisory URL is on the vendor security domain and signature verification passed |
| Supporting evidence | Vendor attestation references build flag `xml.external_entities=false`, integration test `SEC-XML-XXE-NA-482`, and runtime config inventory showing the vulnerable parser path disabled |
| Priority downgrade | Allowed only for this product release and deployment profile; exception expires if component version or parser configuration changes |

Expected outcome:

- Do not flag `SBOM-VEX-01` because product identity matches.
- Do not flag `SBOM-VEX-02` because component purl and bom-ref map exactly.
- Do not flag `SBOM-VEX-03` because vulnerability aliases are documented.
- Do not flag `SBOM-VEX-04` or `SBOM-VEX-05` because status and justification are explicit.
- Do not flag `SBOM-VEX-06` because the VEX is newer than the SBOM and release.
- Do not flag `SBOM-VEX-07` because source authenticity is verified.
- Do not flag `SBOM-VEX-08` because code-path and configuration evidence support the justification.
- Do not flag `SBOM-VEX-09` because the downgrade is conditioned on all validation checks passing.
