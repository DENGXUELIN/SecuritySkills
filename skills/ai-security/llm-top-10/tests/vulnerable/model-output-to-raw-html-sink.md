# Vulnerable: model output crosses into raw HTML renderer

This sample should produce an LLM05 finding because the source-to-sink path is concrete and lacks an output handling control.

## Scenario

- Category: LLM05 Improper Output Handling
- Entry point: user prompt plus retrieved support article
- Trust boundary: model output crosses from untrusted provider response into browser-rendered HTML
- Downstream sink: React `dangerouslySetInnerHTML`

## Evidence excerpt

```yaml
owasp_category: LLM05
entry_point_source: "model completion from support assistant"
trust_boundary: "LLM provider response -> web client renderer"
control_reviewed: "No sanitizer or markdown safe-list before HTML rendering"
downstream_sink: "dangerouslySetInnerHTML in ChatAnswer.tsx"
evidence_location: "src/components/ChatAnswer.tsx:42"
result: "fail"
false_positive_checks: "No DOMPurify, no markdown HTML stripping, no allowlisted response schema"
```

## Expected result

- Result: `Fail`
- Required finding: model output is untrusted data and is rendered as raw HTML without sanitization.
- Required remediation: render as text or sanitize/allowlist markdown output before it reaches the HTML sink.
