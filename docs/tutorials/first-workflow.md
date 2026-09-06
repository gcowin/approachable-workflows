# Your First Workflow

**Goal:** Build and understand a complete workflow in 10 minutes.

By the end of this tutorial, you'll have:
- ✅ Written your first Approachable-Workflows
- ✅ Understood the basic activity structure
- ✅ Added verification and branching
- ✅ Seen how it executes

---

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

---

## Step 2: Add Roles and Verification (3 minutes)

Now let's make it production-ready by adding roles and quality gates:

```text
Workflow: Refund Review with Verification
Goal: Approve or reject refund requests

Review Request
  Role: Analyst
  Do: Check if the refund request meets our policy
  Verify: Request amount and customer ID are present
  Next: Make Decision

Make Decision
  Role: Approver
  Do: Approve or reject based on policy
  Verify: Decision has documented reasoning
  Next: Notify Customer

Notify Customer
  Role: Communicator
  Do: Send approval or rejection email to customer
  Verify: Email sent successfully
  Next: Completed
```

**What you just learned:**
- `Role:` shows who's responsible (Analyst, Approver, Communicator)
- `Verify:` creates quality gates — activities can't complete unless verification passes
- Verification captures evidence automatically

**Try this:** What happens if "Request amount and customer ID are present" fails? The workflow can't proceed — it stays at "Review Request" until the problem is fixed.

---

## Step 3: Add Failure Handling (5 minutes)

Real workflows need to handle failures. Let's add branching:

```text
Workflow: Refund Review with Error Handling
Goal: Approve or reject refund requests

Review Request
  Role: Analyst
  Needs: Refund request, Customer record
  Do: Check if the refund request meets our policy
  Verify: Request amount and customer ID are present; Customer record found
  If Failed: Reject incomplete request
  Next: Make Decision

Make Decision
  Role: Approver
  Needs: Analyst recommendation
  Do: Approve or reject based on policy and amount
  Creates: Decision record with reasoning
  Verify: Decision has documented reasoning
  Next: Notify Customer

Notify Customer
  Role: Communicator
  Needs: Decision record
  Do: Send approval or rejection email to customer
  Verify: Email sent successfully
  If Failed: Log notification failure and escalate
  Next: Completed

Reject incomplete request
  Role: Coordinator
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

---

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
  Role: Coordinator
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

---

## Complete Workflow

Here's the full workflow with everything we've learned:

```text
Workflow: Complete Refund Review
Version: 1.0
Goal: Approve or reject refund requests with appropriate routing

Review Request
  Role: Analyst
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
  Role: Coordinator
  Needs: Request validation result
  Do: Automatically approve and log the decision
  Creates: Decision record (auto-approved)
  Verify: Decision logged
  Next: Notify Customer

Make Decision
  Role: Approver
  Needs: Request validation result
  Do: Approve or reject based on policy and amount
  Creates: Decision record with reasoning
  Verify: Decision has documented reasoning
  Next: Notify Customer

Notify Customer
  Role: Communicator
  Needs: Decision record
  Do: Send approval or rejection email to customer
  Verify: Email sent successfully
  If Failed: Log notification failure and escalate
  Next: Completed

Reject incomplete request
  Role: Coordinator
  Needs: Request validation result with failure reasons
  Do: Return the request with list of missing information
  Creates: Rejection notice
  Verify: Missing fields are listed
  Next: Completed
```

---

## What You've Built

You now have a production-ready workflow with:
- ✅ **6 activities** with clear responsibilities
- ✅ **Branching logic** (Route by Amount)
- ✅ **Error handling** (If Failed paths)
- ✅ **Quality gates** (Verify conditions)
- ✅ **Data flow** (Needs/Creates)
- ✅ **Multiple outcomes** (Completed via different paths)

---

## Next Steps

**Learn more techniques:**
- [How to Add Parallel Execution](../how-to/parallel-execution.md) — Run activities concurrently
- [Step-by-Step Tutorial](step-by-step.md) — Complete guide with advanced features

**See real examples:**
- [Example Workflows](../../examples/examples.md) — Real-world workflows
- [Legal Discovery Review](../../examples/legal-review-analysis/legal-review-analysis.txt) — Production workflow (99.5/100 evaluation)

**Understand the concepts:**
- [The Activity Model](../explanation/activity-model.md) — How activities work
- [Why It Works](../explanation/why-it-works.md) — Graph engineering evidence

**Look up syntax:**
- [Field Reference](../reference/fields.md) — All fields explained
- [Spec for Humans](../reference/spec-for-humans.md) — Complete specification
