# Vulnerable Fixture: Tool Output Taint Stripped Before Delegated Deploy

## Scenario

A research agent browses an external issue page. The page contains attacker-controlled text that asks the system to deploy a hotfix. The research agent summarizes the page and delegates a deployment task to an executor agent, but the summary strips the untrusted-source label and the executor accepts the task as trusted internal work.

## Evidence

```yaml
flow: external-issue-to-deploy
trace_id: trace-7844
research_agent:
  tools:
    - browser.read
    - queue.publish
  source:
    type: external_web
    url: https://issues.example.invalid/INC-441
    taint: untrusted
  summary_output:
    taint: none
    content_type: task_summary
delegation_message:
  sender: research-agent
  recipient: deploy-executor
  requested_tool: deploy.production
  parent_authorization: null
  risk_tier: high
  original_source_taint: omitted
executor_agent:
  validates_sender: false
  validates_requested_tool_scope: false
  requires_approval_artifact: false
  action_taken: deploy.production
```

## Expected Assessment

- Flag a **Critical** finding because untrusted tool output can cause a delegated production deployment.
- Identify AG02, AG03, AG05, and AG08 overlap: tool misuse, privilege escalation, trust-boundary violation, and HITL bypass.
- Require taint propagation from browser output through summary and queue message.
- Require delegated capability checks for sender identity, requested tool, risk tier, approval artifact, and trace ID before execution.
