# Vulnerable Fixture: Remote Code and Unverified Final Bundle

## Scenario

A production inference container loads a custom model with remote repository code
enabled, then serves a quantized bundle and chat template that are not covered by
the base model's provenance evidence.

## Code Under Review

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

MODEL_ID = "research-lab/custom-architecture-llm"

model = AutoModelForCausalLM.from_pretrained(
    MODEL_ID,
    revision="main",
    trust_remote_code=True,
)

tokenizer = AutoTokenizer.from_pretrained(
    MODEL_ID,
    revision="main",
    trust_remote_code=True,
)
```

```dockerfile
FROM ollama/ollama:latest
RUN ollama pull hf.co/unverified-org/customer-support-model:Q4_K_M
COPY Modelfile /models/customer-support/Modelfile
```

```text
FROM hf.co/unverified-org/customer-support-model:Q4_K_M
TEMPLATE "{{ .System }}\n{{ .Prompt }}"
```

## Expected Finding

- Category: Remote Code Loading / Final Artifact Composition
- Severity: Critical for unpinned `trust_remote_code=True`
- Severity: High for missing final bundle manifest
- Evidence: no immutable revision, no code-review provenance for remote model
  code, and no manifest covering quantized weights, tokenizer assets, chat
  template, Modelfile, and runtime config.

## Why This Should Trigger

The deployment trusts executable repository code during model and tokenizer load.
It also verifies neither the final quantized artifact nor the served prompt
template. A verified base model would not cover the actual served bundle.
