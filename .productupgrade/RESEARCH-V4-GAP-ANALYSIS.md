# ProductUpgrade V4.0 — Comprehensive Gap Analysis

*Generated: 2026-03-18 | Sources: 6 parallel research agents, 42 repos, 50+ arxiv papers*

## Executive Summary

V4 implements **17 of 58 canonical prompt engineering techniques** (29%). After analyzing 42 reference repos, 50+ arxiv papers (2023-2026), and the architectures of 10 top Claude Code plugins, we identified **25 HIGH priority gaps**, **14 MEDIUM**, and **7 LOW**.

The top 5 highest-impact gaps are:
1. **Discuss-Phase** (from GSD) — pre-pipeline user decision capture
2. **Distractor-Augmented Prompting** (Chhikara 2025) — 460% accuracy improvement
3. **ES-CoT / Early Stopping CoT** (2025) — 41% token cost reduction
4. **DOWN / Confidence-Gated Debate** (Eo 2025) — 6x debate efficiency
5. **Generated Knowledge Prompting** (Liu 2022) — eliminates confident-wrong-answer failure

---

## Part 1: Skill Architecture Gaps (vs GSD, superpowers, ECC, gstack)

### HIGH PRIORITY

| # | Gap | Source | Impact |
|---|-----|--------|--------|
| 1 | Discuss-phase: pre-pipeline user decision capture | GSD | Prevents agents from fixing things user didn't want changed |
| 2 | Goal-backward stub detection (wired vs placeholder) | GSD verifier | Catches React `<div>Placeholder</div>` stubs |
| 3 | Plan-check agent before execution | GSD plan-checker | Verifies plans will achieve goals before dispatching agents |
| 4 | Nyquist behavioral test gap-filler | GSD nyquist-auditor | Generates tests for untested requirements |
| 5 | Cross-session continuous learning (Stop hook) | ECC | Converts Reflexion insights into persistent learned skills |
| 6 | Eval-driven development (pass@k metrics) | ECC eval-harness | Deterministic code-based capability evals |
| 7 | Iterative subagent context retrieval | ECC | Agents request more context when insufficient |
| 8 | Document-release post-pipeline doc sync | gstack | Updates docs to match code changes |

### MEDIUM PRIORITY

| # | Gap | Source |
|---|-----|--------|
| 9 | UI-SPEC contract + AI slop detection | GSD + gstack |
| 10 | Standalone codebase mapper command | GSD |
| 11 | Session pause/resume with state handoff | GSD |
| 12 | Model profile flag (`--profile budget`) | GSD |
| 13 | Receiving-review protocol with YAGNI filter | superpowers |
| 14 | Skill writing validation (TDD for docs) | superpowers |
| 15 | Design consultation (generative) | gstack |
| 16 | Harness self-audit scorecard | ECC |
| 17 | Per-agent cost tracking | ECC |
| 18 | Prompt self-optimizer using Reflexion log | ECC |

---

## Part 2: Prompt Engineering Gaps (vs arxiv + Fabric + Prompt-Engineering-Guide)

### Already in V4 (17 techniques)
CoT, ToT, GoT, CoD, Self-Consistency, Reflexion, Constitutional AI, LLM-as-Judge, Emotion Prompting, Meta-Prompting, Debate Protocol, Persona Evaluation, Step-Back, Contrastive CoT, ReAct, Cumulative Reasoning, Self-Debugging, LATS

### HIGH PRIORITY — Not in V4

| # | Technique | Source | Impact |
|---|-----------|--------|--------|
| 1 | Generated Knowledge Prompting | Liu 2022 | Agents generate best practices BEFORE evaluating code |
| 2 | APE / Self-Optimizing Prompts | Zhou 2022 | Auto-improve agent prompts using rubric as signal |
| 3 | PAL (Program-Aided Language) | Gao 2022 | Generate code for numeric analysis instead of reasoning |
| 4 | Claim Analysis / Logical Fallacy Detection | Fabric | Rate agent findings A-F, remove D/F claims |
| 5 | Inner Monologue / Scratchpad Hiding | Devin/Cursor/Gemini | Separate reasoning space before output |
| 6 | Distractor-Augmented Prompting | Chhikara 2025 | Inject wrong-answer distractors → 460% accuracy gain |
| 7 | ES-CoT (Early Stopping CoT) | 2509.14004 | 41% token reduction, no accuracy loss |
| 8 | DOWN (Confidence-Gated Debate) | Eo 2025 | Only debate when confidence < threshold → 6x efficiency |
| 9 | ThinkPRM / Generative PRM | 2504.16828 | Step-level verification with reasoning chains |
| 10 | Agent-as-a-Judge | Zhuge 2024 | Judge the agent's process, not just output files |
| 11 | LLM-as-a-Fuser (ensemble calibration) | 2508.06225 | +47% accuracy, -54% calibration error in judge |
| 12 | Multi-Agent Reflexion (MAR) | Ozer 2025 | Multi-persona reflections fix degeneration-of-thought |
| 13 | Meta-Policy Reflexion (MPR) | 2509.03990 | Structured predicate-rule memory across sessions |
| 14 | Adaptive Graph of Thoughts (AGoT) | 2502.05078 | Auto-select chain/tree/graph topology per problem |
| 15 | TextGrad | Yuksekgonul 2024 | Pipeline self-optimization via textual backpropagation |
| 16 | Domain-Specific Constitutional AI | 2509.16444 | Tech-stack-specific guardrails |
| 17 | Confidence Calibration / CoCoA | Liu 2025 | Grades become "7.3 ± 0.4" not "7.3" |

