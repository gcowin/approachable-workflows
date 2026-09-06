# Integration Guide

## Three Ways to Use Approachable-Workflows

Approachable-Workflows can be integrated into your AI systems in three ways, depending on your needs and environment.

---

## Option 1: Runtime Skill (Recommended for Production)

Use the pre-built [workflow-runtime skill](../../skills/workflow-runtime/SKILL.md) in agent harnesses like Copilot Studio, Claude Code, GitHub Copilot, or custom frameworks.

### What You Get
- ✅ Automatic execution reporting with activity feedback
- ✅ 3-law governance enforcement (Truth, Authorization, Confirmation)
- ✅ Mermaid flow charts
- ✅ HTML execution reports ([see example](examples/legal-review-analysis/cases/vantek-ostrow/runs/Vantek-v-Ostrow-Halcyon-VDI-2025-0503-20260906-012531/Workflow_Execution_Report_Vantek_v_Ostrow_Halcyon_VDI-2025-0503.html))
- ✅ Improvement recommendations
- ✅ Automatic tool/connector integration from descriptions

### How to Use

```
Run the following workflow using the workflow-runtime Skill.

Workflow: Customer Refund Review
Goal: Approve or reject refund requests
...
```

The runtime skill handles:
- Activity execution with verification gates
- Evidence collection based on role and activity kind
- State management and transitions
- Error handling and failure paths
- Report generation

---

## Option 2: Knowledge Source

Include [spec-for-ai.md](../reference/spec-for-ai.md) in your AI agent's context. The agent reads workflows and executes them using the specification as a guide.

### What You Get
- Token-efficient specification optimized for AI agents
- Natural language workflow execution
- Flexible integration with any LLM framework
- No special runtime required

### How to Use

```
"Use spec-for-ai.md as your workflow specification. 
Execute the workflow in customer-refund.txt"
```

The agent will:
- Parse the workflow structure
- Execute activities in sequence
- Apply verification conditions
- Handle failure paths
- Capture evidence based on roles

**Best for:** Prototyping, custom integrations, research

---

## Option 3: Rely on the Harness

Just write workflows in plain English and let your agent harness process them. No special tools required.

### What You Get
- Natural language workflow structure
- Self-documenting activity definitions
- Clear role and responsibility mapping
- Built-in quality gates (Verify conditions)

### How to Use

Write your workflow following the natural language patterns from [standard-template.md](../../templates/standard-template.md) and let your harness execute it:

```
Workflow: Process Customer Request

Receive Request
  Role: Coordinator
  Do: Create work record and assign initial category
  Verify: Request has unique ID
  Next: Review Request

Review Request
  Role: Analyst
  Do: Analyze request and form recommendation
  Verify: Recommendation addresses all requirements
  Next: Approve or Reject
```

**Best for:** Simple workflows, quick prototyping, harnesses with built-in workflow understanding

---

## Workflow-Level Configuration

Specify tools and settings at the workflow level, and agents connect automatically:

```text
Workflow: Customer Onboarding
Version: 1.0

Configuration:
  Tools:
    - Salesforce CRM (read customer records)
    - SendGrid (email notifications)
    - OneDrive (store evidence at /Workflow-Artifacts/)
  Settings:
    - Timeout: 24 hours
    - Notification email: {user_email}
```

Agents connect to tools automatically based on good descriptions — no manual wiring needed.

---

## Tool Integration Examples

### Example: CRM Integration
```text
Configuration:
  Tools:
    - Salesforce CRM (read/write customer records, opportunity tracking)
    - HubSpot (contact enrichment, deal pipeline)
```

The agent automatically:
- Identifies available tool capabilities
- Selects appropriate tools per activity
- Handles authentication and connection
- Retries on transient failures

### Example: Document Storage
```text
Configuration:
  Tools:
    - OneDrive (store workflow artifacts at /Workflows/Evidence/)
    - SharePoint (publish final reports to /Legal/Discovery/)
```

### Example: Communication
```text
Configuration:
  Tools:
    - SendGrid (email notifications)
    - Slack (team alerts to #workflow-alerts)
    - Teams (approval requests to Approvers channel)
```

---

## Comparison

| Feature | Runtime Skill | Knowledge Source | Rely on Harness |
|---------|--------------|------------------|-----------------|
| **Execution reporting** | Automatic | Manual/agent-dependent | Agent-dependent |
| **HTML reports** | ✅ Yes | ❌ No | ❌ No |
| **Governance enforcement** | ✅ 3-law enforcement | ⚠️ Specification-guided | ❌ Agent-dependent |
| **Mermaid diagrams** | ✅ Auto-generated | ⚠️ Agent can generate | ⚠️ Agent can generate |
| **Setup complexity** | Medium | Low | Very Low |
| **Best for** | Production workflows | Custom integrations | Prototyping |
| **Token efficiency** | High | Very High | High |

---

## Getting Started

1. **For production workflows**: Use [workflow-runtime skill](../../skills/workflow-runtime/SKILL.md)
2. **For custom integrations**: Include [spec-for-ai.md](../reference/spec-for-ai.md) as context
3. **For prototyping**: Write plain English workflows and let your harness handle it

**Next steps:**
- [Your First Workflow](../tutorials/first-workflow.md) — 10-minute tutorial
- [Authoring Template](../../templates/standard-template.md) — Copy and adapt
- [Examples](../../examples/examples.md) — Real-world workflows
- [Step-by-Step Guide](../tutorials/step-by-step.md) — Complete learning guide
