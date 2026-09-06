# Approachable-Workflows: Plain-Language Workflow

## Goal

Provide a beautifully simple and powerful workflow language. Start simple (~10 lines), add detail only when needed (~50 lines for production, ~100+ for complex workflows with state and events).

## Documentation Structure

**Organized by user intent:**

- **docs/tutorials/** — Learning-oriented (hands-on, build something)
- **docs/how-to/** — Task-oriented (accomplish specific goals)
- **docs/explanation/** — Understanding-oriented (concepts, "why" questions)
- **docs/reference/** — Information-oriented (lookup, specifications)

**Key files:**
- `docs/reference/spec-for-humans.md` — Canonical specification (source of truth)
- `docs/reference/spec-for-ai.md` — Token-efficient AI reference for knowledge sources
- `docs/reference/fields.md` — Complete A-Z field reference
- `docs/tutorials/first-workflow.md` — 10-minute hands-on tutorial
- `docs/explanation/why-it-works.md` — Evidence that graph engineering in LLMs works
- `examples/` — Real-world workflows (including legal-review-analysis with 99.5/100 evaluation)
- `templates/` — Workflow templates to copy and adapt

**README.md** — Streamlined entry point (97 lines), guides users to right resources by intent.

## Structure Conventions

**Examples:** Put in `./examples/` directory, organized by complexity or domain.

**New documentation:** Place by user intent:
- Tutorial = hands-on learning → `docs/tutorials/`
- How-to = specific task → `docs/how-to/`
- Explanation = concepts/why → `docs/explanation/`
- Reference = lookup/spec → `docs/reference/`

**Templates:** Put in `./templates/` directory.

**Specs:** `spec-for-humans.md` drives `spec-for-ai.md` (token-efficient AI reference).

## Constraints

Make it readable and editable by business analysts or prompt engineers, but also expressive enough (extensions) for AI engineers and structured enough for runtimes to compile into agent loops.

**No YAML or JSON. Plain language only.**

## Progressive Formalization

**Start minimal:** Activity names, Do, Next  
**Add as needed:** Roles, Verify, If Failed, Choice, Repeat  
**Extended features:** State tracking, events, Do Together, Run Workflow

All workflows are valid regardless of formalization level. Add structure only when it adds value.

## Design Principles

1. **Plain Language First**: No YAML, JSON, or code syntax — everything uses clear English
2. **Progressive Formalization**: Start simple, add detail only when needed
3. **Defaults Over Specification**: Kind defaults to Work, Next is implicit, Role implies capability
4. **Analyst, Prompt Engineer, and AI Engineer**: Approachable for business, expressive for engineers
5. **Runtime Ready**: Compiles into executable agent loops

## Key Simplifications (v0.8)

- **Removed pattern declarations**: Workflows are self-documenting
- **Removed Capability field**: Role indicates work type (Analyst analyzes, Researcher researches, etc.)
- **Changed Case to Handles**: More active language ("Handles: Each refund request")
- **Use → Needs**: Clearer dependencies ("Needs: Policy library, Customer data")
- **Produce → Creates**: More natural language ("Creates: Recommendation, Risk score")
- **Invoke Workflow → Run Workflow**: Plain language ("Run Workflow: Credit Check")
- **Parallel Work → Do Together**: Simple English ("Kind: Do Together")
- **Smart defaults**: Kind=Work, implicit Next, fewer required fields
- **Ultra-simple option**: Start with ~10 lines for simple workflows

## Evidence

**Production-ready:** Legal Discovery Review workflow achieved 99.5/100 evaluation score.

**Key evidence:**
- `examples/legal-review-analysis/legal-review-analysis.txt` — Production workflow (20+ activities)
- `examples/legal-review-analysis/cases/vantek-ostrow/evals/EVAL_REPORT_*.md` — Detailed evaluation
- `examples/legal-review-analysis/cases/vantek-ostrow/runs/.../chat-log.md` — Graph execution trace
- `docs/explanation/why-it-works.md` — Complete analysis

**Proof points:**
- ✅ Complex graph traversal 
- ✅ State propagation 
- ✅ Adversarial robustness (detected and neutralized prompt injection)
- ✅ Graph integrity (zero privilege leakage across entire execution)
- ✅ Parallel execution (entity resolution, timeline assembly)

Graph engineering in LLMs isn't just possible — it's **repeatable, auditable, and production-ready**.

## Version History

**v0.8** — Current
- Documentation restructure by user intent
- Streamlined README (97 lines, 48% reduction)
- Production evidence: 99.5/100 evaluation
- Created comprehensive field reference
- Added first-workflow tutorial
- Established documentation by user intent
- **Removed "three levels" concept** — replaced with "progressive formalization" throughout
- **Updated terminology** — "evidence capture" → "execution reporting with activity feedback"
- **Simplified spec-for-humans.md** — Essential/Production/Complex instead of Simple/Standard/Extended
