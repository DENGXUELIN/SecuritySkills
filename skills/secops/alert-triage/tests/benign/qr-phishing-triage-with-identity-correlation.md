# Benign Fixture: QR Phishing Triage With Identity Correlation

## Scenario

A security team triages an image-only voicemail lure delivered through email. The analyst safely extracts the visual payload, decodes the QR destination, scopes recipients, and correlates follow-on identity activity before assigning disposition.

## Evidence Presented

```json
{
  "alert_id": "mail-qr-2026-06-08-07",
  "message_id": "<secure-voicemail-188@example.invalid>",
  "artifact": {
    "type": "png",
    "sha256": "82d8a1c4ff59791ddf1bb23e2b7713e2b3aa4c81e0f3e0d7e4315c64e0d7a1d9",
    "stored_in_case": true
  },
  "visual_extraction": {
    "safe_render_run_id": "sandbox-render-441",
    "ocr_text": "Scan to review encrypted voicemail",
    "decoded_qr": "hxxps://login-example.invalid/m365",
    "expanded_final_domain": "login-example.invalid",
    "reputation": "newly_registered_domain"
  },
  "delivery_scope": {
    "recipient_count": 214,
    "same_hash_messages": 214,
    "quarantined_count": 214
  },
  "interaction_evidence": {
    "url_rewrite_clicks": 0,
    "idp_signins_after_delivery": [
      {
        "user": "finance.user@example.invalid",
        "device": "unmanaged_mobile",
        "asn_change": true,
        "mfa_prompt": "suspicious"
      }
    ],
    "proxy_or_dns_seen": "not_expected_for_unmanaged_mobile"
  },
  "disposition": "True Positive",
  "priority": "P2",
  "containment": [
    "quarantine delivered copies",
    "block decoded final domain",
    "reset affected session",
    "notify identity team"
  ]
}
```

## Expected Result

Treat this as a complete QR/visual phishing triage. The evidence satisfies `QR-PHISH-01` through `QR-PHISH-08`: original artifact preservation, safe extraction, decoded destination analysis, recipient scoping, cross-device identity correlation, and containment are documented before disposition.
