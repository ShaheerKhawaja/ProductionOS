# ProductionOS V5.1 — Session Handoff

**Copy this entire prompt into a new Claude Code session to continue work.**

---

## Context

You are continuing work on **ProductionOS V5.1** (formerly ProductUpgrade) — an agentic development operating system built as a Claude Code plugin. The repo is at `~/productupgrade/` on the `v4.0.0` branch, pushed to GitHub at `ShaheerKhawaja/productupgrade`.

### What Exists Now (V5.1.0, commit 466c391)

**10 commands:**
`/omni-plan` (flagship 13-step pipeline), `/auto-swarm`, `/production-upgrade`, `/deep-research`, `/agentic-eval`, `/security-audit`, `/context-engineer`, `/logic-mode`, `/learn-mode`, `/productionos-update`

**29 agents** across: code review, security, research, orchestration, self-improvement

**TypeScript infrastructure (NEW in V5.1):**
- `package.json` with Bun scripts (`build`, `gen:skill-docs`, `skill:check`, `test`)
- `scripts/gen-skill-docs.ts` — validates version/agent/command consistency, catches drift
- `scripts/skill-check.ts` — 47-check health dashboard (all pass)
- `tests/skill-validation.test.ts` — 11 Tier 1 tests, 117 assertions, 23ms
- `tsconfig.json` for strict TypeScript

**Context orchestration (NEW in V5.1):**
- `hooks/context-orchestrator.sh` — workspace-aware SessionStart hook that detects project type and suppresses irrelevant plugin injection
- `.claude/settings.local.json` — disables 23 irrelevant plugins at project level (Vercel, Firebase, LSPs, etc.)
- `VERCEL_PLUGIN_LEXICAL_PROMPT=0` — prevents Vercel's keyword matching from triggering on command templates
- Solved a critical 529 `overloaded_error` caused by 36 plugins stacking ~115K+ tokens of context per prompt

**Other infrastructure:**
- 16 prompt engineering layers (CoT, ToT, GoT, CoD, ReAct, LATS, Self-Debugging, etc.)
- Tri-tiered evaluation (Judge 1: Correctness/Opus, Judge 2: Practicality/Sonnet, Judge 3: Adversarial/Opus)
- Self-learning hook (PostToolUse → `~/.productionos/learned/`)
- MetaClaw cross-run learning with 30-day time-decay
- ARCHITECTURE.md, CONTRIBUTING.md, CHANGELOG.md, TODOS.md
- CEO + Engineering reviews (`.productupgrade/REVIEW-CEO.md`, `REVIEW-ENGINEERING.md`)

### What Was Done This Session (V5.0 → V5.1)

1. **Diagnosed and fixed 529 overloaded_error** — root cause was 36 enabled plugins stacking context. Vercel plugin's lexical matching triggered on keywords inside the `/omni-plan` command template, injecting 6 irrelevant skills per prompt.
2. **Built context orchestrator** — `hooks/context-orchestrator.sh` detects workspace type, sets env vars to suppress heavy plugins, manages a `PRODUCTIONOS_CONTEXT_PROFILE`.
3. **Added TypeScript infrastructure** — package.json, tsconfig.json, gen-skill-docs.ts, skill-check.ts, Tier 1 test suite. All modeled on gstack's patterns.
4. **Fixed version drift** — VERSION, plugin.json, marketplace.json, SKILL.md were all showing different versions (1.0/4.0/5.0) and agent counts (25/32/54). Unified to 5.1.0 / 29 agents.
5. **Enriched commands** — production-upgrade.md (fixed 54→29 agents, .productupgrade→.productionos paths, added self-enrichment), auto-swarm.md (path fixes), productionos-update.md (full rebrand), omni-plan.md (restored full pipeline + lazy loading preamble).
6. **Created OMNI-PIPELINE.md** — extended phase protocol supplement in templates/.

### Audit Results (gap score 7.4/10 vs gstack)

