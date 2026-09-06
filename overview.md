# Approachable-Workflows Overview and Sophisticated Example

**Purpose**: Explain Approachable-Workflows in one page, then show how its Core concepts, capabilities, Activities, evidence, checks, approvals, and failure paths work together in a realistic workflow.

## Approachable-Workflows at a glance

Approachable-Workflows describes accountable work performed by people, agents, teams, and systems. It is written as clear operating instructions while preserving enough structure for tools to validate, visualize, compile, and execute a workflow.

### A workflow defines:

- Goal: The business result to achieve
- Handles: What each execution processes
- Information: What is provided, updated, and returned
- Roles: Who is responsible
- Activities: The named units of behavior
- Evidence: Durable proof of what happened (captured automatically based on Role and Kind)
- Checks: Conditions that must pass
- Approvals: Authorized decisions
- Governance: How the workflow ensures dependable outcomes
- Outcomes: How the workflow ends

### The two-part Activity model

Every Activity separates two concerns:

| Concern | Approachable-Workflows field | Example |
|---------|------------|---------|
| What structural behavior occurs? | Kind | Work, Choice, Approval, Wait, Outcome |
| Who is accountable? | Role | Researcher, Analyst, Approver, Executor |

This separation lets the same workflow meaning survive changes in staffing, agents, products, and runtime implementations.

### Core roles and what they do (7 roles)

- Coordinator: Routes work, tracks progress, handles handoffs
- Researcher: Finds information, gathers evidence, retrieves data
- Analyst: Interprets information, produces findings or recommendations, verifies quality
- Approver: Grants or denies authorization
- Executor: Performs approved actions, executes external changes
- Communicator: Formats and delivers messages
- Observer: Monitors external systems and confirms results

Roles make workflows clear and help separate responsibilities across people, agents, and systems.

## Sophisticated example: High-value supplier payment exception

### 

