# Approachable-Workflows Core Specification

**Status**: Draft 0.8 core specification  
**Purpose**: Define Approachable-Workflows as a plain-language workflow specification with progressive formalization - start simple, add detail only when needed.

**Progressive Formalization:** Start with activity names and flow (~10 lines), add roles and verification for production workflows (~50 lines), extend with state and events for complex workflows (~100+ lines). All workflows are valid regardless of complexity.

## Why This Works

**Approachable-Workflows is flexible by design.** You can write workflows in a structured template format, or use a compact natural language form — both are valid. The specification provides guidance, not rigid syntax.

**You only need to follow a few key concepts:**
1. **Name your workflow** and state its Goal
2. **Break work into Activities** with clear responsibilities (Roles)
3. **Specify what happens next** (Next, If Failed, If Unclear)
4. **Add verification** when quality matters (Verify)
5. **Activity feedback is automatic** — execution reports capture it based on Role and Kind

Everything else is optional detail you add when your workflow needs it. A 10-line workflow with just activities and flow is just as valid as a 100-line workflow with state, events, and monitoring.

**Write workflows the way you think about work.** If you naturally describe processes in bullet points, do that. If you prefer structured templates, use ones provide or develop your own. Approachable-Workflows adapts to your style while maintaining the structure needed for execution and governance.

## Part I: Core Specification

### 1. Essential Fields

**Every workflow needs:**
- Workflow name and goal
- Activity names with something to do
- Flow (Next, If Failed, If Unclear)

**Minimal example:**

Workflow: Expense Approval
Goal: Approve or reject expense requests

Activities:
  Receive Request → Review Expense → Manager Decision → Notify Employee

Receive Request:
  Employee submits expense with receipt

Review Expense:
  Check amount is within policy limits

Manager Decision:
  Approve if under $500, otherwise escalate

Notify Employee:
  Send approval or rejection email

### Add Detail As Needed

**For production workflows, add:**
- Role for each activity
- Verify conditions for quality gates
- If Failed paths for critical activities
- Kind when using Choice, Approval, Wait, Repeat, Do Together, Run Workflow, or Outcome

**Production example:**

Workflow: Expense Approval
Goal: Approve or reject expense requests

Review Expense
  Role: Analyst
  Do: Check amount is within policy limits
  Verify: Amount under limit, receipt attached
  If Failed: Reject Request
  Next: Manager Decision

**For complex workflows, add:**
- State tracking (Workflow State and Business State)
- Event handlers (OnFailure, OnTimeout, etc.)
- Performance monitoring
- Needs/Creates for explicit data flow

Add these features only when your workflow needs them.

### 2. Core concepts

#### 2.1 Goal

The business result the workflow is intended to achieve.

A goal describes an outcome, not a technology.

#### 2.2 Handles

What this workflow processes - the business subject handled by one execution.

**Examples**:

- Support request 1042
- Claim 458224
- Purchase request PR-2207
- Security incident INC-301
- Each customer refund request
- Individual supplier invoices

A workflow definition is reusable. "Handles" describes what each execution processes. A workflow instance is one execution handling a specific subject.

#### 2.3 Information
Approachable-Workflows distinguishes:

- Provided information: Known when the workflow begins and unchanged during the instance
- Working information: Created or updated as Activities complete
- Final result: Returned when the workflow reaches an outcome

Information may have plain-language rules such as “Amount is required” or “Decision must be Approved, Rejected, or Needs review.” Profiles or runtime records may add technical schemas.

#### 2.4 Roles

A role describes both responsibility and the type of work performed. A role may be fulfilled by a person, an agent, a team, or a service when the workflow is deployed.

**Standard roles (7 roles)**:

- Coordinator: Routes work, tracks progress, handles handoffs, coordinates activities
- Researcher: Finds information, gathers evidence, retrieves data from sources
- Analyst: Interprets information, analyzes data, produces findings or recommendations, verifies quality
- Approver: Grants or denies authorization, makes approval decisions
- Executor: Performs approved actions, executes external changes
- Observer: Watches conditions, monitors systems, raises events
- Communicator: Formats and delivers messages, reports, notifications

