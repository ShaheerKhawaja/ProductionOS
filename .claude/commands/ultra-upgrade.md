---
name: ultra-upgrade
description: "The ULTIMATE product upgrade mode — combines 16 prompt engineering layers, multi-model judge tribunal, adversarial red-teaming, Reflexion memory, Constitutional AI safety, and Mixture-of-Agents ensemble. Targets 9.5/10 with up to 12 iterations."
arguments:
  - name: target
    description: "Target directory or repo URL"
    required: false
  - name: focus
    description: "Comma-separated focus dimensions (e.g., security,performance)"
    required: false
---

# Ultra-Upgrade — Maximum Reasoning & Planning Pipeline

You are the Ultra-Upgrade orchestrator — the most powerful product improvement engine available. You combine EVERY advanced technique from prompt engineering, multi-agent orchestration, adversarial review, and recursive self-improvement into a single convergence loop.

## What Makes Ultra Different

| Feature | /productupgrade | /auto-swarm | /ultra-upgrade |
|---------|-----------------|-------------|----------------|
| Agents per iteration | 7 | configurable | up to 14 |
| Max iterations | 7 | 11 | 12 |
| Judge | Single LLM | Coverage-based | 3-model tribunal |
| Prompt layers | Basic CoT | Task-specific | All 16 layers |
| Adversarial review | No | No | Every iteration |
| Reflexion memory | No | No | Cross-iteration learning |
| Research depth | Local scan | Configurable | Ultra (2000+ sources) |
| Target grade | 8.0/10 | Coverage% | 9.5/10 |
| Self-consistency | No | No | 3 reasoning paths |
| Constitutional AI | No | No | Safety principles |
| Graph of Thought | No | No | Finding networks |
| Debate protocol | No | No | Agent argumentation |

## Input
- Target: $ARGUMENTS.target (default: current working directory)
- Focus: $ARGUMENTS.focus (default: all 10 dimensions)

## Ultra-Upgrade Protocol

### Phase 0: INTELLIGENCE GATHERING (3 parallel agents)

Launch 3 research agents simultaneously:

**Agent 1 — Deep Researcher (Opus)**
Use the `deep-researcher` agent. Research the target's:
- Technology stack (every dependency, version, alternative)
- Competitor landscape (find 3 competitors, scrape their UX)
- Industry best practices (latest patterns for this tech stack)
- Known vulnerabilities (CVE databases, security advisories)
Depth: ultra (2000 sources/query, 10K total)
Output: `.productupgrade/INTEL-RESEARCH.md`

**Agent 2 — Codebase Mapper**
Full codebase analysis:
- Architecture map (entry points, data flow, service boundaries)
- LOC by language, churn hotspots (git log --numstat)
- TODO/FIXME/HACK/XXX markers
- Dead code detection
- Dependency graph
- Test coverage baseline
Output: `.productupgrade/INTEL-CODEBASE.md`

**Agent 3 — Context Retriever**
Use the `context-retriever` agent. Gather:
- All CLAUDE.md, README.md, architecture docs
- Previous `.productupgrade/` artifacts (if any)
- Memory system entries (mem-search for past decisions)
- context7 MCP docs for all major dependencies
Output: `.productupgrade/INTEL-CONTEXT.md`

### Phase 1: MULTI-PERSPECTIVE REVIEW (7 parallel agents)

Apply ALL 16 prompt engineering layers to each agent's system prompt.
Each agent receives the 7-layer composed prompt from `templates/PROMPT-COMPOSITION.md`.

**Agent 1 — CEO Review: SCOPE EXPANSION**
Invoke `/plan-ceo-review` in EXPANSION mode. Dream state, 10x vision, user delight.
Apply: Emotion Prompting (Layer 1) + Step-Back Prompting (Layer 9)

**Agent 2 — CEO Review: HOLD SCOPE**
Invoke `/plan-ceo-review` in HOLD mode. Error map, failure modes, security.
Apply: Constitutional AI (Layer 11) + Chain of Thought (Layer 3)

**Agent 3 — CEO Review: SCOPE REDUCTION**
Invoke `/plan-ceo-review` in REDUCTION mode. Cut to minimum viable.
Apply: Skeleton of Thought (Layer 12) + Chain of Density (Layer 6)

**Agent 4 — Engineering Review: Architecture**
Invoke `/plan-eng-review` Pass 1. Architecture, data flow, SPOFs, scaling.
Apply: Graph of Thought (Layer 5) + Tree of Thought (Layer 4)

**Agent 5 — Engineering Review: Robustness**
Invoke `/plan-eng-review` Pass 2. Edge cases, error handling, rollback.
Apply: Analogical Prompting (Layer 10) + Self-Consistency (Layer 7)

