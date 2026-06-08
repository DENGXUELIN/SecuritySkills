# Vulnerable Fixture: QR PDF Closed Without Visual Extraction

## Scenario

A reported payroll-themed email contains a PDF attachment with no text URLs in the body. The gateway delivered the message, and the analyst closes the alert as a false positive because URL rewriting logs show no clicks.

## Evidence Presented

```json
{
  "alert_id": "mail-qr-2026-06-08-01",
  "rule_name": "Suspicious email reported",
  "message_id": "<payroll-update-944@example.invalid>",
  "body_urls": [],
  "attachment": {
    "filename": "payroll_update.pdf",
    "sha256": "2e7d2c03a9507ae265ecf5b5356885a53393a2029d241394997265a1a25aefc6",
    "mime_type": "application/pdf"
  },
  "gateway_result": "delivered",
  "url_rewrite_clicks": 0,
  "initial_disposition": "False Positive",
  "reason": "No text URL and no click telemetry."
}
```

## Missing Evidence

- No safe-rendered screenshot or PDF page extraction was preserved.
- No OCR or QR decoding was performed.
- No decoded URL, shortened URL expansion, redirect chain, or final domain was recorded.
- No recipient scope was checked for the same attachment hash.
- No IdP/MFA/mobile sign-in correlation was reviewed after delivery.
- No containment decision covered delivered copies or decoded destinations.

## Expected Finding

Treat the closure as unsafe. The triage fails `QR-PHISH-01` through `QR-PHISH-08`: absent text URLs and rewritten-click telemetry do not prove no interaction for QR phishing. The alert should remain Unknown/Needs Investigation until visual extraction, destination analysis, recipient scoping, and follow-on identity correlation are complete.
