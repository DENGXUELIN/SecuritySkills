# Vulnerable: Mutable Model Artifact With Self-Referential Checksum

## Scenario

The inference service downloads a production fraud model from a public model registry during container startup.

## Model Inventory

| Model | Source | Format | Checksum Verified | Pinned Version | Model Card |
|---|---|---|---|---|---|
| fraud-bert | `https://modelhub.example.com/acme/fraud-bert` | safetensors | Yes | No, uses `main` | Partial |

## Verification Notes

The deployment script downloads `model.safetensors`, `tokenizer.json`, and `config.json` from the same mutable registry path, then downloads `SHA256SUMS` from that same path. No signed release, attestation service, transparency log, or first-ingest internal registry record is checked.

## Missing Evidence

- `MSC-ART-02`: no immutable commit, object version, release tag, or registry digest is recorded.
- `MSC-ART-03`: tokenizer and config digests are not recorded.
- `MSC-ART-04`: no signature, Sigstore/cosign entry, SLSA provenance, or in-toto attestation is linked.
- `MSC-ART-05`: no trusted key, certificate identity, transparency log, or publisher identity is identified.
- `MSC-ART-06`: the checksum comes from the same mutable source as the artifact.
- `MSC-ART-07`: no verifier, timestamp, or verification command is recorded.
- `MSC-ART-08`: no evidence proves that the verified digest is the one deployed to production.

## Expected Review Result

The skill should not treat `Checksum Verified: Yes` as sufficient. The artifact verification result should be `Unknown` or `Fail` because the revision is mutable and the checksum source is self-referential.
