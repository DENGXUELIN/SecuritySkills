# Vulnerable: BEC response declares containment after password reset only

## Scenario

A finance user reported a suspicious vendor invoice thread. The IdP shows a successful mailbox login from a new ASN, and the user clicked an OAuth consent-phishing link two hours before the invoice thread changed bank details.

## Incomplete response

- Reset the user's password.
- Re-enrolled MFA.
- Ran an endpoint AV scan with no malware found.
- Marked the incident contained.

## Missing evidence

- No export of inbox rules, hidden rules, forwarding addresses, or transport rules.
- No review of delegated mailbox access, shared mailbox membership, SendAs, or SendOnBehalf permissions.
- No message trace for sent, deleted, or externally forwarded invoice messages.
- No review of enterprise app consent grants or suspicious service principals.
- No refresh-token or SaaS session revocation evidence.
- No AP/vendor callback or bank recall status.
- IR coordination still used the affected mailbox.

## Expected skill behavior

The playbook should not allow this incident to be marked contained. It should route to the BEC / SaaS identity containment track and require mailbox, OAuth grant, session, and finance workflow evidence before recovery.
