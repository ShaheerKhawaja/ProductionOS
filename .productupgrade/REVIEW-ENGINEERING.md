# Engineering Deep-Dive Review -- ProductUpgrade V4.0

**Reviewer:** Claude Opus 4.6 (1M context)
**Date:** 2026-03-18
**Scope:** Full architecture, agent design, convergence engine, prompt composition, hooks, commands, edge cases
**Files Reviewed:** 25+ files across agents/, templates/, hooks/, scripts/, .claude/commands/

---

## PASS 1: ARCHITECTURE & DATA FLOW

---

### 1.1 Agent Architecture -- Responsibility Separation

**Verdict: SOUND with two structural gaps**

The 25-agent roster is well-partitioned into EVALUATORS (read-only), EXECUTORS (read-write), and PLANNERS (read + write artifacts). The separation documented in `ARCHITECTURE.md:66-76` is enforced via the `tools:` frontmatter in each agent file -- evaluators declare only `Read/Glob/Grep/Bash`, executors additionally declare `Edit/Write`.

**Finding 1.1.1 -- Bash tool in read-only agents creates a write path** [HIGH]

Files: `agents/llm-judge.md:9`, `agents/adversarial-reviewer.md:10`, `agents/guardrails-controller.md:10`

All three "read-only" agents declare `Bash` in their tools list. The Bash tool can execute arbitrary commands including `rm`, `mv`, `git checkout`, `echo > file`, etc. The agents' prompts say "READ-ONLY" and "You CANNOT change code" -- but this is a prompt-level constraint, not a tool-level enforcement. A sufficiently long or adversarial context could cause the judge to run a destructive Bash command.

The adversarial-reviewer explicitly instructs at line 98: "Read-only Bash (grep, find, cat, wc)" -- but this is advisory only. There is no allowlist mechanism.

Severity: **HIGH** -- Violates the core architectural invariant that evaluators cannot modify code.

Recommendation: Either remove Bash from read-only agents entirely (use Glob/Grep for search, which they already have), or document that Claude Code's tool permissions model does not support read-only Bash and this is an accepted risk.

---

**Finding 1.1.2 -- Agent count discrepancy across docs** [LOW]

- `CLAUDE.md:1` says "25-agent"
- `productupgrade.md:3` says "54-agent"
- `CLAUDE.md:87` says 7 agents/phase for /productupgrade
- `ARCHITECTURE.md:55` says "25 agents instead of 1 big prompt"

The listing in `CLAUDE.md:39-63` enumerates exactly 25 agent files (confirmed by `ls agents/` returning 25 files). The "54-agent" claim in `productupgrade.md` likely counts total dispatches (7 review + 5 validation + up to 7x7=49 fix = ~54), not unique agent definitions. But this creates confusion.

Severity: **LOW** -- Documentation inconsistency, no functional impact.

---

**Finding 1.1.3 -- convergence-monitor has Write but no Edit** [MEDIUM]

File: `agents/convergence-monitor.md:9`

The convergence monitor has `Write` but not `Edit`. It only updates `CONVERGENCE-LOG.md`. However, `Write` overwrites entire files. If the monitor writes a new convergence log, it could lose data from a partially-written log by another agent in the same iteration. `Edit` with targeted replacements would be safer.

Severity: **MEDIUM** -- Data loss risk on convergence tracking artifact.

---

### 1.2 Convergence Engine -- Mathematical Correctness

**Verdict: WILL CONVERGE but has a logical gap in the DEGRADED check**

The convergence criteria are defined in three places:
- `ARCHITECTURE.md:113-116` (basic)
- `ultra-upgrade.md:231-239` (ultra)
- `llm-judge.md:53-57` (judge perspective)

The four exit conditions are:
1. `grade >= target` -- SUCCESS
2. `delta < threshold for 2 iterations` -- CONVERGED
3. `any_dimension_dropped > 0.5` -- DEGRADED (HALT)
4. `iteration >= max` -- MAX_REACHED

**Finding 1.2.1 -- DEGRADED check is overly sensitive and blocks legitimate trade-offs** [HIGH]

Files: `ARCHITECTURE.md:115`, `ultra-upgrade.md:238`, `llm-judge.md:154`

The rule "any dimension dropped > 0.5 -> HALT" triggers on ANY dimension decreasing by more than 0.5 points in ANY iteration. This is problematic because:

1. **Legitimate trade-offs exist.** Improving security by adding input validation might slightly reduce performance scores (more processing per request). Adding comprehensive error handling might reduce "code quality" scores by making code more verbose.

