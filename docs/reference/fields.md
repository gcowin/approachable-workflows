# Field Reference

**Complete reference for all Approachable-Workflows fields.**

This reference is organized workflow-first: start with workflow-level fields, then common activity fields, then specialized fields for specific activity kinds.

---

## Part I: Workflow-Level Fields

These fields define the workflow itself and appear at the top of your workflow specification.

### Workflow (Required)

```text
Workflow: Customer Refund Review
```

**Purpose:** Names the workflow.

**Rules:**
- Clear, descriptive name
- Used in execution reports and documentation

---

### Version (Optional)

```text
Version: 1.0
```

**Purpose:** Tracks workflow versions for change management.

---

### Goal (Required)

```text
Goal: Approve or reject refund requests
```

**Purpose:** Describes the business result to achieve.

**Rules:**
- Focus on outcome, not implementation
- One clear sentence

---

### Handles (Optional)

```text
Handles: Each refund request
```

**Purpose:** Describes what each workflow execution processes (the business subject).

**Examples:**
- `Each customer refund request`
- `Individual supplier invoices`
- `Security incident`

---

### Provided (Optional)

```text
Provided:
  - Refund request
  - Customer record
  - Policy document
```

**Purpose:** Lists inputs available to the workflow at start.

**Rules:**
- These become available to activities via `Needs:`
- Known at workflow start, unchanged during execution

---

### Returns (Optional)

```text
Returns:
  - Approval decision
  - Evidence package
  - Notification confirmation
```

**Purpose:** Lists outputs produced by the workflow.

**Rules:**
- Available when workflow reaches an Outcome
- Documents the workflow's interface

---

### Configuration (Optional)

```text
Configuration:
  Tools:
    - Salesforce CRM (read customer records)
    - SendGrid (send emails)
  Settings:
    - Timeout: 30 minutes
    - Evidence storage: OneDrive /Evidence/
```

**Purpose:** Specifies tools and settings for execution.

**When to use:**
- Runtime needs specific tool access
- Environment-specific settings
- Deployment configurations

---

### Governance (Optional)

```text
Governance:
  - Current authoritative policy sources
  - Independent verification of recommendations
  - Human approval for high-risk decisions
  - Recorded external-system confirmations
```

**Purpose:** Documents how the workflow ensures dependable outcomes.

**Best Practice:** Include for production workflows to document quality assurance approach.

---

## Part II: Activity-Level Fields

### Common Activity Fields

These fields can be used with any activity, regardless of Kind.

#### Activity Name (Required)

```text
Review Request
  ...
```

**Purpose:** Identifies the activity. Used for `Next:` routing and in execution reports.

**Rules:**
- Must be unique within the workflow
- Use clear, action-oriented names (verb + object)
- Can include spaces

**Examples:**
- ✅ `Review Request`
- ✅ `Gather authoritative records`
- ✅ `Route by risk and value`
- ❌ `Step1` (not descriptive)

---

#### Kind (Optional, default: Work)

```text
Activity Name
  Kind: Work | Choice | Approval | Wait | Outcome | Repeat | Do Together | Run Workflow
```

**Purpose:** Defines the structural behavior of the activity.

**Options:**
- **Work** — Standard activity that performs work (default)
- **Choice** — Routing decision based on conditions
- **Approval** — Human authorization required
- **Wait** — Pause for external event or timeout
- **Outcome** — Workflow termination point
- **Repeat** — Loop over collection or until condition
- **Do Together** — Parallel execution of sub-activities
- **Run Workflow** — Invoke another workflow

**When to specify:**
- Omit for standard work activities (default)
- Always specify for non-Work kinds

---

#### Role (Optional for Work, Required for Approval)

```text
Activity Name
  Role: Coordinator | Researcher | Analyst | Approver | Executor | Communicator | Observer
```

**Purpose:** Identifies who is accountable for the activity.

**The 7 Roles:**

| Role | Responsibility | When to Use |
|------|----------------|-------------|
| **Coordinator** | Routes work, tracks progress, handles handoffs | Workflow orchestration, routing, handoffs |
| **Researcher** | Finds information, gathers evidence, retrieves data | Data gathering, source lookup, research |
| **Analyst** | Interprets information, forms recommendations, verifies quality | Analysis, recommendation, verification |
| **Approver** | Grants or denies authorization | Authorization decisions, approvals |
| **Executor** | Performs approved actions, executes external changes | External system changes, payments, actions |
| **Communicator** | Formats and delivers messages | Notifications, emails, reports |
| **Observer** | Monitors external systems, confirms results | Result confirmation, reconciliation |

**Activity feedback is captured automatically in execution reports** - no explicit field needed.

---

#### Needs (Optional)

```text
Activity Name
  Needs: Input1, Input2, Input3
```

**Purpose:** Declares inputs required for this activity (like function parameters).

