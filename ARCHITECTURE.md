# Architecture

This document explains **why** ProductUpgrade is built the way it is. For setup and commands, see CLAUDE.md. For contributing, see CONTRIBUTING.md.

## The core idea

ProductUpgrade gives Claude Code a recursive self-improvement engine. Most code review tools run once and produce a report. ProductUpgrade runs in a **convergence loop** — it audits, fixes, re-evaluates, and repeats until the codebase reaches a target quality grade.

The key insight: a single review pass catches ~60% of issues. A second pass catches another ~20%. By the third pass, you're finding systemic patterns that no single-pass tool ever surfaces. The recursive loop is the product.

```
Codebase (grade: 4.2)
        │
        ▼
  ┌─────────────────────────────────────────────────────┐
  │  CONVERGENCE LOOP                                    │
  │                                                     │
  │  DISCOVER → REVIEW → PLAN → EXECUTE → VALIDATE      │
  │       ▲                                    │         │
  │       │         JUDGE (independent)        │         │
  │       │              │                     │         │
  │       │         grade >= target? ──YES──► EXIT       │
  │       │              │                               │
  │       └──────── NO (feed gaps back) ─────────────┘   │
  └─────────────────────────────────────────────────────┘
        │
        ▼
Codebase (grade: 8.1)
```

## Why three commands

ProductUpgrade solves three distinct problems:

### `/productupgrade` — "Make this codebase better"
A structured 6-phase pipeline using proven skills (gstack, superpowers). Targets 8.0/10. The workhorse for any codebase audit. Uses 7 agents per phase, single LLM judge, basic CoT reasoning.

### `/auto-swarm` — "Throw agents at this task"
Not all tasks fit a code quality pipeline. Research, exploration, large-scale refactoring — these need flexible agent orchestration. Auto-swarm decomposes any task into 7 independent subtasks, dispatches parallel agents, and converges on coverage.

### `/ultra-upgrade` — "Maximum everything"
When you need the absolute best result regardless of cost. Multi-model judge tribunal (Opus + Sonnet + Haiku), adversarial red-teaming every iteration, Reflexion memory across iterations, 16 prompt engineering layers, Graph of Thought synthesis, Constitutional AI safety checks. Targets 9.5/10 with up to 12 iterations.

The commands exist on a spectrum of cost vs. thoroughness:

```
Cost:     $2-5          $5-15         $15-50
          /productupgrade  /auto-swarm  /ultra-upgrade
Quality:  8.0/10        85% coverage  9.5/10
Time:     30-60 min     30-90 min     1-3 hours
```

## Agent architecture

### Why 25 agents instead of 1 big prompt

A single prompt that covers security, UX, performance, naming, accessibility, database design, API contracts, business logic, and deployment safety would be 50K+ tokens of instructions. The model would attend to all of them weakly instead of any of them strongly.

Each agent has one job, one rubric, and a focused set of tools. The `llm-judge` can only Read (never Edit). The `self-healer` can Edit (but only lint/type errors). The `adversarial-reviewer` thinks like an attacker. The `persona-orchestrator` evaluates from three perspectives simultaneously.

### Agent independence

The critical design rule: **agents that evaluate must never modify code, and agents that modify code must never evaluate themselves.**

```
EVALUATORS (read-only):           EXECUTORS (read-write):
  llm-judge                         refactoring-agent
  adversarial-reviewer               self-healer
  persona-orchestrator
  convergence-monitor

PLANNERS (read + write artifacts):
  dynamic-planner
  thought-graph-builder
  density-summarizer
```

This prevents the fox-guarding-henhouse problem where a fix agent reports its own fix as successful.

### Why Opus for judges and researchers

Model assignment follows the principle: **reasoning quality matters most where errors compound.**

- A wrong judge score propagates through the convergence loop and can add 2-3 unnecessary iterations ($10-20 wasted)
- A missed research finding means the pipeline optimizes in the wrong direction
- A slightly imperfect code fix gets caught by the validation gate anyway

So judges and researchers get Opus (highest reasoning). Executors use the session's default model. This optimizes the cost/quality tradeoff.

## The 7-layer prompt composition

