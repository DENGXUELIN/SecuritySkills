# Benign: Attested Model Artifact Verification

## Scenario

The model release pipeline verifies every production artifact before promoting it to the managed inference endpoint.

## Artifact Verification Evidence

| Model | Artifact | Source | Revision | SHA-256 | Signature/Attestation | Trust Root | Independent Verification Source | Verifier/Time | Deployment Binding | Result |
|---|---|---|---|---|---|---|---|---|---|---|
| fraud-bert | `model.safetensors` | `registry.internal/ml/fraud-bert` | OCI digest `sha256:6f1d4c2a9e8b7d6c5a4f3e2d1c0b9a887766554433221100ffeeddccbbaa9988` | `6f1d4c2a9e8b7d6c5a4f3e2d1c0b9a887766554433221100ffeeddccbbaa9988` | cosign bundle `rekor://uuid/fraud-bert-2026-06-01` | Fulcio cert for `release-bot@acme.example`; Rekor log inclusion proof | Internal first-ingest manifest `MIRROR-2026-0601` plus signed release notes | Release pipeline `ml-release-4412` at 2026-06-01T10:18:00Z | Endpoint `fraud-prod-v3`, image digest `sha256:5b48d0c2e91a7a4b8a1fbb6cc21a77c7c0dff44112233445566778899aabbccd` | Pass |
| fraud-bert | `tokenizer.json` | `registry.internal/ml/fraud-bert` | OCI digest `sha256:6f1d4c2a9e8b7d6c5a4f3e2d1c0b9a887766554433221100ffeeddccbbaa9988` | `31f9c6f2c4e7d3a1b8c0aab14499887766554433221100ffeeddccbbaa998877` | in-toto attestation `attestations/fraud-bert-tokenizer-2026-06-01.intoto.jsonl` | Internal model registry signing policy `POL-ML-REG-12` | First-ingest manifest `MIRROR-2026-0601` | Release pipeline `ml-release-4412` at 2026-06-01T10:18:00Z | Endpoint `fraud-prod-v3` | Pass |
| fraud-bert | `config.json` | `registry.internal/ml/fraud-bert` | OCI digest `sha256:6f1d4c2a9e8b7d6c5a4f3e2d1c0b9a887766554433221100ffeeddccbbaa9988` | `42bb9efcc0a11223344556677889900aabbccddeeff0011223344556677889900` | in-toto attestation `attestations/fraud-bert-config-2026-06-01.intoto.jsonl` | Internal model registry signing policy `POL-ML-REG-12` | First-ingest manifest `MIRROR-2026-0601` | Release pipeline `ml-release-4412` at 2026-06-01T10:18:00Z | Endpoint `fraud-prod-v3` | Pass |

## Expected Review Result

The skill should treat the artifact verification as reproducible because `MSC-ART-01` through `MSC-ART-08` are satisfied: exact artifact identity, immutable revision, digests, signature or attestation, trust root, independent verification source, verifier/time, deployment binding, and result are recorded.
