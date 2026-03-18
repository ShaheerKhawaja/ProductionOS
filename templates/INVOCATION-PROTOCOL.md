# Agent Invocation Protocol

How ProductionOS agents invoke other agents and skills. Every agent that references "invoke X" MUST follow this protocol.

## Method 1: Subagent Dispatch (primary)

Use Claude Code's Agent tool to spawn a subagent with the target agent's instructions:

```
1. Read the target agent's definition: agents/{name}.md
2. Extract the <role> and <instructions> content
3. Dispatch via Agent tool:
   - description: "{agent-name}: {1-line task description}"
   - prompt: "You are the {agent-name} agent. {role content}\n\n{instructions content}\n\nTASK: {specific task}\nTARGET: {files/scope}\nOUTPUT: Write findings to .productionos/{OUTPUT-FILE}"
   - run_in_background: true (for parallel dispatch)
4. Wait for completion, read output file
```

## Method 2: Skill Invocation (for external skills)

For skills from other plugins (gstack, superpowers):

```
1. Check if skill exists: attempt to invoke it
2. If available: let it execute, read its output
3. If unavailable: log "SKIP: {skill} not available" and continue
4. Never halt the pipeline because an external skill is missing
```

## Method 3: File-Based Handoff (for sequential agents)

When Agent A produces output consumed by Agent B:

```
1. Agent A writes structured output to .productionos/{ARTIFACT}.md
2. Agent A includes a MANIFEST block at the top:
   ---
   producer: {agent-name}
   timestamp: {ISO8601}
   status: complete
   ---
3. Agent B reads .productionos/{ARTIFACT}.md
4. Agent B verifies the MANIFEST block exists (artifact is valid)
5. If artifact missing: Agent B logs "MISSING: {ARTIFACT}.md from {producer}" and continues with degraded capability
```

## Rules

- NEVER assume an agent/skill is available — always check first
- NEVER halt the pipeline because a sub-agent failed — degrade gracefully
- ALWAYS write output to .productionos/ with a consistent filename
- ALWAYS include producer and timestamp in output files
- Subagents get FRESH context — never pass the parent's full conversation
- Maximum subagent nesting depth: 3 (command → agent → sub-agent → skill)