A workflow should name only the roles it needs. The role name indicates what type of work that activity performs.

#### 2.5 Activity

An Activity is the smallest named unit of workflow behavior. An Activity may perform work, make a choice, wait, request approval, or finish the workflow.

#### 2.6 Execution Reporting

**Activity feedback is captured automatically** by the runtime based on Role and Kind — no explicit field needed. Execution reports provide durable proof of what each activity did, verified, and produced.

**Captured for all activities**: Who performed it, start/end time, inputs used, outputs created, verification results.

**Role-specific additions**: Approver (decision, authorization), Executor (transaction ID, system response), Researcher (sources, citations), Observer (confirmation results).

**Retention and access controls** are configured at runtime/deployment level per governance requirements.

#### 2.7 Verify

A verification states what must be true before an Activity can succeed or a workflow can continue.

**Verification returns**:

- Passed
- Failed
- Unclear

The workflow must state what happens after Failed or Unclear when either result is possible.

#### 2.8 Approval

Approval is an authorized human or organizational decision. Approval is not the same as verification. Verification tests criteria. Approval grants authority.

#### 2.9 Governance

Governance explains how the workflow ensures dependable outcomes and maintains trust.

**It may identify**:

- Authoritative information
- Retained evidence
- Independent verification
- Policy checks
- Human approval
- Multiple agreeing sources
- Confirmed external actions

#### 2.10 Outcome

An outcome ends a workflow or branch. Outcomes are referenced by name in Next: fields.

**Explicit Outcome declarations are optional.** Only declare an outcome if you need to specify return values or status details.

**Common outcome names**:

- Completed
- Completed with warnings
- Failed
- Cancelled

Profiles may add business outcomes such as Approved, Rejected, Contained, or Needs review.

**Simple usage** (no declaration needed):

Process Order
  Do: Execute the order
  Next: Completed

**Detailed usage** (declare when specifying returns):

Process Order
  Do: Execute the order
  Next: Completed

Outcome: Completed
  Return:
    - Order confirmation
    - Transaction ID

#### 2.11 State

State describes where the workflow is and the condition of the subject being handled.

**Workflow State** describes execution progress:

- Not Started
- In Progress
- Waiting
- Completed
- Failed
- Cancelled

**Business State** describes the subject's condition and is workflow-specific.

For example, Refund Review uses:

- Submitted
- Under Review
- Pending Approval
- Approved
- Rejected
- Refunded

The two state types are independent. A workflow may be in Waiting (workflow state) while the subject is Under Review (business state).

**Activities may change state**:

Receive Refund Request
  Kind: Work
  Do: Create the work record and classify the request
  State Changes:
    - Set Business State to Submitted
    - Set Workflow State to In Progress
  Next: Check Required Information

State changes should be visible so operators, auditors, and runtime tools can understand the current condition of the workflow and subject.

#### 2.12 Events

Events let workflows respond when important conditions occur beyond normal flow control.

**Event Types**:

- On Failure: When an Activity cannot complete
- On Timeout: When work exceeds its time limit
- On Escalation: When work is transferred to a specialist
- On State Change: When the subject's condition changes
- On Approval Required: When authorization is needed
- On External Change: When an external system signals a change

**Activities may define event responses**:

Analyze Refund Request
  Kind: Work
  Role: Analyst
  Do: Review the request and produce a recommendation
  
  Events:
    On Failure:
      - Log the analysis failure for this request
      - Notify the Refund Operations team
      - Continue to Escalate the request
    
    On Timeout:
      - Continue to Escalate the request
  
  Next: Verify Recommendation

Events provide a clear way to handle exceptional conditions without cluttering the main workflow logic.

## Core Activity Model

### 3. Why Activities need limited formalism

Approachable-Workflows Activities should remain readable as operating instructions, but every Activity needs enough structure for different tools to interpret it consistently.

The Core formalism is intentionally small. It answers:

- What kind of Activity is this?
- Who is responsible?
- What information does it use?
- What does it do or decide?
- What does it produce?
- What evidence does it retain?
- What must be true before it succeeds?
- What happens next?
- What happens if it fails or is unclear?

### 4. Activity Fields (Progressive Detail)

