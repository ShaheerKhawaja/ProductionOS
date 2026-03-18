# Contributing to ProductUpgrade

Thanks for wanting to make ProductUpgrade better. Whether you're adding a new agent, improving a prompt layer, or fixing a gap identified in the research report, this guide gets you up and running.

## Quick start

```bash
git clone https://github.com/ShaheerKhawaja/productupgrade.git
cd productupgrade
git checkout v4.0.0  # or main once merged
```

ProductUpgrade is pure Markdown — no build step, no dependencies. Edit any `.md` file, install the plugin, and test immediately.

## Installation for development

```bash
# Option 1: Symlink into Claude Code skills (recommended for dev)
ln -sfn $(pwd) ~/.claude/skills/productupgrade

# Option 2: Install as plugin
claude plugins add ~/productupgrade

# Option 3: Add to settings
echo '{"plugins": ["~/productupgrade"]}' >> ~/.claude/settings.json
```

Changes to agents, commands, and skills are picked up immediately — no restart needed.

## Project structure

```
productupgrade/
├── agents/           # 25 agent definitions (one file each)
├── prompts/          # 16 composable prompt engineering layers
├── templates/        # Shared templates (rubric, convergence log, prompt composition)
├── hooks/            # Hook scripts (session banner, self-learning)
├── scripts/          # Shell automation (arxiv scraper, competitor scraper, GUI audit)
├── skills-bundle/    # 22 bundled reference skills
├── .claude/
│   ├── skills/productupgrade/SKILL.md   # Core skill definition
│   └── commands/*.md                     # Slash commands
├── .claude-plugin/plugin.json           # Plugin manifest
├── .productupgrade/                      # Research artifacts, design docs
├── ARCHITECTURE.md                       # Why decisions were made
├── CONTRIBUTING.md                       # This file
├── CHANGELOG.md                          # Version history
├── CLAUDE.md                             # How to use
├── TODOS.md                              # Prioritized backlog
└── VERSION                               # Semver version
```

## How to contribute

### Adding a new agent

1. Create `agents/your-agent-name.md` with YAML frontmatter:
   ```yaml
   ---
   name: your-agent-name
   description: "One-line description of what this agent does"
   model: opus  # optional: opus, sonnet, or omit for default
   color: blue  # optional: for visual identification
   tools:
     - Read
     - Glob
     - Grep
   ---
   ```

2. Structure the body with XML role tags:
   ```markdown
   <role>
   You are... (identity, capabilities, boundaries)
   </role>

   <instructions>
   ## Protocol
   ### Step 1: ...
   ### Step 2: ...
   </instructions>
   ```

3. Add the agent to the roster in `.claude/skills/productupgrade/SKILL.md`
4. Reference it in the relevant command (ultra-upgrade.md, productupgrade.md, etc.)

### Adding a new prompt layer

1. Create `prompts/NN-layer-name.md` where NN is the next available number
2. Include:
   - Research citation (paper, authors, year)
   - Impact metric (accuracy improvement, token reduction, etc.)
   - Application template with `{{placeholders}}`
   - When to use / when not to use
3. Add to the layer index in `prompts/README.md`
4. Add to the application matrix in `templates/PROMPT-COMPOSITION.md`

### Modifying an existing agent

1. Read the agent file completely before editing
2. Preserve the XML structure (`<role>`, `<instructions>`, `<constraints>`)
3. Keep the agent's tool list minimal — don't add Edit/Write to read-only agents
4. Update the agent's description in SKILL.md if the scope changed

### Updating commands

1. Edit the command file in `.claude/commands/`
2. Update the mode comparison table in CLAUDE.md
3. Update the command table in SKILL.md
4. Add a CHANGELOG.md entry

## Testing

### Manual testing

The best test is using ProductUpgrade on a real codebase:

```bash
# Test basic audit
/productupgrade audit

# Test ultra mode on a small project
/ultra-upgrade --target ~/some-small-project

# Test auto-swarm
/auto-swarm "research best practices for Django authentication"

# Test self-update
/productupgrade-update
```

### Validation checklist

Before submitting a PR:

- [ ] All agent files have valid YAML frontmatter
- [ ] No agent has tools it shouldn't (judges are read-only, adversarial is read-only)
- [ ] SKILL.md agent roster matches actual agents/ directory
- [ ] CLAUDE.md architecture diagram matches actual structure
- [ ] Commands reference agents that exist
- [ ] Prompt layers have research citations
- [ ] VERSION is bumped
- [ ] CHANGELOG.md is updated

### Future: automated testing

We plan to add gstack-style 3-tier testing:
- **Tier 1 — Static:** Validate YAML frontmatter, check agent references, verify file counts
- **Tier 2 — E2E:** Run `/productupgrade audit` against a fixture codebase via `claude -p`
- **Tier 3 — LLM-judge:** Score agent prompts on clarity, completeness, actionability

See TODOS.md for current status.

## Commit conventions

- **Imperative mood:** "Add adversarial reviewer" not "Added adversarial reviewer"
- **Scope prefixes:** `feat:`, `fix:`, `docs:`, `refactor:`, `test:`
- **One logical change per commit:** Don't mix new agents with prompt layer changes
- **Never commit secrets:** No API keys, tokens, or credentials in any file

## Versioning

We use [SemVer](https://semver.org/):
- **Major (5.0.0):** Breaking changes to command interface or agent protocol
- **Minor (4.1.0):** New agents, commands, or prompt layers
- **Patch (4.0.1):** Bug fixes, documentation updates, prompt improvements

Bump `VERSION` and update `plugin.json` version to match.

## Code of conduct

Be excellent to each other. This is a tool that makes other tools better — contributions that improve quality, thoroughness, or developer experience are always welcome.

## Questions?

Open an issue at https://github.com/ShaheerKhawaja/productupgrade/issues
