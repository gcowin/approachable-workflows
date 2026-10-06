Workflow: P versus NP Research Program

Version: 1.4

Goal: Systematically survey, triage, deep-dive, and execute candidate
strategies for resolving the P vs NP problem — auditing each strategy against
the three known barriers (relativization, natural proofs, algebrization),
carrying forward memory from prior runs, and now ALSO applying explicit
problem-solving techniques (chiefly working backward from the desired solution,
i.e. backward chaining) to derive new sub-goals and checkable increments,
tracking formalizable progress (new lemmas, partial lower bounds,
unconditional separations), and synthesizing an honest research report with
the current best-supported line of attack and a concrete next-step agenda.
Progress is measured only by checkable increments shipped per cycle, never by
claimed resolution. Once converged, the workflow runs the idempotent steady
path instead of re-surveying.

Handles: A corpus of complexity-theory material (new papers, surveys,
claims) per cycle — triaged, then added to the shared registry of strategies,
barriers, known results, and open lemmas; plus a library of problem-solving
techniques applied to advance the primary line of attack.

Provided:
- Target problem: P vs NP (open; resolved direction unknown)
- Corpus input: new items to triage (may be empty on a steady-state cycle)
- Prior-run memory: memory.md + prior run directories, the baseline registry
- Formalization toolkit: proof assistant or pen-and-paper formal proof standards
- Constraint: no strategy may be declared viable without passing the barrier audit

Returns:
- Triage decision for each new corpus item (barrier-relevant / noise / duplicate)
- Barrier audit for each strategy (relativizing? natural? algebrizing?)
- Structured open-lemma ledger (ID, linked strategy, owner capability, status)
- Technique applications: each library technique applied against the target,
  yielding derived sub-goals and new/refreshed checkable increments
- Ranked strategy list with honest feasibility assessment + drift report
- Primary-line deep dive: sub-lemma decomposition + this cycle's checkable
  increment (the only progress metric)
- Final research report (explicit statement that the problem remains open
  unless an unconditional, verified resolution exists)
- Workflow Execution Report
- Updated memory.md + improvement log entry for the next cycle

Working:
- Strategy registry (each candidate approach, one record)
- Technique library (problem-solving techniques, one record each — see below)
- Prior-run memory (baseline ranking, ledger, critiques)
- Triage queue (new corpus items awaiting classification)
- Structured open-lemma ledger (schema below)
- Evidence log: [claim, source, status: proven / conditional / conjectured]
- Counterexample log (candidate proofs with identified gaps)
- Checkable-increment metric (count of increments shipped this cycle)
- Current Activity

