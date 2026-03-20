#!/usr/bin/env bash
# ProductionOS Stop hook — session cleanup, handoff doc, instinct extraction
set -euo pipefail
STATE_DIR="${PRODUCTIONOS_HOME:-$HOME/.productionos}"

# 1. Clean session file
rm -f "$STATE_DIR/sessions/$$" 2>/dev/null || true

# 2. Log session end
echo "{\"event\":\"session_end\",\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"pid\":$$}" >> "$STATE_DIR/analytics/skill-usage.jsonl" 2>/dev/null || true

# 3. Generate session summary
ANALYTICS="$STATE_DIR/analytics/skill-usage.jsonl"
if [ -f "$ANALYTICS" ]; then
  python3 -c "
import json, collections
from datetime import datetime

today = datetime.utcnow().strftime('%Y-%m-%d')
events = []
for line in open('$ANALYTICS'):
    try:
        e = json.loads(line)
        if e.get('ts', '').startswith(today):
            events.append(e)
    except:
        pass

if len(events) < 3:
    exit(0)

types = collections.Counter(e.get('event', '') for e in events)
files = collections.Counter(e.get('file', '') for e in events if e.get('file'))
security = [e for e in events if e.get('event') == 'security_edit']

# Write handoff summary
handoff = f'''# ProductionOS Session Summary — {today}

## Events: {len(events)}
{chr(10).join(f'- {k}: {v}' for k, v in types.most_common(10))}

## Top Files Edited
{chr(10).join(f'- {k}: {v}' for k, v in files.most_common(5)) if files else '- None'}

## Security-Sensitive Edits: {len(security)}
{chr(10).join(f'- {e.get(\"file\", \"\")} ({e.get(\"pattern\", \"\")})' for e in security) if security else '- None'}
'''

import os
handoff_dir = os.path.join('$STATE_DIR', 'sessions')
os.makedirs(handoff_dir, exist_ok=True)
with open(os.path.join(handoff_dir, f'handoff-{today}.md'), 'w') as f:
    f.write(handoff)
" 2>/dev/null || true
fi

# 4. Extract instincts
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"
if [ -f "$PLUGIN_ROOT/hooks/stop-extract-instincts.sh" ]; then
  bash "$PLUGIN_ROOT/hooks/stop-extract-instincts.sh" 2>/dev/null || true
fi
