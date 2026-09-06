# The Activity Model

**How activities work and why they're designed this way.**

---

## The Core Concept

An **activity** is the atomic unit of work in Approachable-Workflows. Every workflow is a graph of activities connected by transitions.

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

This single activity defines:
- **Who** (Role: Analyst)
- **What inputs** (Needs: Request data)
- **What happens** (Do: Check...)
- **What outputs** (Creates: Validation result)
- **Quality gate** (Verify: ...)
- **Success path** (Next: Make Decision)
- **Failure path** (If Failed: Reject incomplete)

---

## The Two-Part Model

Every activity separates two concerns:

| Concern | Field | Example |
|---------|-------|---------|
| **What structural behavior occurs?** | `Kind` | Work, Choice, Approval, Wait, Outcome |
| **Who is accountable?** | `Role` | Researcher, Analyst, Approver, Executor |

### Why This Separation Matters

**Without separation (traditional):**
```yaml
- name: analyst_review_task
  type: user_task
  assignee: ${analyst}
```
Problem: "analyst_review_task" mixes behavior (review) with identity (analyst).

**With separation (Approachable-Workflows):**
```text
Review Request
  Kind: Work
  Role: Analyst
```
Benefit: Change staffing (analyst → AI agent) without changing the workflow graph.

---

## Activity Kinds (Graph Node Types)

### Work (Default)
Standard activity that performs work.

```text
Analyze Request
  Role: Analyst
  Do: Compare data and form recommendation
  Next: Verify Recommendation
```

**Graph behavior:** Single entry, single exit, conditional branching on verification.

---

### Choice (Routing)
Decision point that routes based on conditions.

```text
Route by Amount
  Kind: Choice
  Do: Select routing based on amount
  Conditions:
    1. If amount > $1000 → Senior Approval
    2. Otherwise → Auto-Approve
  Next: The activity named by the selected route
```

**Graph behavior:** Single entry, multiple exits, condition-based edge selection.

---

### Approval (Authorization)
Human authorization gate.

```text
Approve Payment
  Kind: Approval
  Role: Approver
  Do: Review and approve or reject
  Next:
    - Approve → Execute Payment
    - Reject → Return to Analysis
```

**Graph behavior:** Single entry, multiple exits based on approval decision.

**Special evidence:** Captures authorization record (who, when, what decision, why).

---

### Wait (Pause)
Pauses for external event or timeout.

```text
Wait for Upload
  Kind: Wait
  Do: Wait for customer to upload documents
  Time Limit: 48 hours
  Next:
    - Documents received → Validate Documents
    - Timeout → Expired
```

**Graph behavior:** Suspends execution, resumes on event or timeout.

---

### Repeat (Loop)
Iterates over collection or until condition.

```text
Process Each Document
  Kind: Repeat
  Repeat Over: Each document in the upload
  Maximum: 100 documents
  Do: Classify and analyze each document
  Next: Summarize Results
```

**Graph behavior:** Loop node with internal iteration, single exit when complete.

---

### Do Together (Parallel)
Runs multiple activities concurrently.

```text
Validate Request
  Kind: Do Together
  Do These Activities Together:
    - Check Customer Credit
    - Check Inventory
    - Check Fraud
  Wait For: All
  Next: Process Order
```

**Graph behavior:** Fork node, parallel subgraph execution, join on completion.

---

### Run Workflow (Subgraph)
Invokes another workflow.

```text
Run Credit Check
  Kind: Run Workflow
  Workflow: Standard Credit Check
  Provide: Customer ID, Amount
  Receive: Credit decision, Credit score
  Next: Process Order
```

**Graph behavior:** Subgraph invocation, state passed in/out.

---

### Outcome (Terminal)
Workflow termination point.

```text
Completed
  Kind: Outcome
  Status: Success
  Return: Final results, Evidence package
```

**Graph behavior:** Terminal node, no outgoing edges.

---

## State Propagation (Data Flow)

Activities pass data through `Creates:` → `Needs:` connections:

```text
Research Policy
  Creates: Policy document, Policy version
  Next: Analyze Request

Analyze Request
  Needs: Policy document, Policy version
  Creates: Recommendation
  Next: Verify Recommendation

Verify Recommendation
  Needs: Recommendation, Policy document
  Creates: Verification result
  Next: Make Decision
```

