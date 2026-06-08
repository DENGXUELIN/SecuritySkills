# Vulnerable: Hashed evidence kept on a mutable incident share

This fixture should produce immutable evidence storage findings even though the collection report contains SHA-256 hashes.

## Incident Context

- Incident ID: IR-2026-0614
- Matter: suspected privileged insider data staging on `filesrv-07`
- Evidence types: memory dump, disk image, firewall log export, SIEM search export
- Legal hold: requested by counsel, but not mapped to storage controls

## Evidence Storage Record

| Evidence ID | Artifact | Storage Location | Hash Status | Retention / Hold | Access | Audit Logging |
|---|---|---|---|---|---|---|
| EVD-0201 | `filesrv-07-memory.raw` | `\\corp-share\IR\2026-0614\` | SHA-256 recorded at acquisition | none | `Domain Admins`, `SOC-Analysts`, `Helpdesk-L2` | share access logging disabled |
| EVD-0202 | `filesrv-07-disk.E01` | same share | SHA-256 recorded at acquisition | inherited 30-day cleanup | same groups | share access logging disabled |
| EVD-0203 | firewall export CSV | ticket attachment | SHA-256 pasted in ticket | ticket retention unknown | ticket project members | ticket audit only tracks comments |
| EVD-0204 | SIEM export JSON | analyst laptop downloads folder | SHA-256 recorded before upload | none | local analyst account | no storage audit |

## Storage Control Gaps

- The network share allows overwrite and delete by all listed admin groups.
- The cleanup job removes incident folders older than 30 days unless a separate exemption is created.
- No S3 Object Lock, immutable blob policy, WORM media, offline sealed drive, or write blocker evidence is recorded.
- There is no legal hold flag or retention setting on the share or ticket attachments.
- The storage administrators include the same privileged operations team whose activity is under investigation.
- Reads, writes, deletes, retention changes, and access-policy changes are not sent to a separately protected log location.
- The KMS or file-encryption key owner is not recorded.
- Hashes were not re-verified after upload to the share, after the ticket attachment was downloaded, or before analysis.
- The report says "hashes prove preservation" and does not name a compensating control or risk owner.

Expected findings:

- `FOR-IMMUT-01` because the main evidence copy is on mutable share, ticket, and laptop storage.
- `FOR-IMMUT-02` because retention and legal hold are absent or shorter than the investigation need.
- `FOR-IMMUT-03` because custodian access is broad and includes operators in scope.
- `FOR-IMMUT-04` because lifecycle cleanup and admin delete paths can remove evidence.
- `FOR-IMMUT-05` because storage audit logging is missing or incomplete.
- `FOR-IMMUT-06` because encryption and key custody are unknown.
- `FOR-IMMUT-07` because independent post-upload and pre-analysis verification is missing.
- `FOR-IMMUT-08` because residual risk and compensating controls are not documented.

Expected handling: treat the evidence preservation posture as high risk, move artifacts to approved immutable storage, re-hash and reconcile manifests, restrict custodian access, enable protected audit logs, apply legal hold, and record a named risk owner for any evidence that cannot be re-preserved.