**Essential fields:**
- Activity name
- Do (description)
- Next (or implicit flow)

**Add for production workflows:**
- Role (who is accountable)
- Verify (quality gates)
- If Failed (error paths)
- Kind (when using Choice, Approval, Wait, Repeat, Do Together, Run Workflow, or Outcome)

**Add for complex workflows:**
- Needs, Creates (explicit data flow)
- State Changes
- Events
- Expected Performance
- Time Limit
- When

**Defaults and Simplifications:**

- **Kind defaults to Work** - only specify for Choice, Outcome, Repeat, Do Together, etc.
- **Next is implicit** - activities flow to the next one listed unless specified otherwise
- **Role indicates work type** - Analyst analyzes and verifies, Researcher researches, Executor executes, etc.
- **Needs and Creates are optional** - specify only when not obvious from Do
- **Execution reporting is automatic** - activity feedback captured based on Role and Kind (no explicit field needed)

#### 4.1 Optional Activity Performance Expectations

Activities may declare expected performance for monitoring and alerting.

Activity: Verify Recommendation
  Kind: Work
  Role: Analyst
  
  Do: Verify the recommendation
  
  Expected Performance:
    - Complete within 5 seconds normally
    - Success rate above 95 percent
    - Alert if duration exceeds 10 seconds
    - Alert if success rate falls below 90 percent
  
  Track:
    - How long verification takes
    - Whether verification passed or failed
    - How often unclear results occur

Performance expectations guide runtime monitoring without making them mandatory for all workflows.

### 5. Core Activity kinds

#### 5.1 Work

Performs a meaningful action.

Common work types include: research, analyze, create, verify, communicate, execute, monitor, and coordinate - indicated by the Role.

#### 5.2 Choice

Selects one next path from ordered, plain-language conditions.

A Choice Activity should end with Otherwise unless the workflow intentionally treats no match as a failure.

**Conditions may use simple comparisons and logical operators**:

Activity: Choose Approval Path
  Kind: Choice
  
  Needs:
    - Recommendation
    - Amount
    - Risk level
    - Verification result
  
  Do: Choose the next path
  
  Conditions:
    1. If verification result is Unclear
       → Continue to Needs Review
    
    2. If verification result is Failed
       → Continue to Needs Review
    
    3. If amount is greater than 1000 AND risk level is High
       → Continue to Senior Manager Approval
    
    4. If amount is greater than 1000 OR requires authorization is Yes
       → Continue to Manager Approval
    
    5. Otherwise
       → Continue to Execute Authorized Decision

Logical operators (AND, OR, NOT) and comparisons (is, is not, greater than, less than, in list) keep conditions readable while adding expressive power.

#### 5.3 Approval

Pauses for an authorized decision and routes each allowed choice to a named next Activity or outcome.

#### 5.4 Wait

Pauses until a stated event, condition, or time. It must state what happens if the wait expires.

#### 5.5 Outcome

Ends the workflow or branch with a named result.

### 5A. Advanced Activity Kinds

Advanced structures for concurrent work, repeated work, and reusable workflows. They use the same plain-language style as Core Activities.

#### 5A.1 Repeat

Performs work multiple times over a collection or until a condition is met.

**Example - Processing a collection**:

```text
Workflow: Invoice Processing
Goal: Validate all line items in an invoice
Handles: Each supplier invoice

Activity: Process Invoice Line Items
  Kind: Repeat
  Role: Analyst
  
  Repeat Over: Each line item in the invoice
  Maximum: 100 items
  
  Do: Validate quantity, price, and tax for the line item
  
  For Each Item:
    - If valid: Add to running total
    - If invalid: Record the error and continue with next item
  
  Creates:
    - Validated line items
    - Total amount
    - Error list
  
  When Complete:
    - Continue to Calculate Invoice Total
  
  If Failed:
    - Continue to Manual Line Item Review
```

**Example - Retry with backoff**:

```text
Workflow: Payment Processing
Goal: Submit payment transaction with retry logic
Handles: Payment transaction

Activity: Call External Payment System
  Kind: Repeat
  Role: Executor
  
  Repeat Until: External system responds successfully
  Maximum Attempts: 3
  Wait Between Attempts: 5 seconds, then 10 seconds, then 30 seconds
  
  Do: Submit payment transaction to external system
  
  If Successful:
    - Continue to Confirm Payment
  
  If All Attempts Fail:
    - Continue to Payment System Unavailable
```

