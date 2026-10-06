# Payer Policy Change Impact Analysis — Example

Second production-style domain example (healthcare revenue cycle), proving the
same language and skill handle a different domain than legal discovery with no
spec changes — breadth as proof.

**What it demonstrates:**
- A completely different domain (payer policy → revenue-cycle action plan)
  with the same ~10 fields, unchanged
- REMOVED and REPLACED changes treated as first-class (not just "new stuff")
- Per-population routing (Carelon vs. EviCore) as state propagation
- Truth Preservation under missing data: the bulletin lists no specific
  CPT/HCPCS codes — a correct run flags "pull from code list" instead of
  inventing codes
- Approval-gated delivery with a feedback loop (Approval → Revise → Approval)

**Structure (mirrors legal-review-analysis):**
- `policy-change-impact-workflow.txt` (here) — the workflow spec
- `cases/bcbsil-pa-2026/corpus/` — the input bulletin (test corpus)
- `cases/bcbsil-pa-2026/answer-key/ANSWER_KEY.md` — ground truth for scoring
- `cases/bcbsil-pa-2026/evals/eval-run-against-answer-key.md` — eval directive
- `cases/bcbsil-pa-2026/runs/` — execution runs land here when executed

**To run it:** load the workflow-runtime skill, execute
`policy-change-impact-workflow.txt` against the corpus bulletin with a mock
service catalog, then score the run against the answer key.
