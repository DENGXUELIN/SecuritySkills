# Vulnerable: Timeline built from ingestion time and unknown clock skew

This fixture should produce timestamp normalization findings.

## Incident Context

- Incident ID: IR-2026-0612
- Systems: `web-01`, `idp.example.com`, SIEM export, collector workstation
- Collector workstation clock: not recorded before acquisition
- Timeline conclusion: "user logged in after web shell execution"

## Evidence Sources

### EVD-0001: web-01 auth log

- Source timezone: local time, timezone not recorded
- Source clock value at acquisition: not recorded
- Time sync source: unknown
- Event shown in report: `2026-06-12 02:15:03 login accepted`

### EVD-0002: SIEM export

- Timestamp field used in report: `ingestion_time`
- Event time field available: `event_time`
- Processing time field available: `processing_time`
- Ingestion lag: unknown
- Export timezone: UTC

### EVD-0003: IdP SaaS audit export

- Provider event time: UTC
- Export time: `2026-06-12T03:00:00Z`
- Report treats export time as user action time

## Timeline Mistake

The investigation report sorts:

1. web shell process at `2026-06-12T02:13:00Z`
2. SIEM `ingestion_time` for login at `2026-06-12T02:18:00Z`
3. IdP export time at `2026-06-12T03:00:00Z`

The report concludes that the login happened after web shell execution, but it does not record source timezone, source clock, collector clock, clock offset, ingestion lag, or the distinction between event time and export time.

Expected findings:

- `FOR-TIME-01` because `web-01` timezone and UTC offset are missing.
- `FOR-TIME-02` because the collector clock was not recorded before acquisition.
- `FOR-TIME-03` because ingestion/export time is mixed with event time.
- `FOR-TIME-05` and `FOR-TIME-06` because unknown clock skew is ignored while making a sequence-of-events conclusion.

Expected handling: preserve original timestamps, create a derived UTC timeline, and downgrade timeline confidence until clock skew and timestamp semantics are documented.
