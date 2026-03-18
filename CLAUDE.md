# ProductUpgrade V2.1 — Autonomous Self-Learning Pipeline + Swarm Intelligence

AI-powered product upgrade pipeline: 20 agents, 2 commands, 4 execution modes, distributed swarm orchestration, adaptive research depth (10-10,000 sources), and absolute guardrails with human-in-the-loop safety. Takes any codebase — or any IDEA — from current state to production-ready.

## Commands

```
/productupgrade              # Auto mode: smart agent selection, parallel
/productupgrade standard     # Proven 6-phase pipeline, target 8.0
/productupgrade deep         # Autonomous self-learning, 7 loops, target 10.0
/productupgrade audit        # Discovery + evaluation only
/productupgrade fix          # Execute fixes from previous audit
/productupgrade validate     # Validate recent changes
/productupgrade judge        # LLM-as-Judge evaluation only

/auto-swarm                  # Distributed agent swarm for any task
/auto-swarm "task" --depth ultra --swarm_size 7 --iterations 11
```

## Plugin Structure

```
productupgrade/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest (v2.1.0)
│   └── marketplace.json         # Marketplace listing
├── .claude/
│   ├── skills/
│   │   └── productupgrade/
│   │       └── SKILL.md          # Core skill definition
│   └── commands/
│       ├── productupgrade.md     # /productupgrade (3-mode + sub-modes)
│       └── auto-swarm.md         # /auto-swarm (distributed swarm orchestrator)
├── agents/                       # 20 agent definitions
│   ├── llm-judge.md             # Independent quality evaluator (Opus, read-only)
│   ├── deep-researcher.md       # Techstack/competitor/library researcher (Opus)
│   ├── code-reviewer.md         # Systematic code review with confidence scoring
│   ├── ux-auditor.md            # UX/UI audit with a11y and competitor comparison
│   ├── dynamic-planner.md       # Finding synthesis + prioritized batch planning
│   ├── business-logic-validator.md  # Business rule validation
│   ├── dependency-scanner.md    # CVE/license/abandonment scanning
│   ├── api-contract-validator.md # Frontend↔Backend contract validation
│   ├── naming-enforcer.md       # Cross-layer naming convention audit
│   ├── refactoring-agent.md     # Dead code, complexity, duplication
│   ├── database-auditor.md      # Schema, query, migration audit
│   ├── adversarial-reviewer.md  # V2: Red-team agent (hostile, read-only)
│   ├── thought-graph-builder.md # V2: Graph of Thought aggregation
│   ├── persona-orchestrator.md  # V2: 3-persona evaluation (Tech/Human/Meta)
│   ├── density-summarizer.md    # V2: Chain of Density inter-iteration summaries
│   ├── context-retriever.md     # V2: RAG-in-pipeline context management
│   ├── frontend-scraper.md      # V2: Playwright screenshot + Lighthouse capture
│   ├── vulnerability-explorer.md # V2: OWASP Top 10 + attack surface mapping
│   ├── swarm-orchestrator.md    # V2.1: Distributed swarm coordination
│   └── guardrails-controller.md # V2.1: Safety + human-in-the-loop enforcement
├── skills-bundle/               # 22 bundled reference skills
├── scripts/
│   ├── scrape-competitor.sh     # Playwright competitor UX scraper
│   ├── pull-source.sh           # Git clone + repo analysis
│   └── gui-audit.sh             # Screenshots + Lighthouse + a11y
├── templates/
│   ├── RUBRIC.md                # 10-dimension evaluation rubric
│   └── PROMPT-COMPOSITION.md    # 7-layer composed prompt template
├── .productupgrade/
│   └── DESIGN-SPEC-V2.md       # V2 architecture specification
├── CLAUDE.md                    # This file
└── README.md
```

## Idea-to-Production Pipeline

The combination of `/productupgrade deep` + `/auto-swarm` creates an end-to-end pipeline:

```
IDEA → Research (auto-swarm, 10K sources) → Architecture (plan-ceo + plan-eng)
     → Implementation Plan (dynamic-planner) → Code (execution swarms)
     → Review (adversarial + persona evaluation) → QA (frontend scraping + tests)
     → Polish (iterative convergence → 10/10) → Production Ready
```

## Guardrails (Non-Negotiable)

### Human-in-the-Loop Checkpoints
- Pre-launch approval for autonomous operations
- Pre-commit diff review (unless --auto-commit)
- Pre-push ALWAYS requires approval
- Security-critical changes ALWAYS flagged
- Iteration 3 and 5 checkpoints in deep mode
- Cost threshold ($5 / 500K tokens) triggers pause

### Safety Boundaries
- Protected files: .env, keys, certs, production configs
- Max 15 files per batch, 200 lines per file
- Automatic rollback on test failure or score regression
- Scope enforcement: agents cannot modify outside their focus area
- Emergency stop halts all agents when limits exceeded

### Cost Budgets
- Session: 2M tokens, 100 agents, 500 web fetches
- Per iteration: 400K tokens, 14 agents
- Per swarm agent: 100K tokens, 50 web fetches

## Prompting Architecture

Every agent in deep/swarm mode receives 7-layer composed prompts:
1. **Emotion Prompting** — Sets stakes (+8-15% accuracy, Li et al. 2023)
2. **Meta-Prompting** — Forces reflection before action
3. **Context Retrieval** — RAG from memory + context7 + artifacts
4. **Chain of Thought** — Step-by-step reasoning chains
5. **Tree of Thought** — 3-branch exploration with scoring
6. **Graph of Thought** — Finding network with edge detection
7. **Chain of Density** — 3-pass compression for inter-iteration handoff

## Research Depth Scaling

```
shallow:  10 sources/query, 30 total  — local codebase only
medium:   50 sources/query, 250 total — + library docs + memory
deep:     500 sources/query, 5K total — + web + competitors + papers
ultra:    2000 sources/query, 10K total — + sub-swarms for sub-topics
```

## Attribution

Bundles and extends:
- [superpowers](https://github.com/anthropics/claude-code) — Anthropic's core skills
- [gstack](https://github.com/garry-tan/gstack) — Garry Tan's skill suite
- [everything-claude-code](https://github.com/anthropics/everything-claude-code) — 146+ skills
- [agents](https://github.com/wshobson/agents) — 72 plugins, 112 agents
- [Fabric](https://github.com/danielmiessler/fabric) — 252 AI patterns
- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide) — DAIR.AI
- Research: Self-Refine (Madaan 2023), Reflexion (Shinn 2023), GoT (Besta 2024), EmotionPrompt (Li 2023), CoD (Adams 2023), Constitutional AI (Bai 2022)
