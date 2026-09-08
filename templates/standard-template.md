# Approachable-Workflows Authoring Template

**Use this template to create your own workflows**

This is a one-page template showing all the key fields you can use in an Approachable-Workflows. Copy and adapt it to your needs.

---

## Template

```text
Workflow: [Name]

Goal:
  What business result should this workflow achieve?

Handles:
  What does each execution process?

Provided Information:
  What must be known at the start?

Final Result:
  What will be returned?

Roles:
  Who is responsible for each kind of work?

Capabilities:
  Which kinds of work does the workflow perform?

Activity: [Clear verb and object]
  Kind: Work, Choice, Approval, Wait, or Outcome
  Role: Who is responsible?
  Needs: What information is available?
  Do: What happens?
  Creates: What result is expected?
  Verify: What must be true before continuing?
  If Failed: What happens if the Activity cannot complete?
  If Unclear: What happens if verification cannot reach a clear result?
  Next: What Activity or outcome follows?

Activity: [Another clear verb and object]
  ...
  Next: [Eventually Completed]

Governance:
  How does the workflow ensure dependable outcomes?
  
```

---

## Quick Start Version (Minimal)

For simple workflows, you only need:

```text
Workflow: [Name]
Goal: [What you want to achieve]
Handles: [What each execution processes]

Activity: [First Step]
  Role: [Who]
  Do: [What happens]
  Next: [Second Step]

Activity: [Second Step]
  Role: [Who]
  Do: [What happens]
  Verify: [What must be true]
  If Failed: [Where to go if fails]
  Next: Completed

```

---

## Field Reference

### Essential Fields
- **Workflow**: Name of the workflow
- **Goal**: Business result to achieve
- **Activity**: Name with verb-object phrase
- **Do**: What the activity does
- **Next**: Where to go next (or Outcome)

### Quality & Control
- **Role**: Who is responsible (Coordinator, Researcher, Analyst, Approver, Executor, Communicator, Observer)
- **Verify**: Condition that must be true
- **If Failed**: Path when verification fails
- **If Unclear**: Path when result is uncertain

### Data Flow
- **Handles**: What each execution processes
- **Kind**: Activity type (Work, Choice, Approval, Wait, Repeat, Do Together, Run Workflow, Outcome)
- **Needs**: Input information
- **Creates**: Output information
- **Governance**: How workflow ensures dependable outcomes

### Advanced Features
- **State Changes**: Track business/workflow state
- **Events**: Handle exceptions (OnFailure, OnTimeout, OnEscalation)
- **Configuration**: Tools, settings, environment

---

## 7 Roles to Choose From

| Role | Use When | Activity Feedback |
|------|----------|-------------------|
| **Coordinator** | Routing, tracking, handoffs | Routing decisions, handoff confirmations |
| **Researcher** | Finding information, gathering evidence | Sources, versions, retrieval timestamps |
| **Analyst** | Interpreting data, making recommendations, verifying | Analysis, recommendations, verification results |
| **Approver** | Authorizing decisions | Decision, identity, timestamp, comments |
| **Executor** | Performing external actions | Transaction ID, system response |
| **Communicator** | Sending messages, notifications | Message, recipient, delivery confirmation |
| **Observer** | Monitoring, confirming external results | Observed state, confirmation results |

---

## 8 Activity Kinds

| Kind | Use For | Required Fields |
|------|---------|----------------|
| **Work** (default) | General tasks | Do, Next |
| **Choice** | Branching decisions | Conditions, Otherwise |
| **Approval** | Human authorization | Do, Next (with decision paths) |
| **Wait** | Pausing for events | Time Limit, Next (with timeout path) |
| **Repeat** | Loops, retries | Maximum/Maximum Attempts |
| **Do Together** | Parallel execution | Activities list, Wait For, When All Complete |
| **Run Workflow** | Call subworkflow | Workflow name, Provide, Receive |
| **Outcome** | Terminal state | (Only if specifying Return values) |

---

## Common Patterns

### Simple Linear
```
Receive → Process → Send → Done
```

### With Decision
```
Check → If valid → Process → Done
         Otherwise → Reject → Done
```

### With Approval
```
Analyze → Verify → If high risk → Approve → Execute → Done
                    Otherwise → Execute → Done
```

### With Retry
```
Submit (Repeat: max 3 attempts) → Confirm → Done
```

---

## Tips

1. **Start simple** - Just Goal, Activities, and flow
2. **Add roles** when accountability matters
3. **Add Verify** when quality gates are needed
4. **Define If Failed** for critical activities
5. **Execution reporting is automatic** - don't specify it manually
6. **Keep names clear** - verb + object (e.g., "Review Request", not "Review")

---

## Examples Using This Template

- **Payment Processing**: [docs/explanation/overview.md](../docs/explanation/overview.md) - High-value supplier payment exception workflow
- **Legal Review**: [examples/legal-review-analysis/](../examples/legal-review-analysis/) - Production legal discovery workflow (100/100 evaluation)
- **Getting Started**: [docs/tutorials/first-workflow.md](../docs/tutorials/first-workflow.md) - Build your first workflow in 10 minutes

---

## Need More Help?

- **Quick Reference**: [quick-reference.md](../docs/reference/quick-reference.md) - One-page cheatsheet
- **Visual Patterns**: [visual-patterns.md](../docs/reference/visual-patterns.md) - Mermaid diagrams
- **Full Spec**: [spec-for-humans.md](../docs/reference/spec-for-humans.md) - Complete specification
- **Common Mistakes**: [spec-for-humans.md](../docs/reference/spec-for-humans.md#part-ii-common-mistakes--how-to-avoid-them) - What to avoid
- **Step-by-Step Guide**: [step-by-step.md](../docs/tutorials/step-by-step.md) - Complete learning guide

---

**Remember**: The best workflow is the one that's clear enough to execute and simple enough to understand. Start with what you need, add detail as you grow.
