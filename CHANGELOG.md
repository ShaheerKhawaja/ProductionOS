# Changelog

## [5.0.0] - 2026-03-18 — ProductionOS

### Breaking Changes

- **Rebranded:** ProductUpgrade → ProductionOS. Plugin name is now `productionos`.
- **Renamed commands:** `/productupgrade` → `/production-upgrade`, `/ultra-upgrade` → `/omni-plan`, `/productupgrade-update` → `/productionos-update`
- **Renamed skill directory:** `.claude/skills/productupgrade/` → `.claude/skills/productionos/`
- Output directory changed from `.productupgrade/` to `.productionos/`

### Added

- **`/omni-plan`** — 13-step orchestrative pipeline with tri-tiered judge panel (Correctness/Practicality/Adversarial), recursive convergence to 9.5/10, CEO→Eng→Design review chain, CLEAR framework evaluation, PIVOT/REFINE/PROCEED decisions, and self-enrichment protocol. Flagship command.
- **`/deep-research`** — 8-phase autonomous research pipeline with 4-layer citation verification, hypothesis generation, confidence-gated loops (if < 80%, loop deeper), and knowledge archival.
- **`/agentic-eval`** — Niche-agnostic evaluator using CLEAR v2.0 framework: 6-domain assessment, 8 analysis dimensions, 6-tier source prioritization, evidence strength ratings.
- **`/security-audit`** — 7-domain security hardening command wrapping the security-hardener agent. OWASP/MITRE/NIST framework support.
- **`/context-engineer`** — Token-efficient context construction for downstream agents with cross-session persistence via MetaClaw.
- **`/logic-mode`** — Idea → production plan pipeline. Decomposes business ideas, challenges assumptions, researches competitors, identifies pre/post-production flaws, auto-populates planning documents.
- **`/learn-mode`** — Interactive code tutor with 5 modes: file/function explanation, concept explanation, codebase walkthrough, error explanation, and BTW context for ad-hoc questions.
- **Tri-tiered evaluation architecture** — 3 independent judges evaluate at pre-execution AND post-execution gates. Consensus protocol with DEBATE on disagreement.
- **Self-enrichment protocol** — when tasks exceed current capabilities, the system generates new agent definitions and adds them to the pipeline.
- **Anti-hallucination measures** — confidence scoring, citation verification, adversarial review, distractor-augmented evaluation, cross-agent disagreement logging.
- **HANDOFF-PROMPT.md** — comprehensive handoff document for fresh session continuity.

### Research Completed

- **CEO Review** (`.productupgrade/REVIEW-CEO.md`): 7.5/10 engineering, 5/10 product. Top need: `/quick` mode for instant value.
- **Engineering Review** (`.productupgrade/REVIEW-ENGINEERING.md`): 9 HIGH findings including Bash in read-only agents, undefined tribunal debate, no git state check.
- **gstack deep analysis**: 15 tools fully mapped with user journey, shared infrastructure (preamble, ELI16, Review Readiness Dashboard), and missing pieces identified.
- **Orchestration primitives**: Claude Code TaskTool/TeammateTool, spawn backends, task dependencies from Klaassen gist.
- **gstack TypeScript stack**: 74.8% TS (Bun compiled browser, skill-gen, 3-tier testing) vs ProductionOS 100% markdown.

### Changed

- Plugin version: 4.1.0 → 5.0.0
- Total commands: 4 → 10
- Identity: code quality audit tool → agentic development operating system

## [4.1.0] - 2026-03-18

### Added

- **`research-pipeline` agent** — 8-phase autonomous research engine inspired by AutoResearchClaw. Multi-source literature discovery (arxiv, Semantic Scholar, OpenAlex), 4-layer citation verification, hypothesis generation via multi-agent debate, autonomous PIVOT/REFINE/PROCEED decision loops, and knowledge archival with cross-session memory.
- **`security-hardener` agent** — Comprehensive security audit grounded in 734 cybersecurity skills from Anthropic-Cybersecurity-Skills. 7-domain audit: OWASP Top 10 2025, MITRE ATT&CK mapping, NIST CSF 2.0 alignment, secret detection (gitleaks/trufflehog patterns), supply chain audit, container security, and DevSecOps pipeline verification.
- **`decision-loop` agent** — Autonomous PIVOT/REFINE/PROCEED decision maker inspired by AutoResearchClaw Stage 15. Evaluates iteration metrics (grade, delta, velocity, failure rate) and autonomously decides whether to continue, adjust focus, or fundamentally change strategy. Artifact versioning before decisions.
- **`metaclaw-learner` agent** — Cross-run learning system inspired by AutoResearchClaw MetaClaw (+18.3% robustness). Extracts structured lessons from pipeline execution, converts to reusable rules with 30-day time-decay, injects into future runs. 6 lesson categories, confidence scoring, metrics dashboard.

### Changed

- **`self-healer` agent** — Enhanced with AutoResearchClaw's 10-round iterative healing (up from 3), NaN/Infinity fast-fail detection, AST validation before commit, and partial result capture on timeout.
- Plugin version bumped to 4.1.0 (29 agents).