2. **Focus narrowing creates winners and losers.** When the pipeline focuses on the 2 weakest dimensions (ARCHITECTURE.md:119-129), unfocused dimensions naturally drift slightly as new code is added.

3. **Judge variance.** A 0.5 point swing on a 1-10 scale is well within normal LLM scoring variance. The same codebase evaluated twice by the same judge can produce 0.3-0.7 point differences on individual dimensions. This means the DEGRADED check could trigger on noise rather than signal.

The convergence engine will converge (grade is bounded above at 10.0 and each iteration either improves or triggers HALT), but it may HALT prematurely on false degradation signals, causing unnecessary rollbacks.

Severity: **HIGH** -- Will cause false HALT triggers in practice, wasting iterations and budget.

Recommendation: Change to "any dimension dropped > 1.0" or "net score (sum of all dimensions) decreased". Alternatively, require degradation to persist for 2 iterations before HALT.

---

**Finding 1.2.2 -- No weighted scoring, simple average may not reflect priorities** [MEDIUM]

File: `llm-judge.md:148` ("Compute overall grade: average of all 10 dimension scores")

The overall grade is an unweighted average of 10 dimensions. For a SaaS product, Security at 3/10 and Deployment Safety at 3/10 should alarm more than Documentation at 3/10 and Accessibility at 3/10. But the convergence engine treats them identically.

The `/ultra-upgrade` tribunal uses weighted model scores (Opus 50%, Sonnet 30%, Haiku 20%) in `ultra-upgrade.md:223`, but dimension weighting is never applied.

Severity: **MEDIUM** -- Sub-optimal prioritization; a product could converge with critical security gaps masked by high documentation scores.

---

**Finding 1.2.3 -- Convergence threshold is the same regardless of current grade** [LOW]

Files: `ARCHITECTURE.md:114`, `ultra-upgrade.md:236`

The convergence threshold is fixed: 0.2 for /productupgrade, 0.15 for /ultra-upgrade. Going from grade 3.0 to 3.2 is the same "improvement" as 8.0 to 8.2 mathematically, but the latter is far more difficult. This means:

- At low grades, the engine may converge too early (0.2 improvement is trivially achievable)
- At high grades, the engine may converge appropriately

This is acceptable because the SUCCESS condition (grade >= target) gates the final exit, so premature convergence at low grades still shows as "CONVERGED (below target)" rather than "SUCCESS."

Severity: **LOW** -- The interaction between CONVERGED and SUCCESS conditions handles this correctly.

---

### 1.3 Prompt Composition -- Layer Conflicts

**Verdict: WELL-DESIGNED with one composition order concern**

The 7-layer system in `templates/PROMPT-COMPOSITION.md` is cleanly structured with an explicit application matrix (lines 124-131) controlling which agent types receive which layers.

**Finding 1.3.1 -- Layers 5 (Tree of Thought) and 6 (Graph of Thought) never co-apply** [LOW]

File: `templates/PROMPT-COMPOSITION.md:124-131`

Looking at the application matrix:
- Review agents: L1-L4 only (no ToT, no GoT)
- Planning agents: L1-L3, L5 (ToT, no GoT)
- Execution agents: L1, L3, L4 (no ToT, no GoT)
- Judge agents: L1-L4, L7 (no ToT, no GoT)
- Synthesis agents: L3, L6, L7 (GoT, no ToT)
- Adversarial agents: L1, L2, L4, L5 (ToT, no GoT)

ToT and GoT never co-apply to the same agent type. This is architecturally clean -- no conflicts possible.

Severity: **LOW** -- No issue found; noting for completeness.

---

**Finding 1.3.2 -- Layer 7 (Chain of Density) only applies when iteration > 1 but judge always gets it** [MEDIUM]

File: `templates/PROMPT-COMPOSITION.md:152-153`

The composition function has: `if "L7" in layers and iteration > 1: prompt_parts.append(cod_layer(iteration - 1))`. This correctly skips CoD on the first iteration. But the application matrix shows Judge agents always get L7. On iteration 1, the judge will have L7 in its layer list but the composition function will skip it. This works correctly but the matrix is misleading -- it suggests judges always get all their layers.

Severity: **LOW** -- Correct behavior, misleading documentation.

---

**Finding 1.3.3 -- ultra-upgrade.md references 16 layers but PROMPT-COMPOSITION.md defines only 7** [MEDIUM]

Files: `ultra-upgrade.md:3` ("16 prompt engineering layers"), `ultra-upgrade.md:24` ("All 16 layers"), `PROMPT-COMPOSITION.md` (defines 7 layers)

