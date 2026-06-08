# Vulnerable: Broad Policy Exception

## Review Target

```yaml
cluster:
  admission_controls:
    pod_security_admission: enabled
    gatekeeper: enabled
    kyverno: enabled
  claimed_result: policy_enforced

namespaces:
  - name: payments-prod
    labels:
      pod-security.kubernetes.io/enforce: privileged
      pod-security.kubernetes.io/audit: restricted
      pod-security.kubernetes.io/warn: restricted
    owner: unknown
    approval_ticket: null
    exception_expires: never

gatekeeper:
  constraints:
    - name: disallow-hostpath
      enforcementAction: deny
      excludedNamespaces:
        - payments-prod
        - platform-*
    - name: require-nonroot
      enforcementAction: deny
      excludedNamespaces:
        - payments-prod
  audit:
    last_run: 2026-06-01T04:00:00Z
    exception_hits_logged: false

kyverno:
  policies:
    - name: restrict-host-network
      validationFailureAction: Enforce
      exclude:
        any:
          - resources:
              namespaces:
                - payments-prod
              annotations:
                security.unitone.ai/exception: "*"

workloads:
  - namespace: payments-prod
    name: payment-debug
    serviceAccount: default
    securityContext:
      runAsUser: 0
      privileged: true
      allowPrivilegeEscalation: true
    podSpec:
      hostNetwork: true
      hostPID: true
      volumes:
        - name: host
          hostPath:
            path: /
    exception:
      mechanism: namespace PSA privileged + Gatekeeper exclude + Kyverno wildcard annotation
      owner: null
      approval: null
      expires: never
      compensating_controls: []

enforcement_tests:
  non_exempt_namespace_privileged_pod_blocked: unknown
  exempt_namespace_privileged_pod_logged: false
  exception_review_report: missing
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| CTR-EXCEPTION-01 | High | `payments-prod` is broadly exempt through privileged PSA labels, Gatekeeper namespace excludes, and Kyverno wildcard annotation matching. |
| CTR-EXCEPTION-02 | Medium | Exception lacks named owner, security approval, ticket, or risk acceptance. |
| CTR-EXCEPTION-03 | Medium | Exception never expires and has no review or removal plan. |
| CTR-EXCEPTION-04 | High | Exception permits privileged, root, hostNetwork, hostPID, and hostPath `/` beyond a narrow workload need. |
| CTR-EXCEPTION-05 | High | No compensating NetworkPolicy, runtime detection, read-only root filesystem, RBAC restriction, or monitoring is documented. |
| CTR-EXCEPTION-06 | Medium | No evidence proves non-exempt privileged pods are still blocked or audited. |
| CTR-EXCEPTION-07 | Medium | Exception hits are not logged, monitored, or reviewed for drift. |

## Reviewer Notes

Do not mark Pod Security, Gatekeeper, or Kyverno as passing because they are installed. The effective control is bypassed for a production namespace and should be reported until the exception is narrowed, owned, expiring, compensated, and monitored.
