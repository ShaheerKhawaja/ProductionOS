# Changelog

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