**Agent 6 — Adversarial Red Team (READ-ONLY)**
Use the `adversarial-reviewer` agent. Attack every assumption:
- Try to break every feature
- Find every way to abuse the system
- Identify every assumption that could be wrong
- Challenge every architectural decision
Apply: Debate Protocol (Layer 13) + Meta-Prompting (Layer 2)

**Agent 7 — Persona Tribunal**
Use the `persona-orchestrator` agent. Three personas evaluate:
- TECH PERSONA: "Does this code work correctly and scale?"
- HUMAN PERSONA: "Would a real user enjoy this experience?"
- META PERSONA: "Is this the right approach altogether?"
Apply: Mixture of Agents (Layer 15) + Plan-and-Solve (Layer 14)

Wait for all 7 agents. Compile into:
- `.productupgrade/REVIEW-CEO.md`
- `.productupgrade/REVIEW-ENGINEERING.md`
- `.productupgrade/REVIEW-ADVERSARIAL.md`
- `.productupgrade/REVIEW-PERSONAS.md`

### Phase 2: THOUGHT GRAPH SYNTHESIS

Use the `thought-graph-builder` agent to:
1. Read ALL review outputs from Phase 1
2. Extract every finding as a node
3. Connect findings with causal edges (A causes B, A blocks C)
4. Identify systemic issues (nodes with 3+ incoming edges)
5. Find root causes (nodes with 0 incoming edges, 3+ outgoing)
6. Rank by graph centrality (most connected = highest impact)

Output: `.productupgrade/THOUGHT-GRAPH.md` with:
- Node list (finding ID, description, dimension, severity)
- Edge list (from → to, relationship type)
- Centrality ranking (betweenness centrality)
- Root cause analysis (upstream nodes)
- Systemic issue clusters

### Phase 3: DYNAMIC PLANNING (3 parallel agents)

**Agent 1 — Strategic Planner**
Use the `dynamic-planner` agent. Read the thought graph and produce:
- P0/P1/P2/P3 priority matrix
- Batch sequencing (respect dependency edges from thought graph)
- Effort estimates per fix
- Risk assessment per batch
Output: `.productupgrade/ULTRA-PLAN.md`

**Agent 2 — Test Architect**
Use the `test-architect` agent. For every P0/P1 fix:
- Write the test specification FIRST (TDD)
- Define acceptance criteria
- Plan integration test coverage
- Design edge case scenarios
Output: `.productupgrade/ULTRA-TESTS.md`

**Agent 3 — Migration Planner**
Use the `migration-planner` agent. For every breaking change:
- Plan migration steps
- Design rollback procedures
- Identify data migration needs
- Plan feature flag coverage
Output: `.productupgrade/ULTRA-MIGRATION.md`

### Phase 4: EXECUTION WITH SELF-HEALING (up to 12 batches × 7 agents)

```
FOR batch IN 1..12:
    fixes = select_next_7_from_plan(thought_graph_priority_order)
    IF NOT fixes: BREAK

    # Launch 7 parallel fix agents with composed prompts
    FOR EACH fix IN fixes:
        agent_prompt = compose_prompt([
            emotion_layer(fix.severity),
            meta_layer(fix.dimension),
            cot_layer(fix.reasoning_needed),
            context_layer(fix.related_findings),
        ])
        launch_agent(fix, prompt=agent_prompt)

    AWAIT all agents

    # Self-healing gate
    lint = detect_and_run_linters()
    types = detect_and_run_type_checker()
    tests = detect_and_run_tests()

    IF ALL pass:
        git_commit(batch_message)
    ELSE:
        launch self-healer agent to fix errors
        IF self-healer succeeds:
            git_commit(batch_message + " (healed)")
        ELSE:
            ROLLBACK batch, log failure, CONTINUE to next batch

    # Reflexion: record what worked and what didn't
    append_to ".productupgrade/REFLEXION-LOG.md":
        - What was attempted
        - What succeeded
        - What failed and why
        - What to avoid in future batches
```

### Phase 5: MULTI-MODEL JUDGE TRIBUNAL

Launch 3 independent judge evaluations in parallel:

**Judge 1 — Primary (Opus)**
Use the `llm-judge` agent with model: opus
Score all 10 dimensions with evidence citations.

**Judge 2 — Challenger (Sonnet)**
Same rubric, same files, but different model perspective.
Sonnet tends to be more lenient — this creates tension.

**Judge 3 — Skeptic (Haiku)**
Fast, cheap, skeptical evaluation.
Haiku flags obvious issues that deeper models overthink.

**Tribunal Protocol:**
1. Collect all 3 scores per dimension
2. For each dimension:
   - If all 3 agree (within 1 point): use median score
   - If 2 agree, 1 disagrees: use the 2-agree score, flag disagreement
   - If all 3 disagree: trigger DEBATE (agents argue, then re-score)
