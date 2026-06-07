# Benign Fixture: Signed Internal Mirror with Final Bundle Manifest

## Scenario

An internal model registry mirrors an upstream model only after a controlled
promotion workflow. The deployment pins the upstream revision, verifies a signed
in-toto/SLSA import attestation, and checks a final bundle manifest before
serving.

## Code Under Review

```python
from huggingface_hub import snapshot_download
from acme_model_security import verify_bundle_manifest, verify_intoto_attestation

UPSTREAM_REVISION = "0f3c9b2d1b7f4b1d7b0f4e8e9b8e3a3bb4f9c012"
SUBJECT_DIGEST = "sha256:4b7d1f9b9efc9a2f7e6e2a3328b36b227f0aa7da6a1a3fd3c5f5c7182d8b1d10"

model_dir = snapshot_download(
    repo_id="acme-internal-mirror/mistral-7b-instruct-v0.3",
    revision=UPSTREAM_REVISION,
    allow_patterns=[
        "*.safetensors",
        "adapter_model.safetensors",
        "config.json",
        "tokenizer.json",
        "tokenizer_config.json",
        "chat_template.jinja",
        "bundle-manifest.json",
    ],
)

verify_intoto_attestation(
    attestation_path=f"{model_dir}/import.intoto.jsonl",
    upstream_revision=UPSTREAM_REVISION,
    subject_digest=SUBJECT_DIGEST,
    trusted_builder="acme-model-promotion@v2",
)

verify_bundle_manifest(
    manifest_path=f"{model_dir}/bundle-manifest.json",
    required_subjects=[
        "model-00001-of-00004.safetensors",
        "adapter_model.safetensors",
        "tokenizer.json",
        "tokenizer_config.json",
        "chat_template.jinja",
        "config.json",
    ],
)
```

## Expected Classification

- No High finding solely because the source is an internal mirror.
- Accept the mirror as lower risk when the reviewer can verify all of:
  immutable upstream revision, signed promotion attestation, trusted builder,
  restricted registry writers, and deployment-time digest checks for the final
  served bundle.

## Why This Should Not Trigger the Mirror False Positive

The risk is not decided only by whether the publisher is the original upstream
organization. The signed promotion path and final manifest bind the served
weights, adapter, tokenizer, chat template, and config to a reviewed source.
