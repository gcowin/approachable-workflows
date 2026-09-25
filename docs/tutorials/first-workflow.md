# Workflow Tutorial: From First Workflow to Production

**Goal:** Build and understand a complete workflow in 10 minutes, then extend it to production with the advanced features.

This is the single tutorial for Approachable-Workflows. Part I teaches the fundamentals in 10 minutes; Part II extends the same refund example to production with state, events, waits, approvals, and parallel work.

It is a companion to [spec-for-humans.md](../reference/spec-for-humans.md), which is the canonical specification. Use the specification as the source of truth; this tutorial explains how to apply it in practice.

Part I: Fundamentals (10 minutes)
Part II: Production patterns (advanced features)

---

# Part I: Fundamentals

By the end of Part I, you'll have:
- ✅ Written your first Approachable-Workflows
- ✅ Understood the basic activity structure
- ✅ Added verification and branching
- ✅ Seen how it executes

## Step 1: The Simplest Workflow (2 minutes)

Let's start with a three-activity workflow for processing a customer refund request:

```text
Workflow: Simple Refund Review
Goal: Approve or reject refund requests

Review Request
Do: Check if the refund request meets our policy
Next: Make Decision

Make Decision
Do: Approve or reject based on policy
Next: Notify Customer

Notify Customer
Do: Send approval or rejection email to customer
Next: Completed
```

**What you just learned:**
- Every workflow has a `Goal`
- Activities have names (like "Review Request")
- `Do:` explains what happens
- `Next:` chains activities together
- End with "Completed"

## Step 2: Add Roles and Verification (3 minutes)

Now let's make it production-ready by adding roles and quality gates:

```text
Workflow: Refund Review with Verification
Goal: Approve or reject refund requests

Review Request
Do: Check if the refund request meets our policy
Verify: Request amount and customer ID are present
Next: Make Decision

Make Decision
Do: Approve or reject based on policy
Verify: Decision has documented reasoning
Next: Notify Customer

Notify Customer
Do: Send approval or rejection email to customer
Verify: Email sent successfully
Next: Completed
```

**What you just learned:**
- `Role:` defaults to Analyst — only name it for Approver (authorization) or Observer (confirmation)
- `Verify:` creates quality gates — activities can't complete unless verification passes
- Verification captures evidence automatically

**Try this:** What happens if "Request amount and customer ID are present" fails? The workflow can't proceed — it stays at "Review Request" until the problem is fixed.

## Step 3: Add Failure Handling (5 minutes)

Real workflows need to handle failures. Let's add branching:

```text
Workflow: Refund Review with Error Handling
Goal: Approve or reject refund requests

Review Request
Needs: Refund request, Customer record
Do: Check if the refund request meets our policy
Creates: Request validation result
Verify: Request amount and customer ID are present; Customer record found
If Failed: Reject incomplete request
Next: Make Decision

Make Decision
Needs: Analyst recommendation
Do: Approve or reject based on policy and amount
Creates: Decision record with reasoning
Verify: Decision has documented reasoning
Next: Notify Customer

Notify Customer
Needs: Decision record
Do: Send approval or rejection email to customer
Verify: Email sent successfully
If Failed: Log notification failure and escalate
Next: Completed

Reject incomplete request
Do: Return the request with list of missing information
Next: Completed
```

**What you just learned:**
- `Needs:` declares inputs (like function parameters)
- `Creates:` declares outputs (passed to next activities)
- `If Failed:` routes to different activities when verification fails
- You can create multiple completion points

**Flow visualization:**
```
Review Request → Make Decision → Notify Customer → Completed
       ↓
Reject incomplete → Completed
```

## Step 4: Add a Choice (Bonus - 2 minutes)

Let's add automatic approval for small amounts:

```text
Route by Amount
Kind: Choice
Do: Select routing based on refund amount
Conditions:
  1. If amount < $50 → Auto-approve small refund
  2. Otherwise → Make Decision
Next: The activity named by the selected route

Auto-approve small refund
Do: Automatically approve and log the decision
Creates: Decision record (auto-approved)
Verify: Decision logged
Next: Notify Customer
```

**What you just learned:**
- `Kind: Choice` creates branching logic
- `Conditions:` define the rules (evaluated in order)
- First matching condition wins

