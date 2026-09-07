# Approachable-Workflows Visual Patterns

**Mermaid diagrams showing common workflow patterns**

Use these visual patterns as templates for your own workflows.

## Dynamic Diagram Generation

**You don't have to draw these yourself!** Both integration modes can generate diagrams for you:

### During Workflow Design
Ask the agent to visualize your workflow:
```
"Generate a workflow diagram for this workflow"
"Show me a Mermaid chart of the flow"
"Create a visual representation of this workflow"
```

Works in both:
- **Runtime Skill mode**: `workflow-runtime` generates diagrams automatically
- **Knowledge Source mode**: Any agent with `spec-for-ai.md` can create diagrams

### During Workflow Execution
The runtime automatically generates an **execution diagram** showing:
- ✅ Activities that succeeded (green)
- ❌ Activities that failed (red)
- ⚠️ Activities that were unclear (yellow)
- 🔵 Final outcome
- Actual path taken through the workflow

**The execution diagram is saved as part of the audit trail** for governance and review.

### Example Request
```
"Run this workflow and show me the execution diagram"
"Execute the workflow and include a Mermaid chart in the report"
```

The patterns below serve as **templates and reference examples** — use them to understand common flows, then let the agent generate diagrams for your specific workflows.

---

## Pattern 1: Simple Linear Flow (Simple)

