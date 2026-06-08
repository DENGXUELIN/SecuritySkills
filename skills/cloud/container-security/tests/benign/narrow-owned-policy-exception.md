# Benign: Narrow Owned Policy Exception

## Review Target

```yaml
cluster:
  admission_controls:
    pod_security_admission: enabled
    gatekeeper: enabled
    kyverno: enabled
  claimed_result: policy_enforced_with_exception_governance

namespaces:
  - name: payments-prod
    labels:
      pod-security.kubernetes.io/enforce: restricted
      pod-security.kubernetes.io/audit: restricted
      pod-security.kubernetes.io/warn: restricted

gatekeeper:
  constraints:
    - name: disallow-hostpath
      enforcementAction: deny
      excludedNamespaces: []
    - name: allow-debug-hostpath-temporary
      enforcementAction: dryrun
      match:
        namespaces:
          - payments-prod
        kinds:
          - apiGroups: [""]
            kinds: ["Pod"]
      parameters:
        allowedWorkloads:
          - payment-debug
        allowedHostPaths:
          - /var/log/payments
      owner: platform-runtime-owner@example.com
      approval_ticket: SEC-4421
      security_approver: container-security-lead@example.com
      expires: 2026-06-30

kyverno:
  policies:
    - name: restrict-host-network
      validationFailureAction: Enforce
      exclude:
        any:
          - resources:
              namespaces:
                - payments-prod
              names:
                - payment-debug
              annotations:
                security.unitone.ai/exception-id: SEC-4421

workloads:
  - namespace: payments-prod
    name: payment-debug
    serviceAccount: payment-debug-sa
    securityContext:
      runAsNonRoot: true
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      seccompProfile: RuntimeDefault
    podSpec:
      hostNetwork: false
      hostPID: false
      volumes:
        - name: payment-logs
          hostPath:
            path: /var/log/payments
            type: Directory
    exception:
      mechanism: named Kyverno exception + Gatekeeper dryrun constraint
      scope: workload payment-debug hostPath /var/log/payments only
      owner: platform-runtime-owner@example.com
      approval: SEC-4421
      expires: 2026-06-30
      compensating_controls:
        - dedicated service account with no cluster-admin
        - namespace default-deny NetworkPolicy
        - runtime detection rule ctr-hostpath-payments
        - readOnlyRootFilesystem
      review_reminder: jira-automation-2026-06-23

enforcement_tests:
  non_exempt_namespace_privileged_pod_blocked: true
  non_exempt_hostpath_root_blocked: true
  exception_workload_allowed_with_audit: true
  exception_hits_logged: true
  last_reviewed: 2026-06-01
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Exception mechanism | Pass | Exception is named and tied to a specific Kyverno/Gatekeeper control. |
| Exact scope | Pass | Scope is one workload and one hostPath, not a namespace-wide privileged bypass. |
| Owner and approval | Pass | Named owner, security approver, and ticket `SEC-4421` are present. |
| Expiration | Pass | Exception expires on 2026-06-30 with reminder automation. |
| Compensating controls | Pass | Dedicated SA, default-deny NetworkPolicy, runtime detection, and read-only root filesystem reduce risk. |
| Enforcement evidence | Pass | Non-exempt privileged and root hostPath pods are blocked; exception hit is audited. |
| Monitoring | Pass | Exception hits are logged and reviewed. |

## Reviewer Notes

This exception can be treated as governed and time-bound. Continue to report it as residual risk if it is renewed without fresh approval or if the hostPath scope expands.
