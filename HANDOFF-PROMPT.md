# ProductionOS — Fresh Session Handoff Prompt

**Copy this entire prompt into a new Claude Code session to continue work.**

---

## Context

You are continuing work on **ProductionOS** (formerly ProductUpgrade) — an agentic development operating system built as a Claude Code plugin. The repo is at `~/productupgrade/` on the `v4.0.0` branch, pushed to GitHub at `ShaheerKhawaja/productupgrade`.

### What Was Built (previous session)

ProductionOS V5.0 with:
- **10 commands:** `/omni-plan`, `/auto-swarm`, `/production-upgrade`, `/deep-research`, `/agentic-eval`, `/security-audit`, `/context-engineer`, `/logic-mode`, `/learn-mode`, `/productionos-update`
- **29 agents** across code review, security, research, orchestration, and self-improvement
- **16 prompt engineering layers** (CoT, ToT, GoT, CoD, ReAct, LATS, Self-Debugging, etc.)
- **Tri-tiered evaluation** (3 independent judges: Correctness/Practicality/Adversarial)
- **Self-learning hook** (PostToolUse pattern capture to `~/.productionos/learned/`)
- **MetaClaw cross-run learning** with 30-day time-decay rules
- ARCHITECTURE.md, CONTRIBUTING.md, CHANGELOG.md, TODOS.md
- CEO + Engineering reviews completed (`.productupgrade/REVIEW-CEO.md`, `REVIEW-ENGINEERING.md`)
- Comprehensive gap analysis (`.productupgrade/RESEARCH-V4-GAP-ANALYSIS.md`)

### What Needs To Be Done Next

**Priority 1 — Immediate (this session):**

1. **8-repo deep analysis** — deeply analyze these forked repos, compare with gstack, identify gaps for ProductionOS:
   - `~/repos/awesome-claude-code` — plugin/skill index
   - `~/repos/get-shit-done` — wave-based parallel execution OS
   - `~/repos/InsForge` — AI BaaS with DB, auth, storage
   - `~/repos/everything-claude-code` — 146+ skills, 18 agents
   - `~/repos/openrag` — RAG framework (needed for context engineering)
   - `~/repos/superpowers` — 14 core workflow skills
   - `~/repos/ai-coding-primer` — full-stack AI dev guide
   - `~/repos/claude-code-router` — multi-model routing proxy

   For EACH repo: read README, review full structure, understand intended functionality, reverse-engineer architecture decisions, identify what ProductionOS is missing.

2. **TypeScript infrastructure** — ProductionOS is 100% markdown/shell. gstack is 74.8% TypeScript. Add Bun-based tooling:
   - `package.json` with Bun scripts
   - `scripts/gen-skill-docs.ts` — generate SKILL.md from templates (gstack pattern)
   - `scripts/skill-check.ts` — validate agent/command references
   - 3-tier test system: static (free) → E2E via `claude -p` (~$4) → LLM-judge (~$0.15)
   - `browse/` compiled binary for headless Playwright (gstack pattern)

3. **Native Claude Code orchestration** — integrate TaskTool/TeammateTool primitives from the Klaassen gist (`kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea`):
   - Team spawning with inbox messaging
   - Task dependencies with automatic unblocking
   - Spawn backends (in-process, tmux, iTerm2)
   - Pipeline/swarm/parallel specialist patterns

4. **.mjs hook files** — create proper JavaScript hooks (not just shell) for:
   - PreToolUse skill injection (like Vercel plugin's `inject-claude-md.mjs`)
   - PostToolUse self-learning capture
   - SessionStart context loading

5. **GitHub repo rename** — `productupgrade` → `productionos`

6. **Extended discovery phase** — when prompts are unclear, auto-trigger a discovery conversation before planning

7. **SKILL.md update** — rewrite for ProductionOS identity with all 10 commands

8. **Local installation** — sync to `~/.claude/skills/productionos/` and `~/.claude/plugins/`

**Priority 2 — Deep Research:**

9. **Context engineering arxiv research** — search for "context engineering LLM 2025 2026" papers
10. **RLM research** via `~/repos/openrag` for RAG integration
11. **Multi-IDE orchestration** — how to have Claude Code orchestrate Codex/Gemini CLI in containers

**Priority 3 — Fixes from reviews:**

12. **CEO review fixes** (`.productupgrade/REVIEW-CEO.md`):
    - Add `/quick` mode (60-second scorecard, 3 findings)
    - Fix first-time user overwhelm (auto-detect which command to use)
    - Add runtime cost tracking
    - Fix stale "54-agent" claims

13. **Eng review fixes** (`.productupgrade/REVIEW-ENGINEERING.md`):
    - Remove Bash from read-only agent tool lists
    - Adjust DEGRADED threshold (0.5 → 1.0)
    - Define tribunal debate protocol formally
    - Add git state check before pipeline start
    - Add session locking for concurrent runs

### Key Reference Documents

- Plan file: `~/.claude/plans/wild-swinging-cray.md`
- Gap analysis: `~/productupgrade/.productupgrade/RESEARCH-V4-GAP-ANALYSIS.md`
- Memory: `~/.claude/projects/-Users-muhammadshaheerkhawaja/memory/project_productionos_v5.md`
- gstack reference: `~/repos/gstack/` (15 tools, TypeScript infra, 3-tier testing)
- Orchestration gist: `kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea`
- CLEAR framework: embedded in `/agentic-eval` command

### The Vision

ProductionOS is NOT a fixed toolkit like gstack. It is a **recursive natural-language-to-production system**:
1. User describes what they want (even vaguely)
2. System discovers → plans → builds → reviews → refines in a convergence loop
3. If prompt is unclear → extended discovery phase (`/logic-mode`)
4. If capability is missing → system grows its own tools (self-enrichment via MetaClaw)
5. Goal: 99.9% production-ready output through multi-agent orchestration
6. Tri-tiered evaluation prevents hallucination and confidence bias
7. Cross-run learning means each session is smarter than the last

### Commands to Start

```bash
# Check current state
cd ~/productupgrade && git log --oneline -8 && cat VERSION

# Check what's installed
ls ~/.claude/skills/productionos/ 2>/dev/null
ls ~/.claude/plugins/*/productionos/ 2>/dev/null

# Read the memory
cat ~/.claude/projects/-Users-muhammadshaheerkhawaja/memory/project_productionos_v5.md
```

Begin with the 8-repo deep analysis, then proceed through the priority list. Use `/auto-swarm` patterns (7 parallel agents) for the repo analysis. Make commits and push as you go.
