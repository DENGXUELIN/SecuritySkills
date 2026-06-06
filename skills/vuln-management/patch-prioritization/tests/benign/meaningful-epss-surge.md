# Benign: meaningful EPSS trend qualifies for Surging review

This fixture should not be suppressed as a low-baseline artifact. The absolute
delta is meaningful, current EPSS is above the default Surging floor, and the
finding has exposure and exploitability context that can support out-of-cycle
patching when SSVC agrees.

```yaml
finding:
  cve: CVE-2099-0002
  asset: customer-api-01
  environment: production
  exposure: internet-facing
  business_criticality: high
  cisa_kev: false
  public_poc: true
  active_exploitation_evidence: false
  ssvc_decision: Out-of-Cycle
  epss:
    source_date: 2099-03-01
    score_30_days_ago: 0.06
    current_score: 0.31
    absolute_delta_30d: 0.25
    relative_delta_30d: 416.7
    current_percentile: high
    percentile_movement: rising
    history_status: complete
```

Expected handling:

- Trend: `Surging`
- SLA impact: recommend out-of-cycle review only with SSVC, exposure, exploit
  intelligence, asset criticality, or local policy support
- Report note: current probability and absolute delta meet the default trend
  floor, so this is not a near-zero relative-growth artifact.
