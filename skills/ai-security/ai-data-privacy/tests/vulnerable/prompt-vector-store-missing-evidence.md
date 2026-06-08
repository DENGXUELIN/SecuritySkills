# Vulnerable: AI data flow lacks processing evidence

This sample should fail the AI Data Processing Evidence Matrix even though a data-flow diagram exists.

## Scenario

- System: customer support assistant
- Flow: user prompt -> prompt log -> embedding -> vector store -> third-party LLM provider
- Data subjects: customers
- Data type: support messages containing names, email addresses, account IDs, and purchase history

## Evidence excerpt

```yaml
flow_store: "support prompt logs and vector embeddings"
data_type_subjects: "customer support text with PII"
processing_purpose: "support assistant and analytics"
legal_basis_consent: ""
dpa_transfer_proof: ""
provider_region: "unknown third-party LLM provider"
retention_period: "per privacy policy"
retention_enforcement: ""
deletion_propagation: "delete from application database only"
controls_evidence: "architecture diagram says data is protected"
result: "pass"
```

## Expected result

- Result: `Fail`
- Required finding: legal basis/consent evidence is missing, provider and region are unknown, retention enforcement is not tied to code/config, deletion does not propagate to prompt logs/vector stores/provider data, and controls are asserted only by a diagram.
- Required recommendation: do not mark the flow as compliant until evidence is attached for legal basis, DPA/transfer, provider region, retention TTL/purge, deletion propagation, and controls.