The ultra-upgrade command references layers 8-16 inline:
- Layer 8: Self-Consistency (line 94)
- Layer 9: Step-Back Prompting (line 78)
- Layer 10: Analogical Prompting (line 94)
- Layer 11: Constitutional AI (line 82)
- Layer 12: Skeleton of Thought (line 86)
- Layer 13: Debate Protocol (line 102)
- Layer 14: Plan-and-Solve (line 109)
- Layer 15: Mixture of Agents (line 109)
- Layer 16: (implied, not defined -- see TODOS.md line 35 "Generated Knowledge Prompting (Layer 16)")

These extra layers are referenced by name in the ultra-upgrade phase descriptions but have no formal template definitions in `templates/PROMPT-COMPOSITION.md`. The composition function only handles L1-L7. Layers 8-16 exist only as inline references in the command file, not as composable templates.

Severity: **MEDIUM** -- Layers 8-16 are aspirational labels applied ad-hoc, not systematically composed. This means the "16 layers" claim is partially marketing -- 7 are formally composed, 9 are informal prompt-level instructions.

---

### 1.4 Judge Independence

**Verdict: DESIGN IS CORRECT but enforcement has a gap (see 1.1.1)**

The judge independence model is well-reasoned:
- Judge reads actual code, not agent self-reports (`llm-judge.md:37`)
- Judge has no Edit/Write tools (only Read/Glob/Grep/Bash)
- Tribunal judges run in separate agent contexts (`ultra-upgrade.md:308`)
- Focus narrowing feeds from judge to planner, not from executor to judge

**Finding 1.4.1 -- Tribunal judge weighting creates a bias toward leniency** [MEDIUM]

File: `ultra-upgrade.md:223`

The tribunal weights are: Opus 50%, Sonnet 30%, Haiku 20%. The design notes at line 211 state "Sonnet tends to be more lenient -- this creates tension." But if Sonnet (lenient) gets 30% weight, the weighted average will consistently be higher than what the most careful judge (Opus) would assign alone. This creates a systematic upward bias in tribunal scores compared to single-judge /productupgrade scores.

This means:
- /ultra-upgrade (tribunal) will converge at genuinely lower quality than /productupgrade (single Opus judge) for the same target grade
- The "9.5 target" in ultra-upgrade may correspond to roughly an 8.5-9.0 from a single Opus judge

Severity: **MEDIUM** -- Systematic bias inflates tribunal scores, making the "9.5 target" less demanding than it appears.

Recommendation: Weight the most skeptical judge (Opus) higher (60-70%) or use the minimum of the three scores rather than the weighted average.

---

**Finding 1.4.2 -- No mechanism to detect judge manipulation via context stuffing** [MEDIUM]

Files: `llm-judge.md`, `ultra-upgrade.md:201-225`

The judge reads actual code files, which is correct. But the judge also reads `.productupgrade/` artifacts for context (CONVERGENCE-LOG, previous judge reports). If an executor agent writes misleading information into `.productupgrade/` artifacts (e.g., fake test results in REFLEXION-LOG.md), the judge might be influenced.

The judge instructions say "NEVER trust self-reports from other agents" (llm-judge.md:37), but nothing prevents it from reading contaminated artifacts.

Severity: **MEDIUM** -- Indirect leakage path from executors to judge via shared artifact directory.

---

### 1.5 Cost Budgets

**Verdict: OPTIMISTIC -- real costs will exceed stated ranges**

**Finding 1.5.1 -- Stated cost ranges are unrealistic for the agent counts involved** [HIGH]

Files: `ARCHITECTURE.md:47-50`, `CLAUDE.md:129-133`, `ultra-upgrade.md:314-319`

The cost spectrum states:
- /productupgrade: $2-5
- /auto-swarm: $5-15
- /ultra-upgrade: $15-50

Let's verify /ultra-upgrade:
- 12 iterations x 14 agents/iteration = 168 agent dispatches maximum
- Each agent dispatch with Opus costs ~$0.15-0.50 in API tokens (conservative)
- 168 dispatches x $0.30 average = ~$50 in agent dispatch costs alone
- Plus the main orchestrator context, which grows across 12 iterations
- Plus 3 tribunal judges per iteration = 36 more Opus calls
- Total: likely $50-100+ for a full 12-iteration run

The 4M token budget at Opus pricing ($15/MTok input, $75/MTok output for Claude pricing) yields $60-300 depending on I/O ratio.

For /productupgrade:
- 7 iterations x 7 agents + 5 validation + 1 judge = ~55 dispatches
- At $0.15-0.30 per dispatch = $8-17
- The "$2-5" claim assumes most runs converge in 2-3 iterations, which is optimistic

