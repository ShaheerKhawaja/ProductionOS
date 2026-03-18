# ProductUpgrade V4.0 — Ultimate Product Improvement Engine

25-agent recursive product upgrade pipeline with 4 commands, 7-layer prompt composition, multi-model judge tribunal, adversarial red-teaming, Reflexion memory, and convergence-driven self-improvement.

## Commands

```
/productupgrade              # Basic recursive audit (gstack + superpowers)
/productupgrade audit        # Audit-only (no code changes)
/productupgrade ux           # UX focused + competitor scraping
/productupgrade fix          # Execute fixes from previous audit
/productupgrade validate     # Validate recent changes
/productupgrade judge        # LLM-as-Judge evaluation only

/auto-swarm "task"           # Distributed agent swarm for any task
/auto-swarm "task" --depth ultra --swarm_size 7 --iterations 11

/ultra-upgrade               # THE ULTIMATE — all techniques combined
/ultra-upgrade --focus security,performance

/productupgrade-update       # Self-update from GitHub
```

## Architecture

```
productupgrade/
├── .claude-plugin/
│   ├── plugin.json              # V4.0.0 manifest
│   └── marketplace.json         # Marketplace listing
├── .claude/
│   ├── skills/productupgrade/SKILL.md
│   └── commands/
│       ├── productupgrade.md        # Basic recursive audit
│       ├── auto-swarm.md            # Distributed swarm orchestrator
│       ├── ultra-upgrade.md         # THE ULTIMATE mode
│       └── productupgrade-update.md # Self-update
├── agents/                      # 25 agent definitions
│   ├── llm-judge.md             # Independent quality evaluator (Opus, read-only)
│   ├── deep-researcher.md       # Multi-source researcher (Opus)
│   ├── code-reviewer.md         # Systematic code review
│   ├── ux-auditor.md            # UX/UI + a11y audit
│   ├── dynamic-planner.md       # Planning orchestrator
│   ├── business-logic-validator.md
│   ├── dependency-scanner.md
│   ├── api-contract-validator.md
│   ├── naming-enforcer.md
│   ├── refactoring-agent.md
│   ├── database-auditor.md
│   ├── adversarial-reviewer.md  # Red-team (read-only)
│   ├── thought-graph-builder.md # Graph of Thought synthesis
│   ├── persona-orchestrator.md  # 3-persona evaluation
│   ├── density-summarizer.md    # Chain of Density compression
│   ├── context-retriever.md     # RAG context management
│   ├── frontend-scraper.md      # Playwright + Lighthouse
│   ├── vulnerability-explorer.md # OWASP Top 10
│   ├── swarm-orchestrator.md    # Distributed coordination
│   ├── guardrails-controller.md # Safety enforcement
│   ├── test-architect.md        # TDD spec designer
│   ├── performance-profiler.md  # Performance benchmarking
│   ├── migration-planner.md     # Migration safety
│   ├── self-healer.md           # Auto-fix lint/type/test
│   └── convergence-monitor.md   # Convergence strategy
├── templates/
│   ├── RUBRIC.md                # 10-dimension evaluation rubric
│   ├── PROMPT-COMPOSITION.md    # 7-layer composed prompt
│   └── CONVERGENCE-LOG.md       # Convergence tracking
├── hooks/
│   └── hooks.json               # SessionStart banner
├── skills-bundle/               # 22 bundled reference skills
├── scripts/
│   ├── scrape-competitor.sh     # Playwright competitor scraper
│   ├── pull-source.sh           # Git clone + analysis
│   └── gui-audit.sh             # Screenshots + Lighthouse
├── CLAUDE.md                    # This file
├── README.md
├── VERSION                      # 4.0.0
└── CHANGELOG.md

```

## Mode Comparison

| Feature | /productupgrade | /auto-swarm | /ultra-upgrade |
|---------|-----------------|-------------|----------------|
| Purpose | Recursive code audit | Any task orchestration | Maximum everything |
| Agents/phase | 7 | 7/wave | 14 |
| Max iterations | 7 | 11 | 12 |
| Judge type | Single LLM | Coverage-based | 3-model tribunal |
| Prompt layers | Basic CoT | Task-specific | All 7 layers |
| Adversarial | No | No | Every iteration |
| Reflexion | No | No | Cross-iteration |
| Research depth | Local scan | Configurable | Ultra (2000+) |
| Target grade | 8.0/10 | 85% coverage | 9.5/10 |
| Thought graph | No | No | Causal network |
| Persona eval | No | No | Tech+Human+Meta |
| Self-healing | Basic | No | Full |
| Safety checks | Lint gate | Budget limits | Constitutional AI |

## Prompting Architecture

Every agent in ultra/swarm-deep mode receives 7-layer composed prompts:
1. **Emotion Prompting** — Calibrated stakes (+8-15% accuracy, Li et al. 2023)
2. **Meta-Prompting** — Forces reflection before action
3. **Context Retrieval** — RAG from memory + context7 + artifacts
4. **Chain of Thought** — Step-by-step reasoning chains
5. **Tree of Thought** — 3-branch exploration with scoring
6. **Graph of Thought** — Finding network with edge detection
7. **Chain of Density** — 3-pass compression for inter-iteration handoff

## Guardrails (Non-Negotiable)

### Human-in-the-Loop Checkpoints
- Pre-launch approval for autonomous operations
- Pre-commit diff review (unless --auto-commit)
- Pre-push ALWAYS requires approval
- Security-critical changes ALWAYS flagged
- Ultra mode: checkpoints at iterations 3, 6, 9, 12
- Cost threshold ($10 / 1M tokens) triggers pause

### Safety Boundaries
- Protected files: .env, keys, certs, production configs
- Max 15 files per batch, 200 lines per file
- Automatic rollback on test failure or score regression
- Scope enforcement: agents cannot modify outside their focus area
- Emergency stop halts all agents when limits exceeded

### Cost Budgets
| Mode | Session Tokens | Agents | Web Fetches |
|------|---------------|--------|-------------|
| /productupgrade | 2M | 100 | 500 |
| /auto-swarm | 2M | 77 | configurable |
| /ultra-upgrade | 4M | 168 | 1000 |

## Attribution

Built on and extends:
- [superpowers](https://github.com/anthropics/claude-code) — Anthropic's core skills
- [gstack](https://github.com/garry-tan/gstack) — Garry Tan's skill suite
- [everything-claude-code](https://github.com/shobrook/everything-claude-code) — 146+ skills
- [agents](https://github.com/wshobson/agents) — 72 plugins, 112 agents
- [get-shit-done](https://github.com/gsd-framework) — Wave-based parallel execution
- [Fabric](https://github.com/danielmiessler/fabric) — 252 AI patterns
- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide) — DAIR.AI
- Research: Self-Refine (Madaan 2023), Reflexion (Shinn 2023), GoT (Besta 2024), EmotionPrompt (Li 2023), CoD (Adams 2023), Constitutional AI (Bai 2022), LLM-as-Judge (Zheng 2023)
