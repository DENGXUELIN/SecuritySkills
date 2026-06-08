# Vulnerable Fixture: Persistent Debug DaemonSet Without TTL

## Scenario

A platform team keeps a privileged debug DaemonSet deployed in every worker namespace so engineers can troubleshoot node-level networking issues. The manifest name and labels say `debug`, but the workload is persistent, cluster-scoped, and not tied to an incident ticket.

## Evidence

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-debug-shell
  namespace: production
  labels:
    purpose: debug
spec:
  template:
    spec:
      serviceAccountName: default
      hostPID: true
      hostNetwork: true
      containers:
        - name: shell
          image: busybox:latest
          command: ["sleep", "365d"]
          securityContext:
            privileged: true
            allowPrivilegeEscalation: true
          volumeMounts:
            - name: host-root
              mountPath: /host
      volumes:
        - name: host-root
          hostPath:
            path: /
```

```yaml
evidence:
  ttl_seconds_after_finished: null
  cleanup_job: null
  incident_ticket: null
  audit_log_for_creation: null
  rbac_scope: "default service account can manage pods in production"
  admission_exception_expiry: null
```

## Expected Result

The skill should keep this as Critical or High. The privilege is persistent, host-scoped, not time-bound, not audited, and not limited to an approved break-glass role. The `debug` label must not suppress the finding.