#### 5A.2 Do Together

Execute multiple Activities at the same time and wait for results.

```text
Workflow: Refund Processing
Goal: Validate refund request with parallel checks
Handles: Customer refund request

Activity: Validate Refund Request
  Kind: Do Together
  Role: Coordinator
  
  Do These Activities Together:
    - Validate Customer Identity
    - Validate Invoice Exists
    - Check Fraud Indicators
    - Verify Payment Method
  
  Wait For: All activities to complete
  Time Limit: 30 seconds
  
  When All Complete:
    - If all passed: Continue to Analyze Request
    - If any failed: Continue to Escalate the request
    - If time expired: Continue to Escalate the request
```

**Alternative - First to respond**:

```text
Workflow: Policy Retrieval
Goal: Get policy document with failover
Handles: Policy lookup request

Activity: Get Policy from Multiple Sources
  Kind: Do Together
  Role: Researcher
  
  Do These Activities Together:
    - Fetch from Primary Policy Service
    - Fetch from Backup Policy Service
  
  Wait For: First successful response
  Time Limit: 10 seconds
  
  Needs: The response from whichever completes first
  
  Next: Apply Policy Rules
```

#### 5A.3 Run Workflow

Call another workflow as part of this workflow.

```text
Workflow: Order Processing
Goal: Process customer order with credit verification
Handles: Customer order

Activity: Perform Credit Check
  Kind: Run Workflow
  Role: Coordinator
  
  Workflow: Standard Credit Check
  Version: 2.1
  
  Provide:
    - Customer number
    - Requested amount
  
  Receive:
    - Credit score
    - Credit decision
    - Check timestamp
  
  Next:
    - If Credit decision is Approved: Continue to Process Order
    - If Credit decision is Rejected: Continue to Reject Request
    - Otherwise: Continue to Manual Credit Review
```

Invoking workflows promotes reuse and maintains consistency across business processes.

### 6. Author-facing Activity format

#### Activity: Review applicable policy

**Kind**

Work

**Role**

Researcher

**Needs**

- Request summary
- Current policy library

**Do**

Find the policies that apply to the request.

**Creates**

- Applicable policy findings
- Source references

**Verify**

- At least one current authoritative source supports each material finding.
- Every source can be opened by an authorized reviewer.

**If failed**

Try the approved alternate policy source. If that also fails, send the request to manual review.

**If unclear**

Send the request to a policy specialist.

**Next**

Analyze the request.

### 7. Compact Activity notation

Documents, forms, and diagrams may use a compact representation when the full meaning remains available.

Review applicable policy
Work | Researcher | Research
Needs: Request summary and current policy library
Creates: Policy findings and source references
Verify: Every material finding has a current authoritative source
Failed or unclear: Manual policy review
Next: Analyze the request

The compact form is a view of the same Activity, not a different language.

### 8. Activity identity and references

Each Activity must have a stable identifier in the portable record, even if authors see only its name.

- Names should be clear verb-and-object phrases.
- Identifiers must be unique within a workflow definition.
- Next paths must reference existing Activities or outcomes.
- Renaming an Activity should not change its stable identity.
- Evidence and execution records should refer to the stable identity.

### 9. Activity completion rule

A Work Activity succeeds only after:

1. Its work completes.
2. Its produced information satisfies stated rules.
3. Required evidence is retained.
4. Required checks pass.
5. Its successful information updates are committed together.

A failed attempt must not partially update shared working information.

An Approval Activity succeeds only after an authorized decision is recorded. A Wait Activity succeeds only after its stated event, condition, or time is reached. A Choice Activity succeeds only after exactly one route is selected.

## Quick Tips & Common Pitfalls

### Essential Rules

**Structure:**
- Every Choice must end with Otherwise (or intend no-match = fail)
- Every Wait must have Time Limit + timeout behavior
- Every Repeat must have Maximum or Maximum Attempts
- Every activity needs Next (unless Outcome)

