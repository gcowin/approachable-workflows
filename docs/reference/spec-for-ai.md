<!-- FOR: AI AGENT — not human-facing -->

# Approachable-Workflows: AI Agent Reference

Source: [spec-for-humans.md](spec-for-humans.md) (canonical)

## Agent Directives

1. Execute workflows per specification below
2. Keep track of each activity and results from verify: section as evidence. Prepare mermaid chart of actual flow when completed
3. Recommend improvements to improve the workflow when the workflow is completed as a part of workflow report.

## Core Model

Workflows = Activities with accountability + implicit evidence + failure paths
- Activity = Role (who) + Do (what) + Verify (checks) + Next (flow)
- Activity feedback = auto-captured by execution reports 

## Progressive Formalization

**Start simple (~10 lines)**: Name, Do, flow → prototyping
**Add detail (~50 lines)**: +Role, Verify, If Failed, Kinds → production
**Extend (~100+ lines)**: +State, Events, monitoring → mission-critical

## Structure

```
Workflow: [Name]
Goal: [Outcome]
Handles: [What each execution processes]

Activities: [A] → [B] → [C]

Activity: [Name]
  Role: [Who]
  Do: [What]
  Verify: [Condition]
  If Failed: [Path]
  Next: [Activity/Outcome]
```

## Fields (Standard)

| Field | Type | Default | Example |
|-------|------|---------|---------|
| Kind | Work/Choice/Approval/Wait/Repeat/Do Together/Run Workflow/Outcome | Work | Choice |
| Role | Coordinator/Researcher/Analyst/Approver/Executor/Communicator/Observer | - | Researcher |
| Needs | Inputs | - | Policy, Request |
| Do | Action | - | Find policy, check criteria |
| Creates | Outputs | - | Recommendation |
| Verify | Condition | - | All fields present |
| If Failed | Path | - | Escalate |
| If Unclear | Path | - | Manual Review |
| Next | Activity/Outcome | implicit | Verify Step |

## Activity Feedback

**No explicit field needed.** Execution reports automatically capture activity feedback based on Role and Kind. All activities record: who, when, inputs, outputs, verification results.

## Activity Kinds

1. **Work** (default): Execute task
2. **Choice**: Branch on conditions (top-to-bottom, end with Otherwise)
3. **Approval**: Human decision (Approve/Reject/Request Changes)
4. **Wait**: Pause until event/timeout (must define timeout behavior)
5. **Repeat**: Loop (must bound with Maximum/Maximum Attempts)
6. **Do Together**: Parallel (define Wait For + When All Complete)
7. **Run Workflow**: Call subworkflow
8. **Outcome**: Terminal state (optional - just use Next: [outcome name], only declare if specifying return values)

## Roles (7)

Coordinator (routes, tracks), Researcher (finds, cites), Analyst (interprets, recommends), Approver (authorizes), Executor (external actions), Communicator (messages), Observer (confirms)

## Validation Rules

1. Every workflow: Goal + Handles
2. Every Activity: unique name
3. Every non-Outcome: Next (explicit or implicit)
4. Every loop: bounded (Maximum/Maximum Attempts)
5. Choice: ends with Otherwise
6. Wait: timeout + expiry behavior

## State (Extended)

**Workflow State**: Not Started, In Progress, Waiting, Completed, Failed, Cancelled
**Business State**: Workflow-specific (Submitted, Under Review, Approved, Rejected, etc.)

```
State Changes:
  - Set Business State to [state]
  - Set Workflow State to [state]
```

## Events (Extended)

```
Events:
  On Failure: [actions] + Continue to [Activity]
  On Timeout: [actions] + Continue to [Activity]
  On Escalation: [actions]
```

## Patterns

**Research → Analyze → Approve → Execute**
- Researcher: gather + cite sources
- Analyst: interpret + recommend + verify
- Approver: authorize (decision auto-captured)
- Executor: execute (transaction auto-captured)

**Retry w/ Backoff**: Kind=Repeat, Maximum Attempts, Wait Between Attempts, If Successful/If All Attempts Fail

**Parallel**: Kind=Do Together, Wait For (All/First), Time Limit, When All Complete

**Request Mgmt**: Coordinator owns throughout, Business State tracks progress

