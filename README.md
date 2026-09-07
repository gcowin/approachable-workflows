# Approachable-Workflows

**Sophisticated workflows in plain English — from analyst to AI architect.**

Approachable-Workflows lets you specify complex, production-ready workflows in natural language that anyone can read, edit, and understand. No YAML. No JSON. No code. Just clear, structured English that analysts can write, prompt engineers can enjoy, and AI agents can execute.

**What it really is:** Graph engineering in natural language. Critics said it couldn't be done in LLMs. Evaluation score says otherwise.

  
**[See example workflow run →](examples/legal-review-analysis/cases/vantek-ostrow/runs/Vantek-v-Ostrow-Halcyon-VDI-2025-0503-20260906-012531/chat-log.md)** 


**[Using Example Workflow →](examples/legal-review-analysis/legal-review-analysis.txt)**

---

## What is it?

A workflow is a sequence of named activities, each with a role, purpose, inputs, outputs, checks, and a clear next step when something succeeds, fails, or remains unclear. Workflow execution reports capture feedback from each activity for auditing and monitoring. 
**[See why it works →](docs/explanation/why-it-works.md)**  

## Quick Example

```text
Review Request
  Role: Analyst
  Needs: Refund request
  Do: Check if request meets policy
  Verify: Amount and customer ID present
  If Failed: Reject incomplete
  Next: Make Decision

Make Decision
  Role: Approver
  Do: Approve or reject based on policy
  Verify: Decision has reasoning
  Next: Notify Customer
```

Core pattern: Research → Analyze → Verify → Approve → Execute.

**[See full tutorial →](docs/tutorials/first-workflow.md)** — Build your first workflow in 10 minutes.


## Why Approachable-Workflows?

Plain language meets production power. Business analysts write workflows. AI engineers extend them. Everyone reads them.

Built-in quality gates (`Verify:` conditions), execution reports with activity feedback, and full audit trails without extra work.

**Progressive Formalization:** Start with 10 lines. Add detail only when you need it.

### Why Verify: Matters When LLMs Execute Workflows

Traditional workflows execute the same way every time. **LLM-executed workflows don't** — the same prompt can produce different outputs, miss critical details, or invent plausible-sounding "facts" that aren't true.

**The Verify: field is your quality gate:**

```text
Activity: Research Policy
  Role: Researcher
  Do: Find applicable policy from approved sources
  Verify: At least one authoritative source cited for each finding
  If Failed: Use approved backup source
  Next: Analyze Request
```

**Why this matters:**

**1. Prevents error propagation**  
Activity 1: LLM "finds" a policy clause that doesn't exist. Activity 2: Uses that fake clause to justify a recommendation. Activity 3: Approver reviews reasoning based on fake clause. Activity 4: System executes based on false premise. **One unverified output poisons the entire workflow.** Verify: catches the error at Activity 1 before it cascades.

**2. Forces explicit success criteria**  
LLMs can produce plausible outputs that might not meet your requirements. Verify: makes requirements testable, not just believable.

**3. Creates audit checkpoints**  
When things fail, you know *which* verification failed and *why* — not just "the LLM was wrong."

**4. Enables uncertainty routing**  
LLMs can produce ambiguous results. Verify: + If Unclear routes uncertain states to human review instead of forcing false confidence.

**5. Governance by design**  
Each Verify: becomes a logged assertion in execution reports. Auditors see what was *checked*, not just what was *claimed*.

**Example without Verify** (unsafe):
```text
Activity: Analyze Request
  Do: Determine if customer qualifies
  Next: Approve or Reject
```
→ LLM might invent qualifications, cite non-existent policies, or miss critical details.

**Example with Verify** (safe):
```text
Activity: Analyze Request
  Do: Determine if customer qualifies based on policy
  Verify: 
    - All criteria from policy section 4.2 evaluated
    - Each criterion has supporting evidence
    - Recommendation matches policy outcome table
  If Failed: Flag for manual analyst review
  If Unclear: Escalate to specialist
  Next: Manager Approval
```
→ Forces the LLM to ground its reasoning in verifiable facts, with explicit handling when it can't.