| Gap | Severity | Status |
|-----|----------|--------|
| No package.json / build system | 10/10 | FIXED |
| Zero TypeScript | 10/10 | FIXED (starter) |
| No template generation pipeline | 9/10 | PARTIAL (gen-skill-docs validates but doesn't generate from .tmpl) |
| No test suite | 9/10 | FIXED (Tier 1 done, Tier 2/3 pending) |
| Version drift across files | 8/10 | FIXED |
| No skill health dashboard | 8/10 | FIXED (skill-check.ts) |
| No CI pipeline | 8/10 | OPEN |
| No compiled browse binary | 7/10 | OPEN |
| No version auto-nag | 7/10 | OPEN |
| No eval store | 7/10 | OPEN |
| Shell hooks (.sh) not .mjs | 4/10 | OPEN |

### What Needs To Be Done Next

**Priority 1 — Complete TypeScript infrastructure:**
1. **CI pipeline** — `.github/workflows/skill-docs.yml` that runs `bun run gen:skill-docs --dry-run` and `bun test` on push/PR
2. **SKILL.md.tmpl template system** — single source of truth for SKILL.md generation (like gstack's template → build → CI freshness check)
3. **Tier 2 E2E tests** — `tests/skill-e2e.test.ts` using `claude -p` to test actual command execution
4. **Tier 3 LLM-as-judge evals** — `tests/skill-llm-eval.test.ts` for quality assessment
5. **Convert context-orchestrator.sh → .mjs** — proper TypeScript hook with type safety

**Priority 2 — 8-repo deep analysis (carried forward):**
Analyze these repos and extract patterns for ProductionOS:
- `~/repos/awesome-claude-code` — plugin/skill index
- `~/repos/get-shit-done` — wave-based parallel execution OS
- `~/repos/InsForge` — AI BaaS with DB, auth, storage
- `~/repos/everything-claude-code` — 146+ skills, 18 agents
- `~/repos/openrag` — RAG framework (for context engineering)
- `~/repos/superpowers` — 14 core workflow skills
- `~/repos/ai-coding-primer` — full-stack AI dev guide
- `~/repos/claude-code-router` — multi-model routing proxy

**Priority 3 — Native Claude Code orchestration:**
Integrate TaskTool/TeammateTool primitives from the Klaassen gist (`kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea`):
- Team spawning with inbox messaging
- Task dependencies with automatic unblocking
- Spawn backends (in-process, tmux, iTerm2)

**Priority 4 — Fixes from reviews:**
- CEO review: Add `/quick` mode, fix first-time user overwhelm, add runtime cost tracking
- Eng review: Remove Bash from read-only agents, define tribunal debate protocol, add git state check, session locking

**Priority 5 — Remaining infra:**
- GitHub repo rename: `productupgrade` → `productionos`
- Compiled browse binary (own Playwright tooling)
- Version auto-nag system (gstack pattern)
- Eval store for tracking quality across sessions
- Extended discovery phase for unclear prompts

### Key Reference Documents

- Memory: `~/.claude/projects/-Users-muhammadshaheerkhawaja/memory/project_productionos_v5.md`
- Gap analysis: `~/productupgrade/.productupgrade/RESEARCH-V4-GAP-ANALYSIS.md`
- CEO review: `~/productupgrade/.productupgrade/REVIEW-CEO.md`
- Eng review: `~/productupgrade/.productupgrade/REVIEW-ENGINEERING.md`
- gstack reference: `~/repos/gstack/` (15 tools, TypeScript infra, 3-tier testing)
- Orchestration gist: `kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea`
- CLEAR framework: embedded in `/agentic-eval` command

### The Vision

ProductionOS is a **recursive natural-language-to-production system**:
1. User describes what they want (even vaguely)
2. System discovers → plans → builds → reviews → refines in a convergence loop
3. If prompt is unclear → extended discovery phase (`/logic-mode`)
4. If capability is missing → system grows its own tools (self-enrichment via MetaClaw)
5. Goal: 99.9% production-ready output through multi-agent orchestration
6. Tri-tiered evaluation prevents hallucination and confidence bias
7. Cross-run learning means each session is smarter than the last
8. **Context-aware loading** prevents API overload — loads context on demand, not all at once

### Commands to Verify State

```bash
# Check current state
cd ~/productupgrade && git log --oneline -10 && cat VERSION

# Run health checks
bun run scripts/skill-check.ts
bun run scripts/gen-skill-docs.ts --dry-run
bun test

# Check installed locations
ls ~/.claude/skills/productionos/ 2>/dev/null
ls ~/.claude/plugins/*/productupgrade/ 2>/dev/null

# Read memory
cat ~/.claude/projects/-Users-muhammadshaheerkhawaja/memory/project_productionos_v5.md
```

Begin with Priority 1 (CI pipeline + template system), then proceed through the list. Run `bun test` before every commit to catch drift.
