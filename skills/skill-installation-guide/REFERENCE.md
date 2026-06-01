# Skill Installation Guide Reference

This file keeps detailed installation, update, verification, and troubleshooting notes. Keep `SKILL.md` short and prompt-like; put expanded operational detail here.

## Repository Layout

Portable skills live under:

```text
skills/<skill-name>/
├── SKILL.md
├── adapters/
└── scripts/
```

Use `skills/<tool>/<skill-name>` only as a compatibility entry, normally a symlink back to `../<skill-name>` or `../../<skill-name>` depending on depth.

## Native Skill Directories

| Tool | User-level directory | Project-level directory |
| --- | --- | --- |
| OpenCode | `~/.config/opencode/skills/<skill>` | `.opencode/skills/<skill>` |
| Qoder | `~/.qoder/skills/<skill>` | `.qoder/skills/<skill>` |
| Cursor | - | `.cursor/skills/<skill>` |
| Claude Code | - | `.claude/skills/<skill>` |
| Codex | - | `.codex/skills/<skill>` |
| Gemini CLI | - | `.gemini/commands/<skill>` |

Do not use a shared `.agents/skills/` directory. Each tool loads skills from its own native directory.

Do not create platform directories in a project unless that project already uses the platform or the user explicitly asks for that platform.

## Install Modes

### Symlink Installation

Recommended for personal development. A symlink points from the AI editor's native skill directory to the source skill directory.

Use symlink mode when:

- The user has a stable local clone of the skills repository.
- The user wants updates to appear after `git pull` in the source repository.
- The install is for a personal machine rather than a standalone distribution.

Example:

```bash
./skills/install-skill.sh --skill <skill-name> --tool opencode
```

Manual example:

```bash
ln -s /path/to/skills/skills/<skill> ~/.config/opencode/skills/<skill>
```

### Copy Installation

Recommended for standalone distribution, project distribution, or machines that should not depend on the source checkout.

Example:

```bash
./skills/install-skill.sh --skill <skill-name> --tool opencode --copy
```

Manual example:

```bash
cp -R /path/to/skills/skills/<skill> ~/.config/opencode/skills/<skill>
```

### Comparison

| Aspect | Symlink | Copy |
| --- | --- | --- |
| Updates | Automatic via source checkout updates | Manual reinstall required |
| Source dependency | Requires source repository | Independent after install |
| Disk space | Minimal | Full copy |
| Use case | Personal development | Standalone distribution |

## Source Directory Convention

When installing skills via symlink and no explicit `--source` path is given, prefer the vendor convention:

```text
~/.skills/vendor/<repo-name>/skills/<skill-name>
```

This keeps all skill sources under a single vendor tree and avoids scattered clones.

Rules:

- Clone or maintain skill repositories under `~/.skills/vendor/`.
- Example: `~/.skills/vendor/maomao94-skills`.
- If `~/.skills/vendor/<repo-name>` does not exist, fall back to the repository-relative path containing `skills/install-skill.sh`.
- Never symlink to temporary directories such as `/tmp` or `/var/folders/`.
- Development checkouts such as `~/PycharmProjects/skills` are for editing. Vendor checkouts are for installed symlinks.

## Generic Installer

The repository provides `skills/install-skill.sh`.

Basic usage:

```bash
# Install a skill, symlink by default
./skills/install-skill.sh --skill <skill-name> --tool <tool>

# Install with copy mode
./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy

# Install to a project-level directory
./skills/install-skill.sh --skill <skill-name> --tool cursor --project /path/to/project

# Check installation status
./skills/install-skill.sh --skill <skill-name> --tool <tool> --status

# Uninstall a skill
./skills/install-skill.sh --skill <skill-name> --tool <tool> --uninstall
```

Supported `--tool` values:

- `opencode`
- `qoder`
- `cursor`
- `claude-code`
- `codex`
- `gemini-cli`

## Verification

Use `skills/verify-skills.sh` to check installed skills.

```bash
# Verify all installed skills
./skills/verify-skills.sh

# Verify skills for one tool
./skills/verify-skills.sh --tool opencode

# Verify one skill across tools
./skills/verify-skills.sh --skill <skill-name>

# Verbose output
./skills/verify-skills.sh --verbose
```

The verifier checks symlink validity, `SKILL.md` presence, directory structure, and installation type.

## Update Workflow

### Symlink Installations

1. Update the source repository.
2. Run `./skills/verify-skills.sh --tool <tool>`.
3. Restart or reload the AI editor if it caches skill content.

Symlinked skills automatically reflect source-file changes. No reinstall is needed unless the symlink target changes.

### Copy Installations

1. Update the source repository.
2. Reinstall with `./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy`.
3. Verify with `./skills/verify-skills.sh --tool <tool> --skill <skill-name>`.
4. Restart or reload the AI editor if needed.

### Development Checkout To Vendor Checkout

When a user edits a separate development checkout and wants installed vendor skills to update:

1. Confirm the user wants to publish the dev checkout changes.
2. Only commit or push if the user explicitly asks.
3. After the remote is updated, pull in the vendor checkout.
4. Verify installed skills.

Never edit files directly in the installed vendor copy when the repository source file is the canonical source of truth.

## Packaging Rules

- `SKILL.md` must include frontmatter with `name` and `description`.
- The description must say when to use the skill.
- Keep platform-specific setup in `adapters/<tool>.md`.
- Put deterministic installers or validators in `scripts/`.
- Never store secrets, personal tokens, ledger data, or project runtime state inside a skill package.
- Do not edit Trellis-managed blocks when installing skills into Trellis projects.

## AI Assistant Workflow

When helping users install skills:

1. Detect the target AI tool from explicit user wording or project/user directories.
2. Decide user-level vs project-level install.
3. Decide symlink vs copy.
4. Resolve a stable source path, preferably under `~/.skills/vendor/<repo-name>`.
5. Run or provide the install command.
6. Verify the install.
7. Explain whether editor restart/reload may be needed.

Signals for tool detection:

| Sign | Tool |
| --- | --- |
| `~/.config/opencode/` or `.opencode/` | OpenCode |
| `.claude/` | Claude Code |
| `.cursor/` or `.cursorrules` | Cursor |
| `.codex/` | Codex |
| `.qoder/` | Qoder |

## Troubleshooting

### Skill Not Found

Check installation status:

```bash
./skills/install-skill.sh --skill <skill-name> --tool <tool> --status
```

Check the expected directory and `SKILL.md`:

```bash
ls -la ~/.config/opencode/skills/<skill-name>
test -f ~/.config/opencode/skills/<skill-name>/SKILL.md
```

### Broken Symlink

Check the target:

```bash
readlink ~/.config/opencode/skills/<skill-name>
ls -la $(readlink ~/.config/opencode/skills/<skill-name>)
```

Reinstall if needed:

```bash
./skills/install-skill.sh --skill <skill-name> --tool <tool> --uninstall
./skills/install-skill.sh --skill <skill-name> --tool <tool>
```

### Permission Issues

Check file permissions:

```bash
ls -la ~/.config/opencode/skills/
```

Fix permissions only if needed:

```bash
chmod -R 755 ~/.config/opencode/skills/<skill-name>
```

### Editor Not Loading Skills

1. Restart or reload the editor.
2. Check editor configuration.
3. Verify `SKILL.md` frontmatter.
4. Confirm the skill is installed in that editor's native directory.
