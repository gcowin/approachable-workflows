# Cumulative Memory: P versus NP Research Program

Persistent cross-run memory. Every cycle reads this first (Load Prior Run
Memory) and updates it last (Deliver).

## Workflow version
- Current: v1.4 (survey + technique-driven layer)
- History: v1.1 → v1.2 (triage Choice, structured ledger, increment metric,
  convergence rule) → v1.3 (steady/survey mode Choice; survey no-ops) →
  FROZEN at v1.3 at survey fixed point (cycles 3–7) → UNFROZEN at v1.4:
  genuine new axis — problem-solving technique library T1–T7 — applied to
  the primary line (cycle 8).

## Strategy registry (steady state since cycle 1)
1. GCT (algebraic complexity) — PRIMARY — evades natural proofs by design
2. Meta-complexity — backup — natural-proof immune, relativization risk
3. Circuit lower bounds (TC0) — backup — ACC0 exceeded (Williams, proven)
4. Proof complexity — bounded-depth Frege results; relativization pressure
5. Derandomization↔hardness — IW relativizes; rich conditional web
6. Descriptive complexity — least leverage, mild barrier pressure

## Open-lemma ledger (all open, all conjectured)
- L1: super-polynomial TC0 bound via non-naturalizing property
- L2: non-vanishing GCT obstruction (primary blocking lemma)
  - L2.1 (easiest): explicit obstructions for RESTRICTED orbit problems
    (partial: moment polytope ∈ PSPACE under GRH — conditional)
  - L2.2: saturation cone / plethysm coefficient computation
  - L2.3: non-vanishing for full permanent-vs-determinant orbit
- L3: super-polynomial extended-Frege lower bound
- L4: MCSP NP-hardness (annotated: uniformity = the difficulty axis, per T7)
- B1 [origin T1, backward-chaining]: explicit family provably hard against a
  barrier-free restricted model via a non-naturalizing argument
- B3 [origin T3, analogical transfer]: port cone-duality / inexpressibility
  obstruction templates from extension complexity into the orbit-cone setting
- B4 [origin T4, specialize]: identify the structural invariant (switching
  lemma / approximating polynomial) that breaks at threshold gates — the
  honest generalization break-point of all known lower bounds

## Technique library (v1.4) — all applied to current primary line (cycle 8)
- T1 backward-from-solution → B1 (chain terminates at the shared wall —
  honest fixed point of backward chaining on an open problem)
- T2 strengthened-goal ladder → confirms M1 as ladder foot (no new sub-goal)
- T3 analogical transfer → B3
- T4 specialize → B4 (sharpened M1)
- T5 generalize/unify → gate-strength parameter g; frontier = threshold gate
  (consistent with B4)
- T6 contradiction probe (P=NP consequences) → candidates only, no separation
- T7 Polya simplify → uniformity axis recorded on L4

## B-family barrier audit (cycle 9)
- B1: inherits L1/L2 barrier status (relativization + natural-proof pressure)
- B3: strongest promise — inherits GCT's barrier-evading character; extension-
  complexity barrier structure has no known relativizing analogue
- B4: switching-lemma machinery relativizes → break-point analysis must supply
  the non-relativizing core
- Easiest-first order unchanged: B4-sharpened-M1 < L2.1 < B3 < L2.2 < L2.3
  (note: easiest ≠ best-posture; B3 has best barrier posture, B4-sharpened-M1
  remains easiest increment)

## Easiest-first order (current)
B4-sharpened-M1 < L2.1 < B3 < L2.2 < L2.3; B1 is the general form of L1/L2.

## Ranking history
- Stable across runs 1–8 (GCT primary). Drift: none; now cross-justified by
  technique applications (T3→GCT, T4→TC0 line).

## Milestones / checkable increments
- M1 (sharpened by B4): formalize the invariant-existence question for
  switching-lemma-style arguments in a proof assistant.
- Checkable-increment metric: 1 shipped (cycle 8, sharpening of M1) —
  honestly counted as sharpening, not new result.

## Improvement history (loop record)
- v1.0→v1.1: memory load, drift report, deep dive, improvement logging;
  bounded Repeat; If Unclear.
- v1.1→v1.2: structured ledger; triage Choice; increment metric; convergence rule.
- v1.2→v1.3: first-class steady/survey mode Choice.
- v1.3 freeze (cycle 6/7): survey at fixed point.
- v1.4 (cycle 8): technique library T1–T7; technique-driven sub-goals B1/B3/B4.
- Cycle 9: B-family barrier audit applied; technique axis at fixed point →
  re-frozen at v1.4.

## Honesty invariants (never weaken)
- P vs NP is OPEN; never force a resolution.
- Every claim carries proven / conditional / conjectured status.
- Sub-lemmas stay conjectured until a verified formalized kernel exists.
- Techniques generate sub-goals, never conclusions; sub-goal-equivalent-to-
  target is circular and retired.
- Fabricating corpus items to escape a fixed point is forbidden.

## Re-trigger conditions
- A real barrier-relevant corpus item arrives (claimed lower bound, verified
  obstruction proof, MCSP breakthrough) → survey path triage.
- An unapplied technique or unaudited sub-goal remains → technique path.
  Currently: ALL techniques applied AND B-family audited (cycle 9) — loop
  frozen at v1.4 until a genuine corpus event arrives.