### Sources

- [AutoResearchClaw](https://github.com/aiming-lab/AutoResearchClaw) — 23-stage autonomous research pipeline
- [Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills) — 734 cybersecurity skills, MITRE/NIST/OWASP mapped

## [4.0.0] - 2026-03-18

### Added

- **`/ultra-upgrade` — the ultimate mode.** Combines 16 prompt engineering layers, multi-model judge tribunal (Opus + Sonnet + Haiku), adversarial red-teaming every iteration, Reflexion memory across iterations, Graph of Thought synthesis, persona tribunal (Tech + Human + Meta), Constitutional AI safety checks every 3rd iteration, and convergence monitoring with strategy adjustment. Targets 9.5/10 with up to 12 iterations.
- **`/auto-swarm "task"` — distributed agent orchestration.** Spawns parallel subagent clusters for any task. 5 modes (research, build, audit, fix, explore) with auto-detection. Configurable depth (shallow/medium/deep/ultra), swarm size (max 7), and iterations (max 11). Coverage-based convergence at 85%.
- **`/productupgrade-update` — self-update from GitHub.** Detects installation location, checks for updates, shows changelog, pulls latest, and syncs to all local installations (marketplace, skills, commands).
- **14 new agents:** adversarial-reviewer (red-team, read-only), thought-graph-builder (causal network synthesis), persona-orchestrator (3-persona evaluation), density-summarizer (Chain of Density compression), context-retriever (RAG context gathering), frontend-scraper (Playwright + Lighthouse), vulnerability-explorer (OWASP Top 10), swarm-orchestrator (distributed coordination), guardrails-controller (safety + HITL), test-architect (TDD spec design), performance-profiler (benchmarking), migration-planner (safe migrations), self-healer (auto-fix lint/type/test), convergence-monitor (strategy adjustment).
- **7 prompt engineering layers:** Step-Back Prompting (Zheng 2023), Contrastive CoT (Chia 2023), ReAct (Yao 2022), Cumulative Reasoning (Zhang 2023), Self-Debugging (Chen 2023), LATS (Koh 2024). With README and composition rules.
- **7-layer PROMPT-COMPOSITION.md template** with application matrix showing which layers apply to which agent types.
- **Self-learning PostToolUse hook** (`hooks/self-learn.sh`) that silently captures file modifications, validation results, and agent dispatch patterns to `~/.productupgrade/learned/`.
- **Arxiv scraper** (`scripts/arxiv-scraper.sh`) for extracting prompt engineering papers from arxiv API.
- **Comprehensive gap analysis** (`.productupgrade/RESEARCH-V4-GAP-ANALYSIS.md`) from 6 parallel research agents scanning 42 repos and 50+ arxiv papers.
- **ARCHITECTURE.md** — explains why every design decision was made.
- **CONTRIBUTING.md** — contributor guide with dev workflow, testing checklist, commit conventions.
- **CHANGELOG.md** — this file.
- **TODOS.md** — prioritized backlog with V4.1 roadmap.
- **VERSION file** — semver tracking (4.0.0).
- **SessionStart hook** with ASCII banner showing commands and version.

### Changed

- Plugin version bumped from 1.0.0 to 4.0.0.
- SKILL.md rewritten for V4 with full agent roster, command table, convergence specs.
- CLAUDE.md rewritten with mode comparison table and full architecture diagram.
- plugin.json updated with comprehensive keywords and homepage.

### Removed

- `plugins/productupgrade/` duplicate directory — all files preserved at root level. This was a copy of the root that required manual syncing. The root IS the plugin now.

### Fixed

- 9 agents referenced in V2/V3 CLAUDE.md but never committed are now created with full implementations.
- LICENSE file restored at root level.
- Marketplace structure simplified (single canonical location).

## [3.0.0] - 2026-03-17

### Added

- V3 ASCII banner and marketplace metadata.
- 135K-character prompt architecture branding.
- 8 composable skill files reference.

## [2.1.0] - 2026-03-17

### Added

- Auto-swarm distributed orchestration (design only — command not committed).
- Guardrails controller (design only — agent not committed).
- 7-layer composed prompt architecture (design only — template not committed).

### Known Issues

- 9 V2 agents referenced but not committed.
- auto-swarm.md command not committed.
- PROMPT-COMPOSITION.md template not committed.

## [1.0.0] - 2026-03-17

### Added

- Initial release: 54-agent recursive product improvement pipeline.
- 11 core agents: llm-judge, deep-researcher, code-reviewer, ux-auditor, dynamic-planner, business-logic-validator, dependency-scanner, api-contract-validator, naming-enforcer, refactoring-agent, database-auditor.
- `/productupgrade` command with 6 modes (full, audit, ux, fix, validate, judge).
- 10-dimension evaluation rubric.
- Recursive convergence engine with LLM-as-Judge.
- 22 bundled reference skills.
- 3 shell scripts (competitor scraper, pull source, GUI audit).