Severity: **HIGH** -- Users will be surprised by actual costs. The stated "$2-5" for /productupgrade is achievable only if convergence happens in 1-2 iterations.

Recommendation: Show cost ranges as "typical $X-Y, maximum $Z" or add a `--dry-run` flag that estimates cost before executing.

---

**Finding 1.5.2 -- Token budgets don't account for growing context across iterations** [MEDIUM]

Files: `CLAUDE.md:129-133`, `ultra-upgrade.md:314-319`

The session budget is 4M tokens for /ultra-upgrade with 600K per iteration. But:
- Iteration 1 context: agent prompts + codebase files = ~200K
- Iteration 6 context: agent prompts + codebase + 5 JUDGE reports + REFLEXION-LOG + CONVERGENCE-LOG + THOUGHT-GRAPH = ~400K+
- By iteration 12, the accumulated artifacts alone may exceed 600K

The growing context problem means later iterations cost more per agent dispatch, making the per-iteration budget of 600K increasingly tight.

Severity: **MEDIUM** -- Late iterations may degrade in quality as context budget pressure forces truncation.

---

### 1.6 Self-Learning Hook

**Verdict: SAFE but has a data integrity issue**

**Finding 1.6.1 -- No shell injection risk in self-learn.sh** [INFORMATIONAL]

File: `hooks/self-learn.sh`

The script processes JSON from stdin via `jq` and writes to a JSONL file. The input comes from Claude Code's hook system, which provides structured JSON. The script:
- Uses `set -euo pipefail` (line 6)
- Reads from stdin into a variable (line 14)
- Parses via `jq -r` with fallback (lines 17, 24, 29, 38)
- Truncates command strings to 200 chars (line 29)
- Only captures matching command patterns via grep (line 31)

The main injection vector would be a malicious `file_path` or `command` value containing shell metacharacters. However, these values are passed through `jq -r` which outputs raw strings, then used inside double-quoted `echo` arguments that write to the JSONL file. Since they're inside double quotes, shell metacharacters in the values won't execute.

One edge case: if a file path contains a double quote or backslash, the JSON output on line 25 would be malformed (the file path is interpolated into JSON without escaping). This would produce invalid JSONL but not a security vulnerability.

Severity: **LOW** -- No shell injection; malformed JSONL possible with exotic file paths.

---

**Finding 1.6.2 -- JSONL file grows unbounded** [MEDIUM]

File: `hooks/self-learn.sh`

The session file at line 9 is named by date: `session-$(date +%Y%m%d).jsonl`. A long session (3+ hours of /ultra-upgrade) could produce thousands of entries. Pattern extraction happens every 50 entries (line 45), but only creates a patterns file once (line 48: `if [ ! -f "$PATTERNS_FILE" ]`). This means:

- After the first 50 entries, patterns are extracted once
- Entries 51-999 are logged but never analyzed
- The patterns file reflects only the first 50 events, not the full session

The `if [ ! -f "$PATTERNS_FILE" ]` guard prevents re-extraction but also prevents updating patterns with newer data.

Severity: **MEDIUM** -- Self-learning only captures early-session patterns, missing mid/late-session patterns.

Recommendation: Remove the `if [ ! -f ]` guard and regenerate patterns at every 50-entry checkpoint, or use an append+deduplicate approach.

---

**Finding 1.6.3 -- Race condition in JSONL writes** [LOW]

File: `hooks/self-learn.sh:25,33,39`

Multiple PostToolUse hooks could fire concurrently (e.g., parallel agent dispatches triggering Edit on different files). The `echo ... >> "$SESSION_FILE"` appends are not atomic on all filesystems. On macOS HFS+/APFS, appends to the same file from concurrent processes can interleave, producing corrupted JSONL lines.

In practice, the 5000ms timeout (hooks.json:19) and sequential nature of Claude Code's tool execution make true concurrency unlikely, but it's not guaranteed.

Severity: **LOW** -- Unlikely in practice; corrupt lines would cause `jq` extraction to skip them (failing silently due to `|| true` on line 52).

---

### 1.7 Command Structure -- Argument Parsing

**Verdict: FUNCTIONAL with inconsistencies**

**Finding 1.7.1 -- Argument schema inconsistency between commands** [MEDIUM]

Files: `productupgrade.md:6-10`, `auto-swarm.md:3-19`, `ultra-upgrade.md:3-11`

Argument conventions differ across commands:
- `/productupgrade` takes `mode` and `target` as positional-style args
- `/auto-swarm` takes `task` (required), `depth`, `swarm_size`, `iterations`, `mode` as named args
- `/ultra-upgrade` takes `target` and `focus` as named args

