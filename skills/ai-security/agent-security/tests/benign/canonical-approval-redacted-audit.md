# Benign: canonical approval artifact with privacy-preserving audit evidence

This fixture should not be flagged as missing auditability just because raw
prompts and chain-of-thought are not retained. It should be treated as a strong
HITL and audit design because the approval is bound to a canonical executable
artifact, replay protection is present, and logs retain redacted security
context.

```yaml
approval_artifact:
  approval_id: appr_20260607_001
  tool_call_id: call_73e5
  tool_name: crm.update_customer_note
  canonical_args_sha256: 7ab1d2e0b62f7c2b6b6c57b23c0b7568d8f4e827a3c1b08e3d74e19936af2f21
  resource_ids:
    - customer:cus_1842
  risk_tier: medium
  policy_decision_hash: 4bb5e191d73c4f4c8976cfb4c22f7eac2e75fef1b912bf9259aa319813bbf2a4
  expires_at: "2026-06-07T11:15:00Z"
  nonce: "7b0d0c2f-65d4-4568-8f46-b437f89a18b3"
  one_time_use: true
  signed_by: approvals.example.internal

audit_event:
  agent_id: support-agent-prod-04
  user_id: employee_317
  prompt_hash: 0dfbf42bb94f8fd2ff6a8b0f4e946a7f3b6557a3dc6cf83acb254c6f8d2364d4
  retrieved_document_ids:
    - policy:refunds-v3
    - ticket:helpdesk-9441
  redacted_tool_parameters:
    customer_email: "[redacted]"
    note_body_hash: 5a898c5fb0f24d68f23fc3a1e42c9cf961fe6f8e9d68ac962a4f096fbf2781bf
  approval_artifact_id: appr_20260607_001
  policy_trace_id: trace_8bb3
  immutable_sink: cloud-logging-worm
```

Expected handling:

- Do not require raw prompt or chain-of-thought retention.
- Treat the design as acceptable if the executor verifies the artifact signature,
  canonical args hash, resource IDs, expiry, nonce, and one-time-use state before
  invoking the tool.
- Flag only if later evidence shows the executor can ignore or mutate the
  approved artifact.
