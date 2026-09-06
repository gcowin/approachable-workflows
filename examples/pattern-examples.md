# Approachable-Workflows Pattern Examples

**Purpose**: Common workflow patterns as examples and learning aids

This document shows common patterns that appear in Approachable-Workflows workflows. These are **examples to learn from, not declarations to make**. Your workflow Activities speak for themselves—if you have Research → Analyze → Verify, readers can see the pattern.

## How to Use This Guide

- **For Learning**: See how common workflow problems are solved
- **For Starting Points**: Use as templates when building similar workflows
- **Not Required**: You don't need to declare these patterns in your workflows
- **Self-Documenting**: Good Activity names make the pattern obvious

---

## Pattern: Research

**Solves**: Need to gather supported facts from authoritative sources

**Key Elements**:
- Researcher role gathers information
- Records provenance (which source, which version)
- Returns findings with source references

**Example Activities**:

```text
Workflow: Research Pattern

Goal:
  Gather facts supported by authoritative sources.

Handles:
  Research request

Activity: Research Applicable Policy
  Kind: Work
  Role: Researcher
  Do: Find current policies that apply to this request.
  Verify:
    - Every finding has an authoritative source.
  Next: Review Findings

Activity: Review Findings
  Kind: Work
  Role: Analyst
  Do: Compare findings and determine the relevant rule.
  Next: Respond
```

**When to Use**: Anytime you need to find and cite current, authoritative information

---

## Pattern: Analyze and Verify

**Solves**: Need to produce a recommendation and verify it

**Key Elements**:
- Analyst interprets information and makes recommendation
- Analyst verifies that evidence supports the recommendation
- Verify: checks ensure quality and traceability

**Example Activities**:

```text
Workflow: Analyze and Verify Pattern

Goal:
  Produce a recommendation supported by verification.

Handles:
  Review request

Activity: Analyze Request
  Kind: Work
  Role: Analyst
  Do: Review evidence and produce a recommendation.
  Next: Verify Recommendation

Activity: Verify Recommendation
  Kind: Work
  Role: Analyst
  Do: Check that evidence supports the recommendation.
  Verify:
    - All conclusions traceable to evidence.
    - Required checks were applied.
  Next: Decide
```

**When to Use**: When decisions need verification before approval (refunds, approvals, compliance)

---

## Pattern: Human Approval

**Solves**: Need authorized person to make a decision

**Key Elements**:
- Approver role with clear authority
- Explicit choices (Approve, Reject, Request Changes)
- Authorization recorded with identity and timestamp

**Example Activities**:

```text
Workflow: Human Approval Pattern

Goal:
  Ensure a valid decision is made by an authorized person.

Handles:
  Approval decision

Activity: Manager Approval
  Kind: Approval
  Role: Approver
  Needs:
    - Recommendation
    - Evidence package
    - Amount
  Do: Choose Approve, Reject, or Request Changes.
  Verify:
    - Approver is authorized for this amount.
  Next:
    - Approve: Execute Decision
    - Reject: Close as Rejected
    - Request Changes: Return to Analysis
```

**When to Use**: High-value decisions, compliance requirements, risk mitigation

---

## Pattern: Parallel Validation

**Solves**: Need to check multiple independent requirements concurrently

**Key Elements**:
- Multiple validations run at same time
- Join condition (all must pass, any can pass, etc.)
- Time limit prevents indefinite waiting

**Example Activities**:

```text
Workflow: Parallel Validation Pattern

Goal:
  Evaluate independent requirements concurrently and only continue when the checks are complete.

Handles:
  Validation set

Activity: Validate All Requirements
  Kind: Do Together
  Role: Coordinator
  Do These Activities Together
    - Validate Customer Identity
    - Check Credit Standing
    - Verify Contract Terms
    - Confirm Delivery Capability
  Wait For: All activities to complete.
  Time Limit: 30 seconds.
  When All Complete:
    - If all passed: Continue to Approve
    - If any failed: Continue to Review Failures
    - If timeout: Continue to Manual Review
```

**When to Use**: Independent checks that don't depend on each other's results

---

## Pattern: Retry with Backoff

**Solves**: External system may be temporarily unavailable

