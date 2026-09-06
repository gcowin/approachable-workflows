# Design Philosophy: Why Plain Language?

**The Core Question:** Why use plain English instead of YAML, JSON, or code for workflows?

---

## The Problem with Traditional Workflow Languages

### BPMN (Business Process Model and Notation)
```xml
<bpmn:userTask id="Task_1" name="Review Request">
  <bpmn:incoming>Flow_1</bpmn:incoming>
  <bpmn:outgoing>Flow_2</bpmn:outgoing>
</bpmn:userTask>
```

**Issues:**
- ❌ Requires graphical tools or XML expertise
- ❌ Business analysts can't read or edit it
- ❌ Version control diffs are unreadable
- ❌ No way to express verification conditions naturally

### YAML Workflows (GitHub Actions, etc.)
```yaml
- name: Review Request
  uses: actions/workflow@v2
  with:
    role: analyst
    verify: |
      request.amount && request.customerId
```

**Issues:**
- ❌ Indentation-sensitive (breaks easily)
- ❌ Cryptic syntax (`uses:`, `with:`, `|`)
- ❌ Not conversational — reads like configuration
- ❌ Business users can't write it confidently

### Code (Python, JavaScript, etc.)
```python
def review_request(request):
    if not (request.amount and request.customer_id):
        raise ValidationError("Incomplete request")
    return make_decision(request)
```

**Issues:**
- ❌ Requires programming expertise
- ❌ Mixes logic with infrastructure
- ❌ Not readable by business stakeholders
- ❌ Verification is implicit, not explicit

---

## The Approachable-Workflows Answer

```text
Review Request
  Role: Analyst
  Needs: Refund request, Customer record
  Do: Check if the refund request meets our policy
  Verify: Request amount and customer ID are present
  If Failed: Reject incomplete request
  Next: Make Decision
```

**Why this works:**
- ✅ Readable by anyone (business analyst to AI architect)
- ✅ Editable without special tools
- ✅ Version control diffs are meaningful
- ✅ Verification is explicit and visible
- ✅ Structure is self-documenting
- ✅ Conversational but precise

---

## The Three Design Principles

### 1. **Plain Language First**

Every field uses natural English:
- `Do:` not `execute:` or `<action>`
- `If Failed:` not `onError:` or `catch:`
- `Verify:` not `assert:` or `validation:`

**Principle:** If you'd say it to a colleague, you can write it in the workflow.

### 2. **Progressive Formalization**

Start simple, add detail only when needed:

**Simple (10 lines):**
```text
Review Request
  Do: Check the request
  Next: Make Decision
```

**Standard (with verification):**
```text
Review Request
  Role: Analyst
  Do: Check the request
  Verify: Request is complete
  Next: Make Decision
```

**Extended (with state and events):**
```text
Review Request
  Role: Analyst
  Do: Check the request
  Verify: Request is complete
  State Changes: Set Business State to Under Review
  If Failed: Set Business State to Incomplete
  Next: Make Decision
```

All three are valid. The language doesn't force complexity.

### 3. **Defaults Over Specification**

Smart defaults reduce noise:
- `Kind:` defaults to `Work` (most common)
- `Role:` implies capabilities (Analyst analyzes, Researcher researches)
- `Next:` is implicit when there's only one path forward

**Without defaults:**
```text
Activity: Review Request
  Kind: Work
  Role: Analyst
  Capability: Analysis
  Next: Make Decision
  If Success: Make Decision
```

**With defaults:**
```text
Review Request
  Role: Analyst
  Do: Check the request
  Next: Make Decision
```

Same meaning, half the text.

---

## What Makes It "Graph Engineering"?

Critics say: *"That's not graph engineering, it's just plain text."*

**We say:** It's both.

### You're Building a Directed Graph

```text
Review Request
  If Failed: Reject incomplete
  Next: Make Decision
```

This defines:
- **Node:** "Review Request" activity
- **Edges:** Two outgoing edges
  - Success edge → "Make Decision"
  - Failure edge → "Reject incomplete"
- **Conditions:** Edge selection based on `Verify:` result

### The LLM Executes Graph Traversal

When an agent runs this workflow:
1. **Node entry:** Execute "Review Request" activity
2. **Evaluation:** Run `Verify:` conditions
3. **Edge selection:** Choose next node based on result
4. **State propagation:** Pass `Creates:` outputs to next node's `Needs:`
5. **Repeat:** Continue until reaching an outcome node

**This is graph traversal**, not sequential prompting.

[See why-it-works.md](why-it-works.md) for evaluation evidence (99.5/100).

---

## The Business Value

### For Business Analysts
- ✅ Write workflows like you describe processes
- ✅ No training on BPMN or YAML required
- ✅ Direct collaboration with technical teams
- ✅ Own the workflow definition

### For Prompt Engineers
- ✅ Minimal syntax to learn
- ✅ Expressive templates
- ✅ Easy to adapt examples
- ✅ Natural language = natural thinking

### For AI Engineers
- ✅ Full workflow power (state, events, parallel execution)
- ✅ Compiles to executable graphs
- ✅ Token-efficient for LLM context
- ✅ Governance built in (3-law enforcement)

---

## Comparison: Same Workflow, Different Languages

### Approachable-Workflows (15 lines)
```text
Review Request
  Role: Analyst
  Needs: Refund request
  Do: Check if complete and meets policy
  Verify: Amount and customer ID present
  If Failed: Reject incomplete
  Next: Make Decision

Make Decision
  Role: Approver
  Do: Approve or reject based on policy
  Verify: Decision has reasoning
  Next: Notify Customer

Notify Customer
  Role: Communicator
  Do: Send email to customer
  Next: Completed
```

### YAML (30 lines)
```yaml
workflow:
  name: refund-review
  jobs:
    review:
      runs-on: analyst
      inputs:
        - refund_request
      steps:
        - name: Check request
          run: validate_request
          verify:
            - amount_present
            - customer_id_present
          on-failure:
            goto: reject
        - name: Route to decision
          goto: decision
    decision:
      runs-on: approver
      needs: review
      steps:
        - name: Make decision
          run: approve_or_reject
          verify:
            - has_reasoning
        - name: Route to notify
          goto: notify
    # ... continues for 30+ lines
```

### Python (40+ lines)
```python
class RefundReviewWorkflow:
    def __init__(self, request):
        self.request = request
        
    def review_request(self):
        if not self.request.amount or not self.request.customer_id:
            raise ValidationError("Incomplete")
        # ...continues with class methods, error handling, state management
```

**The plain language version:**
- 50% shorter than YAML
- 60% shorter than Python
- 100% readable by business users
- Just as powerful

---

## The Assisted-Delivery Advantage

**Traditional:** Rigid syntax → Syntax errors → Frustration

**Approachable-Workflows:** Gradual formalism
- Start informal: "Review the request"
- Add structure when needed: `Do: Review the request`
- Add verification when important: `Verify: Request is complete`
- Add failure handling when critical: `If Failed: Reject incomplete`

The language **assists** you in creating complete workflows without **demanding** rigid syntax.

---

## The Bottom Line

**Plain language is not a compromise — it's the optimal interface for human-AI workflow collaboration.**

- Human-readable = business analyst can own it
- Machine-executable = LLM can run it
- Version-controllable = team can collaborate on it
- Self-documenting = everyone understands it

**See also:**
- [Why It Works](why-it-works.md) — Evidence that graph engineering in LLMs is production-ready
- [The Activity Model](activity-model.md) — How activities compile to graph nodes
- [Comparison to Other Workflow Languages](../reference/comparisons.md) — Detailed feature comparison
