# Benign: AI provider flow has legal, retention, deletion, and control evidence

This sample should pass the AI Data Processing Evidence Matrix for the reviewed flow.

## Scenario

- System: customer support assistant
- Flow: redacted user prompt -> zero-retention LLM provider -> response filter -> short-lived audit log
- Data subjects: customers
- Data type: support messages after PII redaction

## Evidence excerpt

```yaml
flow_store: "redacted support prompt sent to LLM provider"
data_type_subjects: "customer support text after PII redaction"
processing_purpose: "generate support response for active customer ticket"
legal_basis_consent: "contract necessity documented in DPIA-AI-042; AI disclosure accepted at ticket creation"
dpa_transfer_proof: "DPA-LLM-2026 with SCC module 2; provider training disabled"
provider_region: "Azure OpenAI, East US, no cross-region storage"
retention_period: "0 days provider retention; 14 days internal redacted audit log"
retention_enforcement: "provider zero-retention setting screenshot ZDR-2026-06-08; audit_log_ttl_days=14 in config/privacy.yml"
deletion_propagation: "DSAR job dsar_ai_delete removes ticket prompts, vector references, audit log rows, and provider request IDs"
controls_evidence: "Presidio redaction test pii-redact-118 passed; tenant ACL test rag-acl-2026-06 passed; output PII filter enabled"
result: "pass"
```

## Expected result

- Result: `Pass`
- Required non-finding: do not flag this flow as missing processing evidence because legal basis, consent/disclosure, DPA/transfer proof, provider/region, retention enforcement, deletion propagation, and controls evidence are all present.
- Required recommendation: continue monitoring provider retention settings and DSAR job coverage when the provider, region, logging path, or vector-store design changes.
