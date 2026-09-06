# Approachable-Workflows Tutorial: From Business Goal to Conformant Workflow

This tutorial teaches business architects, process owners, prompt engineers, and AI engineers how to describe accountable work using the Approachable-Workflows Core Activity Model.

It is a companion to [spec-for-humans.md](spec-for-humans.md), which is the canonical specification for the language. Use the specification as the source of truth; this tutorial explains how to apply it in practice.

## Quick Start: Create a Simple Workflow in 5 Minutes

For simple workflows, start with the essential elements:

```text
Workflow: Expense Approval

Goal: Approve or reject an expense request

Handles: Each employee expense request

Activities:
  1. Receive Request
    - Employee submits expense with amount and reason

  2. Manager Reviews
    - If amount under $500: Approve
    - If amount over $500: Send to Director
    - If looks suspicious: Reject

  3. Approved or Rejected
    - Notify employee
    - Update accounting system
```

**That's it!** You can add more detail later:
- Checks: What must be true before proceeding
- Time limits: How long to wait
- Failure paths: What to do when things go wrong

Note: Execution reports capture activity feedback (like timestamps, transaction IDs, approvals) automatically based on who does the work and what kind of activity it is.

The rest of this tutorial shows how to add these details for production-ready workflows.

---

## 1. Start with the business result

Write a short Goal that describes the outcome, not the technology.

**Example Goal**

Review a refund request and reach a supported, authorized decision.

Avoid implementation language such as model names, products, APIs, or orchestration frameworks in the Goal.

## 2. Define what the workflow handles

Specify what this workflow processes - the business subject handled by each execution.

**Example**

Handles: Each customer refund request

**Distinguish three concepts**:

- Workflow definition: The reusable Refund Review design
- Subject: Refund Request 100245 (a specific instance)
- Workflow instance: One execution of Refund Review handling Refund Request 100245

## 3. Identify the information

Separate information into three groups.

**Provided information**

Known when the workflow begins and unchanged during the instance:

- Request number
- Customer number
- Amount
- Reason

**Working information**

Created or updated as Activities complete:

- Request summary
- Missing-information list
- Policy findings
- Recommendation
- Verification result
- Approval decision

**Final result**

Returned when the workflow reaches an Outcome:

- Decision
- Explanation
- Evidence package

Add simple business rules where useful, such as “Amount must be zero or greater” and “Request number is required.”

### 3A. Define state

Approachable-Workflows distinguishes two kinds of state.

**Workflow State**

Workflow State describes where execution is.

**Example states**:

- Not Started
- Ready
- In Progress
- Waiting
- Checking
- Completed
- Failed
- Cancelled

**Business State**

Business State describes the condition of the subject being handled.

**For Refund Review**:

- Submitted
- Under Review
- Pending Approval
- Approved
- Rejected
- Refunded
- Needs Review

The two state types are independent.

**Example**:

- Workflow State: Waiting
- Business State: Under Review

while the workflow is waiting for customer documents.

**State changes**

Activities may change state.

**Examples**:

- Receive Refund Request → Submitted
- Research Applicable Policy → Under Review
- Manager Approval → Approved or Rejected
- Wait for Missing Information → Waiting
- Execute Authorized Decision → Refunded

State changes should be visible so operators, auditors, and runtime tools can understand the current condition of the workflow and the subject being handled.

## 4. Select only the roles you need

A Role describes responsibility, not the implementation. A person, agent, team, or service may fulfill it when deployed.

**For Refund Review, use**:

- Coordinator: Routes work and manages handoffs
- Researcher: Finds the applicable policy and evidence
- Analyst: Produces the recommendation
- Analyst: Independently checks the recommendation
- Approver: Authorizes high-value or high-risk decisions
- Executor: Performs the authorized external action

Do not add Roles merely to make the workflow appear more sophisticated.

## 5. Design the Activity flow

Use the smallest clear set of Activities. Name each Activity with a verb and object.

**For Refund Review, the flow is**:

1. Receive Refund Request
2. Check Required Information
3. Choose Information Path
4. Wait for Missing Information, when needed
5. Research Applicable Policy
6. Analyze Refund Request
7. Verify Recommendation
8. Choose Approval Path
9. Manager Approval, when required
10. Execute Authorized Decision
11. Notify Customer
12. Completed, Rejected, Needs Review, or Failed

Every non-outcome Activity must name its Next Activity or Outcome. Every repeating path must be bounded.

## 7. Write each Activity

### Activity: Research Applicable Policy

**Kind**

Work

**Role**

Researcher

**Needs**

- Request summary
- Approved policy library

**Do**

Find the policies that apply to the request.

**Creates**

- Policy findings
- Source references

**Verify**

