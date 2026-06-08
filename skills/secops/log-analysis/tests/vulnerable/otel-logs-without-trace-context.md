# Vulnerable Fixture: OpenTelemetry Logs Without Trace Context

## Scenario

A SOC analyst investigates suspicious checkout failures in a microservice
platform. The application logs include ad hoc request IDs, but the team claims
the events are correlated to traces without proving OpenTelemetry trace context,
sampling, resource attributes, or semantic attributes.

## Evidence Snapshot

| Field | Value |
|---|---|
| Analysis window | `2026-06-01T14:00:00Z` to `2026-06-01T14:30:00Z` |
| Application service | `checkout-api` |
| Log field used for pivot | `request_id=req-88a7` |
| Native OpenTelemetry fields | Missing `TraceId`, `SpanId`, and `TraceFlags` |
| Vendor mapping | None documented for `request_id` to OpenTelemetry trace context |
| Trace sampling | Head sampling at 5 percent, no exception for error/security events |
| Resource attributes | Logs say `service.name=checkout`, traces say `service.name=payments-api` |
| Environment context | Logs say `deployment.environment=prod`, trace explorer defaults to `staging` |
| Semantic attributes | Missing `http.route`, `http.request.method`, `server.address`, and `db.system` |
| Join validation | No known-positive trace-log join test; no known-negative rejection test |
| Timing basis | Log timestamps are ingest time; spans use host event time with unknown skew |
| Reported confidence | "Confirmed correlated" with no missing-context reasons |

## Problem Indicators

- `OTEL-CORR-01`: Logs lack `TraceId` and `SpanId`, and no vendor mapping exists.
- `OTEL-CORR-02`: Sampled-away spans are possible but not treated as expected gaps.
- `OTEL-CORR-03`: Resource attributes disagree across logs and spans.
- `OTEL-CORR-04`: Non-OTLP fields are not normalized to OpenTelemetry fields.
- `OTEL-CORR-05`: Security-relevant semantic attributes are absent.
- `OTEL-CORR-06`: The report lacks known-positive and known-negative join evidence.
- `OTEL-CORR-07`: Timestamp and clock-skew handling are not documented.
- `OTEL-CORR-08`: Correlation confidence is overstated without evidence-gap reasons.

## Expected Finding

Classify the correlation as **Low confidence**. The analyst may keep the
request-ID timeline as a lead, but the report must not claim trace-log
correlation until OpenTelemetry identifiers, resource consistency, sampling
expectations, semantic attributes, and join validation are collected.

## Required Remediation

Instrument logs with OpenTelemetry trace context, document vendor-field
normalization, align resource attributes, preserve error/security spans or mark
sampled gaps, verify required semantic attributes, and add known-positive plus
known-negative join tests before reporting trace correlation.
