# Benign Fixture: OpenTelemetry Trace-Log Correlation Evidence

## Scenario

A SOC analyst investigates a suspected credential stuffing burst against a
checkout service. Logs, traces, and backend spans all carry normalized
OpenTelemetry context, and the analyst validates both positive and negative
joins before using the trace pivot in the incident timeline.

## Evidence Snapshot

| Field | Value |
|---|---|
| Analysis window | `2026-06-01T14:00:00Z` to `2026-06-01T14:30:00Z` |
| Application service | `checkout-api` |
| Trace field source | Native OpenTelemetry log records |
| Identifiers present | `TraceId`, `SpanId`, `TraceFlags`, W3C `traceparent` |
| Resource attributes | `service.name=checkout-api`, `service.namespace=payments`, `deployment.environment=prod` |
| Trace sampling | Tail sampling keeps all 4xx/5xx and auth-failure traces for 14 days |
| Semantic attributes | `http.request.method`, `http.route`, `http.response.status_code`, `server.address`, `db.system` |
| Vendor mapping | Legacy `trace_id` field is mapped to OpenTelemetry `TraceId` in the parser config |
| Join validation | Known-positive `TraceId=4bf92f3577b34da6a3ce929d0e0e4736` joins log error, API span, and database span |
| Negative validation | Unrelated `TraceId=7d9c2f0e8c1346bd8f97c9a106c2d44a` does not join to the incident user or route |
| Timing basis | Logs and spans use event time from NTP-synchronized hosts; max skew observed is 800 ms |
| Correlation confidence | High, with no unresolved missing-context reasons |

## Positive Controls

- `OTEL-CORR-01`: Logs include native `TraceId` and `SpanId`.
- `OTEL-CORR-02`: Sampling and retention preserve the relevant error/security traces.
- `OTEL-CORR-03`: Resource attributes match between logs and spans.
- `OTEL-CORR-04`: Legacy trace fields have a documented OpenTelemetry mapping.
- `OTEL-CORR-05`: HTTP and database semantic attributes support the investigation.
- `OTEL-CORR-06`: Known-positive and known-negative join tests were performed.
- `OTEL-CORR-07`: Clock skew and event-time handling are documented.
- `OTEL-CORR-08`: The report assigns High confidence with evidence backing it.

## Expected Result

Do not flag the trace pivot as unsupported. Any remaining finding should focus
on the credential stuffing activity or application defense gaps, not on missing
OpenTelemetry trace-log correlation evidence.
