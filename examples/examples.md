# Approachable-Workflows Real-World Workflow Examples

This document shows real workflows using the Approachable-Workflows Core Activity Model.

These examples are written to align with the canonical rules in [../spec-for-humans.md](../spec-for-humans.md). If a wording difference appears, the specification in that document governs the meaning.

Each example demonstrates Activities in action—no pattern declarations, just clear workflow descriptions.

## Example 1: Customer Support Resolution

```text
Workflow: Customer Support Resolution

Goal:
  Resolve a customer issue accurately and quickly.

Handles:
  Customer support request

Activity: Understand Request
  Kind: Work
  Role: Researcher
  Needs: Customer request, account history
  Do: Classify the issue and identify missing information.
  Verify: Classification confidence meets threshold.
  Next: Analyze Resolution

Activity: Analyze Resolution
  Kind: Work
  Role: Analyst
  Do: Determine the best resolution.
  Next: Verify Recommendation

Activity: Verify Recommendation
  Kind: Work
  Role: Analyst
  Verify: Recommendation is supported by evidence.
  Next: Resolved

Activity: Resolved
  Kind: Outcome
  Do: Request resolved.

Governance:
  Customer records, policy guidance, independent verification.
```

## Example 2: Insurance Claim Review

```text
Workflow: Insurance Claim Review

Goal:
  Reach a supported claim decision.

Handles:
  Insurance claim

Activity: Validate Claim
  Kind: Work
  Role: Researcher

Activity: Analyze Coverage
  Kind: Work
  Role: Analyst

Activity: Verify Findings
  Kind: Work
  Role: Analyst

Activity: Claim Approval
  Kind: Approval
  Role: Approver
  Do: Approve, deny, or refer the claim.
  Next:
    - Approve → Approved
    - Deny → Denied
    - Refer → Referred
```

## Example 3: Employee Onboarding

```text
Workflow: Employee Onboarding

Goal:
  Prepare a new employee for productive work.

Handles:
  Employee onboarding request

Activities:
  - Provision equipment
  - Create accounts
  - Assign training
  - Schedule introductions → Employee Ready
```

## Example 4: Procurement Approval

```text
Workflow: Procurement Approval

Goal:
  Authorize valid purchasing requests.

Handles:
  Purchase request

Activities:
  1. Validate budget
  2. Assess business value
  3. Generate recommendation
  4. Request approval
  5. Approved purchase (outcome)
```

## Example 5: Security Incident Investigation

```text
Workflow: Security Incident Investigation

Goal:
  Protect systems and data from threats.

Handles:
  Security incident

Activities:
  1. Detect alert
  2. Gather evidence
  3. Assess severity
  4. Recommend response
  5. Escalate if needed
  6. Contained / escalated / closed (outcome)
```

## Example 6: Sales Opportunity Qualification

```text
Workflow: Sales Opportunity Qualification

Goal:
  Determine whether an opportunity should advance.

Handles:
  Sales opportunity

Activities:
  1. Research account
  2. Assess fit
  3. Evaluate opportunity
  4. Recommend action
  5. Qualified / nurture / disqualify (outcome)
```

## Example 7: Marketing Content Publication

```text
Workflow: Marketing Content Publication

Goal:
  Publish accurate and compliant content.

Activities:
  1. Draft content
  2. Verify accuracy
  3. Review compliance
  4. Approve publication
  5. Publish content → Content Published
```

## Example 8: Contract Review

```text
Workflow: Contract Review

Goal:
  Identify risk and determine acceptance.

Activities:
  1. Extract terms
  2. Compare against standards
  3. Review exceptions
  4. Obtain legal approval
  5. Approved / revised / rejected (outcome)
```

## Example 9: Data Quality Remediation

```text
Workflow: Data Quality Remediation

Goal:
  Improve trustworthiness of enterprise data.

Activities:
  1. Detect issues
  2. Analyze root cause
  3. Recommend fixes
  4. Validate corrections
  5. Certified dataset (outcome)
```

## Example 10: Product Launch Readiness

```text
Workflow: Product Launch Readiness

Goal:
  Determine launch readiness.

Activities:
  - Technical review
  - Security review
  - Compliance review
  - Documentation review
  - Support review
  - Launch approval → Approved / Delayed / Cancelled
```

## Workflow Definition, Subject, and Instance

```text
Workflow: Refund Review

Workflow Definition:
  Refund Review (reusable)

Handles:
  Each customer refund request

Subject:
  Refund Request 100245 (a specific instance)

Workflow Instance:
  Execution of Refund Review handling Refund Request 100245.
```

## Example 11: Multi-Vendor Purchase Order Processing

```text
Workflow: Multi-Vendor Purchase Order Processing

Goal:
  Process a purchase order with multiple line items from multiple vendors efficiently.

Handles:
  Purchase order

Activities:
Activity: Receive Purchase Order
  Kind: Work
  Role: Coordinator
  Do: Validate PO structure and create a work record
  State Changes:
    - Set Business State to Received
    - Set Workflow State to In Progress
  Next: Process All Line Items

Activity: Process All Line Items
  Kind: Repeat
  Role: Analyst
  Repeat Over: Each line item in the purchase order
  Maximum: 500 items
  Do: Validate item number, quantity, price, and vendor for each line item
  For Each Item:
    - If valid: Add to approved list
    - If invalid: Add to exceptions list
  Events:
    - On Failure:
      - Log processing error
      - Continue to Manual Review
  Next: Validate All Vendors Concurrently

Activity: Validate All Vendors Concurrently
  Kind: Do Together
  Role: Researcher
  Do These Activities Together:
    - Validate vendor credit standing
    - Check vendor compliance status
    - Verify vendor contract terms
    - Confirm vendor delivery capability
  Wait For: All activities to complete
  Time Limit: 30 seconds
  When All Complete:
    - If all passed: Continue to Approve Purchase Order
    - If any failed: Continue to Vendor Review Required
    - If timeout: Continue to Escalate

Activity: Submit to ERP System
  Kind: Repeat
  Role: Executor
  Repeat Until: ERP system confirms receipt
  Maximum Attempts: 3
  Wait Between Attempts: 10 seconds, then 30 seconds, then 60 seconds
  Do: Submit approved purchase order to ERP system
  Events:
    - On Timeout:
      - Alert: ERP integration team
      - Continue to ERP System Unavailable
  If Successful:
    - Set Business State to Submitted to ERP
    - Continue to PO Completed
  If All Attempts Fail:
    - Continue to ERP System Unavailable

Outcome:
  PO completed, vendor review required, ERP system unavailable, or manual review

Governance:
  - Each line item validated
  - All vendors checked in parallel for efficiency
  - ERP submission retried automatically
  - Complete audit trail of all validations and attempts
```

---

## Common Patterns Shown in These Examples

These examples demonstrate common workflow patterns:

- Research: Gathering information from authoritative sources
- Analyze and Verify: Independent validation of recommendations
- Human Approval: Authorized decision-making
- Escalation: Transferring complex requests to specialists
- Workflow Management: Managing work across multiple steps
- Do Together: Concurrent execution of independent checks
- Repeat: Processing collections and retry logic
- Events: Handling exceptional conditions

For more pattern examples and guidance, see [Pattern Examples.md](Pattern Examples.md).

These examples align with the Approachable-Workflows Core Specification.