### MEDIUM PRIORITY — Not in V4

| # | Technique | Source |
|---|-----------|--------|
| 18 | Skeleton of Thought (SoT) | Ning 2023 |
| 19 | Thread of Thought (ThoT) | 2311.08734 |
| 20 | Rephrase and Respond (RaR) | 2311.04205 |
| 21 | Active Prompting | 2305.13195 |
| 22 | Analogical Prompting | 2310.01714 |
| 23 | Plan-and-Solve (PS+) | 2305.04091 |
| 24 | G-Eval Framework | Liu 2023 |
| 25 | Socratic Self-Refine (SSR) | 2511.10621 |
| 26 | OPRO rubric evolution | Yang 2023 |
| 27 | RethinkMCTS error memory | 2409.09584 |
| 28 | Code-A1 adversarial co-evolution | 2603.15611 |

---

## Part 3: Architecture Patterns (vs top 10 plugins)

### Patterns V4 has:
- Multi-agent parallel execution (7/wave)
- LLM-as-Judge convergence loops
- Self-healing validation gates
- Adversarial red-teaming
- Human-in-the-loop checkpoints
- Cost budgets per mode
- Protected file guardrails

### Patterns V4 is missing:

| # | Pattern | Source Plugin | Impact |
|---|---------|-------------|--------|
| 1 | Progressive Disclosure (3-tier loading) | Anthropic best practices | Reduce SKILL.md context overhead |
| 2 | Lean Orchestrator (15% context) | GSD | Orchestrator uses minimal context, agents get full |
| 3 | Ralph Pattern (Stop hook loop) | Anthropic Ralph Wiggum | Autonomous multi-hour development |
| 4 | Template-Generated Skills | gstack | Skills auto-generated from source metadata |
| 5 | 4-Tier Model Routing | wshobson/agents | Explicit Opus/Sonnet/Haiku per agent role |
| 6 | Hook Profiles (minimal/standard/strict) | ECC | User-configurable hook overhead |
| 7 | Two-Stage Review (spec + quality) | superpowers | Separate spec compliance from code quality |
| 8 | 3-Tier Evaluation (static→E2E→judge) | gstack | 95% of issues caught for free |
| 9 | Self-Improving Knowledge Base | metaswarm | JSONL entries from each run |
| 10 | Completion Promises | Ralph Wiggum | Agent outputs specific word to signal genuine completion |

---

## Part 4: Top 10 Arxiv Papers for /ultra-upgrade Integration

| # | Paper | Year | Key Technique | Applicability |
|---|-------|------|--------------|--------------|
| 1 | Distractor-Augmented Prompting | 2025 | Inject plausible wrong answers | All review agents |
| 2 | ES-CoT (Early Stopping) | 2025 | Stop reasoning when converged | /productupgrade cost mode |
| 3 | DOWN (Confidence-Gated Debate) | 2025 | Debate only when uncertain | Tribunal efficiency |
| 4 | ThinkPRM | 2025 | Generative process verification | Step-level fix validation |
| 5 | LLM-as-a-Fuser | 2025 | Ensemble calibration | Tribunal scoring |
| 6 | Multi-Agent Reflexion (MAR) | 2025 | Multi-persona reflection | Cross-iteration learning |
| 7 | SEAL Steering Vectors | 2025 | Training-free reasoning calibration | +14% accuracy |
| 8 | Agent-as-a-Judge | 2024 | Judge agent behavior, not just output | Ultra judge upgrade |
| 9 | Adaptive Graph of Thoughts | 2025 | Auto-select reasoning topology | Layer routing |
| 10 | Code-A1 | 2026 | Adversarial code+test co-evolution | Fix verification |

---

## Recommended V4.1 Roadmap

### Immediate (this session)
- [x] All 9 missing V2 agents created
- [x] 7 new prompt layers (09-15) written
- [x] /ultra-upgrade command created
- [x] /auto-swarm command created
- [x] /productupgrade-update command created
- [x] Self-learning PostToolUse hook
- [x] Arxiv scraper script

### V4.1 (next session)
- [ ] Add Discuss-Phase agent (pre-pipeline decision capture)
- [ ] Add Stub Detector agent (wired vs placeholder check)
- [ ] Add Plan Checker agent (verify plans before execution)
- [ ] Add Scratchpad/Inner Monologue to all agent templates
- [ ] Add Generated Knowledge Prompting layer (Layer 16)
- [ ] Add Distractor-Augmented Prompting layer (Layer 17)
- [ ] Add Confidence Calibration to judge tribunal
- [ ] Add ES-CoT mode for cost-efficient /productupgrade
- [ ] Add DOWN (confidence-gated) debate protocol
- [ ] Cross-session learning via Stop hook

### V4.2 (future)
- [ ] TextGrad pipeline self-optimization
- [ ] Agent-as-a-Judge (process evaluation)
- [ ] Domain-Specific Constitutional AI
- [ ] OPRO rubric self-evolution
- [ ] 4-tier model routing
- [ ] Hook profiles (minimal/standard/strict)