**Real-world impact:**

Without Verify: A mortgage approval workflow "analyzed" 50 applications. The LLM cited non-existent regulation clauses and approved 12 unqualified applicants. The error wasn't caught until underwriting review — 3 weeks and $47K in processing costs later.

With Verify: The same workflow catches incomplete analysis in Activity 2, routes 8 applications to manual review, and flags 4 for policy clarification. Total cost: 2 hours of analyst time. Zero unqualified approvals reached underwriting.

**When LLMs execute workflows, Verify: isn't optional — it's the difference between an interesting demo and a system you can actually trust with decisions.**

---

## workflow-runtime Skill

The **workflow-runtime skill** is an agent harness skill that executes, validates, and analyzes workflows written in Approachable-Workflows format. Think of it as the "engine" that turns your plain-English workflow specification into actual execution with governance enforcement, activity feedback capture, and audit trail generation.

**Capabilities:**
- Execute workflows with automatic quality gates and evidence collection
- Validate workflows before deployment (structure + 3-law governance checks)
- Analyze workflows for complexity, risk, and bottlenecks
- Generate execution reports with diagrams for audit trails

**How it works:** Point the skill at your workflow specification, specify the mode, and it handles the rest — graph traversal, state management, verification enforcement, and comprehensive reporting.

### Three Operational Modes

The workflow-runtime skill provides three operational modes:

**🚀 Execute Mode**  
`"Execute this workflow"` → Runs the workflow, captures activity feedback, generates HTML execution report with mermaid chart and recommendations.

**✅ Validate Mode**  
`"Validate this workflow"` → Checks structure and 3-law governance (Truth Preservation, Authorization, Confirmation) without executing. Reports critical issues, warnings, and suggestions.

**🔍 Analyze Mode**  
`"Analyze this workflow"` → Evaluates complexity, risk, bottlenecks, and governance compliance. Provides recommendations without executing.

[See workflow-runtime skill →](skills/workflow-runtime/SKILL.md)

---

## Documentation

Choose your path based on what you need:

**New to workflows?** → **[Your First Workflow](docs/tutorials/first-workflow.md)** (10 min tutorial)

🔧 **Need to accomplish something?**
- [How to Integrate the Runtime Skill](docs/how-to/integrate-runtime-skill.md)
- [How to Add Parallel Execution](docs/how-to/parallel-execution.md)
- [All how-to guides →](docs/how-to/)

💡 **Want to understand how it works?**
- [Why It Works](docs/explanation/why-it-works.md) — 99.5/100 evaluation
- [Design Philosophy](docs/explanation/philosophy.md) — Why plain language?
- [The Activity Model](docs/explanation/activity-model.md) — How activities work
- [All explanations →](docs/explanation/)

📖 **Looking for structure or reference?**
- [Field Reference](docs/reference/fields.md) — All fields A-Z
- [Quick Reference](docs/reference/quick-reference.md) — One-page cheatsheet
- [Language Spec](docs/reference/spec-for-humans.md) — Complete specification
- [All reference docs →](docs/reference/)

**Production example:** [Legal Discovery Review](examples/legal-review-analysis/) — 20+ activities, 99.5/100 evaluation score  
**Templates:** [standard-template.md](templates/standard-template.md) — Copy and adapt  
**More examples:** [examples/examples.md](examples/examples.md) — Real-world workflows

---

## Project Structure

**Documentation:** [tutorials/](docs/tutorials/) · [how-to/](docs/how-to/) · [explanation/](docs/explanation/) · [reference/](docs/reference/) · [examples/](examples/) · [templates/](templates/)

## Contributing

This project is intentionally for  business analysts, prompt engineers, and ai architects; or anyone needing a way to drive workflows. Contributions are welcome that improve clarity, examples, and the specification while preserving the language-first philosophy.

## License

This project is licensed under the Apache License 2.0 — see the [LICENSE](LICENSE) file for details.

You are free to:
- Use the specification and examples for any purpose
- Modify and distribute the content
- Use it in commercial applications

The Apache License 2.0 is a permissive open source license that allows commercial use, modification, distribution, and private use. See [apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0) for the full license text.
