# Field Reference

**Complete A-Z reference for all Approachable-Workflows fields.**

---

## Activity Definition Fields

### Activity Name (Required)

```text
Review Request
  ...
```

**Purpose:** Identifies the activity. Used for `Next:` routing and in execution reports.

**Rules:**
- Must be unique within the workflow
- Use clear, action-oriented names
- Can include spaces

**Examples:**
- ✅ `Review Request`
- ✅ `Gather authoritative records`
- ✅ `Route by risk and value`
- ❌ `Step1` (not descriptive)

---

### Kind (Optional, default: Work)

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

### Role (Optional for Work, Required for Approval)

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

### Needs (Optional)

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

### Do (Required)

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

### Creates (Optional)

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

### Verify (Optional but Recommended)

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

### If Failed (Optional)

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

### If Unclear (Optional)

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

### Next (Required for most activities)

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

### State Changes (Extended - Optional)

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

## Choice Activity Fields

### Conditions (Required for Kind: Choice)

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

---

## Approval Activity Fields


## Repeat Activity Fields

### Repeat Over (Required for Kind: Repeat)

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

### Maximum (Optional for Repeat)

```text
Maximum: 100 documents
```

**Purpose:** Sets upper limit on iterations (prevents infinite loops).

---

## Wait Activity Fields

### Time Limit (Optional for Kind: Wait)

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

---

## Workflow-Level Fields

### Workflow (Required)

```text
Workflow: Customer Refund Review
```

**Purpose:** Names the workflow.

---

### Version (Optional)

```text
Version: 1.0
```

**Purpose:** Tracks workflow versions.

---

### Goal (Required)

```text
Goal: Approve or reject refund requests
```

**Purpose:** Describes the business result to achieve.

---

### Handles (Optional)

```text
Handles: Each refund request
```

**Purpose:** Describes what each execution processes.

---

### Provided (Optional)

```text
Provided:
  - Refund request
  - Customer record
  - Policy document
```

**Purpose:** Lists inputs available to the workflow.

---

### Returns (Optional)

```text
Returns:
  - Approval decision
  - Evidence package
  - Notification confirmation
```

**Purpose:** Lists outputs produced by the workflow.

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

---

## Field Combinations

### Minimal Activity
```text
Review Request
  Do: Check if complete
  Next: Make Decision
```

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

## See Also

- [Activity Kinds Reference](activity-kinds.md) — Detailed explanation of each Kind
- [Role Reference](roles.md) — When to use each role
- [Tutorial: Your First Workflow](../tutorials/first-workflow.md) — Learn by building
- [Spec for Humans](spec-for-humans.md) — Complete language specification
