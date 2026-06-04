# Benign: suspicious mailbox login with no BEC persistence found

## Scenario

A user reported a suspicious invoice email, and one successful login came from an unusual geography. The organization investigated the mailbox and identity provider before deciding containment scope.

## Evidence collected

- Interactive and non-interactive sign-in logs were exported for the exposure window.
- MFA and conditional-access results showed the session was challenged and terminated.
- Inbox rules, forwarding settings, transport rules, delegated access, SendAs, and SendOnBehalf were exported before cleanup.
- Message trace found no attacker replies, external forwarding, or deleted invoice threads.
- Enterprise app consent grants showed no new OAuth apps, no new service principals, and no `offline_access` grants.
- Refresh tokens and active sessions were revoked.
- Finance/AP confirmed no payment-change request was actioned.
- IR coordination used an out-of-band channel until mailbox access was confirmed clean.

## Expected skill behavior

The playbook should treat this as a bounded mailbox/identity investigation, not automatically as malware or endpoint compromise. Host isolation is unnecessary unless separate endpoint evidence appears.