**Rules:**
- Comma-separated list
- Must come from prior activity's `Creates:` or workflow's `Provided:`
- Verification fails if needed inputs are missing

**Examples:**
```text
Analyze Request
  Needs: Customer record, Policy document, Request details
```

---

#### Do (Required)

```text
Activity Name
  Do: Description of what this activity does
```

**Purpose:** Explains what happens during this activity.

**Rules:**
- Clear, actionable description
- Can be multi-line for complex activities
- Describes the work, not the outcome

**Examples:**
```text
Do: Retrieve customer record from CRM and policy document from SharePoint
```

```text
Do: Compare invoice with purchase order, receiving evidence, and contract terms. Form a recommendation without changing any external system.
```

---

#### Creates (Optional)

```text
Activity Name
  Creates: Output1, Output2, Output3
```

**Purpose:** Declares outputs produced by this activity.

**Rules:**
- Comma-separated list
- These become available to downstream activities' `Needs:`
- Represents state propagation through the workflow graph

**Examples:**
```text
Creates: Recommendation, Risk score, Evidence package
```

---

#### Verify (Optional but Recommended)

```text
Activity Name
  Verify: Condition to check
```

**Purpose:** Quality gate that must pass before activity completes.

**Rules:**
- Activity cannot complete until verification passes
- Multiple conditions separated by semicolons
- Failure triggers `If Failed:` path

**Examples:**
```text
Verify: Amount is present; Customer ID is valid
```

```text
Verify: Every material fact has an authoritative source
```

**Best Practice:** Always add `Verify:` for critical activities.

---

#### If Failed (Optional)

```text
Activity Name
  Verify: Condition
  If Failed: Activity Name or action description
  Next: Activity Name
```

**Purpose:** Defines what happens when verification fails.

**Options:**
1. **Route to another activity:**
   ```text
   If Failed: Reject incomplete request
   ```

2. **Describe failure handling:**
   ```text
   If Failed: Log error and escalate to manual review
   ```

**Rules:**
- Only evaluated if `Verify:` fails
- Can name another activity or describe an action
- If omitted, failure halts workflow at this activity

---

#### If Unclear (Optional)

```text
Activity Name
  If Unclear: Activity Name or action description
```

**Purpose:** Handles uncertainty (neither success nor clear failure).

**When to use:**
- External system status unknown
- Data is ambiguous
- Manual review needed

**Examples:**
```text
If Unclear: Route to specialist for investigation
```

---

#### Next (Required for most activities)

```text
Activity Name
  Next: Activity Name
```

**Purpose:** Defines the next activity on success.

**Rules:**
- Must name an activity defined in the workflow
- Can be omitted if activity ends workflow
- For Choice activities, see `Conditions:` instead

**Examples:**
```text
Next: Make Decision
```

```text
Next: Completed
```

---

#### State Changes (Extended - Optional)

```text
Activity Name
  State Changes: Set Business State to Under Review
```

**Purpose:** Tracks business state transitions.

**Examples:**
```text
State Changes: Set Business State to Approved
```

```text
State Changes: Set Workflow State to Awaiting Approval
```

---

#### Events (Extended - Optional)

```text
Activity Name
  Events:
    On Failure: Log error + Notify team → Escalate
    On Timeout: → System Unavailable
```

**Purpose:** Handles exceptional conditions.

**When to use:**
- Define behavior for failures, timeouts, escalations
- Triggers actions before routing to next activity

---

### Kind-Specific Fields

Additional fields required or available for specialized activity kinds.

#### Choice Activity Fields

##### Conditions (Required for Kind: Choice)

```text
Route Decision
  Kind: Choice
  Do: Select routing based on criteria
  Conditions:
    1. If amount > $1000 → Senior Approval
    2. If amount > $500 → Manager Approval
    3. Otherwise → Auto-Approve
  Next: The activity named by the selected route
```

**Purpose:** Defines routing rules for Choice activities.

**Rules:**
- Numbered list
- Evaluated in order
- First matching condition wins
- Use `Otherwise` for default case
- Arrow `→` indicates target activity

**Operators:** AND, OR, NOT, >, <, ≥, ≤, =, ≠

---

#### Approval Activity Fields

Approval activities use only common fields. No additional fields required.

**Key fields for Approvals:**
- `Kind: Approval` (required)
- `Role: Approver` (required)
- `Needs:` (recommended - what the approver reviews)
- `Next:` (with decision paths: Approve → X, Reject → Y)

---

#### Repeat Activity Fields

##### Repeat Over (Required for collection iteration)

```text
Process Each Document
  Kind: Repeat
  Repeat Over: Each document in the upload
  Maximum: 100 documents
  Do: Classify and analyze each document
  Next: Summarize Results
```

**Purpose:** Defines the collection to iterate over.

---

##### Repeat Until (Required for retry logic)