```text
Workflow: High-Value Supplier Payment Exception
Version: 1.0

Goal: Resolve a supplier payment exception without releasing an unsupported, duplicate, unauthorized, or incorrectly directed payment

Handles: Each supplier invoice exception

Provided:
  - Invoice and purchase order
  - Supplier identity and payment instructions
  - Receiving and contract records
  - Exception reason
  - Amount and requested payment date
  - Current finance, procurement, and fraud-control policies

Returns:
  - Resolution status
  - Payment or rejection decision
  - Evidence package
  - Approval record when required
  - External action record when a payment change is made

Open and classify the exception
  Kind: Work
  Role: Coordinator
  Needs: Submitted exception, Invoice identifier, Supplier identifier
  Do: Create the work record, detect missing required information, classify the exception, and assign the initial risk category
  Creates: Work record, Exception classification, Initial risk category, Missing-information list
  Verify: The invoice and supplier can be uniquely identified; The handled request has exactly one active owner
  If Failed: Reject malformed or duplicate submissions and retain the reason
  If Unclear: Route the request to a finance operations specialist
  Next: Gather authoritative records

Gather authoritative records
  Kind: Work
  Role: Researcher
  Needs: Work record, Approved finance, procurement, receiving, contract, and supplier sources
  Do: Retrieve the records needed to determine whether the invoice, supplier, goods or services, amount, and payment instructions are supported
  Creates: Source-backed request facts, Source references, Identified conflicts or gaps
  Verify: Every material fact has a current authoritative source; Every cited source can be opened by an authorized reviewer
  If Failed: Try the approved alternate source. If required records remain unavailable, escalate the request
  If Unclear: Preserve the uncertainty and send the request to manual investigation
  Next: Analyze the exception

Analyze the exception
  Kind: Work
  Role: Analyst
  Needs: Source-backed request facts, Applicable policies, Exception classification
  Do: Compare the invoice with the purchase order, receiving evidence, contract terms, supplier identity, prior payment records, and allowed payment controls. Produce a recommendation without changing an external system
  Creates: Recommended action, Reasoning summary, Risk indicators, Unresolved questions
  Verify: The recommendation addresses each material conflict; Any remaining uncertainty is explicit; No external action has occurred
  If Failed: Return the request for additional research
  If Unclear: Escalate to investigation rather than treating uncertainty as approval
  Next: Verify the recommendation

Verify the recommendation
  Kind: Work
  Role: Analyst
  Needs: Recommendation, Evidence package, Applicable policy checks
  Do: Determine whether the evidence supports the recommendation and whether required controls were applied
  Creates: Verification result (Passed, Failed, or Unclear), Verification findings
  Verify: Every material conclusion is traceable to retained evidence
  If Failed: Return the request to Analyze the exception with the failed criteria
  If Unclear: Route the request to Escalate for specialist review
  Next: Route by risk and value

Route by risk and value
  Kind: Choice
  Do: Select the first matching route
  Conditions:
    1. If fraud indicators, supplier identity conflicts, or unsupported payment-instruction changes are present → Escalate the request
    2. If policy requires authorization → Approve the resolution
    3. If the verified recommendation requires only an authorized low-risk correction → Execute the resolution
    4. Otherwise → Close without payment action
  Next: The Activity named by the selected route

Approve the resolution
  Kind: Approval
  Role: Approver
  Needs: Recommendation, Verification result, Evidence package, Risk category
  Do: Select Approve, Reject, or Request changes
  Verify: The Approver is authorized for the action and amount; The evidence package and verification result are available
  If Failed: Escalate authorization failure for manual review
  If Unclear: Do not execute. Escalate the request
  Next:
    - Approve → Execute the resolution
    - Reject → Close without payment action
    - Request changes → Analyze the exception

Execute the resolution
  Kind: Work
  Role: Executor
  Needs: Verified recommendation, Approval record when required, Authorized action parameters
  Do: Perform only the authorized payment release, hold, correction, or cancellation in the external system
  Creates: External action result, Updated work status
  Verify: The action exactly matches the verified and authorized resolution; The external system returned a durable transaction reference
  If Failed: Do not mark the work complete. Record the failure and route to Escalate the request
  If Unclear: Treat an unknown external result as unresolved and prevent a second execution until the first result is reconciled
  Next: Confirm the external result

Confirm the external result
  Kind: Work
  Role: Observer
  Needs: External action record, Expected state
  Do: Confirm that the external system reflects the authorized result and that no conflicting action occurred
  Creates: Confirmation result, Reconciliation findings
  Verify: The observed state matches the authorized action
  If Failed: Escalate for reconciliation
  If Unclear: Keep the request open and escalate rather than retrying the payment action
  Next: Close the request

Escalate the request
  Kind: Work
  Role: Coordinator
  Needs: Complete work record, Evidence package, Failed or unclear criteria
  Do: Transfer the request to the named finance, procurement, fraud, or system specialist while preserving ownership, evidence, and urgency
  Creates: Escalation record, New owner, Required response condition
  Verify: The receiving role is named; The evidence package is complete and accessible
  If Failed: Escalate for manual review and retain the request as unresolved
  If Unclear: Keep the request open under the current Coordinator
  Next: Wait for specialist resolution

Wait for specialist resolution
  Kind: Wait
  Do: Wait for a specialist decision, a request for additional information, or the stated time limit
  Time Limit: The limit defined by the applicable operating profile or policy
  If Failed: Escalate the overdue request for manual review
  Next:
    - Specialist resolution → Analyze the exception
    - Additional information requested → Gather authoritative records
    - Time limit reached → Escalate the request

Close the request
  Kind: Outcome
  Status: Completed, Completed with warnings, Failed, or Cancelled
  Return: Final resolution, Evidence package, Verification result, Approval record when required, External action and confirmation records when applicable, Remaining warnings or unresolved conditions
```

### Why the roles matter in this example

| Role | Meaning in the workflow | Practical effect |
|------|------------------------|------------------|
| Coordinator | Owns the request and handoffs | Makes routing, ownership, and escalation explicit |
| Researcher | Gathers supported facts | Creates provenance and authoritative-source expectations |
| Analyst | Forms a recommendation and verifies it | Separates interpretation from evidence collection and execution |
| Approver | Authorizes an action | Makes business choices and authorization records visible |
| Executor | Changes an external system | Triggers strict action evidence and confirmation requirements |
| Observer | Confirms the resulting state | Detects mismatches without blindly repeating the action |

The role does not replace the Activity instructions. It shows who is responsible so that readers, validators, governance tools, and runtimes can track accountability.

### Governance

The workflow ensures dependable outcomes through:

- Material facts come from identified authoritative sources.
- The recommendation is verified against evidence.
- Uncertainty is preserved and routed rather than silently converted into success.
- Required authorization is recorded before execution.
- External changes are limited to the authorized action.
- The external result is confirmed independently.
- The complete work record, evidence, decisions, checks, handoffs, and action records are retained.

## Core takeaway

Approachable-Workflows stays readable by expressing work in plain language, but it becomes operationally meaningful by giving every important Activity a clear structure:

**Name, Kind, Role, Needs, Do, Creates, Verify, Failure, Unclear, and Next.**

Evidence is captured implicitly based on Role and Kind.

That structure makes sophisticated workflows understandable to business readers and dependable enough for validation, governance, visualization, compilation, and execution.

**No pattern declarations needed**—the Activities speak for themselves. This workflow clearly shows Research → Analyze → Verify → Approve → Execute, which is self-documenting.