- At least one current authoritative source supports each material finding.
- Every source can be opened by an authorized reviewer.

**If failed**

Use the approved alternate policy source. If that also fails, continue to Needs Review.

**If unclear**

Continue to Needs Review.

**Next**

Analyze Refund Request.

### 7A. Add State Changes (Optional)

Activities can declare when they change Business State or Workflow State:

```markdown
Activity: Receive Refund Request
  Kind: Work
  Role: Coordinator
  
  Do: Create the work record and classify the request
  
  State Changes:
    - Set Business State to Submitted
    - Set Workflow State to In Progress
  
  Next: Check Required Information
```

### 7B. Add Event Handlers (Optional)

Activities can specify what happens for exceptional conditions:

```markdown
Activity: Research Applicable Policy
  Kind: Work
  Role: Researcher
  
  Do: Find the policies that apply to the request
  
  Events:
    On Failure:
      - Log the research failure
      - Notify the Policy team
      - Continue to Needs Review
    
    On Timeout:
      - Continue to Needs Review
  
  Next: Analyze Refund Request
```

## 8. Add a Choice Activity

Choice conditions are evaluated from top to bottom. End with Otherwise unless no match is intentionally a failure.

### Activity: Choose Approval Path

**Kind**

Choice

**Needs**

- Recommendation
- Amount
- Risk level
- Verification result

**Do**

Choose the next path:

1. If verification is Unclear, continue to Needs Review.
2. If verification Failed, continue to Needs Review.
3. If the request requires authorization, continue to Manager Approval.
4. Otherwise, continue to Execute Authorized Decision.

**Evidence**

- Selected condition
- Selected next path

**Next**

The Activity selected by the first matching condition.

### 8A. Use Logical Operators in Choices (Optional)

For complex decisions, use AND, OR, and NOT:

```markdown
Activity: Choose Approval Path
  Kind: Choice
  
  Do: Choose the next path
  
  Conditions:
    1. If verification is Unclear OR verification is Failed
       → Continue to Needs Review
    
    2. If amount is greater than 1000 AND risk level is High
       → Continue to Senior Manager Approval
    
    3. If amount is greater than 1000 OR requires authorization is Yes
       → Continue to Manager Approval
    
    4. Otherwise
       → Continue to Execute Authorized Decision

Note: Activity feedback (like condition matched and values used) is captured in execution reports automatically.
```

## 9. Add a Wait Activity

A Wait Activity must define what ends the wait and what happens when time expires.

### Activity: Wait for Missing Information

**Kind**

Wait

**Role**

Coordinator

**Needs**

- Missing-information list
- Contact details

**Do**

Wait for the requested information to be received.

**Time limit**

The business deadline defined by the applicable profile or deployment policy.

**If failed**

Continue to Failed if the wait mechanism cannot be maintained safely.

**If unclear**

Continue to Needs Review if received information cannot be matched to the request.

**Next**

- Information received: Check Required Information
- Time expired: Rejected or another business outcome defined by the Profile

## 10. Add an Approval Activity

Approval grants authorization. It does not replace verification.

### Activity: Manager Approval

**Kind**

Approval

**Role**

Approver


- Recommendation
- Policy findings
- Verification result
- Evidence package

**Do**

Choose Approve, Reject, or Request Changes.

**If failed**

Continue to Needs Review if authorization cannot be obtained.

**If unclear**

Continue to Needs Review if the decision is incomplete or unauthorized.

**Next**

- Approve: Execute Authorized Decision
- Reject: Rejected
- Request Changes: Analyze Refund Request, subject to a defined repetition limit

## 11. Add the external action

External changes need clear authorization, evidence, and protection against duplicate execution.

### Activity: Execute Authorized Decision

**Kind**

Work

**Role**

Executor


**Needs**
- Amount

**Do**

Perform the authorized refund or close the request as rejected.

**Creates**

- System result
- Transaction or closure reference

**Verify**

- The executed action matches the authorized decision.
- The external system confirms the result.

**If failed**

Do not record completion. Continue to Needs Review with the error and action evidence.

**If unclear**

Do not repeat the external change until its status is reconciled. Continue to Needs Review.

**Next**

Notify Customer.

### 11A. Add Retry Logic (Optional)

For external systems that may be temporarily unavailable:

```markdown
Activity: Submit to External Refund System
  Kind: Repeat
  Role: Executor
  
  Repeat Until: External system responds successfully
  Maximum Attempts: 3
  Wait Between Attempts: 5 seconds, then 10 seconds, then 30 seconds
  
  Do: Submit the refund transaction
  
  If Successful:
    - Continue to Confirm External Result
  
  If All Attempts Fail:
    - Continue to External System Unavailable
```

### 11B. Add Do Together (Optional)

