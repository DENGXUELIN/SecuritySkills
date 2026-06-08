# Vulnerable: Failed Authentication Counted as Clean Credentialed Coverage

## Scenario

An enterprise Nessus policy is labeled `weekly-credentialed-windows`, but the scan uses one shared `DOMAIN\scan-admin` account across production, staging, and workstation scopes.

## Evidence

- Credential source: scanner-local stored password, no Vault/PAM checkout log
- Privilege: member of Domain Admins, no least-privilege review in the last 180 days
- Domain lockout policy: 5 bad attempts in 15 minutes
- Scanner settings: 8 parallel scan nodes, 4 authentication retries per host, no failed-auth abort threshold
- Targeted assets: 400 Windows hosts
- Authenticated assets: 326
- Failed Authentication assets: 61
- Unsupported/offline assets: 13
- Local checks skipped on failed-auth hosts: Windows patch inventory, registry policy checks, local software enumeration
- Report behavior: all 61 failed-auth hosts are included in the clean credentialed summary
- Rotation evidence: password changed two days before the scan, but scanner credential store was not updated

## Expected Result

The skill must fail the Credential Safety and Lockout Evidence Gate.

Failed-authentication hosts must be marked **Not Evaluable**, not clean. The report should call out overprivileged shared credentials, missing Vault/PAM evidence, lockout threshold mismatch, missing abort behavior, and lack of an authentication success denominator.

## Required Output Markers

- `Credential Safety Evidence`
- `Failed Authentication`
- `Not Evaluable`
- `Vault/PAM`
- `Lockout Alignment`
