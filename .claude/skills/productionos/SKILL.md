---
name: productionos
description: "ProductionOS 5.2 — 40-agent agentic development OS for Claude Code. 14 commands including nuclear-scale /max-research (500-1000 simultaneous agents), recursive /omni-plan-nth orchestration targeting 10/10, distributed /auto-swarm parallel execution, tri-tiered LLM judge evaluation, 7-layer prompt composition, and cross-run learning."
---

# ProductionOS 5.2 — Agentic Development Operating System

ProductionOS transforms Claude Code into a full development operating system. It deploys 40 specialized AI agents across 14 commands to research, build, audit, fix, and ship code at scale — targeting 10/10 quality across every dimension through recursive convergence loops.

## What It Does

ProductionOS is a Claude Code plugin that adds multi-agent orchestration to your development workflow. Instead of working with a single AI assistant, you deploy coordinated agent swarms that research topics exhaustively, audit codebases systematically, and fix issues in parallel — then evaluate results through a tri-tiered judge panel until quality converges at 10/10.

**Core capabilities:**
- Deploy 500-1000 research agents simultaneously with `/max-research`
- Run recursive quality loops until every dimension hits 10/10 with `/omni-plan-nth`
- Distribute work across 7 parallel agents per wave with `/auto-swarm`
- Evaluate code through 3 independent judge perspectives (correctness, completeness, adversarial)
- Compose agent prompts using 7 proven reasoning layers (Emotion, Meta, CoT, ToT, GoT, CoD, Context)

## Commands (14)

### Orchestrative (recursive, nth-iteration)
| Command | What It Does | Scale |
|---------|-------------|-------|
| `/omni-plan-nth` | Chains ALL skills and agents, loops until 10/10 on every dimension | Up to 420 agents |
| `/auto-swarm-nth` | Recursive parallel swarm until 100% coverage AND 10/10 quality | Up to 140 agents |

### Pipeline (structured, single-pass with convergence)
| Command | What It Does | Scale |
|---------|-------------|-------|
| `/omni-plan` | 13-step pipeline with tri-tiered judging | 14 agents/phase |
| `/auto-swarm "task"` | Distributed agent swarm for any task | 7-77 agents |
| `/production-upgrade` | Recursive product audit across all dimensions | Up to 49 agents |

### Nuclear Scale
| Command | What It Does | Scale |
|---------|-------------|-------|
| `/max-research` | ALL agents deployed in ONE massive simultaneous wave | 500-1000 agents |

### Specialized
| Command | What It Does |
|---------|-------------|
| `/deep-research` | 8-phase autonomous research with citation verification |
| `/agentic-eval` | CLEAR v2.0 framework evaluation (6 domains, 8 dimensions) |
| `/security-audit` | 7-domain audit: OWASP, MITRE ATT&CK, NIST CSF 2.0 |
| `/context-engineer` | Token-optimized context packaging for downstream agents |
| `/logic-mode` | Business idea to production-ready plan pipeline |
| `/learn-mode` | Interactive code tutor for any codebase |
| `/productionos-update` | Self-update from GitHub |
| `/productionos-help` | Usage guide and recommended workflows |

## Agent Roster (40 agents)

**Core (11):** llm-judge, deep-researcher, code-reviewer, ux-auditor, dynamic-planner, business-logic-validator, dependency-scanner, api-contract-validator, naming-enforcer, refactoring-agent, database-auditor

**Advanced (9):** adversarial-reviewer, thought-graph-builder, persona-orchestrator, density-summarizer, context-retriever, frontend-scraper, vulnerability-explorer, swarm-orchestrator, guardrails-controller

**V4+ (9):** test-architect, performance-profiler, migration-planner, self-healer, convergence-monitor, decision-loop, metaclaw-learner, research-pipeline, security-hardener

**V5.1 (6):** gitops, frontend-designer, asset-generator, comms-assistant, comparative-analyzer, reverse-engineer

**V5.2 (5):** debate-tribunal, ecosystem-scanner, gap-analyzer, recursive-orchestrator, verification-gate

## Integrated Skills (loaded from other plugins — NOT bundled)

`/plan-ceo-review`, `/plan-eng-review`, `/code-review`, `/browse`, `/qa`, `/ship`, `/brainstorming`, `/writing-plans`, `/test-driven-development`, `/systematic-debugging`, `/dispatching-parallel-agents`

## Output Directory

All pipeline outputs go to `.productionos/` in the target project. Artifacts are tracked across commands for consumption by downstream pipelines.

## Installation

```bash
git clone https://github.com/ShaheerKhawaja/ProductionOS.git \
  ~/.claude/plugins/marketplaces/productupgrade
mkdir -p ~/.claude/skills/productionos
cp ~/.claude/plugins/marketplaces/productupgrade/.claude/skills/productionos/SKILL.md \
  ~/.claude/skills/productionos/SKILL.md
for cmd in ~/.claude/plugins/marketplaces/productupgrade/.claude/commands/*.md; do
  cp "$cmd" ~/.claude/commands/$(basename "$cmd")
done
```

## Validation

```bash
cd ~/.claude/plugins/marketplaces/productupgrade
bun run skill:check    # 10/10
bun run validate       # 40/40 agents
bun test               # 60 tests pass
```
