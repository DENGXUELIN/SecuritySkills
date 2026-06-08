# Vulnerable: Ticket Closure Treated as Effectiveness

## Scenario

After a ransomware incident, the PIR identifies that backup restore procedures failed because the restore runbook required a domain administrator account that was unavailable during containment.

## Remediation Plan Extract

| ID | Finding | Action | Owner | Priority | Deadline | Tracking |
|---|---|---|---|---|---|---|
| REM-001 | Restore runbook depends on domain administrator access during containment. | Update the restore runbook to use the backup operator role. | Infrastructure | P1 | 2026-07-01 | PIR-4812 |

## Follow-Up Evidence

- Ticket `PIR-4812` is marked closed.
- The runbook page was edited.
- The backup platform role description says "backup operator".
- No restore drill was run.
- No pre/post comparison shows that a non-domain-admin account can now complete restore.
- No effectiveness owner signed off.
- No recurrence signal is defined for failed restore drills, restore time, or privileged credential dependency.
- Residual risk is not documented.

## Expected Skill Behavior

The post-incident review should not treat this as effective remediation.

Required findings:

- `PIR-EFF-01` should fail because no validation method is recorded.
- `PIR-EFF-02` should fail because there is no pre/post restore comparison.
- `PIR-EFF-03` should fail because no effectiveness owner is assigned.
- `PIR-EFF-04` should fail because the only artifact is ticket closure and a runbook edit.
- `PIR-EFF-05` should fail because no recurrence signal is monitored.
- `PIR-EFF-06` should fail because residual risk is absent.
- `PIR-EFF-07` should keep the closure state at `Implemented`, not `Effective`.
- `PIR-EFF-08` should fail because no dated P1 retest cadence is scheduled.

## Correct Classification

P1 remediation remains `Implemented - Not Validated`.
