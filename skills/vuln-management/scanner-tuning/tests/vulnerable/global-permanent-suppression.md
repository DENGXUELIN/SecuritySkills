# Vulnerable: permanent global suppression without lifecycle evidence

This sample should be rejected even if the original finding was a real false positive on one host.

## Scenario

- Scanner: Tenable
- Plugin ID: `15901`
- CVE: `CVE-2024-0001`
- Original false positive root: one RHEL host had a backported patch while the banner still showed the old upstream version
- Proposed tuning: suppress plugin `15901` globally for all Linux servers

## Suppression ticket excerpt

```yaml
scanner: Tenable
plugin_id: "15901"
cve: CVE-2024-0001
affected_scope: "all-linux-prod"
suppression_scope: "plugin:15901"
evidence: "Team says this is a false positive"
owner: ""
approver: ""
created_date: "2026-06-08"
expiration_date: ""
revalidation_trigger: ""
status: "active"
```

## Expected result

- Decision: `Reject suppression`
- Required finding: the suppression is global, has no accountable owner or approver, lacks concrete FP evidence, has no expiration/revalidation date, and has no trigger for scanner plugin updates, package rebuilds, exposure changes, or compensating-control changes.
- Required recommendation: restrict suppression to the verified host/package scope only after authenticated evidence is attached, assign an owner, and set a short revalidation date.
