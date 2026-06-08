# Benign: Latency-Aware Window With Deduplication

## Scenario

A Sentinel password spray rule runs every 5 minutes and intentionally searches a 20 minute arrival window with event-time grouping.

## Rule Fragment

```kql
let rule_frequency = 5m;
let latency_buffer = 15m;
let detection_window = 10m;
SigninLogs
| where ingestion_time() > ago(rule_frequency + latency_buffer)
| where TimeGenerated > ago(detection_window + latency_buffer)
| where ResultType == "50126"
| extend IngestionDelay = ingestion_time() - TimeGenerated
| summarize
    DistinctAccounts = dcount(UserPrincipalName),
    FirstEventTime = min(TimeGenerated),
    LastEventTime = max(TimeGenerated),
    MaxIngestionDelay = max(IngestionDelay)
    by IPAddress, EventTimeBucket = bin(TimeGenerated, detection_window)
| where DistinctAccounts >= 10
| extend AlertKey = strcat(IPAddress, ":", tostring(EventTimeBucket))
```

## Evidence

```text
Event-time field: TimeGenerated
Ingestion-time field: ingestion_time()
Latency measurement date: 2026-06-01
p50/p95/p99: 2m / 9m / 14m
Clock skew tolerance: 2m, source timestamps normalized to UTC
Lookback buffer: 15m
Deduplication: IPAddress + 10m event-time bucket + rule ID
Backfill: connector outage replay suppresses duplicate alert keys and sends replay summary to SOC lead
```

## Expected Skill Behavior

The SIEM review should not flag this as a late-arrival blind spot.

Required satisfied gates:

- `SIEM-TIME-01` documents `TimeGenerated` as event time.
- `SIEM-TIME-02` documents `ingestion_time()` as arrival time.
- `SIEM-TIME-03` documents p50/p95/p99 latency.
- `SIEM-TIME-04` uses a 15 minute buffer that covers measured p99 and skew.
- `SIEM-TIME-05` defines a deduplication key for overlapping windows.
- `SIEM-TIME-06` documents UTC normalization and clock skew.
- `SIEM-TIME-07` uses event time for sequence/window grouping.
- `SIEM-TIME-08` defines backfill/outage replay behavior.

## Correct Classification

Pass for late-arrival handling, subject to periodic latency remeasurement.