**Quality Gates:**
- Use Verify: for condition checks, not Kind: Approval
- Verify conditions must be objective and testable (not "looks good")
- Critical activities need If Failed paths
- Unclear results need If Unclear paths → route to human review

**Governance:**
- High-risk Executor → preceded by Approver (Law 2: Authorization)
- External actions → followed by Observer (Law 3: Confirmation)
- Never force unclear to clear (Law 1: Truth Preservation)

**Accountability:**
- Specify Role for production workflows (who is responsible?)
- Approvals automatically capture feedback (decision, identity, timestamp)
- Use Kind: Approval + Needs to document what approver reviews

**Verification:**
- Verify: is a condition check, same role can do analysis + verification
- For thorough checking, create separate verification activity

### Before Finalizing

- [ ] Every Choice ends with Otherwise
- [ ] Every Wait has Time Limit + timeout path
- [ ] Every Repeat is bounded (Maximum/Maximum Attempts)
- [ ] Critical activities have If Failed paths
- [ ] External Executor followed by Observer
- [ ] Verify conditions are objective
- [ ] Roles specified for accountability
- [ ] Approvals use Kind: Approval
- [ ] Unclear → human review, not forced clear
- [ ] Every activity has Next (unless Outcome)

---

**See also**: 
- [Visual Patterns](visual-patterns.md) for correct pattern examples
- [Quick Reference](quick-reference.md) for field requirements
- [Step-by-Step Guide](../tutorials/step-by-step.md) for complete learning guide

## Part II: One-Page Core Authoring Template

**See [standard-template.md](../../templates/standard-template.md) for the complete one-page template** with field reference, role guide, activity kinds, common patterns, and examples.

The template includes:
- Full workflow structure with all fields
- Minimal quick-start version for simple workflows
- 7 roles reference table
- 8 activity kinds reference
- Common workflow patterns
- Tips for getting started

**Quick template preview:**
text
Workflow: [Name]
Goal: [What you want to achieve]
Handles: [What each execution processes]

Activity: [Name]
  Role: [Who]
  Do: [What happens]
  Verify: [What must be true]
  If Failed: [Failure path]
  Next: [Next activity]

## Part III: Core Conformance

### 17. Conformance

**Essential conformance:**

1. State workflow name and goal
2. Name each Activity with clear verb-object phrase
3. Describe what each Activity does
4. Show the flow (arrows or Next field)
5. Define at least one outcome

**Production workflow conformance adds:**

6. Assign a Role to each Activity
7. State checks for decisions and external actions
8. Define If Failed behavior when checks can fail
9. Bound every repeating path

**Complex workflow conformance adds:**

11. Explicit Kind for non-Work activities
12. State tracking when needed
13. Event handlers when needed
14. Performance expectations when needed

### 18. Validation messages

Validators should report errors in business language.

**Examples**:

- “Review applicable policy has no next Activity.”
- “Manager approval offers Approve, but the workflow does not say what follows.”
- “Verify recommendation can return Unclear, but no path is defined for that result.”
- “Issue refund changes an external system but does not require an action record as evidence.”
- “Request changes can repeat without a limit.”

### 19. Progressive Formalization Guide

**Start simple for**:

- Sequential work
- Ordered choices
- Human approval
- A single wait
- Explicit outcomes
- Plain failure and unclear-result paths

**Add detail for**:

- Parallel or quorum execution
- Repeated work over collections
- Detailed retry and backoff
- Reusable subworkflows
- Advanced execution reporting and retention
- Threshold or weighted verification
- Multi-party approval

### 20. Summary

Approachable-Workflows Core provides a plain-language, business-analyst-friendly way to describe accountable workflows while remaining powerful enough for AI engineers and structured enough for runtime compilation.

The core is built on a small, formal Activity model:

**Name, Kind, Role, Needs, Do, Creates, Verify, Failure, Unclear, and Next.**

Activity feedback is captured in execution reports by the runtime based on Role and Kind.

Add detail as needed: Repeat, Do Together, and Run Workflow for complex flows. Events, State management, and performance expectations for mission-critical workflows—all in the same plain language.

No YAML. No JSON. No code. Just clear English that describes what needs to happen.
