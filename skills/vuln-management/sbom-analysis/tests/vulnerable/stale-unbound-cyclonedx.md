# Vulnerable: stale and unbound CycloneDX SBOM

This sample should be treated as a failed SBOM freshness and artifact binding case even though it includes normal NTIA-style fields.

## Scenario

- Product: `payments-api`
- Claimed version: `2.8.0`
- Reviewed artifact: production container `registry.example.com/payments-api:2.8.0`
- Current deployment date: `2026-06-07T10:15:00Z`
- SBOM timestamp: `2026-05-20T08:30:00Z`
- Artifact digest: missing
- Build ID: missing
- SBOM generator version: missing
- Generation pipeline: missing
- Release evidence: deployment logs show a dependency rebuild after the SBOM timestamp

## SBOM excerpt

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "metadata": {
    "timestamp": "2026-05-20T08:30:00Z",
    "component": {
      "type": "application",
      "name": "payments-api",
      "version": "2.8.0"
    },
    "authors": [{ "name": "Vendor Security" }]
  },
  "components": [
    {
      "type": "library",
      "name": "example-json",
      "version": "4.1.0",
      "supplier": { "name": "Example OSS" },
      "purl": "pkg:npm/example-json@4.1.0"
    }
  ],
  "dependencies": [
    {
      "ref": "pkg:npm/example-json@4.1.0",
      "dependsOn": []
    }
  ]
}
```

## Expected result

- Binding Result: `Unbound`
- Freshness Result: `Stale`
- Decision: `Reject for risk decisions`
- Required finding: the SBOM has product/version data but no immutable artifact digest, build/release ID, generator version, pipeline provenance, or evidence that it was regenerated after the deployed artifact changed.