3. Compute tribunal grade (weighted: Opus 50%, Sonnet 30%, Haiku 20%)
4. Apply Self-Consistency: if any dimension has LOW confidence from 2+ judges, re-evaluate with fresh file samples

Output: `.productupgrade/JUDGE-TRIBUNAL-{N}.md`

### Phase 6: CONVERGENCE DECISION

```
tribunal_grade = weighted_average(opus, sonnet, haiku)
delta = tribunal_grade - previous_grade

DECISIONS:
  IF tribunal_grade >= 9.5:          → SUCCESS (target reached)
  IF delta < 0.15 for 2 iterations:  → CONVERGED (plateau)
  IF iteration >= 12:                → MAX_REACHED
  IF any_dimension_dropped > 0.5:    → DEGRADED (halt + investigate)
  ELSE:                              → CONTINUE

IF CONTINUE:
  focus_dimensions = 2 lowest-scoring dimensions from tribunal
  reflexion_insights = read REFLEXION-LOG.md for patterns
  feed both into next iteration's planning phase
```

### Phase 7: CONSTITUTIONAL SAFETY CHECK (every 3rd iteration)

At iterations 3, 6, 9, 12 — run a safety audit:
1. Check no secrets were committed
2. Check no security dimensions regressed
3. Check no protected files were modified
4. Check total token spend is within budget
5. Present human checkpoint: show progress, ask to continue

### Phase 8: FINAL REPORT

When convergence is reached, produce:

```
╔══════════════════════════════════════════════════════════════╗
║                    ULTRA-UPGRADE COMPLETE                     ║
╠══════════════════════════════════════════════════════════════╣
║  Target Grade: 9.5/10                                        ║
║  Final Grade:  X.X/10 (from X.X baseline)                    ║
║  Iterations:   N                                             ║
║  Agents Used:  M                                             ║
║  Fixes Applied: F (P0: a, P1: b, P2: c, P3: d)              ║
║  Tests Added:  T                                             ║
║  Commits:      C                                             ║
║  Dimensions:                                                  ║
║    Code Quality:      X/10 (+Y)                              ║
║    Security:          X/10 (+Y)                              ║
║    Performance:       X/10 (+Y)                              ║
║    UX/UI:             X/10 (+Y)                              ║
║    Test Coverage:      X/10 (+Y)                              ║
║    Accessibility:     X/10 (+Y)                              ║
║    Documentation:     X/10 (+Y)                              ║
║    Error Handling:    X/10 (+Y)                              ║
║    Observability:     X/10 (+Y)                              ║
║    Deployment Safety: X/10 (+Y)                              ║
║                                                               ║
║  Reflexion Insights: I key learnings                         ║
║  Deferred Items:     D (see ULTRA-DEFERRED.md)               ║
╚══════════════════════════════════════════════════════════════╝
```

Output files:
- `.productupgrade/ULTRA-PLAN.md`
- `.productupgrade/ULTRA-TESTS.md`
- `.productupgrade/ULTRA-MIGRATION.md`
- `.productupgrade/ULTRA-LOG.md`
- `.productupgrade/ULTRA-DEFERRED.md`
- `.productupgrade/THOUGHT-GRAPH.md`
- `.productupgrade/REFLEXION-LOG.md`
- `.productupgrade/JUDGE-TRIBUNAL-{N}.md` (per iteration)
- `.productupgrade/CONVERGENCE-LOG.md`
- `.productupgrade/RUBRIC-BEFORE.md`
- `.productupgrade/RUBRIC-AFTER.md`

## Anti-Patterns

1. **Never skip the tribunal.** All 3 judges must evaluate every iteration.
2. **Never let fix agents self-report.** Judges read code independently.
3. **Never continue if a dimension dropped > 0.5.** Halt and rollback.
4. **Never batch more than 7 fixes.** Merge conflicts compound.
5. **Never skip constitutional checkpoints.** Safety is non-negotiable.
6. **Never ignore Reflexion insights.** Learn from previous iterations.
7. **Never skip the thought graph.** Systemic issues need network analysis.
8. **Never run tribunal judges in the same agent context.** Independence is critical.

## Resource Budgets

| Resource | Per Iteration | Total Session |
|----------|---------------|---------------|
| Tokens | 600K | 4M |
| Agents | 14 max | 168 max |
| Web fetches | 100 | 1000 |
| Time | ~15 min | ~3 hours |

## Guardrails

- Protected files: `.env*`, `*key*`, `*cert*`, `*secret*`, production configs
- Max 15 files per batch, 200 lines per file
- Automatic rollback on test failure or score regression
- Human checkpoint at iterations 3, 6, 9, 12
- Emergency stop on cost threshold ($10 / 1M tokens)
- Scope enforcement: agents cannot modify outside their focus area
