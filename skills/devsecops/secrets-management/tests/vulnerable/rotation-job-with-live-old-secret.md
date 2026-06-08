# Vulnerable: Rotation job succeeds but old credential remains usable

This fixture should produce rotation validation findings without exposing actual secret values.

## Review Context

- Secret type: payment API key
- Store: AWS Secrets Manager
- Rotation method: Lambda rotation job with a 24-hour rollback window
- Rotation event: `SM-ROT-2026-0609-01`
- Review conclusion: "rotation completed successfully"

## Evidence Provided

| Item | Evidence |
|---|---|
| Rotation job | `SM-ROT-2026-0609-01` succeeded at `2026-06-09T00:15:00Z` |
| New version | alias `AWSCURRENT` points to `version-2026-0609` |
| Consumers | `checkout-api`, `refund-worker`, `billing-cron` listed in the architecture diagram |
| Monitoring | rotation Lambda logs only |

## Missing or Bad Validation

- `refund-worker` was not redeployed and still uses a cached old version.
- Old credential disablement is marked "defer until no errors" with no closure timestamp.
- No old credential test proves the previous version is denied.
- No new credential test is recorded for `billing-cron`.
- Monitoring checks only the rotation job, not downstream authentication errors or fallback use.
- A later log shows `refund-worker` authenticating through the rollback credential after the rollback window should have closed.

Expected findings:

- `SEC-ROT-03` because consumer adoption is incomplete.
- `SEC-ROT-04` because old credential revocation is missing after the rollover window.
- `SEC-ROT-05` because old credential validation is missing and later evidence shows old access still works.
- `SEC-ROT-06` because the new credential was not tested for every required consumer.
- `SEC-ROT-07` because post-rotation monitoring does not cover fallback or consumer auth failures.

Expected handling: mark the rotation incomplete, close the rollback window, revoke the old version, redeploy or refresh all consumers, test old and new credential behavior, and record monitoring evidence.
