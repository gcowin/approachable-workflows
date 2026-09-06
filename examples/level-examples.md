# Approachable-Workflows Level Examples

This document shows the same workflow written at each of the three Approachable-Workflows levels.

## Example Workflow: Customer Refund Review

---

## Simple Level Approachable-Workflows

For straightforward workflows - just activities and flow.

```text
Workflow: Customer Refund Review

Goal:
  Approve or reject refund requests.

Handles:
  Customer refund request

Activity: Receive Request
  Kind: Work
  Role: Coordinator
  Do: Customer submits a refund request with reason and amount.
  Next: Check Policy

Activity: Check Policy
  Kind: Work
  Role: Researcher
  Do: Find the applicable refund policy and verify the request meets criteria.
  Next: Verify Amount

Activity: Verify Amount
  Kind: Work
  Role: Analyst
  Do: Check that the refund amount matches the purchase amount.
  Next: Manager Decision

Activity: Manager Decision
  Kind: Choice
  Role: Approver
  Do: If amount exceeds $500, manager approves or rejects; otherwise, auto-approve.
  Next: Process Refund

Activity: Process Refund
  Kind: Work
  Role: Executor
  Do: Issue the refund to the original payment method and notify the customer.
  Next: Refund Completed
```

**That's it!** ~10 lines. Perfect for simple, well-understood workflows.

---

## Standard Level Approachable-Workflows

Same workflow with roles, checks, and failure paths.

```text
Workflow: Customer Refund Review

Goal:
  Approve or reject refund requests.

Handles:
  Customer refund request

Activity: Receive Request
  Role: Coordinator
  Do: Customer submits refund request with reason and amount.
  Verify: Request has customer ID, amount, and reason.
  If Failed: Reject - Incomplete Request
  Next: Check Policy

Activity: Check Policy
  Role: Researcher
  Do: Find applicable refund policy and verify request meets criteria.
  Verify: Request meets policy requirements.
  If Failed: Reject - Policy Not Met
  Next: Verify Amount

Activity: Verify Amount
  Role: Analyst
  Do: Check that refund amount matches purchase amount.
  Verify: Refund amount equals or less than purchase amount.
  If Failed: Reject - Amount Mismatch
  Next: Manager Decision

Activity: Manager Decision
  Kind: Choice
  Conditions:    1. If amount over $500 → Approval Required
    2. Otherwise → Process Refund

Activity: Approval Required
  Kind: Approval
  Role: Manager
  Do: Review request and approve or reject.
  Next:
    - If Approved → Process Refund
    - If Rejected → Reject - Manager Denied

Activity: Process Refund
  Role: Executor
  Do: Issue refund to original payment method.
  Next: Refund Completed

Outcome: Reject - Incomplete Request
  Return: Missing required information.

Outcome: Reject - Policy Not Met
  Return: Does not meet refund policy.

Outcome: Reject - Amount Mismatch
  Return: Refund amount exceeds purchase amount.

Outcome: Reject - Manager Denied
  Return: Manager rejected the request.
```

**More detail:** ~60 lines. Includes roles, checks, evidence, and failure paths.

---

## Extended Level Approachable-Workflows

Same workflow with state tracking, events, and retry logic.

```text
Workflow: Customer Refund Review

Goal:
  Approve or reject refund requests.

Handles:
  Customer refund request

Activity: Receive Request
  Role: Coordinator
  Do: Customer submits refund request with reason and amount.
  Verify: Request has customer ID, amount, and reason.
  State Changes:
    - Set Business State to Submitted
    - Set Workflow State to In Progress
  Events:    OnFailure:      - Log validation error
      - Notify customer support team
      - Continue to Reject - Incomplete Request
  If Failed: Reject - Incomplete Request
  Next: Check Policy

Activity: Check Policy
  Role: Researcher
  Do: Find applicable refund policy and verify request meets criteria.
  Expected Performance
    - Complete within 2 seconds
    - Success rate above 95%
  State Changes:
    - Set Business State to Under Review
  Verify: Request meets policy requirements.
  If Failed: Reject - Policy Not Met
  Next: Verify Amount

Activity: Verify Amount
  Role: Analyst
  Do: Check that refund amount matches purchase amount.
  Verify: Refund amount equals or less than purchase amount.
  If Failed: Reject - Amount Mismatch
  Next: Manager Decision

Activity: Manager Decision
  Kind: Choice
  Conditions:    1. If amount over $500 → Approval Required
    2. Otherwise → Process Refund

Activity: Approval Required
  Kind: Approval
  Role: Manager
  Do: Review request and approve or reject.
  Time Limit: 24 hours.
  State Changes:
    - Set Business State to Pending Approval
  Events:    OnTimeout:      - Notify manager
      - Escalate to senior manager after 48 hours
  Next:
    - If Approved → Process Refund
    - If Rejected → Reject - Manager Denied

Activity: Process Refund
  Kind: Repeat
  Role: Executor
  Repeat Until: Payment system confirms refund.
  Maximum Attempts: 3
  Wait Between Attempts: 30 seconds, then 60 seconds, then 120 seconds.
  Do: Issue refund to original payment method.
  State Changes:
    - Set Business State to Refunded
  Events:    OnFailure:      - Log payment system error
      - Alert finance team
  If Successful: Refund Completed
  If All Attempts Fail: Payment System Error

Outcome: Refund Completed
  State Changes:
    - Set Workflow State to Completed

Outcome: Payment System Error
  Return: Unable to process refund after 3 attempts.
```

**Full detail:** ~100+ lines. Adds state tracking, events, retry logic, performance monitoring.

---

## When to Use Each Level

**Use Simple when:**
- Workflow is well-understood and straightforward
- No complex error handling needed
- Linear flow with few branches
- Internal team workflows
- Prototyping or documentation

**Use Standard when:**
- Need clear accountability (roles)
- Require validation (checks)
- Have multiple failure paths
- Need evidence for compliance
- Production workflows
- Customer-facing processes

**Use Extended when:**
- Need state tracking for monitoring
- Require retry logic for reliability
- Have event-driven behavior
- Need performance monitoring
- Complex orchestration
- Mission-critical workflows

**Start Simple, add detail only when needed.**

---

## Mixing Levels

You can mix levels within one workflow:

```text
Workflow: Order Processing

Goal:
  Fulfill a valid customer order.

Handles:
  Customer order

Activity: Receive Order
  Kind: Work
  Role: Coordinator
  Do: Customer submits an order.

Activity: Validate Order
  Role: Validator
  Do: Check inventory and pricing.
  Verify: Items are in stock and pricing is correct.
  If Failed: Order Validation Failed

Activity: Process Payment
  Kind: Repeat
  Role: Executor
  Maximum Attempts: 3
  Do: Charge the customer payment method.
  Events:    OnFailure: Notify finance team.
  State Changes: Set to Payment Processed.

Activity: Ship Order
  Kind: Work
  Role: Executor
  Do: Fulfill the order and ship it to the customer.
```

Use the right level of detail for each activity.
