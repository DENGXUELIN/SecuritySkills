# Benign: current SBOM bound to immutable artifact evidence

This sample should be accepted as a properly bound and current SBOM freshness case before the rest of the SBOM analysis proceeds.

## Scenario

- Product: `payments-api`
- Reviewed artifact: `registry.example.com/payments-api@sha256:4d4b77f4f7f9e4c2d4f3c8b9a6f2d1e0c3b2a190887766554433221100ffeedd`
- Release tag: `payments-api-v2.8.0`
- Commit SHA: `9f0d5d5a23f2b4b1aa53ce17d6d7f6a44cb6a210`
- Build ID: `gha-74219931`
- SBOM timestamp: `2026-06-07T10:12:00Z`
- Deployment date: `2026-06-07T10:15:00Z`
- SBOM generator: `syft 1.27.0`
- Generation pipeline: `github-actions://payments-api/.github/workflows/release.yml@gha-74219931`

## SBOM excerpt

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "metadata": {
    "timestamp": "2026-06-07T10:12:00Z",
    "tools": [
      {
        "vendor": "Anchore",
        "name": "syft",
        "version": "1.27.0"
      }
    ],
    "component": {
      "type": "container",
      "name": "payments-api",
      "version": "2.8.0",
      "bom-ref": "pkg:oci/payments-api@sha256:4d4b77f4f7f9e4c2d4f3c8b9a6f2d1e0c3b2a190887766554433221100ffeedd",
      "purl": "pkg:oci/payments-api@sha256:4d4b77f4f7f9e4c2d4f3c8b9a6f2d1e0c3b2a190887766554433221100ffeedd"
    },
    "properties": [
      { "name": "build:id", "value": "gha-74219931" },
      { "name": "release:tag", "value": "payments-api-v2.8.0" },
      { "name": "source:commit", "value": "9f0d5d5a23f2b4b1aa53ce17d6d7f6a44cb6a210" },
      { "name": "pipeline:url", "value": "github-actions://payments-api/.github/workflows/release.yml@gha-74219931" }
    ]
  },
  "components": [
    {
      "type": "library",
      "name": "example-json",
      "version": "4.1.2",
      "supplier": { "name": "Example OSS" },
      "purl": "pkg:npm/example-json@4.1.2"
    }
  ],
  "dependencies": [
    {
      "ref": "pkg:oci/payments-api@sha256:4d4b77f4f7f9e4c2d4f3c8b9a6f2d1e0c3b2a190887766554433221100ffeedd",
      "dependsOn": ["pkg:npm/example-json@4.1.2"]
    }
  ]
}
```

## Expected result

- Binding Result: `Bound`
- Freshness Result: `Current`
- Decision: `Use for risk decisions`
- Required non-finding: do not flag the SBOM as stale solely because it is a point-in-time document when digest, build ID, generator version, pipeline provenance, release tag, commit SHA, and aligned timestamps bind it to the reviewed artifact.