**Key Elements**:
- Limited retry attempts
- Increasing wait between attempts
- Clear failure path when all attempts exhausted

**Example Activities**:

```text
Workflow: Retry with Backoff Pattern

Goal:
  Keep trying a temporary external action without spamming the system.

Handles:
  External integration request

Activity: Submit to External System
  Kind: Repeat
  Role: Executor
  Repeat Until: External system responds successfully.
  Maximum Attempts: 3
  Wait Between Attempts: 5 seconds, then 15 seconds, then 45 seconds.
  Do: Submit the transaction.
  If Successful
    - Continue to Confirm Result
  If All Attempts Fail
    - Continue to External System Unavailable
```

**When to Use**: Integration with external APIs, payment systems, third-party services

---

## Pattern: Escalation

**Solves**: Transfer unresolved, unclear, or high-risk work to specialists

**Key Elements**:
- Preserve complete context (work record, evidence, why escalating)
- Named specialist role
- Clear handoff confirmation

**Example Activities**:

```text
Workflow: Escalation Pattern

Goal:
  Hand off unresolved, unclear, or high-risk work to a specialist with full context.

Handles:
  Escalated request

Activity: Escalate to Specialist
  Kind: Work
  Role: Coordinator
  Needs:
    - Complete work record
    - All evidence
    - Failed or unclear criteria
  Do: Transfer the request to a finance specialist with full context.
  Creates:
    - Escalation record
    - New owner
    - Response deadline
  Next: Wait for Specialist Decision
```

**When to Use**: Unclear results, policy exceptions, unusual cases, timeout conditions

---

## Pattern: Request Management

**Solves**: Manage a business subject (ticket, claim, request) across multiple steps, waits, and decisions

**Key Elements**:
- Coordinator owns the subject throughout
- Business state tracks progress
- Subject remains open across waits and handoffs

**Example Flow**:

```text
Workflow: Request Management Pattern

Goal:
  Keep a business subject active from first submission through final closure.

Handles:
  Request record

1. Create Request (Coordinator)
  - Set Business State to Submitted

2. Gather Information (Researcher)
  - Set Business State to Under Review

3. Analyze and Decide
  - Set Business State to Pending Approval or Approved

4. Execute if Approved
  - Set Business State to Completed

5. Close Request (Coordinator)
  - Return complete record and evidence
```

**When to Use**: Support tickets, claims processing, requests, investigations

---

## Pattern: Process Collection

**Solves**: Apply same operation to each item in a collection

**Key Elements**:

**Example Activities**:

```text
Workflow: Process Collection Pattern

Goal:
  Apply the same handling to each item in a collection.

Handles:
  Collection of line items

Activity: Process All Line Items
  Kind: Repeat
  Role: Analyst
  Repeat Over: Each line item in the order.
  Maximum: 500 items.
  Do: Validate item number, quantity, and price.
  For Each Item:
    - If valid: Add to approved list
    - If invalid: Add to exceptions list
  When Complete
    - Continue to Calculate Total
```

**When to Use**: Invoice line items, batch approvals, multi-item orders

---

## Combining Patterns

Workflows often combine multiple patterns:

**Example: Refund Review**
- Uses Research to find policy
- Uses Analyze and Verify for recommendation
- Uses Human Approval for high amounts
- Uses Escalation for unclear cases
- Wraps all in Request Management

**The workflow Activities tell the story**—no pattern declarations needed.

---

## Creating Your Own Patterns

As you build workflows, you'll discover your own patterns:

1. **Notice Repetition**: Same Activity sequence appears in multiple workflows
2. **Name It**: Give it a clear name (e.g., "Three-Way Match")
3. **Document It**: Write it like the examples above
4. **Share It**: Help your team reuse it

But remember: **Patterns are learning tools, not requirements**. The Activities themselves are what matter.

---

## Key Takeaway

Good workflows are self-documenting through clear Activity names and structure. Use these patterns as inspiration and starting points, but let your Activities speak for themselves.

If someone reading your workflow can see that you:
- Research sources
- Analyze findings
- Verify independently
- Get approval
- Execute the decision

...then the pattern is obvious. No declaration needed.
