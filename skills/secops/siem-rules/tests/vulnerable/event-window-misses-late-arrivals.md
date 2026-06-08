# Vulnerable: Event-Time Window Misses Late Arrivals

## Scenario

A password spray rule runs every 5 minutes with a 5 minute event-time query period.

## Rule Fragment

```kql
let threshold_accounts = 10;
SigninLogs
| where TimeGenerated > ago(5m)
| where ResultType == "50126"
| summarize DistinctAccounts = dcount(UserPrincipalName) by IPAddress, bin(TimeGenerated, 5m)
| where DistinctAccounts >= threshold_accounts
```

## Source Latency Evidence

```text
Connector: Azure AD SigninLogs
Measured ingestion delay during peak load:
  p50: 3m
  p95: 11m
  p99: 16m
Clock skew tolerance: not documented
Deduplication: none
```

## Late Events

```text
Event Time           Ingestion Time       IP
2026-06-08 12:00:10  2026-06-08 12:10:40  203.0.113.10
2026-06-08 12:01:02  2026-06-08 12:11:05  203.0.113.10
2026-06-08 12:03:41  2026-06-08 12:13:12  203.0.113.10
```

## Expected Skill Behavior

The SIEM review should flag this rule as likely to miss delayed password spray events.

Required findings:

- `SIEM-TIME-01` should identify `TimeGenerated` as the event-time field.
- `SIEM-TIME-02` should fail because `ingestion_time()` is not used or measured in the rule.
- `SIEM-TIME-03` should require p95/p99 latency evidence in the rule design.
- `SIEM-TIME-04` should fail because the query period equals rule frequency despite p95 latency above 5 minutes.
- `SIEM-TIME-05` should require deduplication before extending the lookback.
- `SIEM-TIME-06` should require clock-skew and timezone normalization evidence.
- `SIEM-TIME-07` should preserve event time for the spray sequence.
- `SIEM-TIME-08` should require backfill behavior for delayed connector ingestion.

## Correct Classification

P2 High detection reliability gap until latency-aware lookback and deduplication are implemented.
