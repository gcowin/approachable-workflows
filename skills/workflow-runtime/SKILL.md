---
name: workflow-runtime
version: 2.2.0
description: Create, execute, validate, and govern Approachable-Workflows with automatic execution reporting and 3-law compliance
---

# Workflow Runtime

Create, execute, validate, and analyze workflows per Approachable-Workflows spec.
Execution reports are always produced as HTML (see `reference/report-template.html`).
At each activity transition, announce: activity name + Do + Verify before proceeding.

## Core Model

```
Activity = Role (who) + Do (what) + Verify (gate) + Next (flow)
```

Activity feedback is captured automatically from Role (no field needed).

## Fields (canonical reference)

| Field | Meaning | Required | Default / notes |
|---|---|---|---|
| Workflow / Version / Goal / Handles / Provided / Working / Returns / Activities / Governance / Configuration | workflow-level sections | Goal, Activities always; rest optional | Handles recommended; Governance recommended for production |
| Activity | one unit of work, unique name | Always | — |
| Do | what happens | Always | — |
| Next | success path | Yes unless Outcome | May be implicit |
| Kind | activity type | Only if not Work | Work (default), Choice, Approval, Wait, Repeat, Do Together, Run Workflow, Outcome |
| Role | who is accountable | Only when it changes behavior | Approver (approval), Observer (confirmation); default Analyst |
| Needs / Creates | inputs / outputs | When they exist | — |
| Verify | quality gate | Recommended | Gate on the activity |
| If Failed | failure path | When Verify exists | No target → block and report; never fabricate a pass |
| If Unclear | ambiguity path | When uncertainty possible | Missing → outcome stays `?` and blocks (Law 1) |

Kind constraints: Choice must end with Otherwise and is evaluated top-to-bottom; Repeat must be bounded (Maximum/Maximum Attempts); Wait must define its timeout behavior; Do Together defines When All Complete; Approval offers Approve/Reject/Request Changes.

Roles and their auto-captured feedback (default Analyst — name a Role only when it changes behavior):

| Role | Responsibility | Feedback captured |
|---|---|---|
| Analyst (default) | interprets, recommends, verifies; also researches, executes, delivers as the activity name states | analysis, recommendations, verification results |
| Approver | authorizes decisions | decision, identity, timestamp, comments |
| Observer | confirms external results | observed state, confirmation results |

## Canonical Rules (single source of truth — checked in Validate, enforced in Execute)

1. Workflow has Goal + Handles; every activity has a unique name and a Do.
2. Every non-Outcome activity has a Next (explicit or implicit).
3. Every Repeat loop is bounded; every Choice ends with Otherwise; every Wait defines timeout behavior.
4. Unclear or missing failure targets never resolve silently: no If Failed → block and report; no If Unclear → stay `?` and block.
5. **Sensitive-value rule:** artifacts (logs, reports, redaction maps, approval records) reference redactions by location ("E018 SSN field — REDACTED"), never echoing the masked value in any deliverable, including summary/audit tables and chat-visible output.

## Governance Laws 

1. **Truth Preservation:** Verify that cannot determine true/false yields `?`, never a forced ✓/✗. Without If Unclear, the workflow blocks and reports; never fabricate.
2. **Authorization:** high-risk actions (financial, legal, irreversible, external-org communication) are preceded by an Approver in the prior 1–2 activities; the Approver receives context (evidence, amount, reasoning).
3. **Confirmation:** actions performing external changes (DB writes, API calls, emails, transactions, file changes) are followed by an Observer in the next 1–2 activities; the Observer checks actual state, not just the API response.

## Mode: Create

1. Clarify requirements: business process, roles, decision points, external systems, success criteria, error conditions.
2. Build with progressive formalization: minimal first (names, Do, Next), then governance (Role, Verify, If Failed/If Unclear), then detail (Needs/Creates, Configuration) as needed.
3. Validate against canonical rules 1–5 and Governance Laws 1–3 before output.
4. Output plain-text spec; suggest validate or execute as next step.

## Mode: Execute

1. Pre-validate against canonical rules; critical violations block, warnings flag. Output validation status.
2. Execute: announce each activity (name + Do + Verify), record ✓/✗/?, follow Next/If Failed/If Unclear, capture Role feedback.
3. Generate the HTML report per `reference/report-template.html` (summary, colored mermaid path, activity log, recommendations). Color semantics are fixed in the template.

## Mode: Validate | Analyze (read-only)

```markdown
# Validation Report: [Name]
**Structure**: Goal | Handles | Unique names | Next | Loops bounded — ✓/✗ each
**Governance**: Truth Preservation | Authorization | Confirmation — ✓/⚠/✗ each
**Complexity** (Analyze only): X activities, Y decisions, Z paths, depth N
**Issues**: 🔴 Critical (blocks) | ⚠️ Warning | 💡 Suggestion
**Bottlenecks** (Analyze only): [Activity]: [reason]
**Top 3 Recommendations**: 1..3: [Priority] [Issue]: [Fix]
**Status**: ✓ VALID | ⚠ VALID WITH WARNINGS | ✗ INVALID — Top Fix: [most critical improvement]
```

## Engine Rules

1. Validate first (canonical rules), then execute.
2. Announce transitions before executing; capture Role feedback automatically.
3. `?` stays `?` — never forced to ✓/✗ (Law 1).
4. Always produce the HTML report; apply the Sensitive-value rule (canonical rule 5) to every artifact you write.
