# Improvement Log: P versus NP Research Program

## v1.0 → v1.1 (applied before cycle 2)
- Added Load Prior Run Memory — cross-run memory is now explicit.
- Added drift report to ranking step — stability vs change is surfaced, not silent.
- Added Deepen Primary Strategy — ranking alone was shallow; lemma decomposition with easiest-first sub-lemmas now produces an actionable milestone (M1 for cycle 2).
- Added Log Run Improvement — workflow self-improvement is now a first-class activity.
- Fixed cycle-1 defects: malformed bullet nesting, unbounded Repeat (added Maximum: 12), missing If Unclear path.

## v1.1 → v1.2 candidates (from cycle-2 execution)
1. Corpus triage gate: new papers should enter via a Choice activity (relevant / barrier-relevant / noise) instead of silently landing in the registry.
2. Event handling: add On New Corpus Item so runs can be incremental rather than full re-surveys.
3. Ledger schema: give each open lemma an ID, owner-capability tag, and linked strategy so drift checks are mechanical.
4. Metric: add "checkable increment shipped per cycle" as the program's only progress measure — keeps honesty (increment ≠ resolution).
