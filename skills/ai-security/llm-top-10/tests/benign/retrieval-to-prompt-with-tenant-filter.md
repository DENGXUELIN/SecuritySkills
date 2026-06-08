# Benign: RAG retrieval crosses boundary with tenant filter and sink controls

This sample should not produce an LLM02 or LLM08 finding because the source-to-sink path includes the relevant controls.

## Scenario

- Category reviewed: LLM02 Sensitive Information Disclosure / LLM08 Vector and Embedding Weaknesses
- Entry point: tenant-scoped retrieval query
- Trust boundary: vector store results cross into prompt assembly
- Downstream sink: prompt context block sent to model

## Evidence excerpt

```yaml
owasp_category: "LLM02/LLM08"
entry_point_source: "retrieval query from authenticated user session"
trust_boundary: "vector store -> prompt assembly"
control_reviewed: "tenant_id and document_acl filters applied before similarity search; min_score=0.78"
downstream_sink: "context block in build_prompt()"
evidence_location: "rag/retriever.py:88 and tests/test_rag_acl.py::test_cross_tenant_docs_filtered"
result: "pass"
false_positive_checks: "Cross-tenant fixture attempted retrieval of tenant_b document from tenant_a session and returned zero chunks"
```

## Expected result

- Result: `Pass`
- Required non-finding: do not report cross-tenant RAG disclosure when tenant filtering, document ACL filtering, similarity thresholding, and a negative cross-tenant test are present.
- Required recommendation: keep the test tied to each retriever/query path when new vector collections or ingestion paths are added.