Every technique in the prompt composition has published research showing measurable accuracy improvement. They're not decorative — each layer addresses a specific failure mode:

| Layer | Addresses | Research |
|-------|-----------|----------|
| Emotion Prompting | Low effort/accuracy on "boring" tasks | Li 2023: +8-15% accuracy |
| Meta-Prompting | Premature conclusions | Forces reflection before action |
| Context Retrieval | Hallucinated assumptions | Grounds in actual docs/history |
| Chain of Thought | Skipped reasoning steps | Wei 2022: +20-30% on complex |
| Tree of Thought | Single-path fixation | Yao 2023: +70% on planning |
| Graph of Thought | Missed systemic connections | Besta 2024: +51% on synthesis |
| Chain of Density | Context rot across iterations | Adams 2023: 3x compression |

Layers are applied selectively via the application matrix in `templates/PROMPT-COMPOSITION.md`. Not every agent gets every layer — review agents don't need Tree of Thought, execution agents don't need Graph of Thought.

## Convergence engine

### Why convergence, not iteration count

A fixed iteration count (e.g., "always run 5 iterations") wastes money on codebases that converge at iteration 3 and underserves codebases that need 7. The convergence engine stops when improvement plateaus:

```
SUCCESS:    grade >= target (8.0 for basic, 9.5 for ultra)
CONVERGED:  delta < threshold (0.2 for basic, 0.15 for ultra) for 2 iterations
DEGRADED:   any dimension dropped > 0.5 → HALT + rollback
MAX:        iteration >= limit (7 for basic, 12 for ultra)
```

### Why focus narrowing

After each iteration, the judge identifies the 2 lowest-scoring dimensions. The next iteration focuses exclusively on those. Without this, the pipeline thrashes — fixing security breaks performance, fixing performance breaks error handling, etc.

Focus narrowing creates a monotonic improvement trajectory:

```
Iteration 1: All 10 dimensions → identifies weak spots
Iteration 2: Focus on Tests + Security → those improve
Iteration 3: Focus on Performance + Accessibility → those improve
...
```

### Why the judge is independent

The judge runs as a separate agent with read-only access. It reads the actual codebase, not agent self-reports. It uses sequential-thinking MCP for structured reasoning. Without this independence, fix agents would always report success (measuring your own homework is not measurement).

## Self-learning system

The `hooks/self-learn.sh` PostToolUse hook silently captures:
- Which files are modified most (churn hotspots)
- Which validation commands fail (recurring issues)
- Which agent dispatches happen (workflow patterns)

This data accumulates in `~/.productupgrade/learned/` as JSONL. Every 50 events, patterns are extracted into a summary. This gives future sessions historical context without explicit memory management.

## What's intentionally not here

- **No MCP server.** ProductUpgrade orchestrates existing tools; it doesn't need to be one. The complexity of maintaining an MCP server would outweigh the benefit.
- **No GUI/dashboard.** The output is Markdown files in `.productupgrade/`. Any Markdown viewer works.
- **No cloud backend.** Everything runs locally in Claude Code sessions. No data leaves the machine.
- **No plugin dependencies at runtime.** The 22 bundled skills mean ProductUpgrade works without any other plugins installed. It references gstack and superpowers skills when available, falls back gracefully.
- **No Windows/Linux-specific tooling.** The scripts assume macOS (Playwright, Lighthouse). Cross-platform support would triple the maintenance surface.

## File layout rationale

```
productupgrade/
├── agents/          ← One file per agent. Agents are the product.
├── prompts/         ← Composable prompt layers. Research-backed.
├── templates/       ← Shared artifacts (rubric, convergence log).
├── hooks/           ← SessionStart + PostToolUse self-learning.
├── scripts/         ← Shell scripts for browser/scraping automation.
├── skills-bundle/   ← 22 bundled skills for self-contained operation.
├── .claude/         ← Skills + commands (Claude Code convention).
├── .productupgrade/ ← Research artifacts, design docs.
├── ARCHITECTURE.md  ← This file (why decisions were made).
├── CONTRIBUTING.md  ← How to contribute.
├── CHANGELOG.md     ← What changed per version.
├── CLAUDE.md        ← How to use (commands, modes, config).
└── TODOS.md         ← Prioritized backlog.
```
