## Preamble (runs before every ProductionOS skill)

```bash
# ProductionOS Preamble — universal initialization
STATE_DIR="${PRODUCTIONOS_HOME:-$HOME/.productionos}"

# 1. Initialize state
bash "${CLAUDE_PLUGIN_ROOT}/bin/pos-init" 2>/dev/null || true

# 2. Track session
mkdir -p "$STATE_DIR/sessions"
touch "$STATE_DIR/sessions/$$"
find "$STATE_DIR/sessions" -mmin +120 -type f -delete 2>/dev/null || true
_SESSIONS=$(find "$STATE_DIR/sessions" -mmin -120 -type f 2>/dev/null | wc -l | tr -d ' ')

# 3. Load config
_PROACTIVE=$(bash "${CLAUDE_PLUGIN_ROOT}/bin/pos-config" get proactive 2>/dev/null || echo "true")
_AUTO_REVIEW=$(bash "${CLAUDE_PLUGIN_ROOT}/bin/pos-config" get auto_review 2>/dev/null || echo "true")
_AUTO_LEARN=$(bash "${CLAUDE_PLUGIN_ROOT}/bin/pos-config" get auto_learn 2>/dev/null || echo "true")

# 4. Detect environment
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_REPO=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "unknown")

# 5. Log skill invocation
_TEL_START=$(date +%s)
bash "${CLAUDE_PLUGIN_ROOT}/bin/pos-telemetry" "SKILL_NAME" 2>/dev/null || true

# 6. Print status
echo "ProductionOS | Branch: $_BRANCH | Sessions: $_SESSIONS | Review: $_AUTO_REVIEW"
```

If `_PROACTIVE` is `"false"`, do not proactively suggest ProductionOS skills.
If `_AUTO_REVIEW` is `"true"`, run lightweight code review after major edits.
If `_AUTO_LEARN` is `"true"`, extract patterns at session end.
