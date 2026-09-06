# How to Integrate the Runtime Skill

**Goal:** Set up and use the workflow-runtime skill in your agent harness.

**Time:** 5-10 minutes

---

## What You'll Get

The runtime skill provides:
- ✅ Automatic execution reporting with activity feedback
- ✅ HTML execution reports
- ✅ 3-law governance enforcement (Truth, Authorization, Confirmation)
- ✅ Mermaid flow charts
- ✅ Improvement recommendations

---

## Prerequisites

- Agent harness that supports skills (Claude Code, Copilot Studio, custom frameworks)
- Workflow written in Approachable-Workflows format

---

## Step 1: Enable the Skill

### For Claude Code
The workflow-runtime skill is built-in. No installation needed.

### For Copilot Studio
1. Navigate to **Skills** in your workspace
2. Click **Add Skill**
3. Select **workflow-runtime** from the gallery
4. Click **Enable**

### For Custom Harnesses
Copy `skills/workflow-runtime/SKILL.md` to your harness's skills directory.

---

## Step 2: Write Your Workflow

Create a workflow file (e.g., `my-workflow.txt`):

```text
Workflow: Customer Refund Review
Version: 1.0

Goal: Approve or reject refund requests

Review Request
  Role: Analyst
  Needs: Refund request
  Do: Check if request meets policy
  Verify: Amount and customer ID present
  Next: Make Decision

Make Decision
  Role: Approver
  Do: Approve or reject based on policy
  Verify: Decision has reasoning
  Next: Notify Customer

Notify Customer
  Role: Communicator
  Do: Send approval or rejection email
  Verify: Email sent successfully
  Next: Completed
```

---

## Step 3: Run the Workflow

### In Claude Code
```
Run the workflow in my-workflow.txt using the workflow-runtime skill.
```

### In Copilot Studio
```
Execute workflow: my-workflow.txt
Use skill: workflow-runtime
```

### Via API
```python
from anthropic import Anthropic

client = Anthropic(api_key="your-key")

response = client.messages.create(
    model="claude-sonnet-4",
    max_tokens=4096,
    messages=[{
        "role": "user",
        "content": f"Run the workflow using workflow-runtime skill:\n\n{workflow_text}"
    }]
)
```

---

## Step 4: Review the Output

The runtime skill generates:

### Console Output
```
🔄 Starting workflow: Customer Refund Review
✅ Review Request (Analyst) — PASSED verification
✅ Make Decision (Approver) — PASSED verification
✅ Notify Customer (Communicator) — PASSED verification
✅ Workflow completed successfully

📊 Execution report: 3 activities, 3 verifications
📈 Recommendation: Consider adding failure path for notification errors
```

### HTML Report
Saved to `workflow-execution-report.html`:
- Executive summary
- Activity-by-activity breakdown
- Verification results
- Evidence package
- Mermaid flow chart
- Improvement recommendations

### Evidence Package
Saved to `evidence/`:
```
evidence/
├── activity-review-request.md
├── activity-make-decision.md
├── activity-notify-customer.md
└── verification-log.md
```

---

## Step 5: Configure (Optional)

### Workflow-Level Configuration

Add to your workflow file:

```text
Configuration:
  Tools:
    - Salesforce CRM (read customer records)
    - SendGrid (send emails)
  Settings:
    - Timeout: 30 minutes
    - Evidence storage: OneDrive /Workflow-Evidence/
    - Notification email: team@example.com
```

### Harness-Level Configuration

Create `.claude/workflow-settings.json`:

```json
{
  "workflow_runtime": {
    "evidence_storage": "/path/to/evidence",
    "report_format": "html",
    "enable_recommendations": true,
    "governance_mode": "strict"
  }
}
```

---

## Troubleshooting

### Issue: "workflow-runtime skill not found"
**Solution:** Ensure skill is enabled in your harness. Check `skills/` directory.

### Issue: "Verification failed: Amount not present"
**Solution:** This is expected! The verification gate caught incomplete data. Fix the input and re-run.

### Issue: "HTML report not generated"
**Solution:** Check write permissions on output directory. Set `report_format: "markdown"` as fallback.

### Issue: "Tool not found: Salesforce CRM"
**Solution:** Ensure tool is available to your harness. Add tool descriptions to Configuration.

---

## Next Steps

**Learn more workflow features:**
- [How to Add Parallel Execution](parallel-execution.md)
- [Activity Model](../explanation/activity-model.md) — Understanding roles and activity kinds
- [Overview](../explanation/overview.md) — Complete workflow concepts

**Understand the specification:**
- [Spec for Humans](../reference/spec-for-humans.md) — Complete language specification
- [Fields Reference](../reference/fields.md) — A-Z field reference
- [Quick Reference](../reference/quick-reference.md) — One-page cheatsheet
