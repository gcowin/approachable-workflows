# Approachable-Workflows

**Sophisticated workflows in plain English — from analyst to AI architect.**

Approachable-Workflows lets you specify complex, production-ready workflows in natural language that anyone can read, edit, and understand. No YAML. No JSON. No code. Just clear, structured English that analysts can write, prompt engineers can enjoy, and AI agents can execute.

**What it really is:** Graph engineering in natural language. Critics said it couldn't be done in LLMs. Evaluation score says otherwise.  **[See why it works →](docs/explanation/why-it-works.md)**  

---

## What is it?

A workflow is a sequence of named activities, each with a role, purpose, inputs, outputs, checks, and a clear next step when something succeeds, fails, or remains unclear. Workflow execution reports capture feedback from each activity for auditing and monitoring.



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

## Why Approachable-Workflows?

Plain language meets production power. Business analysts write workflows. AI engineers extend them. Everyone reads them.

Built-in quality gates (`Verify:` conditions), execution reports with activity feedback, and full audit trails without extra work.

**Progressive Formalization:** Start with 10 lines. Add detail only when you need it.

---

## Workflow Runtime Skill Modes

The workflow-runtime skill provides three operational modes:

**🚀 Execute Mode**  
`"Execute this workflow"` → Runs the workflow, captures activity feedback, generates HTML execution report with mermaid chart and recommendations.

**✅ Validate Mode**  
`"Validate this workflow"` → Checks structure and 3-law governance (Truth Preservation, Authorization, Confirmation) without executing. Reports critical issues, warnings, and suggestions.

**🔍 Analyze Mode**  
`"Analyze this workflow"` → Evaluates complexity, risk, bottlenecks, and governance compliance. Provides recommendations without executing.

[See full workflow-runtime documentation →](skills/workflow-runtime/SKILL.md)

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
