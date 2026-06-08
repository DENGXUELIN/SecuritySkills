# Benign: Vault-Scoped Credentials with Auth Denominator Evidence

## Scenario

A Qualys VMDR policy scans production Windows and Linux servers with dedicated per-platform service principals retrieved from CyberArk at runtime.

## Evidence

- Credential source: CyberArk Vault/PAM checkout with 4 hour TTL and immutable audit log
- Windows credential: `PROD\svc-vmdr-win-read`, local admin only on approved server groups
- Linux credential: SSH key for `svc-vmdr-linux`, sudo allowlist limited to package and configuration inventory commands
- Privilege review: group membership and sudo policy reviewed 2026-06-01 with no drift
- Rotation: credentials rotated 2026-06-03; scanner policy points to current vault object IDs
- Lockout policy: 10 bad attempts in 15 minutes
- Scanner settings: 2 authentication retries, 3 concurrent credential tests per subnet, abort after 3% failed-auth rate
- Targeted assets: 250
- Authenticated assets: 250
- Failed Authentication assets: 0
- Unsupported/offline assets: 0
- Verification scan: completed 2026-06-07 before full scan; SIEM shows successful logons from scanner IPs only
- Notification path: SOC and vulnerability-management owner alerted on abort or vault checkout failure

## Expected Result

The skill should pass the Credential Safety and Lockout Evidence Gate.

The output should include a Credential Safety Evidence row showing Vault/PAM source, lockout alignment, successful authentication denominator, no failed-auth assets, no privilege drift, and tested abort behavior.

## Required Output Markers

- `Credential Safety Evidence`
- `Vault/PAM`
- `Lockout Alignment`
- `Pass`