The `target` argument defaults differ:
- `/productupgrade`: "Target directory or repo URL to upgrade"
- `/ultra-upgrade`: "Target directory or repo URL"
- `/auto-swarm`: no target argument (task description instead)

Users switching between commands will face inconsistent argument patterns.

Severity: **MEDIUM** -- UX friction, not a bug.

---

**Finding 1.7.2 -- No argument validation** [MEDIUM]

Files: all command files

None of the commands validate their arguments. Examples:
- `/auto-swarm "task" --depth invalid_value` -- no validation that depth is one of shallow/medium/deep/ultra
- `/auto-swarm "task" --swarm_size 99` -- no enforcement of max 7
- `/ultra-upgrade --focus nonexistent_dimension` -- no check against the 10 known dimensions

These are Claude Code slash commands (markdown interpreted by the LLM), not programmatic parsers, so the LLM would likely handle invalid values gracefully by interpreting intent. But the declared defaults (auto-swarm.md:15-16: `default: "7"` for swarm_size, `default: "7"` for iterations) are enforced only by the LLM's prompt following.

Severity: **MEDIUM** -- Acceptable for LLM-interpreted commands, but could cause silent misconfiguration.

---

### 1.8 File Layout

**Verdict: CLEAN with minor redundancy**

**Finding 1.8.1 -- Rubric defined in two places** [LOW]

Files: `templates/RUBRIC.md`, `agents/llm-judge.md:127-142`

The scoring rubric is defined in `templates/RUBRIC.md` as a fill-in template, and also embedded inline in the llm-judge agent at lines 127-142 with a compressed version. If the rubric criteria change, both files need updating. The judge agent should reference the template rather than embed a copy.

Severity: **LOW** -- Maintenance burden, no functional conflict currently.

---

**Finding 1.8.2 -- skills-bundle/ referenced but not reviewed** [INFORMATIONAL]

File: `ARCHITECTURE.md:162`, `CLAUDE.md:68`

The 22 bundled skills in `skills-bundle/` are referenced as providing self-contained operation without external plugins. These were not part of this review scope but represent a significant surface area (22 more files).

---

---

## PASS 2: EDGE CASES & ROBUSTNESS

---

### 2.1 Agent Timeout Mid-Batch

**Finding 2.1.1 -- No timeout handling for individual agents in a batch** [HIGH]

Files: `ultra-upgrade.md:160-198`, `productupgrade.md:77-86`

The execution protocol says "AWAIT all agents" (ultra-upgrade.md:177) and "Wait for all 7 agents to complete" (productupgrade.md:59). But there is no specified behavior if one agent hangs or takes disproportionately long.

Claude Code's Agent tool has a default timeout, but the commands don't define:
- What happens to the batch if 1 of 7 agents times out
- Whether to commit the 6 successful fixes or roll back the entire batch
- Whether the timed-out agent's work is lost or partially captured
- Whether the timed-out fix is retried in the next batch

The self-healer (self-healer.md:79) has a 3-attempt limit, but the main orchestration has no equivalent for agent dispatch failures.

Severity: **HIGH** -- A single hung agent blocks the entire batch, and no recovery path is defined.

Recommendation: Add explicit timeout per agent dispatch (e.g., 5 minutes), define partial-batch commit policy, and add timed-out fixes back to the plan queue for the next batch.

---

### 2.2 Target Codebase Has No Tests, Lint, or Type Checker

**Finding 2.2.1 -- Self-healer assumes tooling exists** [HIGH]

File: `agents/self-healer.md:29-40, 51-58, 70-77`

The self-healer's healing protocol runs hardcoded commands:
```
npx tsc --noEmit
npx eslint . --ext .ts,.tsx
uvx ruff check .
mypy .
pytest
bun test
```

If the target codebase is:
- A Ruby on Rails app (no tsc, no eslint, no ruff, no pytest, no bun)
- A Go project (no npm, no python tools)
- A plain HTML/CSS website (no linters at all)
- A fresh project with no test suite configured

Every command will fail. The self-healer will run its 3 healing attempts, all will fail on tooling detection, and the batch will be rolled back despite the fixes being potentially correct.

The `2>/dev/null` redirects on lines 53-58 suppress errors, but the verify step on lines 70-77 uses `&&` chains that will fail if the tools don't exist.

Severity: **HIGH** -- ProductUpgrade claims to work on any codebase but the validation gate only works on TypeScript/Python projects.

Recommendation: Add tool detection before running validation. Only run linters/checkers that exist in the target project. Fall back to `git diff --stat` + manual review if no tooling is detected.

---

**Finding 2.2.2 -- productupgrade.md assumes specific test frameworks** [MEDIUM]

