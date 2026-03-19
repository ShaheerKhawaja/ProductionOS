# ProductionOS -- Agentic Development Operating System

40-agent development OS with 14 commands for Claude Code. Nuclear-scale research, recursive orchestration, multi-agent swarms, and tri-tiered quality evaluation -- all targeting 10/10.

## Installation

```bash
# Via Claude Code plugin marketplace
claude plugin install productupgrade

# Or manual clone
git clone https://github.com/ShaheerKhawaja/productupgrade.git ~/.claude/plugins/marketplaces/productupgrade
cd ~/.claude/plugins/marketplaces/productupgrade && bun install
```

## Quick Start

```
/production-upgrade          Audit any codebase with recursive convergence
/omni-plan                   Full 13-step pipeline with tri-tiered judging
/auto-swarm "task"           Distributed agent swarm for any task
```

## Commands (14)

### Orchestrative -- recursive, nth-iteration

| Command | Description | Agent Scale |
|---------|-------------|-------------|
| `/omni-plan-nth [target]` | Recursive orchestration -- chains ALL skills, loops until 10/10 | 21/iter, max 420 |
| `/auto-swarm-nth "task"` | Recursive swarm -- 100% coverage, 10/10 quality per item | 7/wave, max 140 |

### Pipeline -- structured, single-pass with convergence

| Command | Description | Agent Scale |
|---------|-------------|-------------|
| `/omni-plan [target]` | 13-step pipeline with tri-tiered judging | 14/phase |
| `/auto-swarm "task" [--depth]` | Distributed agent swarm (shallow, medium, deep, ultra) | 7/wave, max 77 |
| `/production-upgrade [mode]` | Recursive product audit (full, audit, ux, fix, validate, judge) | 7/phase, max 49 |

### Nuclear Scale

| Command | Description | Agent Scale |
|---------|-------------|-------------|
| `/max-research [topic]` | 500-1000 agents in ONE massive wave -- exhaustive research | 500-1000 (single wave) |

### Specialized

| Command | Description |
|---------|-------------|
| `/deep-research [topic]` | 8-phase autonomous research pipeline |
| `/agentic-eval [target]` | CLEAR v2.0 framework evaluation |
| `/security-audit [target]` | 7-domain OWASP/MITRE/NIST security audit |
| `/context-engineer [target]` | Token-optimized context packaging |
| `/logic-mode [idea]` | Business idea validation pipeline |
| `/learn-mode [topic]` | Interactive code tutor |
| `/productionos-update` | Self-update from GitHub |

## Agents (40)

| Category | Count | Agents |
|----------|-------|--------|
| Core | 11 | llm-judge, deep-researcher, code-reviewer, ux-auditor, dynamic-planner, business-logic-validator, dependency-scanner, api-contract-validator, naming-enforcer, refactoring-agent, database-auditor |
| Advanced | 9 | adversarial-reviewer, thought-graph-builder, persona-orchestrator, density-summarizer, context-retriever, frontend-scraper, vulnerability-explorer, swarm-orchestrator, guardrails-controller |
| V4+ | 9 | test-architect, performance-profiler, migration-planner, self-healer, convergence-monitor, decision-loop, metaclaw-learner, research-pipeline, security-hardener |
| V5.1 | 6 | gitops, frontend-designer, asset-generator, comms-assistant, comparative-analyzer, reverse-engineer |
| V5.2 | 5 | debate-tribunal, ecosystem-scanner, gap-analyzer, recursive-orchestrator, verification-gate |

Agents are loaded on-demand from `agents/`. Commands only read agent files when referenced during execution -- no preloading.

## Orchestration Hierarchy

```
/omni-plan-nth (TOP LEVEL -- invokes any command, loops until 10/10)
    |
    +-- /omni-plan (13-step pipeline per iteration)
    |   +-- /deep-research (Step 1)
    |   +-- /agentic-eval (Step 6)
    |   +-- /auto-swarm-nth (Step 9 -- execution engine)
    |   +-- /ship (Step 13, external)
    |
    +-- /auto-swarm-nth (parallel execution, recursive quality gates)
    |
    +-- /max-research (NUCLEAR -- 500-1000 agents, single massive wave)
    |
    +-- /production-upgrade (structured audit)
    +-- /deep-research (topic research)
    +-- /security-audit (security-focused audit)
    +-- /agentic-eval (quality evaluation)
```

## Features

**7-Layer Prompt Composition** -- agents in deep/ultra mode receive layered prompts:

1. Emotion Prompting -- stakes calibrated to severity
2. Meta-Prompting -- self-reflection before action
3. Context Retrieval -- RAG from memory and context7
4. Chain of Thought -- step-by-step reasoning
5. Tree of Thought -- 3-branch exploration with scoring
6. Graph of Thought -- finding network with edge detection
7. Chain of Density -- compression for inter-iteration handoff

**Tri-Tiered Evaluation** -- three independent judges score every output:

- Judge 1 (correctness) -- factual accuracy, code validity
- Judge 2 (practicality) -- real-world applicability, maintainability
- Judge 3 (adversarial) -- attack surface, edge cases, failure modes

**Recursive Convergence** -- commands loop with PIVOT/REFINE/PROCEED decisions until target scores are met. Regression protection rolls back any dimension drop greater than 0.5.

**Guardrails** -- pre-commit diff review, pre-push approval, protected files (.env, keys, certs), max 15 files/batch, automatic rollback on test failure or score regression.

## Output

All pipeline artifacts go to `.productionos/` in the target project. Artifacts are tracked via manifest for cross-command consumption.

## Validation

```bash
bun run skill:check        # 10-check health dashboard
bun run validate           # Agent frontmatter validation (40/40)
bun run audit:context      # Token budget tracking
bun run dashboard          # Review readiness dashboard
bun test                   # Automated test suite
```

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- [Bun](https://bun.sh) >= 1.0.0 (for TypeScript infrastructure scripts)

## Version

5.2.0

## License

MIT
