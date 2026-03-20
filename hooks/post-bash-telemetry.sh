#!/usr/bin/env bash
# ProductionOS PostToolUse — log bash command telemetry
set -euo pipefail
STATE_DIR="${PRODUCTIONOS_HOME:-$HOME/.productionos}"
mkdir -p "$STATE_DIR/analytics"

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    data = json.loads(sys.stdin.read())
    ti = data.get('tool_input', {})
    print(ti.get('command', '')[:200])
except:
    print('')
" 2>/dev/null || true)

echo "{\"event\":\"bash\",\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"cmd\":\"$COMMAND\"}" >> "$STATE_DIR/analytics/skill-usage.jsonl" 2>/dev/null || true