```text
Submit Payment
  Kind: Repeat
  Repeat Until: System responds successfully
  Maximum Attempts: 3
  Wait Between Attempts: 5s, 15s, 45s
  If Successful: Confirm
  If All Attempts Fail: System Unavailable
```

**Purpose:** Defines the success condition for retry loops.

---

##### Maximum / Maximum Attempts (Required)

```text
Maximum: 100 documents
```
or
```text
Maximum Attempts: 3
```

**Purpose:** Sets upper limit on iterations (prevents infinite loops).

**Rules:**
- Required for all Repeat activities
- Use `Maximum` for collections
- Use `Maximum Attempts` for retry logic

---

##### For Each Item (Optional)

```text
For Each Item:
  - If valid: Add to results
  - If invalid: Add to exceptions
```

**Purpose:** Defines per-item processing logic.

---

##### Wait Between Attempts (Optional for retry)

```text
Wait Between Attempts: 5s, 15s, 45s
```

**Purpose:** Defines backoff strategy for retry attempts.

---

#### Wait Activity Fields

##### Time Limit (Required for Kind: Wait)

```text
Wait for Upload
  Kind: Wait
  Do: Wait for customer to upload documents
  Time Limit: 48 hours
  Next:
    - Documents received → Validate Documents
    - Timeout → Expired
```

**Purpose:** Sets timeout for wait activities.

**Rules:**
- Required for Wait activities
- Must define what happens on timeout

---

#### Do Together Fields

##### Do These Activities Together (Required)

```text
Validate Request
  Kind: Do Together
  Do These Activities Together:
    - Check Customer Identity
    - Check Inventory
    - Check Credit
  Wait For: All
  Time Limit: 30s
  When All Complete:
    - If all passed → Process
    - If any failed → Reject
```

**Purpose:** Lists activities to execute in parallel.

---

##### Wait For (Required)

**Options:**
- `Wait For: All` - Wait for all activities to complete
- `Wait For: First` - Wait for first successful response

---

##### When All Complete (Required)

**Purpose:** Defines routing based on parallel execution results.

**Rules:**
- Must handle: all passed, any failed, timeout scenarios

---

#### Run Workflow Fields

##### Workflow (Required)

```text
Activity: Run Credit Check
  Kind: Run Workflow
  Workflow: Standard Credit Check
  Version: 2.1
  Provide:
    - Customer ID
    - Requested Amount
  Receive:
    - Credit Decision
    - Credit Score
  Next: Process Order
```

**Purpose:** Names the workflow to invoke.

---

##### Provide (Required)

**Purpose:** Specifies inputs to pass to the invoked workflow.

---

##### Receive (Required)

**Purpose:** Specifies outputs to receive from the invoked workflow.

---

## Part III: Examples

### Minimal Activity

```text
Review Request
  Do: Check if complete
  Next: Make Decision
```

---

### Standard Activity

```text
Review Request
  Role: Analyst
  Needs: Request data
  Do: Check if complete and meets policy
  Creates: Validation result
  Verify: Amount and customer ID present
  If Failed: Reject incomplete
  Next: Make Decision
```

---

### Extended Activity with State

```text
Review Request
  Role: Analyst
  Needs: Request data
  Do: Check if complete and meets policy
  Creates: Validation result
  Verify: Amount and customer ID present
  State Changes: Set Business State to Under Review
  If Failed: Set Business State to Incomplete; Reject incomplete
  Next: Make Decision
```

---

### Complete Workflow Example

```text
Workflow: Refund Review
Version: 1.0
Goal: Approve or reject refund requests
Handles: Each customer refund request

Provided:
  - Refund request
  - Customer record

Returns:
  - Decision
  - Evidence package

Activity: Review Request
  Role: Analyst
  Needs: Refund request, Customer record
  Do: Verify request completeness
  Verify: All required fields present
  If Failed: Request More Information
  Next: Analyze Request

Activity: Analyze Request
  Role: Analyst
  Do: Determine if request meets policy
  Verify: Decision supported by policy
  Next: Manager Approval

Activity: Manager Approval
  Kind: Approval
  Role: Approver
  Needs: Analysis results
  Do: Approve or reject
  Next:
    - Approve → Process Refund
    - Reject → Rejected

Outcome: Rejected
  Return: Decision, Reason

Activity: Process Refund
  Role: Executor
  Do: Execute refund transaction
  Verify: Transaction confirmed
  Next: Completed

Outcome: Completed
  Return: Decision, Transaction ID, Evidence package
```

---

## See Also

- [Spec for Humans](spec-for-humans.md) — Complete language specification
- [Activity Model](../explanation/activity-model.md) — Understanding activities and roles
- [Tutorial: Your First Workflow](../tutorials/first-workflow.md) — Learn by building
- [Quick Reference](quick-reference.md) — One-page cheatsheet