**Updated flow:**
```
Review Request → Route by Amount ─┬→ Auto-approve small refund → Notify Customer
       ↓                          └→ Make Decision → Notify Customer
Reject incomplete
```

## Complete Workflow (End of Part I)

Here's the full workflow with everything we've learned:

```text
Workflow: Complete Refund Review
Version: 1.0
Goal: Approve or reject refund requests with appropriate routing

Review Request
Needs: Refund request, Customer record
Do: Check if the refund request is complete and meets our policy
Creates: Request validation result
Verify: Request amount and customer ID are present; Customer record found
If Failed: Reject incomplete request
Next: Route by Amount

Route by Amount
Kind: Choice
Needs: Request validation result
Do: Select routing based on refund amount
Conditions:
  1. If amount < $50 → Auto-approve small refund
  2. Otherwise → Make Decision
Next: The activity named by the selected route

Auto-approve small refund
Needs: Request validation result
Do: Automatically approve and log the decision
Creates: Decision record (auto-approved)
Verify: Decision logged
Next: Notify Customer

Make Decision
Needs: Request validation result
Do: Approve or reject based on policy and amount
Creates: Decision record with reasoning
Verify: Decision has documented reasoning
Next: Notify Customer

Notify Customer
Needs: Decision record
Do: Send approval or rejection email to customer
Verify: Email sent successfully
If Failed: Log notification failure and escalate
Next: Completed

Reject incomplete request
Needs: Request validation result with failure reasons
Do: Return the request with list of missing information
Creates: Rejection notice
Verify: Missing fields are listed
Next: Completed
```

You now have a production-ready workflow with:
- ✅ **6 activities** with clear responsibilities
- ✅ **Branching logic** (Route by Amount)
- ✅ **Error handling** (If Failed paths)
- ✅ **Quality gates** (Verify conditions)
- ✅ **Data flow** (Needs/Creates)
- ✅ **Multiple outcomes** (Completed via different paths)

---

# Part II: Production Patterns

The same refund example, formalized with the full activity model. These are optional extensions — add them only when they add value.

## The full production flow

1. Receive Refund Request
2. Check Required Information
3. Choose Information Path
4. Wait for Missing Information, when needed
5. Research Applicable Policy
6. Analyze Refund Request
7. Verify Recommendation
8. Choose Approval Path
9. Manager Approval, when required
10. Execute Authorized Decision
11. Notify Customer
12. Completed, Rejected, Needs Review, or Failed

Every non-outcome Activity must name its Next Activity or Outcome. Every repeating path must be bounded.

## 1. Start with the business result

Write a short Goal that describes the outcome, not the technology.

**Example Goal**

Review a refund request and reach a supported, authorized decision.

Avoid implementation language such as model names, products, APIs, or orchestration frameworks in the Goal.

## 2. Define what the workflow handles

Specify what this workflow processes — the business subject handled by each execution.

**Example**

Handles: Each customer refund request

**Distinguish three concepts**:

- Workflow definition: The reusable Refund Review design
- Subject: Refund Request 100245 (a specific instance)
- Workflow instance: One execution of Refund Review handling Refund Request 100245

## 3. Identify the information

Separate information into three groups.

**Provided information** — known when the workflow begins and unchanged during the instance:

- Request number
- Customer number
- Amount
- Reason

**Working information** — created or updated as Activities complete:

- Request summary
- Missing-information list
- Policy findings
- Recommendation
- Verification result
- Approval decision

**Final result** — returned when the workflow reaches an Outcome:

- Decision
- Explanation
- Evidence package

Add simple business rules where useful, such as "Amount must be zero or greater" and "Request number is required."

## 4. Define state (optional)

Approachable-Workflows distinguishes two kinds of state.

**Workflow State** describes where execution is.

**Example states**: Not Started, Ready, In Progress, Waiting, Checking, Completed, Failed, Cancelled

**Business State** describes the condition of the subject being handled.

**For Refund Review**: Submitted, Under Review, Pending Approval, Approved, Rejected, Refunded, Needs Review

The two state types are independent. **Example**: Workflow State: Waiting while Business State: Under Review, while the workflow is waiting for customer documents.

Activities may change state. **Examples**:

- Receive Refund Request → Submitted
- Research Applicable Policy → Under Review
- Manager Approval → Approved or Rejected
- Wait for Missing Information → Waiting
- Execute Authorized Decision → Refunded