## Examples

### Simple
```
Workflow: Coffee Order
Goal: Get customer their coffee

Activities: Take Order → Make Coffee → Serve

Take Order: Customer orders
Make Coffee: Barista makes drink
Serve: Hand to customer
```

### Standard
```
Workflow: Refund Review
Goal: Approve/reject refund
Handles: Customer refund request

Activity: Check Request
  Role: Analyst
  Do: Verify fields
  Verify: Has customer ID, amount, reason
  If Failed: Request More Info
  Next: Verify Amount

Activity: Verify Amount
  Role: Analyst
  Needs: Policy, Request
  Do: Check within limits
  Verify: Amount ≤ max
  If Failed: Reject
  Next: Manager Decision

Activity: Manager Decision
  Kind: Choice
  Conditions:
    1. If amount > $500 → Approval
    2. Otherwise → Process

Activity: Approval
  Kind: Approval
  Role: Approver
  Do: Approve/Reject
  Next: Approve→Process, Reject→Rejected

Activity: Process
  Role: Executor
  Do: Execute refund
  Verify: System confirms
  If Failed: Escalate
  Next: Completed
```

### Extended (Repeat + Events + State)
```
Activity: Submit Payment
  Kind: Repeat
  Role: Executor
  Repeat Until: System responds
  Maximum Attempts: 3
  Wait Between Attempts: 5s, 15s, 45s
  Do: Submit transaction
  Events:
    On Failure: Log + Notify finance → Payment Failed
    On Timeout: → System Unavailable
  State Changes:
    - Set Business State to Processing Payment
  If Successful: Confirm
  If All Attempts Fail: Payment Failed
```

## Choice Syntax

```
Activity: [Name]
  Kind: Choice
  Do: Select path
  Conditions:
    1. If [cond] → [Activity]
    2. If [cond] AND [cond] → [Activity]
    3. If [cond] OR [cond] → [Activity]
    4. Otherwise → [Activity]
```

Operators: AND, OR, NOT, >, <, ≥, ≤, =, ≠, in

## Do Together Syntax

```
Activity: [Name]
  Kind: Do Together
  Do These Activities Together:
    - [Activity1]
    - [Activity2]
  Wait For: All/First
  Time Limit: [duration]
  When All Complete:
    - If all passed: → [Activity]
    - If any failed: → [Activity]
    - If timeout: → [Activity]
```

## Repeat Syntax

**Collection:**
```
Activity: [Name]
  Kind: Repeat
  Repeat Over: Each [item] in [collection]
  Maximum: [count]
  Do: [action per item]
  For Each Item:
    - If valid: [action]
    - If invalid: [action]
  When Complete: → [Activity]
```

**Retry:**
```
Activity: [Name]
  Kind: Repeat
  Repeat Until: [condition]
  Maximum Attempts: [count]
  Wait Between Attempts: [t1], [t2], [t3]
  Do: [action]
  If Successful: → [Activity]
  If All Attempts Fail: → [Activity]
```

## Run Workflow Syntax

```
Activity: [Name]
  Kind: Run Workflow
  Workflow: [Workflow Name]
  Provide: [inputs]
  Receive: [outputs]
  Next: → [Activity]
```

## Key Distinctions

- **Needs vs Creates**: inputs vs outputs
- **Verify vs Approval**: condition check vs authorization
- **If Failed vs Events**: inline path vs exceptional handling
- **Workflow State vs Business State**: execution vs subject condition
- **Activity feedback**: automatic, no explicit field

## Execution Notes

- **Default flow**: Activities execute in listed order unless Next specified
- **Kind default**: Work (omit if Work)
- **Audit trail**: Automatic via execution reports
- **Verify failure**: Triggers If Failed path
- **Unclear result**: Triggers If Unclear path (preserve uncertainty)
- **Bounds required**: All loops must have Maximum/Maximum Attempts
- **Choice coverage**: Must end with Otherwise (unless no-match = fail is intentional)

## Compact Notation (for reference only)

```
[Activity] ([Role]): [Do] → [Next]
```

Expands to full fields. Not required in workflows.

---

**Reference implementation**: Follow this spec when executing workflows. Track state. Log progression with activity status (✓/✗/?). Generate mermaid charts on request.
