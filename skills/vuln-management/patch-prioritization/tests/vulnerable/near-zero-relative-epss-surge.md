# Vulnerable: near-zero relative EPSS spike escalated as Surging

This fixture should be flagged by the skill because the relative EPSS increase is
large but the current probability and absolute delta remain below the default
trend policy floors. A review should classify this as `Low-baseline Monitor`,
not `Surging`, and should not change the SSVC-driven SLA from trend alone.

```yaml
finding:
  cve: CVE-2099-0001
  asset: dev-mirror-02
  environment: development
  exposure: internal
  business_criticality: low
  cisa_kev: false
  public_poc: false
  active_exploitation_evidence: false
  ssvc_decision: Scheduled
  epss:
    source_date: 2099-03-01
    score_30_days_ago: 0.0005
    current_score: 0.0016
    absolute_delta_30d: 0.0011
    relative_delta_30d: 220
    current_percentile: low
    percentile_movement: minimal
    history_status: complete
```

Expected handling:

- Trend: `Low-baseline Monitor`
- SLA impact: keep the existing SSVC-driven SLA
- Report note: relative EPSS change is high, but current probability, absolute
  delta, and percentile movement remain below policy floors.