Technique Library (per cycle, apply each to the TARGET = "construct an
unconditional, barrier-free resolution of P vs NP"; record what each yields):
- T1 Backward from the solution (backward chaining): assume the finished
  proof exists and work backward — what must the final object look like?
  An explicit hard function family, an algorithm, a proof system
  lower-bound certificate — then ask which already-known object in the
  ledger comes closest, and make THAT gap the next checkable increment.
- T2 Work backward from strengthening the goal: find the strongest true
  statement whose proof would imply the target (e.g., NEXP not in P/poly →
  MA≠NEXP fragments); shrink ambition stepwise until reaching a statement
  whose easiest case is decidable now.
- T3 Analogical transfer: solve the same-shaped problem in an analogous
  setting (communication complexity, extension complexity, Kolmogorov
  complexity) and port the obstruction pattern back.
- T4 Specialize to simplify: restrict the model (monotone circuits, bounded
  depth, one-way communication) where resolutions ARE known, extract the
  proof idea, then identify precisely where generalization breaks (that
  failure point is a lemma).
- T5 Generalize to unify: restate scattered partial results as one
  parameterized conjecture; the parameter where the known cases end marks
  the frontier.
- T6 Contradiction probe: assume the opposite resolution (P = NP) and
  enumerate its structural consequences (collapses, complete search
  problems in FP^np-opt) — a surprising-but-false consequence, if ever
  made rigorous, becomes the separation; record candidate consequences.
- T7 Simplify the goal (Polya): strip one assumption from the target
  (adversary restriction, non-uniformity, average-case weakening) and
  check whether the stripped goal is proven; where stripping changes the
  status, that axis names the real difficulty.

Ledger Schema (every lemma record has exactly these fields):
- id: stable identifier (L1, L2, L2.1, ...)
- claim: the exact open statement
- linked-strategy: registry id it depends on
- capability: what would need to be true to advance it
- status: always "open/conjectured" until a verified formalized kernel exists
- checkable-increment: the smallest verifiable step toward it

Business State:
- Memory Load In Progress
- Triage In Progress
- Survey In Progress
- Barrier Audit In Progress
- Technique Application In Progress
- Deep Evaluation In Progress
- Synthesis In Progress
- Delivered

Activities:

Activity: Load Prior Run Memory
Do:
  1. Read memory.md and the most recent run directory: prior ranking, primary
     line, structured ledger, milestones, technique-application history,
     improvement history.
  2. Carry the prior registry and ledger forward as the baseline; mark anything
     new relative to memory.
Creates: Prior-run memory record (baseline ranking + structured ledger + critiques)
Verify: Memory is read-only input — prior claims keep their status
       (proven / conditional / conjectured); nothing is silently re-marked
Next: Select Cycle Mode

Activity: Select Cycle Mode
Kind: Choice
Needs: Prior-run memory record
Conditions:
- Ranking + ledger stable for 3+ consecutive runs AND no barrier-relevant
  corpus delta AND no unapplied technique left → take the steady path: skip
  re-survey, carry all records unchanged, and confirm stability.
- A triaged barrier-relevant item changes a record, OR an unapplied library
  technique can produce a new derived sub-goal → take the survey path:
  (re-)run framing, inventory, and audit, then apply techniques.
Otherwise: Mode cannot be decided → keep `?`, block, and report honestly;
  do not silently pick a path.
Creates: This cycle's mode (steady | survey) with the evidence for it
Verify: The chosen mode is justified by the memory record, not by preference
Next: Triage New Corpus Items

Activity: Triage New Corpus Items
Kind: Choice
Needs: Corpus input, prior-run memory record
Conditions:
- New barrier-relevant item (touches a strategy or lemma) → create an
  evidence-log record, link to the affected strategy/lemma id, mark as added
  in the registry delta.
- Duplicate of an existing record → mark duplicate, link to existing id, do
  not re-audit.
- Noise (irrelevant to any registry entry) → mark excluded, no analysis.
- No new items (steady-state cycle) → record "no corpus delta"; proceed on
  the existing registry.
Otherwise: Unclear relevance → keep `?` in the triage queue and block only
  that item's path (Law 1); do not force a classification.
Creates: Triage decisions (one per item), updated registry delta
Verify: Every item has exactly one triage decision with a reason
Next: Frame the Problem Precisely

Activity: Frame the Problem Precisely
Needs: Prior-run memory record, selected cycle mode
Do:
  0. If mode is steady: carry the framed problem forward unchanged and stop here.
  1. State the problem in exact form: Is P equal to NP? Note the widely
     expected answer (P ≠ NP) is unproven.
  2. List what a valid resolution requires: a proof either (a) an explicit
     NP problem with super-polynomial (ideally exponential) lower bound
     against all polynomial-size circuits, or (b) an algorithm solving an
     NP-complete problem in polynomial time.
  3. Record that any acceptable argument must be non-relativizing,
     non-naturalizing, and non-algebrizing — or explain how it evades the
     barrier that seems to apply.
  4. Record canonical examples and structure: NP-completeness, hierarchy
     collapses implied by P = NP, oracle facts (Baker-Gill-Solovay).
Creates: Precisely framed problem, barrier list, validity criteria
Verify: Every technique mentioned is classified against the three barriers
If Unclear: A barrier classification cannot be decided — keep it `?`, record
       in the counterexample log, and continue only on decidable items
Next: Inventory Candidate Strategies

Activity: Inventory Candidate Strategies
Needs: Framed problem, prior-run memory record, cycle mode
Do:
  0. If mode is steady: carry the registry forward unchanged (delta: none)
     and stop here. Otherwise:
  1. Start from the prior run's strategy registry (from memory) if present;
     otherwise enumerate from scratch.
  2. Confirm, add, merge, or retire strategy families; each entry keeps a
     one-paragraph mechanism sketch and its barrier to evade:
     - Circuit lower bounds: explicit functions hard for AC0, ACC0; TC0
       lower bounds beyond known results; monotone vs general circuits
     - Geometric Complexity Theory (GCT): group-geometric programs for
       VP vs VNP; permanent-vs-determinant; plethysm / weight obstructions
     - Proof complexity: super-polynomial lower bounds for stronger and
       stronger propositional proof systems; weak P ≠ NP routes
     - Meta-complexity: worst-case ↔ average-case meta-theorems, natural-
       proof-immune routes to NP average-case hardness
     - Derandomization-to-hardness: Impagliazzo-Wigderson-style windows —
       derandomizing MA/MAP yields worst-case lower bounds; relativizes
     - Descriptive complexity: logical characterization limits (Fagin,
       fixed-point logic) and what stronger invariance results would yield
  3. Mark each entry: unchanged / added / retired relative to memory.
Creates: Updated strategy registry (with deltas vs prior run)
Verify: Each entry names its mechanism and the barrier it must evade;
       registry delta is explained against memory
Next: Run Barrier Audit

Activity: Run Barrier Audit
Kind: Repeat
Repeat Over: Each strategy in the strategy registry
Maximum: 12 strategies
Do:
  0. If mode is steady: carry prior audit verdicts forward (still cited) and
     stop here. Otherwise:
  1. Test the strategy against each barrier:
     - Relativization: does a standard oracle construction decide the same
       claim, making the proof technique insufficient? (Baker-Gill-Solovay)
     - Natural proofs: does the argument, applied to a large constructive
       distinguishability property, contradict the existence of pseudorandom
       generators? (Razborov-Rudich)
     - Algebrization: does the argument arithmetize through every relevant
       oracle? (Aaronson-Wigderson)
  2. For each barrier that applies: mark the strategy as blocked-unless-evaded
     and record exactly what is needed to evade it.
  3. Record residual viability: what fraction of the needed result already
     exists conditionally (relative to oracles, or assuming plausible
     conjectures)?
Creates: Barrier audit record per strategy
Verify: Every barrier verdict has a cited theorem or cited barrier example
Next: Formalize What Is Proven

Activity: Formalize What Is Proven
Needs: Barrier audit records
Do:
  1. For the strongest results each surviving strategy can reach, state the
     exact incremental lemma needed (e.g., "super-polynomial lower bounds
     against TC0 via a non-naturalizing property").
  2. Check each lemma for vacuity: does the demanded property exist at all
     under known pseudorandom-generator assumptions? Log counterexamples
     where the demand violates natural-proof consistency.
  3. Split into achievable milestones: unconditional results obtainable now
     against restricted models; conditional implications worth publishing.
  4. Record each lemma in the structured ledger schema (id, claim,
     linked-strategy, capability, status=open, checkable-increment).
Creates: Structured open-lemma ledger, milestone list
Verify: No milestone secretly assumes the conclusion (no circularity:
        "assume super-polynomial circuit lower bounds" is not a strategy)
Next: Apply Problem-Solving Techniques

Activity: Apply Problem-Solving Techniques
Kind: Repeat
Repeat Over: Each technique T1..T7 in the technique library not yet applied
             to the current primary line
Maximum: 7 techniques
Needs: Framed problem, open-lemma ledger, primary line from memory
Do:
  1. Apply T1 (backward from the solution) FIRST: assume a finished
     unconditional resolution exists and work backward — the final proof
     object must exhibit some property; ask which ledger item comes closest
     to that object, and name the exact gap as a derived sub-goal.
     Backward chaining never assumes the conclusion is true; it assumes the
     OUTPUT SHAPE and asks what the last step before it must have been.
  2. Apply T2..T7 in order; for each, write the derived sub-goal(s) it
     produces into the ledger as new schema records (linked to the technique
     id as origin), each with its own smallest checkable increment.
  3. Check every derived sub-goal for hidden circularity: if the sub-goal
     is secretly equivalent to the target, mark it circular and retire it
     (the anti-circularity rule applies to techniques too).
  4. Record honestly when a technique yields no new purchase; "no new
     sub-goal from T5" is a valid, recorded result.
Creates: Ledger records derived via named techniques; applied-technique log
Verify: Every applied technique has a recorded outcome (sub-goal produced or
        honest no-progress note); every new sub-goal traces to a technique id
Next: Evaluate and Rank Strategies

Activity: Evaluate and Rank Strategies
Needs: Audit records, open-lemma ledger, prior ranking from memory
Do:
  1. Score each strategy: barrier-freedom plausibility, existing partial
     results, community traction, leverage on other results.
  2. Rank; justify every ranking decision with the barrier audit and the
     open-lemma ledger.
  3. Compare against the prior run's ranking (from memory): if the ranking
     changed, explain the drift and its evidence; if unchanged, confirm
     stability across runs.
  4. Select the primary line of attack and at most two backups.
Creates: Ranked list with drift report vs prior run
Verify: Every ranking has evidence; every blocked strategy's blocker is
       cited; drift is explained
Next: Deepen Primary Strategy

Activity: Deepen Primary Strategy
Needs: Primary strategy record, its open lemma from the ledger, technique-derived sub-goals
Do:
  0. If mode is steady: carry the sub-lemma set forward unchanged and stop here.
  1. Decompose the primary strategy's blocking lemma into concrete
     sub-lemmas — enriched by any non-circular sub-goals produced by the
     technique applications (T1..T7) — ordered easiest-first.
  2. For the easiest open sub-lemma, state the precise standing conjecture,
     the known partial results, and the first checkable increment.
  3. Do NOT claim the sub-lemma is proven; it stays conjectured in the
     evidence log.
  4. Increment the checkable-increment metric only if this cycle actually
     shipped a verifiable step toward a lemma; on a steady-state cycle the
     metric legitimately stays 0 (no increment shipped ≠ failure).
Creates: Sub-lemma decomposition, checkable-increment count for this cycle
Verify: The decomposition reduces scope without assuming the conclusion
Next: Synthesize Research Report

Activity: Synthesize Research Report
Kind: Work
Do:
  1. Assemble: framing → memory delta → strategy inventory → barrier audits →
     open lemmas and milestones → technique applications → ranking + drift →
     deep dive → next-step agenda.
  2. Include an explicit honesty section: state that P vs NP remains open,
     that no enumerated strategy currently resolves it, and that any future
     claim of resolution must pass all three barrier audits against a
     verified formalized kernel before acceptance.
  3. Run execution reporting with activity feedback per the runtime skill.
Creates: Final research report
Verify: Report distinguishes proven facts from conjectures everywhere; zero
       unmarked conjectures
Next: Log Run Improvement

Activity: Log Run Improvement
Do:
  Write an improvement-log entry: what this run's execution revealed about
  the workflow itself (missing activities, ambiguous gates, format defects)
  and the concrete change proposed for the next version.
Creates: Improvement log entry (memory for the next workflow revision)
Verify: Entry cites actual execution observations, not speculation
Next: Deliver

Activity: Deliver
Needs: Final research report, improvement log entry
Do:
  Deliver final report, ranked strategy list with drift report, sub-lemma
  decomposition, open-lemma ledger, improvement log entry, and execution
  report to the user. Write all artifacts to the new run directory so the
  next run can use them as memory. Mark state Delivered.
Next: Outcome: Completed

Governance:
- Every claim carries a source and a status (proven / conditional / conjectured).
- No strategy upgrade without barrier audit; no audit without citations.
- Anti-circularity rule: evaluation forbids strategies that assume hard
  problems in the class being separated.
- Any alleged resolution found in the corpus is routed through full barrier
  audit and gap hunt before any mention; unresolved gaps are public in the
  counterexample log.
- Memory rule: prior-run content is carried forward unchanged unless current
  evidence changes its status; re-marking requires citation.
- Convergence rule: when ranking + ledger are stable for 3 consecutive runs
  AND every library technique has been applied to the current primary line,
  stop re-surveying and switch to event-driven mode — cycles run only when a
  triaged barrier-relevant corpus item changes a record, or an unapplied
  technique remains.
- Technique rule: techniques generate sub-goals, never conclusions; a derived
  sub-goal sub-goal-equivalent to the target is circular and retired.
- Honesty metric: the checkable-increment metric is the only progress measure;
  it is never inflated and a 0 is reported honestly.
- Execution reporting with activity feedback is automatic at every transition.
