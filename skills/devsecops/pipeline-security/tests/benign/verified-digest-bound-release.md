# Benign: Release verifies digest-bound signature, provenance, and SBOM

This fixture should avoid CICD-SEC-9 artifact integrity findings because all integrity evidence is bound to the same digest and enforced before deployment.

## Review Context

- Artifact: container image `registry.example.com/orders-api`
- Build platform: GitHub Actions hosted runner
- Build run: `gha-run-9914`
- Deployment target: Kubernetes production namespace
- Review date: `2026-06-09`

## Artifact Integrity Evidence

| Artifact | Build Run | Digest | Signature | Signing Identity | Provenance | SBOM | Verification Command | Verification Result | Deployment Reference | Exception / Owner |
|---|---|---|---|---|---|---|---|---|---|---|
| `registry.example.com/orders-api` | `gha-run-9914` | `sha256:aaaabbbbccccdddd1111222233334444aaaabbbbccccdddd1111222233334444` | `cosign-bundle-9914` | `repo:unitone/orders-api:ref:refs/heads/main` | `slsa-9914.intoto.jsonl` bound to same digest | `orders-api-9914.spdx.json` bound to same digest | `cosign verify-attestation` plus admission policy `kyverno-verify-orders` | Pass | `prod/orders-api.yaml` uses the same digest | N/A |

## Review Notes

- The deployment manifest uses the exact OCI digest, not a mutable tag.
- Signature, provenance, SBOM, and deployment all reference the same digest and build run.
- The signing identity matches the trusted repository and protected branch.
- The admission policy blocks deployment when signature, provenance, or digest binding fails.
- No integrity exception is open.

Expected outcome:

- Do not flag `PIPE-ART-01` because an immutable digest is recorded and deployed.
- Do not flag `PIPE-ART-02` or `PIPE-ART-03` because signature and provenance are present and bound to the digest.
- Do not flag `PIPE-ART-04` because the SBOM references the same build and digest.
- Do not flag `PIPE-ART-05` because verification is enforced before deployment.
- Do not flag `PIPE-ART-06` or `PIPE-ART-07` because promotion keeps the digest stable.
- Do not flag `PIPE-ART-08` because there is no failed or skipped verification exception.
