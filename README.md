# ProductUpgrade

AI-powered autonomous self-learning product upgrade pipeline for Claude Code. Uses **20 specialized agents** with 7-layer prompt composition, LLM-as-Judge convergence, and distributed swarm orchestration to systematically audit, improve, and validate any product codebase.

## What It Does

1. **Scans** your codebase for architecture, tech debt, security, and performance issues
2. **Scrapes** competitor sites to identify UX/UI improvement opportunities
3. **Reviews** with CEO strategic lens + engineering deep-dive + design audit
4. **Plans** prioritized fixes with TDD specs and migration strategies
5. **Fixes** issues in parallel batches with validation gates
6. **Validates** all changes with code review, QA testing, and before/after grading
7. **Learns** from each iteration via reflexion memory and decision weight tracking

## Quick Start

```bash
# Install as Claude Code plugin
echo '{"plugins": ["~/productupgrade"]}' >> .claude/settings.json

# Auto mode (smart agent selection)
/productupgrade

# Standard mode (6-phase pipeline, target 8.0)
/productupgrade standard

# Deep mode (autonomous self-learning, target 10.0)
/productupgrade deep

# Audit only (no changes)
/productupgrade audit
```

## Pipeline Architecture

```
AUTO MODE:    3-54 agents (complexity-dependent, single pass)
STANDARD:     6 phases × 7 agents = up to 54 dispatches per iteration
DEEP MODE:    7 loops × 20 agents = autonomous convergence to 10/10

Convergence:  LLM-as-Judge scores 10 dimensions after each iteration
              delta < 0.15 for 2 consecutive iterations = CONVERGED
```

## License

MIT