File: `productupgrade.md:115`

Line 115: "Use `/gstack qa` for web apps, `pytest` for Python, `bun test` for JS/TS"

This hardcodes framework assumptions. A Python project might use `unittest`, `nose2`, or have no tests. A JS project might use `vitest`, `jest`, `mocha`, or `ava`.

Severity: **MEDIUM** -- Same class of issue as 2.2.1 but in the main command.

---

### 2.3 Contradictory Judge Scores

**Finding 2.3.1 -- Tribunal debate protocol is underspecified** [HIGH]

File: `ultra-upgrade.md:219-224`

The tribunal protocol states:
- "If all 3 disagree: trigger DEBATE (agents argue, then re-score)"

But the debate protocol is never defined. Key questions unanswered:
1. How does the debate work mechanically? (Do judges see each other's scores? In what order?)
2. What if the debate doesn't resolve disagreement? Is there a tiebreaker?
3. How many rounds of debate are allowed?
4. Does the debate count toward the token budget?
5. Who moderates the debate?

The only guidance is "agents argue, then re-score" -- this is a one-line description of what should be a multi-step protocol.

Severity: **HIGH** -- The fallback mechanism for the most contentious scoring situations is undefined. In practice, the orchestrating LLM will improvise, leading to inconsistent behavior across runs.

Recommendation: Define the debate protocol explicitly: (1) each judge explains their score with evidence, (2) each judge responds to the other two, (3) final re-score, (4) if still no consensus, use the most conservative (lowest) score.

---

**Finding 2.3.2 -- Self-consistency check could loop** [MEDIUM]

File: `llm-judge.md:108-119`

When confidence < 0.80, the judge generates 3 reasoning paths and compares. If paths disagree, the judge uses "more conservative score." But what if the conservative path A gives 5/10 and path C gives 7/10 and path B gives 3/10? The "conservative" score is 3/10 -- but this might be an outlier, not a conservative estimate.

The self-consistency validation doesn't specify how to handle outliers vs. genuine disagreement.

Severity: **MEDIUM** -- Could produce unreasonably low scores from outlier reasoning paths.

---

### 2.4 Dirty Git Repo at Pipeline Start

**Finding 2.4.1 -- No git state check before pipeline execution** [HIGH]

Files: `productupgrade.md`, `ultra-upgrade.md`, `auto-swarm.md`

None of the three commands check git state before starting. If the repo has:
- Uncommitted changes (dirty working tree)
- Staged but uncommitted files
- Merge conflicts
- Detached HEAD

The pipeline will start executing, making changes on top of an unknown state. Rollback (mentioned in ARCHITECTURE.md:115 and ultra-upgrade.md:191) uses `git` operations, but if the initial state was dirty, rollback to "before the pipeline" is ambiguous.

The guardrails-controller.md checks `git diff --name-only HEAD` for protected files (line 28), but this would match pre-existing dirty files, not just pipeline-modified files.

Severity: **HIGH** -- Pipeline rollback is unreliable if the repo was dirty at start.

Recommendation: Add a Step 0 to all commands: `git status --porcelain`. If non-empty, either (a) require a clean working tree, (b) create a stash point for rollback, or (c) create a baseline commit "productupgrade: baseline snapshot".

---

### 2.5 Concurrent ProductUpgrade Sessions

**Finding 2.5.1 -- No session locking mechanism** [HIGH]

Files: all command files, hooks/self-learn.sh

There is no lock file, PID check, or session identifier to prevent two simultaneous runs. If two terminal windows both run `/productupgrade`:

1. Both write to the same `.productupgrade/` directory -- overwriting each other's artifacts
2. Both write to the same `~/.productupgrade/learned/session-{date}.jsonl` -- interleaving events
3. Both make git commits -- creating a tangled commit history
4. Both run the same linters/tests -- producing confusing output
5. The convergence monitor reads partial/mixed data from both sessions

The CONVERGENCE-LOG.md, JUDGE-ITERATION-{N}.md, and other artifacts use sequential numbering that would collide.

Severity: **HIGH** -- Silent data corruption and unpredictable behavior.

Recommendation: Add a lock file (`.productupgrade/.lock` with PID) checked at pipeline start. If locked, abort with a message showing which session holds the lock.

---

### 2.6 Convergence Monitor Detects Oscillation

**Finding 2.6.1 -- Oscillation detection is documented but no automated response** [MEDIUM]

File: `agents/convergence-monitor.md:40-41, 50-53`

The convergence monitor detects oscillation: "Dimension goes up then down -> fix is introducing regression." The recommended strategies are:
- Identify which batches cause regression
- Add regression tests before fixing
- Reduce batch size to isolate the culprit

But these are recommendations to the orchestrator, not automated actions. The monitor writes to CONVERGENCE-LOG.md and provides analysis, but the orchestration commands (productupgrade.md, ultra-upgrade.md) don't read convergence monitor recommendations between iterations. They only check the judge's convergence verdict (SUCCESS/CONTINUE/CONVERGED/DEGRADED).

The oscillation detection is therefore advisory-only. The pipeline will continue oscillating until the DEGRADED check triggers (dimension dropped > 0.5) or MAX_REACHED.

Severity: **MEDIUM** -- Oscillation wastes iterations and budget. The detection exists but has no actuator.

Recommendation: Wire the convergence monitor's recommendations into the planner's input for the next iteration. If oscillation detected, force the planner to add regression tests before attempting the fix again.

---

### 2.7 Self-Healer Introduces New Bugs

**Finding 2.7.1 -- Self-healer has no scope constraint beyond "fix the errors"** [MEDIUM]

File: `agents/self-healer.md:63-66`

The self-healer's instructions say:
- "Make the MINIMAL change to fix it"
- "Do NOT refactor, do NOT improve, do NOT add features"
- "One error at a time, verify each fix"
- Maximum 3 healing attempts per batch

This is prompt-level constraint only. The self-healer has full Edit/Write/Bash access and could in theory make changes beyond minimal fixes. However, the 3-attempt limit (line 85) and the verify step (line 69-77) provide a practical safeguard.

The more concrete risk: the self-healer fixes a type error by adding a cast (`as any` in TypeScript, `# type: ignore` in Python), which the instructions explicitly forbid (lines 83-84). But "fix the type" vs. "suppress the type error" is a judgment call the LLM might get wrong under pressure.

Severity: **MEDIUM** -- The 3-attempt limit and verification step provide adequate protection. The risk is quality regression, not pipeline failure.

---

**Finding 2.7.2 -- Self-healer's changes are never independently judged** [MEDIUM]

Files: `self-healer.md`, `ultra-upgrade.md:187-191`

The self-healer runs after a batch fails validation. If it succeeds, the batch is committed with the message "(healed)" (ultra-upgrade.md:189). But the healed code is not re-evaluated by the judge until the next full iteration. The healer could introduce subtle behavioral changes that pass lint/type/test checks but degrade actual quality.

The next iteration's judge evaluation will catch this, but:
- The commit is already made
- If the degradation is < 0.5 per dimension, it won't trigger HALT
- The regression compounds if it happens across multiple healed batches

Severity: **MEDIUM** -- Acceptable risk given the judge catches regressions, but the gap between "committed" and "judged" means low-severity regressions accumulate.

---

### 2.8 All 3 Tribunal Judges Disagree Completely

**Finding 2.8.1 -- Complete tribunal disagreement triggers undefined behavior** [HIGH]

File: `ultra-upgrade.md:219-224`

Scenario: Opus scores Security at 4/10, Sonnet scores it at 7/10, Haiku scores it at 9/10. All three differ by more than 1 point. The protocol says "trigger DEBATE" but as noted in 2.3.1, the debate protocol is undefined.

Without a defined debate protocol, the orchestrating LLM will improvise. Possible outcomes:
- It uses the weighted average anyway (ignoring the "debate" instruction): 4(0.5) + 7(0.3) + 9(0.2) = 5.9
- It attempts an ad-hoc debate that may or may not converge
- It picks the most detailed judge's score

Each of these produces a different grade, different convergence decision, and different pipeline behavior. Across 10 dimensions per iteration and 12 iterations, even occasional disagreement makes the pipeline non-deterministic.

Severity: **HIGH** -- Non-deterministic convergence decisions when judges disagree.

Recommendation: Define a deterministic fallback: if debate doesn't resolve after 1 round, use the minimum (most conservative) score per the judge's own principle of conservatism (llm-judge.md:205).

---

---

## SUMMARY TABLE

| # | Finding | File(s) | Severity | Category |
|---|---------|---------|----------|----------|
| 1.1.1 | Bash tool in read-only agents creates write path | agents/llm-judge.md:9, adversarial-reviewer.md:10 | **HIGH** | Architecture |
| 1.1.2 | Agent count discrepancy (25 vs 54) | CLAUDE.md:1, productupgrade.md:3 | LOW | Documentation |
| 1.1.3 | convergence-monitor uses Write not Edit | agents/convergence-monitor.md:9 | MEDIUM | Data Integrity |
| 1.2.1 | DEGRADED check overly sensitive (0.5 threshold) | ARCHITECTURE.md:115, llm-judge.md:154 | **HIGH** | Convergence |
| 1.2.2 | No weighted dimension scoring | llm-judge.md:148 | MEDIUM | Convergence |
| 1.2.3 | Fixed convergence threshold regardless of grade | ARCHITECTURE.md:114 | LOW | Convergence |
| 1.3.1 | ToT and GoT never co-apply (correct) | templates/PROMPT-COMPOSITION.md:124-131 | LOW | Prompt Layers |
| 1.3.2 | CoD layer guard hides intent in matrix | templates/PROMPT-COMPOSITION.md:152 | LOW | Documentation |
| 1.3.3 | 16 layers claimed, only 7 formally composed | ultra-upgrade.md:3, PROMPT-COMPOSITION.md | MEDIUM | Prompt Layers |
| 1.4.1 | Tribunal weighting biases toward leniency | ultra-upgrade.md:223 | MEDIUM | Judge |
| 1.4.2 | Judge can be influenced via shared artifacts | llm-judge.md, ultra-upgrade.md:201 | MEDIUM | Judge |
| 1.5.1 | Stated cost ranges unrealistic | ARCHITECTURE.md:47-50 | **HIGH** | Budget |
| 1.5.2 | Context growth not budgeted per iteration | CLAUDE.md:129, ultra-upgrade.md:314 | MEDIUM | Budget |
| 1.6.1 | No shell injection in self-learn.sh | hooks/self-learn.sh | INFORMATIONAL | Security |
| 1.6.2 | JSONL grows unbounded, patterns extracted only once | hooks/self-learn.sh:45-59 | MEDIUM | Self-Learning |
| 1.6.3 | Race condition in JSONL appends | hooks/self-learn.sh:25 | LOW | Self-Learning |
| 1.7.1 | Argument schemas inconsistent across commands | all command files | MEDIUM | UX |
| 1.7.2 | No argument validation | all command files | MEDIUM | UX |
| 1.8.1 | Rubric defined in two places | templates/RUBRIC.md, agents/llm-judge.md | LOW | Maintenance |
| 2.1.1 | No timeout handling for individual agents | ultra-upgrade.md:177 | **HIGH** | Robustness |
| 2.2.1 | Self-healer assumes TS/Python tooling exists | agents/self-healer.md:29-40 | **HIGH** | Robustness |
| 2.2.2 | Hardcoded test framework assumptions | productupgrade.md:115 | MEDIUM | Robustness |
| 2.3.1 | Tribunal debate protocol undefined | ultra-upgrade.md:219-224 | **HIGH** | Robustness |
| 2.3.2 | Self-consistency outlier handling unclear | llm-judge.md:108-119 | MEDIUM | Robustness |
| 2.4.1 | No git state check before pipeline start | all command files | **HIGH** | Robustness |
| 2.5.1 | No session locking for concurrent runs | all files | **HIGH** | Robustness |
| 2.6.1 | Oscillation detection has no actuator | agents/convergence-monitor.md:40-53 | MEDIUM | Robustness |
| 2.7.1 | Self-healer scope is prompt-level only | agents/self-healer.md:63-66 | MEDIUM | Robustness |
| 2.7.2 | Self-healer changes not independently judged | self-healer.md, ultra-upgrade.md:187 | MEDIUM | Robustness |
| 2.8.1 | Complete tribunal disagreement = undefined behavior | ultra-upgrade.md:219-224 | **HIGH** | Robustness |

## SEVERITY DISTRIBUTION

- **CRITICAL:** 0
- **HIGH:** 9
- **MEDIUM:** 14
- **LOW:** 7
- **INFORMATIONAL:** 2

## TOP 5 RECOMMENDED FIXES (priority order)

1. **Define the tribunal debate protocol** (2.3.1 + 2.8.1) -- Two HIGH findings collapse into one fix. Define a 1-round debate with deterministic fallback to the most conservative score.

2. **Add git state check and session locking** (2.4.1 + 2.5.1) -- Two HIGH findings. Add pre-flight checks: clean working tree + lock file. Both are small shell script additions.

3. **Add tooling detection to self-healer** (2.2.1) -- One HIGH finding. Detect available linters/testers before running them. Fall back gracefully if none exist.

4. **Revise the DEGRADED threshold** (1.2.1) -- One HIGH finding. Change from "any dimension dropped > 0.5" to "any dimension dropped > 1.0 OR net score decreased" to reduce false HALTs.

5. **Remove Bash from read-only agents OR document the accepted risk** (1.1.1) -- One HIGH finding. Glob and Grep cover all search needs; Bash adds an unnecessary write vector.
