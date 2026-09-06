# Approachable-Workflows Quick Reference

**One-page cheatsheet for writing workflows in plain English**

---

## The 5 Core Concepts

1. **Name your workflow** and state its Goal
2. **Break work into Activities** with clear responsibilities (Roles)
3. **Specify what happens next** (Next, If Failed, If Unclear)
4. **Add verification** when quality matters (Verify)
5. **Execution reporting is automatic** — activity feedback captured by Role and Kind

---


## 7 Roles (Who Does What)

| Role | Does | Activity Feedback |
|------|------|-------------------|
| **Coordinator** | Routes, tracks, handoffs | Routing decisions, handoffs |
| **Researcher** | Finds info, cites sources | Sources, versions, timestamps |
| **Analyst** | Interprets, recommends, verifies | Analysis, recommendations, verification results |
| **Approver** | Authorizes decisions | Decision, identity, timestamp, comments |
| **Executor** | External actions | Transaction ID, system response |
| **Communicator** | Delivers messages | Message, recipient, delivery confirmation |
| **Observer** | Monitors, confirms | Observed state, confirmations |

---

## 8 Activity Kinds

| Kind | Purpose | Example |
|------|---------|---------|
| **Work** (default) | Execute a task | `Do: Analyze data` |
| **Choice** | Branch on conditions | `If amount > $500 → Approval` |
| **Approval** | Human decision | `Next: Approve→Process, Reject→End` |
| **Wait** | Pause until event | `Time Limit: 24h, Next: timeout→End` |
| **Repeat** | Loop/retry | `Maximum Attempts: 3, Wait Between: 5s,15s,45s` |
| **Do Together** | Parallel execution | `Wait For: All, When All Complete: If all passed→X` |
| **Run Workflow** | Call subworkflow | `Workflow: Credit Check, Provide: ID` |
| **Outcome** | Terminal state | `Outcome: Done` (optional unless specifying Return) |

---

## Essential Fields to know

```
Workflow: [Name]
Version: [Number]
Goal: [What you're trying to achieve]
Handles: [What each execution processes]

Configuration:
  Tools: [List of tools with descriptions and how to integrate if necessary]
  Settings: [Key settings]

Activities:

Activity: [Name]
  Kind: [Work/Choice/Approval/Wait/Repeat/Do Together/Run Workflow/Outcome]
  Role: [Who's responsible]
  Needs: [Inputs]
  Do: [What to do]
  Creates: [Outputs]
  Verify: [Conditions that must be true]
  If Failed: [Path when verify fails]
  If Unclear: [Path when uncertain]
  Next: [Next activity or outcome]
```

---

## 3 Governance Laws

**These laws are automatically enforced by the workflow runtime** (whether you use the Runtime Skill or Knowledge Source integration). You don't implement them manually — the agent enforces them during execution.

1. **Truth Preservation** - Unclear stays unclear (never force to clear)
   - Runtime preserves uncertainty rather than fabricating clarity
   - If Unclear paths are honored, not overridden

2. **Authorization** - High-risk requires human Approver
   - Runtime checks for Approver role on high-risk activities
   - Captures authorization evidence automatically

3. **Confirmation** - External actions need Observer verification
   - Runtime expects Observer confirmation after Executor actions
   - Validates external system state matches expected outcome

**Specified in:**
- [workflow-runtime/SKILL.md](../../skills/workflow-runtime/SKILL.md) - Executable skill enforces laws
- [spec-for-ai.md](spec-for-ai.md) - Knowledge source documents laws for agents

---

## Common Pattern: Research → Analyze → Verify → Approve → Execute

```
Activity: Research Policy
  Role: Researcher
  Do: Find applicable policies
  Verify: Every fact has authoritative source
  Next: Analyze Request

Activity: Analyze Request
  Role: Analyst
  Do: Form recommendation
  Verify: All criteria addressed
  Next: Verify Recommendation

Activity: Verify Recommendation
  Role: Analyst
  Do: Check evidence supports recommendation
  Verify: All conclusions traceable
  Next: Approval Decision

Activity: Approval Decision
  Kind: Choice
  Conditions:
    1. If high risk → Manager Approval
    2. Otherwise → Execute

Activity: Manager Approval
  Kind: Approval
  Role: Approver
  Do: Approve or reject
  Next: Approve→Execute, Reject→End

Activity: Execute
  Role: Executor
  Do: Perform approved action
  Verify: System confirms success
  Next: Completed
```

---

## Quick Start Template

```
Workflow: [Your Workflow Name]
Goal: [What you want to achieve]
Handles: [What each execution processes]

Activity: [First Step]
  Role: Coordinator
  Do: [What happens first]
  Next: [Second Step]

Activity: [Second Step]
  Role: [Analyst/Researcher/etc]
  Do: [What happens]
  Verify: [What must be true]
  If Failed: [Where to go if it fails]
  Next: [Third Step or Done]

Outcome: Done
```

---


## Execution Reporting is Automatic

Execution reports capture activity feedback:
- **All roles**: start/end time, who, inputs, outputs
- **Approver**: decision, identity, timestamp
- **Executor**: transaction ID, system response
- **Researcher**: sources, versions, timestamps
- **By Kind**: Approval → auth record, Wait → trigger, Repeat → attempts

---

## Need More Help?

- **Getting Started**: [Your First Workflow](../tutorials/first-workflow.md) — 10-minute tutorial
- **Step-by-Step Guide**: [Step-by-Step Tutorial](../tutorials/step-by-step.md) — Complete learning guide
- **Full Specification**: [spec-for-humans.md](spec-for-humans.md)
- **Examples**: [Real-world workflows](../../examples/examples.md)
- **Visual Patterns**: [visual-patterns.md](visual-patterns.md)
- **Common Mistakes**: See [spec-for-humans.md](spec-for-humans.md) Section 3

---

**Remember**: Start simple. Add detail only when needed. Both 10-line and 100-line workflows are valid.
