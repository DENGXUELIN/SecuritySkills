# Benign: Measured emergency stop and recovery drill covers queued and delegated actions

This fixture should avoid emergency stop and rollback drill findings because stop, containment, recovery, timing, and follow-up evidence are documented.

## Architecture Context

- System: `OpsPilot`
- Agent workflow: production incident assistant
- Agents: `orchestrator`, `deploy-worker`, `crm-worker`, `notification-worker`
- Stop control: signed operator API call `POST /agent-control/emergency-stop`
- Stop scopes: session, tenant, tool class, worker pool, delegated-agent tree, global
- Drill date: `2026-06-08`

## Emergency Stop and Rollback Drill

| Field | Evidence |
|---|---|
| Scenario | prompt-injection run attempts deploy, CRM update, and notification send |
| Agent / Workflow | `OpsPilot` incident assistant workflow `IR-AUTO-42` |
| Stop Trigger | on-call lead runs signed emergency-stop API with incident ID and scope `tenant+delegated-tree` |
| Stop Scope | tenant `acme-prod`, all delegated workers spawned by correlation ID `corr-9f21`, deployment and notification tool classes |
| Queued Calls Contained | Redis queue moved 22 pending jobs to quarantine, 3 in-flight jobs reached cancellation checkpoint, retries blocked by policy version `stop-2026-06-08-01` |
| State Capture Evidence | action ledger `ledger-IR-AUTO-42`, database snapshot `snap-20260608-ops`, deployment version `api@2026.06.08-4`, draft notification IDs |
| Recovery Method | deployment rollback to previous version, CRM compensation script from ledger, notification drafts discarded before send |
| Time to Stop | 42 seconds from trigger to no runnable jobs |
| Time to Recover | 11 minutes 34 seconds to restore deployment and CRM state |
| Recovery Objective | stop under 2 minutes, recover under 30 minutes, zero sent external notifications |
| Operator Runbook | `runbooks/agent-emergency-stop.md` version `2026.06.01` |
| Approvals / Escalation | on-call lead plus incident commander; legal/comms notified if messages are sent |
| Drill Result | Pass |
| Follow-up Owner / Due | one low-severity observability improvement assigned to platform team, due `2026-06-30` |

## Validation Notes

- The stop API updates a central policy store read by orchestrator and workers.
- Workers check the stop policy before executing, before retrying, and at cancellation checkpoints.
- Delegated agents inherit the parent correlation ID, so the stop scope reaches the full delegated tree.
- External communications are prepared as drafts until after HITL approval, so the drill had no sent messages to recall.
- Recovery evidence includes before/after hashes for CRM rows touched by the compensation script.

Expected outcome:

- Do not flag `AGENT-STOP-01` because a documented signed emergency stop trigger exists.
- Do not flag `AGENT-STOP-02` or `AGENT-STOP-03` because scope and queued/delegated containment are tested.
- Do not flag `AGENT-STOP-04` because state capture evidence is complete.
- Do not flag `AGENT-STOP-05` because rollback and compensation are executed in the drill.
- Do not flag `AGENT-STOP-06` because timing and recovery objectives are measured.
- Do not flag `AGENT-STOP-07` because the runbook, approvals, and escalation path are recorded.
- Do not flag `AGENT-STOP-08` because follow-up is assigned with an owner and due date.