State changes should be visible so operators, auditors, and runtime tools can understand the current condition of the workflow and the subject being handled.

```text
Activity: Receive Refund Request
Kind: Work

Do: Create the work record and classify the request

State Changes:
  - Set Business State to Submitted
  - Set Workflow State to In Progress

Next: Check Required Information
```

## 5. Name a Role only when it changes behavior

A Role describes responsibility, not the implementation. A person, agent, team, or service may fulfill it when deployed.

**Analyst is the default** — interpreting, recommending, and verifying is implied. Most activities need no Role field at all; the activity name carries the meaning. For Refund Review, the only roles worth naming are:

- Approver: Authorizes high-value or high-risk decisions
- Observer: Confirms the external result actually took effect

Do not add Roles merely to make the workflow appear more sophisticated.

## 6. Write each Activity

### Example: Research Applicable Policy

```text
Activity: Research Applicable Policy
Kind: Work

Needs:
- Request summary
- Approved policy library

Do: Find the policies that apply to the request.

Creates:
- Policy findings
- Source references

Verify:
- At least one current authoritative source supports each material finding.
- Every source can be opened by an authorized reviewer.

If Failed: Use the approved alternate policy source. If that also fails, continue to Needs Review.

If Unclear: Continue to Needs Review.

Next: Analyze Refund Request
```

### Event handlers (optional)

Activities can specify what happens for exceptional conditions:

```text
Activity: Research Applicable Policy
Kind: Work

Do: Find the policies that apply to the request

Events:
  On Failure:
    - Log the research failure
    - Notify the Policy team
    - Continue to Needs Review

  On Timeout:
    - Continue to Needs Review

Next: Analyze Refund Request
```

## 7. Logical operators in Choices

Choice conditions are evaluated from top to bottom. End with Otherwise unless no match is intentionally a failure.

```text
Activity: Choose Approval Path
Kind: Choice

Do: Choose the next path

Conditions:
  1. If verification is Unclear OR verification is Failed
     → Continue to Needs Review

  2. If amount is greater than 1000 AND risk level is High
     → Continue to Senior Manager Approval

  3. If amount is greater than 1000 OR requires authorization is Yes
     → Continue to Manager Approval

  4. Otherwise
     → Continue to Execute Authorized Decision

Note: Activity feedback (like condition matched and values used) is captured in execution reports automatically.
```

## 8. Add a Wait Activity

A Wait Activity must define what ends the wait and what happens when time expires.

```text
Activity: Wait for Missing Information
Kind: Wait

Needs:
- Missing-information list
- Contact details

Do: Wait for the requested information to be received.

Time limit: The business deadline defined by the applicable profile or deployment policy.

If Failed: Continue to Failed if the wait mechanism cannot be maintained safely.

If Unclear: Continue to Needs Review if received information cannot be matched to the request.

Next:
- Information received: Check Required Information
- Time expired: Rejected or another business outcome defined by the Profile
```

## 9. Add an Approval Activity

Approval grants authorization. It does not replace verification.

```text
Activity: Manager Approval
Kind: Approval
Role: Approver

Needs:
- Recommendation
- Policy findings
- Verification result
- Evidence package

Do: Choose Approve, Reject, or Request Changes.

If Failed: Continue to Needs Review if authorization cannot be obtained.

If Unclear: Continue to Needs Review if the decision is incomplete or unauthorized.

Next:
- Approve: Execute Authorized Decision
- Reject: Rejected
- Request Changes: Analyze Refund Request, subject to a defined repetition limit
```

## 10. Add the external action

External changes need clear authorization, evidence, and protection against duplicate execution.

```text
Activity: Execute Authorized Decision
Kind: Work

Needs:
- Amount

Do: Perform the authorized refund or close the request as rejected.

Creates:
- System result
- Transaction or closure reference

Verify:
- The executed action matches the authorized decision.
- The external system confirms the result.

If Failed: Do not record completion. Continue to Needs Review with the error and action evidence.

If Unclear: Do not repeat the external change until its status is reconciled. Continue to Needs Review.

Next: Notify Customer.
```

### Retry logic (optional)

For external systems that may be temporarily unavailable:

```text
Activity: Submit to External Refund System
Kind: Repeat

Repeat Until: External system responds successfully
Maximum Attempts: 3
Wait Between Attempts: 5 seconds, then 10 seconds, then 30 seconds

Do: Submit the refund transaction

If Successful:
  - Continue to Confirm External Result

If All Attempts Fail:
  - Continue to External System Unavailable
```

### Do Together (optional)

For activities that can run concurrently:

```text
Activity: Validate Request Completeness
Kind: Do Together

Do These Activities Together:
  - Validate Customer Identity
  - Validate Invoice Number
  - Check Account Status

Wait For: All activities to complete
Time Limit: 15 seconds

When All Complete:
  - If all passed: Continue to Research Policy
  - If any failed: Continue to Request Missing Information
```

## 11. Run Workflow (optional)

Call reusable workflows:

```text
Activity: Run Standard Credit Check
Kind: Run Workflow
Workflow: Standard Credit Check
```

## 12. Define Outcomes

**Outcome declarations are optional.** Just reference the outcome name in `Next:` fields.

```
Activity: Notify Customer
Do: Send notification
Next: Completed
```

The workflow ends at "Completed" — no separate declaration required.

**Detailed outcomes** (declare when specifying return values):

```
Outcome: Completed
Return:
  - Decision
  - Explanation
  - Evidence package
  - External action confirmation
```

**Common outcome names**: Completed, Rejected, Needs Review, Failed, Cancelled

Only declare outcomes explicitly if you need to document what they return.

## 13. State the governance

For Refund Review, the Governance is:

- Current authoritative policy sources
- Retained source passages and policy versions
- Independent verification of the recommendation
- Human approval when required
- Recorded external-system confirmation
- Preserved failed and unclear check results

The Governance should explain how the workflow ensures dependable outcomes.

## 14. Validate the workflow

Before calling the workflow Core-conforming, verify:

1. Name, Goal, and Handles are present.
2. Provided information and final result are defined.
3. A starting Activity is identified.
4. Every Activity has a unique name and stable identity.
5. Every Activity has a Core kind.
6. Every non-outcome Activity has a valid next path.
7. At least one Outcome exists.
8. Material decisions and external actions retain evidence and have checks.
9. Failed and Unclear behavior is defined where applicable.
10. Every repeating path is bounded.
11. Human decisions and external actions are preserved.
12. Each material outcome has Governance defined.

You can also chat with the workflow-runtime skill for it to make recommendations. It, also, can make recommendations as a part of the workflow artifacts and evidence.

## 15. Use the compact view for review

After the complete workflow is valid, a tool may show a compact view:

```
Research Applicable Policy
Work | Research
Needs: Request summary and approved policy library
Creates: Policy findings and source references
Verify: Every material finding has a current authoritative source
Failed or unclear: Needs Review
Next: Analyze Refund Request
```

The compact view is a presentation of the same Activity, not a different language.

## 16. Common mistakes

- Using Step or Node instead of Activity in normative Approachable-Workflows authoring
- Omitting Failed or Unclear paths
- Using approval as if it were verification
- Allowing a Choice without a complete final condition
- Allowing a Wait without expiry behavior
- Performing an external action without retained authorization and action evidence
- Adding Roles that do not improve accountability or clarity

---

## Practice exercises

1. Convert Customer Support Resolution into complete Activities.
2. Add a Wait Activity to Insurance Claim Review for missing documents.
3. Add a Choice Activity to Procurement Approval.
4. Add Do Together to Product Launch Readiness to check multiple requirements concurrently.
5. Add a Repeat Activity to process multiple approval requests.
6. Add Event handlers to handle timeout conditions.

## Completion checklist

You have completed the tutorial when you can:

- Explain Goal, Handles, Information, Role, Activity, Verify, Approval, Governance, and Outcome
- Understand that activity feedback is captured in execution reports automatically based on Role and Kind
- Select an Activity kind for each unit of behavior
- Define success, Failed, and Unclear behavior
- Connect every Activity to a valid next Activity or Outcome
- Explain how the workflow ensures dependable outcomes
- Use advanced features (Repeat, Do Together, Events, State) when needed

**See also**: [examples.md](../../examples/examples.md) and [pattern-examples.md](../../examples/pattern-examples.md) for common workflow patterns as learning aids.

**Source basis**: [spec-for-humans.md](../reference/spec-for-humans.md) — the canonical specification.