**Use for**: Straightforward processes with no branching

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','primaryBorderColor':'#1B5E20','lineColor':'#666','secondaryColor':'#1565C0','tertiaryColor':'#F57C00'}}}%%
graph TD
    Start([Start]) --> A[Receive Request<br/>Coordinator]
    A --> B[Review Request<br/>Analyst]
    B --> C[Process Request<br/>Executor]
    C --> D[Notify Customer<br/>Communicator]
    D --> End([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#2E7D32,stroke:#1B5E20,color:#fff
    style C fill:#2E7D32,stroke:#1B5E20,color:#fff
    style D fill:#2E7D32,stroke:#1B5E20,color:#fff
    style End fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Workflow: Simple Request Processing
Goal: Process customer requests

Receive Request → Review Request → Process Request → Notify Customer → Completed
```

---

## Pattern 2: Research → Analyze → Verify → Approve → Execute (Standard)

**Use for**: Decisions requiring evidence, analysis, and authorization

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','primaryBorderColor':'#1B5E20','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Research Policy<br/>Researcher]
    A --> B[Analyze Request<br/>Analyst]
    B --> C[Verify Recommendation<br/>Analyst]
    C --> D{High Risk?<br/>Choice}
    D -->|Yes| E[Manager Approval<br/>Approver]
    D -->|No| F[Execute Action<br/>Executor]
    E -->|Approved| F
    E -->|Rejected| End1([Rejected])
    F --> G[Confirm Result<br/>Observer]
    G --> End2([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#2E7D32,stroke:#1B5E20,color:#fff
    style C fill:#2E7D32,stroke:#1B5E20,color:#fff
    style D fill:#F57C00,stroke:#E65100,color:#fff
    style E fill:#7B1FA2,stroke:#4A148C,color:#fff
    style F fill:#2E7D32,stroke:#1B5E20,color:#fff
    style G fill:#2E7D32,stroke:#1B5E20,color:#fff
    style End1 fill:#C62828,stroke:#B71C1C,color:#fff
    style End2 fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Key Activities:**
- **Research** (Researcher): Gather evidence with sources
- **Analyze** (Analyst): Form recommendation
- **Verify** (Analyst): Check quality
- **Approve** (Approver): Authorize high-risk actions
- **Execute** (Executor): Perform action
- **Confirm** (Observer): Verify external result

---

## Pattern 3: Choice with Multiple Paths (Standard)

**Use for**: Routing based on conditions

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Check Request<br/>Analyst]
    A --> B{Route Decision<br/>Choice}
    B -->|Amount > $1000| C[Senior Approval<br/>Approver]
    B -->|Amount > $500| D[Manager Approval<br/>Approver]
    B -->|Otherwise| E[Auto-Approve<br/>Coordinator]
    C --> F[Execute<br/>Executor]
    D --> F
    E --> F
    F --> End([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#F57C00,stroke:#E65100,color:#fff
    style C fill:#7B1FA2,stroke:#4A148C,color:#fff
    style D fill:#7B1FA2,stroke:#4A148C,color:#fff
    style E fill:#2E7D32,stroke:#1B5E20,color:#fff
    style F fill:#2E7D32,stroke:#1B5E20,color:#fff
    style End fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Activity: Route Decision
  Kind: Choice
  Conditions:
    1. If amount > $1000 → Senior Approval
    2. If amount > $500 → Manager Approval
    3. Otherwise → Auto-Approve
```

---

## Pattern 4: Retry with Backoff (Standard)

**Use for**: External systems that may be temporarily unavailable

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#EF6C00','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Submit to API<br/>Executor<br/>Repeat]
    A -->|Attempt 1: 5s wait| B{Success?}
    A -->|Attempt 2: 15s wait| B
    A -->|Attempt 3: 45s wait| B
    B -->|Yes| C[Confirm Result<br/>Observer]
    B -->|All Failed| D([System Unavailable])
    C --> E([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#EF6C00,stroke:#E65100,color:#fff
    style B fill:#F57C00,stroke:#E65100,color:#fff
    style C fill:#2E7D32,stroke:#1B5E20,color:#fff
    style D fill:#C62828,stroke:#B71C1C,color:#fff
    style E fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Activity: Submit to API
  Kind: Repeat
  Role: Executor
  Repeat Until: System responds successfully
  Maximum Attempts: 3
  Wait Between Attempts: 5s, 15s, 45s
  
  If Successful: Confirm Result
  If All Attempts Fail: System Unavailable
```

---

## Pattern 5: Parallel Execution (Standard)

**Use for**: Independent tasks that can run concurrently

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#EF6C00','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Validate Request<br/>Do Together]
    A --> B[Check Customer<br/>Researcher]
    A --> C[Check Inventory<br/>Researcher]
    A --> D[Check Credit<br/>Analyst]
    B --> E{All Complete?}
    C --> E
    D --> E
    E -->|All Passed| F[Process Order<br/>Executor]
    E -->|Any Failed| G([Validation Failed])
    F --> H([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#EF6C00,stroke:#E65100,color:#fff
    style B fill:#2E7D32,stroke:#1B5E20,color:#fff
    style C fill:#2E7D32,stroke:#1B5E20,color:#fff
    style D fill:#2E7D32,stroke:#1B5E20,color:#fff
    style E fill:#F57C00,stroke:#E65100,color:#fff
    style F fill:#2E7D32,stroke:#1B5E20,color:#fff
    style G fill:#C62828,stroke:#B71C1C,color:#fff
    style H fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Activity: Validate Request
  Kind: Do Together
  Do These Activities Together:
    - Check Customer Identity
    - Check Inventory Availability
    - Check Credit Status
  
  Wait For: All
  Time Limit: 30 seconds
  
  When All Complete:
    - If all passed → Process Order
    - If any failed → Validation Failed
    - If timeout → Escalate
```

---

## Pattern 6: Wait for External Event (Standard)

**Use for**: Workflows that pause for human input or external triggers

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Request Documents<br/>Communicator]
    A --> B[Wait for Upload<br/>Coordinator<br/>Wait]
    B -->|Received| C[Validate Documents<br/>Analyst]
    B -->|Timeout 48h| D([Expired])
    C -->|Valid| E[Process Application<br/>Executor]
    C -->|Invalid| A
    E --> F([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#F9A825,stroke:#F57F17,color:#000
    style C fill:#2E7D32,stroke:#1B5E20,color:#fff
    style D fill:#C62828,stroke:#B71C1C,color:#fff
    style E fill:#2E7D32,stroke:#1B5E20,color:#fff
    style F fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Activity: Wait for Upload
  Kind: Wait
  Role: Coordinator
  Do: Wait for customer to upload documents
  Time Limit: 48 hours
  
  Next:
    - Documents received → Validate Documents
    - Timeout → Expired
```

---

## Pattern 7: With Failure Paths (Standard)

**Use for**: Production workflows needing robust error handling

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Process Payment<br/>Executor]
    A -->|✓ Success| B[Send Confirmation<br/>Communicator]
    A -->|✗ Failed| C[Log Error<br/>Coordinator]
    A -->|? Unclear| D[Manual Review<br/>Coordinator]
    B --> End1([Completed])
    C --> End2([Failed])
    D --> End3([Needs Review])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#2E7D32,stroke:#1B5E20,color:#fff
    style C fill:#C62828,stroke:#B71C1C,color:#fff
    style D fill:#F9A825,stroke:#F57F17,color:#000
    style End1 fill:#1565C0,stroke:#0D47A1,color:#fff
    style End2 fill:#C62828,stroke:#B71C1C,color:#fff
    style End3 fill:#F9A825,stroke:#F57F17,color:#000
```

**Workflow:**
```
Activity: Process Payment
  Role: Executor
  Do: Submit payment to external system
  Verify: System confirms transaction
  
  If Failed: Log Error → Failed
  If Unclear: Manual Review → Needs Review
  Next: Send Confirmation
```

---

## Pattern 8: Repeat Over Collection (Standard)

**Use for**: Processing multiple items (documents, requests, line items)

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#EF6C00','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Process Each Document<br/>Analyst<br/>Repeat]
    A --> B[Classify Document]
    B --> C{Valid?}
    C -->|Yes| D[Analyze Content]
    C -->|No| E[Flag for Review]
    D --> F{More Items?}
    E --> F
    F -->|Yes| B
    F -->|No| G[Summarize Results<br/>Analyst]
    G --> End([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#EF6C00,stroke:#E65100,color:#fff
    style B fill:#2E7D32,stroke:#1B5E20,color:#fff
    style C fill:#F57C00,stroke:#E65100,color:#fff
    style D fill:#2E7D32,stroke:#1B5E20,color:#fff
    style E fill:#F9A825,stroke:#F57F17,color:#000
    style F fill:#F57C00,stroke:#E65100,color:#fff
    style G fill:#2E7D32,stroke:#1B5E20,color:#fff
    style End fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Activity: Process Each Document
  Kind: Repeat
  Role: Analyst
  Repeat Over: Each document in the upload
  Maximum: 20 documents
  
  For Each Item:
    1. Classify document type
    2. If valid: Analyze content
    3. If invalid: Flag for manual review
  
  When Complete: Summarize Results
```

---

## Pattern 9: Sub-Workflow (Standard)

**Use for**: Reusable workflows called from other workflows

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Validate Customer<br/>Analyst]
    A --> B[Run Workflow:<br/>Credit Check]
    B --> C{Credit OK?}
    C -->|Approved| D[Process Order<br/>Executor]
    C -->|Declined| E([Declined])
    D --> F([Completed])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#7B1FA2,stroke:#4A148C,color:#fff
    style C fill:#F57C00,stroke:#E65100,color:#fff
    style D fill:#2E7D32,stroke:#1B5E20,color:#fff
    style E fill:#C62828,stroke:#B71C1C,color:#fff
    style F fill:#1565C0,stroke:#0D47A1,color:#fff
```

**Workflow:**
```
Activity: Run Credit Check
  Kind: Run Workflow
  Workflow: Standard Credit Check
  Provide:
    - Customer ID
    - Requested Amount
  Receive:
    - Credit Decision
    - Credit Score
  
  Next: Process Order
```

---

## Pattern 10: Full Extended with State & Events

**Use for**: Complex, mission-critical workflows with state tracking

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph TD
    Start([Start]) --> A[Submit Request<br/>Coordinator]
    A --> B[Research<br/>Researcher]
    B --> C[Analyze<br/>Analyst]
    C --> D{Risk Level?<br/>Choice}
    D -->|High| E[Senior Approval<br/>Approver]
    D -->|Medium| F[Manager Approval<br/>Approver]
    D -->|Low| G[Execute<br/>Executor]
    E --> G
    F --> G
    G -->|Success| H[Confirm<br/>Observer]
    G -->|Failed| I[OnFailure Event]
    H --> End1([Completed])
    I --> End2([Failed])
    
    B -.->|Timeout Event| J[Escalate]
    C -.->|Unclear| J
    J --> End3([Needs Review])
    
    style Start fill:#1565C0,stroke:#0D47A1,color:#fff
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#2E7D32,stroke:#1B5E20,color:#fff
    style C fill:#2E7D32,stroke:#1B5E20,color:#fff
    style D fill:#F57C00,stroke:#E65100,color:#fff
    style E fill:#7B1FA2,stroke:#4A148C,color:#fff
    style F fill:#7B1FA2,stroke:#4A148C,color:#fff
    style G fill:#2E7D32,stroke:#1B5E20,color:#fff
    style H fill:#2E7D32,stroke:#1B5E20,color:#fff
    style I fill:#D32F2F,stroke:#B71C1C,stroke-width:3px,color:#fff
    style J fill:#EF6C00,stroke:#E65100,stroke-width:3px,color:#fff
    style End1 fill:#1565C0,stroke:#0D47A1,color:#fff
    style End2 fill:#C62828,stroke:#B71C1C,color:#fff
    style End3 fill:#F9A825,stroke:#F57F17,color:#000
```

**Workflow with State & Events:**
```
Workflow: Complex Request Processing
Version: 2.0

Business State:
  - Submitted
  - Under Review
  - Awaiting Approval
  - Approved
  - Executing
  - Completed
  - Failed
  - Escalated

Events:
  On Failure:
    - Log to monitoring system
    - Notify support team
    - Set Business State to Failed
    - Continue to Failed outcome
  
  On Timeout:
    - Capture partial results
    - Set Business State to Escalated
    - Continue to Escalation

Activities:
  [Activities with State Changes...]
  
  State Changes:
    - Submit Request → Set Business State to Submitted
    - Research → Set Business State to Under Review
    - Approval → Set Business State to Awaiting Approval
    - Execute → Set Business State to Executing
```

---

## Legend

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#2E7D32','primaryTextColor':'#fff','lineColor':'#666'}}}%%
graph LR
    A[Work Activity<br/>Role] 
    B{Choice<br/>Decision}
    C[Approval Activity<br/>Approver]
    D[Wait Activity<br/>Wait]
    E[Repeat Activity<br/>Repeat]
    F[Do Together<br/>Parallel]
    G[Run Workflow<br/>Subworkflow]
    H([Outcome])
    I[Failed Activity]
    J[Unclear Activity]
    
    style A fill:#2E7D32,stroke:#1B5E20,color:#fff
    style B fill:#F57C00,stroke:#E65100,color:#fff
    style C fill:#7B1FA2,stroke:#4A148C,color:#fff
    style D fill:#F9A825,stroke:#F57F17,color:#000
    style E fill:#EF6C00,stroke:#E65100,color:#fff
    style F fill:#EF6C00,stroke:#E65100,color:#fff
    style G fill:#7B1FA2,stroke:#4A148C,color:#fff
    style H fill:#1565C0,stroke:#0D47A1,color:#fff
    style I fill:#C62828,stroke:#B71C1C,color:#fff
    style J fill:#F9A825,stroke:#F57F17,color:#000
```

**Colors (Optimized for Light & Dark Mode):**
- 🟢 **Dark Green** (#2E7D32): Successful Work activities
- 🟠 **Dark Orange** (#F57C00): Choice/Decision points
- 🟣 **Purple** (#7B1FA2): Approval activities & Run Workflow
- 🟡 **Dark Yellow** (#F9A825): Wait activities or Unclear states
- 🟠 **Darker Orange** (#EF6C00): Repeat or Do Together activities
- 🔵 **Dark Blue** (#1565C0): Outcomes (start/end)
- 🔴 **Dark Red** (#C62828): Failed states

**Theme:** All diagrams use the base theme with dark mode compatible colors and high contrast borders

---

## How to Use These Patterns

### Option 1: Manual Design
1. **Start with the pattern** that matches your workflow type
2. **Copy the Mermaid diagram** to visualize your flow
3. **Adapt the activities** to your specific needs
4. **Add Verify conditions** where quality matters
5. **Define If Failed paths** for robust error handling
6. **Add State tracking** (Extended) if your workflow is long-running

### Option 2: Agent-Generated (Recommended)
1. **Write your workflow** in plain English
2. **Ask the agent** to generate a diagram:
   - "Show me a workflow diagram"
   - "Generate a Mermaid chart for this workflow"
3. **Review and iterate** on the visualization
4. **Execute** and get an audit-ready execution diagram automatically

## Execution Diagrams in Audit Reports

When you execute a workflow, the runtime generates a **color-coded execution diagram** showing:

- **Actual path taken** through your workflow
- **Success/failure status** of each activity
- **Duration** and timestamps
- **Decision points** and which conditions matched
- **Final outcome** reached

**This diagram is automatically included in:**
- HTML execution reports
- Evidence packages
- Audit trails
- Workflow recommendations

**Example execution output:**
```markdown
# Workflow Execution: Customer Refund Review

## Mermaid Chart
[Color-coded diagram showing green successes, red failures, actual path]

## Evidence Package
[All captured evidence by activity and role]

## Recommendations
[Suggestions for workflow improvement]
```

The execution diagram becomes a permanent audit record, making it easy to:
- Review what actually happened
- Identify bottlenecks
- Debug failures
- Demonstrate compliance
- Train new team members

---

## Need More Examples?

- **Real workflows**: [examples.md](../../examples/examples.md)
- **Pattern library**: [pattern-examples.md](../../examples/pattern-examples.md)
- **Production example**: [Legal Discovery Review](../../examples/legal-review-analysis/)
- **Step-by-Step Guide**: [step-by-step.md](../tutorials/step-by-step.md)