For activities that can run concurrently:

```markdown
Activity: Validate Request Completeness
  Kind: Do Together
  Role: Coordinator
  
  Do These Activities Together:
    - Validate Customer Identity
    - Validate Invoice Number
    - Check Account Status
  
  Wait For: All activities to complete
  Time Limit: 15 seconds
  
  When All Complete:
    - If all passed: Continue to Research Policy
    - If any failed: Continue to Request Missing Information
```

## 12. Define Outcomes

**Outcome declarations are optional.** Just reference the outcome name in `Next:` fields.

**Simple outcomes** (no declaration needed):
```
Activity: Notify Customer
  Role: Communicator
  Do: Send notification
  Next: Completed
```

The workflow ends at "Completed" - no separate declaration required.

**Detailed outcomes** (declare when specifying return values):
```
Outcome: Completed
  Return:
    - Decision
    - Explanation
    - Evidence package
    - External action confirmation
```

**Common outcome names**: Completed, Rejected, Needs Review, Failed, Cancelled

Only declare outcomes explicitly if you need to document what they return.

## 13. State the governance

For Refund Review, the Governance is:

- Current authoritative policy sources
- Retained source passages and policy versions
- Independent verification of the recommendation
- Human approval when required
- Recorded external-system confirmation
- Preserved failed and unclear check results

The Governance should explain how the workflow ensures dependable outcomes.

## 14. Validate the workflow

Before calling the workflow Core-conforming, verify:

1. Name, Goal, and Handles are present.
2. Provided information and final result are defined.
3. A starting Activity is identified.
4. Every Activity has a unique name and stable identity.
5. Every Activity has a Core kind.
6. Every non-outcome Activity has a valid next path.
7. At least one Outcome exists.
8. Material decisions and external actions retain evidence and have checks.
9. Failed and Unclear behavior is defined where applicable.
10. Every repeating path is bounded.
11. Human decisions and external actions are preserved.
12. Each material outcome has Governance defined.

You can also chat with it for it to make recommendations. It, also, can make recommendations as a part of the workflow artifacts and evidence.

## 15. Use the compact view for review

After the complete workflow is valid, a tool may show a compact view:

```
Research Applicable Policy
Work | Researcher | Research
Needs: Request summary and approved policy library
Creates: Policy findings and source references
Verify: Every material finding has a current authoritative source
Failed or unclear: Needs Review
Next: Analyze Refund Request
```

The compact view is a presentation of the same Activity, not a different language.

## 16. Common mistakes

- Using Step or Node instead of Activity in normative Approachable-Workflows authoring
- Omitting Failed or Unclear paths
- Using approval as if it were verification
- Allowing a Choice without a complete final condition
- Allowing a Wait without expiry behavior
- Performing an external action without retained authorization and action evidence
- Adding Roles that do not improve accountability or clarity

## 17. Advanced features summary

Approachable-Workflows includes optional advanced features:

**Repeat**: Process collections or retry failed operations
```
Activity: Process Each Line Item
  Kind: Repeat
  Repeat Over: Each item in the list
```

**Do Together**: Execute multiple activities concurrently
```
Activity: Validate All Requirements
  Kind: Do Together
  Do These Activities Together:
    - Check A
    - Check B
    - Check C
```

**Run Workflow**: Call reusable workflows
```
Activity: Run Standard Credit Check
  Kind: Run Workflow
  Workflow: Standard Credit Check
```

**Events**: Handle exceptional conditions
```
Events:
  On Failure:
    - Log error
    - Notify team
    - Continue to Escalation
```

**State Changes**: Track workflow and business state
```
State Changes:
  - Set Business State to Approved
```

## 18. Next practice exercises

1. Convert Customer Support Resolution into complete Activities.
2. Add a Wait Activity to Insurance Claim Review for missing documents.
3. Add a Choice Activity to Procurement Approval.
4. Add Do Together to Product Launch Readiness to check multiple requirements concurrently.
5. Add a Repeat Activity to process multiple approval requests.
6. Add Event handlers to handle timeout conditions.

## Tutorial completion checklist

You have completed the tutorial when you can:

- Explain Goal, Handles, Information, Role, Activity, Verify, Approval, Governance, and Outcome
- Understand that activity feedback is captured in execution reports automatically based on Role and Kind
- Select an Activity kind for each unit of behavior
- Define success, Failed, and Unclear behavior
- Connect every Activity to a valid next Activity or Outcome
- Explain how the workflow ensures dependable outcomes
- Use advanced features (Repeat, Do Together, Events, State) when needed

**See also**: Pattern Examples.md for common workflow patterns as learning aids

**Source basis**: Approachable-Workflows Core Specification, Approachable-Workflows Real-World Workflow Examples.
