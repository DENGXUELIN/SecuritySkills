# Benign: Derived UTC timeline with documented skew and timestamp semantics

This fixture should avoid false positives when timestamp normalization is documented and original evidence remains unchanged.

## Incident Context

- Incident ID: IR-2026-0613
- Systems: `web-02`, Entra ID audit export, SIEM export, collector workstation
- Collector workstation clock: `2026-06-13T09:00:00Z`, synchronized to `time.cloudflare.com`, drift under 1 second
- Original evidence files: stored read-only with SHA-256 hashes before analysis
- Derived timeline: separate `timeline-normalized-utc.csv`

## Time Source Records

| Evidence ID | Source | Source Time Zone | Source Clock Value | Collector Clock Value | Observed Offset | Time Sync Source | Timestamp Fields | Normalization Applied | Confidence |
|---|---|---|---|---|---|---|---|---|---|
| EVD-0101 | `web-02` auth log | America/New_York UTC-04:00 | `2026-06-13 04:57:11 -0400` | `2026-06-13T09:00:00Z` | +37 seconds | domain controller NTP | `event_time` | derived UTC copy only | high |
| EVD-0102 | Entra ID audit | UTC | provider event time from API | `2026-06-13T09:01:00Z` | provider-managed | cloud provider | `activityDateTime`, `export_time` | `activityDateTime` used; export time preserved separately | high |
| EVD-0103 | SIEM export | UTC | provider event time from event payload | `2026-06-13T09:02:00Z` | ingestion lag 94 seconds | SIEM managed NTP | `event_time`, `ingestion_time`, `processing_time` | event time used for ordering; ingestion time retained | medium |

## Timeline Handling

- Original timestamps in all source files are unchanged.
- The normalized timeline stores `normalized_utc`, `original_timestamp`, `source_timezone`, `clock_offset_seconds`, `timestamp_field_used`, and `confidence`.
- Sequence-of-events conclusion states: "The web login likely preceded the process execution by 41-45 seconds after applying the documented +37 second source clock offset."
- The report separately notes that SIEM ingestion lag is not used as the event order source.

Expected outcome:

- Do not flag local timezone usage because UTC offset, collector clock, and skew are documented.
- Do not flag SIEM ingestion time because it is preserved but not used as event time.
- Do not flag timestamp normalization because original evidence is unchanged and the UTC timeline is a derived artifact with confidence notes.