**This is the graph's data flow:**
```
Research → [Policy] → Analyze → [Recommendation] → Verify → [Verification result] → Make Decision
```

---

## Verification as Quality Gates

`Verify:` conditions are **node-level assertions** that must pass:

```text
Gather Records
  Do: Retrieve records from sources
  Verify: Every material fact has an authoritative source
  If Failed: Try alternate sources
  Next: Analyze Records
```

**Graph behavior:**
- Verification passes → Follow `Next:` edge
- Verification fails → Follow `If Failed:` edge
- No `If Failed:` → Stay at current node (block)

**This creates explicit quality gates in the graph.**

---

## Roles and Activity Feedback

The `Role` determines what feedback is captured in execution reports:

| Role | Activity Feedback |
|------|-------------------|
| **Researcher** | Sources cited, provenance trail |
| **Analyst** | Reasoning, findings, recommendations |
| **Approver** | Authorization record (who, when, decision, reasoning) |
| **Executor** | Action record (what was done, system response, transaction ID) |
| **Observer** | Confirmation record (what was verified, timestamp) |
| **Communicator** | Message sent, recipient, timestamp |
| **Coordinator** | Routing decisions, handoffs, ownership changes |

**This is automatic — you don't write reporting code.**

---

## Activities as Graph Nodes

### Traditional Graph Definition (Code)
```python
graph = {
    'Review': {
        'success': 'MakeDecision',
        'failure': 'RejectIncomplete'
    },
    'MakeDecision': {
        'success': 'NotifyCustomer'
    },
    # ...
}
```

### Approachable-Workflows (Plain Language)
```text
Review Request
  Verify: Request is complete
  If Failed: Reject incomplete
  Next: Make Decision

Make Decision
  Do: Approve or reject
  Next: Notify Customer

Reject incomplete
  Do: Return request with missing fields
  Next: Completed
```

**Same graph, readable by anyone.**

---

## Execution Model

When a workflow runs:

1. **Node Entry:** Agent enters activity node
2. **Execute Do:** Perform the work described in `Do:`
3. **Evaluate Verify:** Check `Verify:` conditions
4. **State Update:** Update `Creates:` outputs
5. **Edge Selection:**
   - Verify passed → Follow `Next:`
   - Verify failed → Follow `If Failed:`
   - Neither → Stay at current node
6. **Activity Feedback:** Captured automatically
7. **Repeat:** Continue to next node

**This is directed graph traversal, not sequential prompting.**

---

## Why This Model Works

### For Business Analysts
- ✅ Activities read like process steps
- ✅ No need to think in "nodes" and "edges"
- ✅ Natural language = natural thinking

### For Prompt Engineers
- ✅ Minimal syntax to learn
- ✅ Clear structure for templates
- ✅ Easy to adapt examples

### For AI Engineers
- ✅ Compiles to formal DAG
- ✅ Verifiable graph properties
- ✅ State management built in
- ✅ Parallel execution support

### For AI Agents
- ✅ Structured enough to parse
- ✅ Natural enough to understand intent
- ✅ Explicit quality gates
- ✅ Clear routing rules

---

## Activity Lifecycle

```
┌─────────────────┐
│   Activity      │
│   Defined       │
└────────┬────────┘
         │
         v
┌─────────────────┐
│   Ready to      │
│   Execute       │
└────────┬────────┘
         │
         v
┌─────────────────┐
│   Executing     │
│   Do:           │
└────────┬────────┘
         │
         v
┌─────────────────┐
│   Evaluating    │
│   Verify:       │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    v         v
┌────────┐ ┌──────────┐
│ Pass   │ │  Fail    │
└───┬────┘ └────┬─────┘
    │           │
    v           v
┌────────┐ ┌──────────┐
│ Next   │ │ If Failed│
└────────┘ └──────────┘
```

---

## See Also

**Learn more concepts:**
- [Overview](overview.md) — Complete workflow concepts
- [Philosophy](philosophy.md) — Design principles
- [Why It Works](why-it-works.md) — Graph engineering evidence

**See it in action:**
- [Tutorial: Your First Workflow](../tutorials/first-workflow.md)
- [Step-by-Step Guide](../tutorials/step-by-step.md) — Complete learning guide

**Look up syntax:**
- [Field Reference](../reference/fields.md) — All fields explained
- [Spec for Humans](../reference/spec-for-humans.md) — Complete specification
