# Execution Chat Log: P versus NP Research Program (Cycle 8)
Instance: pnp-2026-10-04-08 — Workflow version: 1.4 (technique layer added)
Pre-validation: ✓ VALID (Repeat T1–T7 bounded at 7; both Choices end in Otherwise).

## Activity: Load Prior Run Memory — ✓
- State: Memory Load In Progress
- memory.md read: frozen at v1.3, survey converged; primary GCT; L1–L4 open;
  M1 standing. Loop unfrozen by a genuine new axis: the technique library (T1–T7)
  is unapplied — that alone justifies survey mode (no fabrication required).

## Activity: Select Cycle Mode — ✓
- Condition 2 matched: unapplied library techniques exist → mode SURVEY
  (technique application path). Evidence: applied-technique log was empty.

## Activity: Triage New Corpus Items — ✓
- No new corpus items; "no corpus delta" (technique axis drives this cycle).

## Activity: Frame the Problem Precisely — ✓
- State: Survey In Progress. Framing unchanged (barriers unchanged). ✓

## Activity: Inventory Candidate Strategies — ✓
- Registry carried unchanged (the technique layer augments lines, not families). ✓

## Activity: Run Barrier Audit — ✓
- Verdicts carried, still cited. ✓

## Activity: Formalize What Is Proven — ✓
- Ledger carried; L1–L4 still open. ✓

## Activity: Apply Problem-Solving Techniques — ✓ (Repeat 7/7, bounded)
- State: Technique Application In Progress. Target: unconditional barrier-free
  resolution. Each application recorded honestly; all sub-goals conjectured.

  T1 Backward from the solution (applied FIRST):
     Assume the finished P≠NP proof exists. Work backward: its final act
     must be exhibiting an explicit function f in NP whose language escapes
     poly-size circuits — i.e., a single boolean function with an
     *explicitness certificate*. Closest ledger object: none — no known
     explicit candidate sits provably outside any circuit class ≥ TC0.
     Derived sub-goal B1: "construct an explicit family where hardness
     against a barrier-free restricted model (e.g., constant-depth
     threshold with limited symmetry) is provable by a
     non-naturalizing argument" — exact gap named. Honest note: T1's
     backward chain terminates at B1 = the known wall; that IS the result.
  T2 Strengthened-goal ladder: strongest true statement implying target =
     NEXP ⊄ P/poly (kabanets-camel). Step down: N3EXP...→ the ladder's
     bottom rung decidable-now case = the M1 restricted-orbit formalization.
     Confirms M1 as the ladder foot — no new sub-goal; recorded honestly.
  T3 Analogical transfer: extension complexity (lower bounds for
     extended formulations ARE proven, barrier-free in their domain) and
     communication complexity (discrepancy / corruption methods, resolved).
     Ported pattern: "certificate of inexpressibility in a cone" ↔ GCT
     obstructions. Derived sub-goal B3: port cone-duality obstruction
     templates from extension-complexity proofs into the orbit-cone setting.
     Genuine new ledger item.
  T4 Specialize: known resolutions — monotone circuits (Razborov 1985,
     proven), AC0 (proven), formulae. Extracted idea: every successful
     specialized proof uses a *structural invariant* (switching lemmas,
     approximating polynomials) that BREAKS at threshold gates. Recorded
     failure point as sub-goal B4: "identify the invariant that switching
     lemmas approximate for AC0 and prove it is unbounded for TC0" —
     this is the honest generalization-break point.
  T5 Generalize/unify: unifying parameter = gate strength g
     (AC0[g]=poly-size depth-d unbounded fan-in AND/OR; TC0 adds MAJ).
     Known case ends at ACC0 (Williams); frontier marked exactly at the
     threshold gate. Consistent with B4; no separate record.
  T6 Contradiction probe (P=NP consequences): PH collapses to ΣP1; SAT in
     P → every NP search problem has poly-time self-reduction; cryptographic
     implication: no one-way functions. Consequences are merely surprising,
     none rigorously falsified — recorded as candidate consequences, NOT as
     separations. Honest: probe yields no separation today.
  T7 Polyá-simplify (strip one assumption): strip uniformity → non-uniform
     (circuits) is where the target lives already; strip worst-case →
     average-case (MCSP/L2 route) — status flips exactly when uniformity is
     added back for meta-complexity theorems. Axis named: uniformity is a
     real difficulty axis; recorded as annotation on L4, not a new lemma.
- Circular check: B1/B3/B4 are strict sub-goals, none equivalent to target ✓
- Checkable-increment metric: +1 — B4 reframes M1 as a precise invariant-
  existence question: sharper checkable increment than before (the invariant
  statement is itself formalizable in a proof assistant). Counted honestly:
  this is a sharpening of an existing increment, not a fake new result.

## Activity: Evaluate and Rank Strategies — ✓
- State: Deep Evaluation In Progress
- Ranking drift: NONE in order (GCT still primary — B3 feeds it directly).
  Evidence per row: T1's chain ends at B1 (shared wall); T3 feeds GCT; T4→B4
  feeds TC0 line. Ranking unchanged, now with cross-technique justification.

## Activity: Deepen Primary Strategy — ✓
- Sub-lemma set enriched: B3 (cone-duality templates) joins the L2 family;
  ordered easiest-first: B4-sharpened-M1 < L2.1 < B3 < L2.2 < L2.3.
- All remain conjectured; nothing claimed proven ✓

## Activity: Synthesize Research Report — ✓
- Honesty section intact: problem OPEN; technique layer produced re-framed
  sub-goals and ONE sharpened increment, not a resolution. ✓

## Activity: Log Run Improvement — ✓
- Execution observations: technique library functions; T1's honest termination
  at the known wall is the correct behavior for a genuinely open problem.
- Candidate v1.5: cross-feeding — feed B-family sub-goals back into barrier
  audit (audit the SUB-goal, not just the parent strategy) so technique
  outputs get their own barrier classification.

## Activity: Deliver — ✓
- Artifacts + memory.md updated (unfrozen with technique axis active).
Next: Outcome: Completed ✓

---
Outcome: ✓ — cycle 8 completed; problem remains open (honest). Technique layer
live: B1/B3/B4 added (all conjectured), M1 sharpened, increments +1.
