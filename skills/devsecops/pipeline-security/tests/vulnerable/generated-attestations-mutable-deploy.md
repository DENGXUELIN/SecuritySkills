# Vulnerable: Pipeline generates attestations but deploys a mutable tag

This fixture should produce CICD-SEC-9 artifact integrity findings.

## Review Context

- Artifact: container image `registry.example.com/payments-api`
- Build platform: GitHub Actions
- Evidence generated: cosign signature, SLSA provenance, CycloneDX SBOM
- Deployment target: Kubernetes production namespace
- Review conclusion: "CICD-SEC-9 passes because signing and SBOM generation exist"

## Bad Integrity Evidence

| Artifact | Build Run | Digest | Signature | Provenance | SBOM | Deployment Reference |
|---|---|---|---|---|---|---|
| `payments-api:latest` | `gha-run-8812` | `sha256:1111222233334444aaaabbbbccccdddd1111222233334444aaaabbbbccccdddd` | `cosign-8812.sig` | `slsa-8812.intoto.jsonl` | `payments-api-8812.cdx.json` | `deployment/prod.yaml` uses `payments-api:latest` |

## Gaps

- The production manifest deploys the mutable tag `payments-api:latest`, not the signed digest.
- The SBOM was generated from `gha-run-8811`, while the signature and provenance claim `gha-run-8812`.
- The admission controller is set to audit-only and does not block unsigned or mismatched images.
- No deployment evidence proves production pulled `sha256:1111222233334444aaaabbbbccccdddd1111222233334444aaaabbbbccccdddd`.
- A later retag changes `payments-api:latest` to `sha256:9999000011112222aaaabbbbccccdddd9999000011112222aaaabbbbccccdddd` without a new signature.

Expected findings:

- `PIPE-ART-04` because the SBOM is from a different build run.
- `PIPE-ART-05` because verification is audit-only and not enforced before deployment.
- `PIPE-ART-06` because the deployment uses a mutable tag while evidence is tied to another digest.
- `PIPE-ART-07` because promotion by tag permits digest drift.
- `PIPE-ART-08` because skipped enforcement lacks an owned exception and expiry.

Expected handling: require digest-based deployment, verify signature/provenance/SBOM for the same digest, enforce admission policy, and record any exception owner and expiry.
