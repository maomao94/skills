---
name: skill-installation-guide
description: Standardize installation of portable AI skills across OpenCode, Qoder, Cursor, Claude Code, Codex, and Gemini CLI. Each tool uses its own native skill directory. Use when adding a skill to this personal skills repository, installing skills into user or project directories, or deciding copy vs symlink install modes.
---

# Skill Installation Guide

Use this skill when packaging or installing skills from the personal skills repository.

## Repository Layout

Portable skills live under:

```text
skills/<skill-name>/
├── SKILL.md
├── adapters/
└── scripts/
```

Use `skills/<tool>/<skill-name>` only as a compatibility entry, normally a symlink back to `../<skill-name>` or `../../<skill-name>` depending on depth.

## Install Directory Matrix

Each AI tool has its own native skill directory. Install skills into the appropriate directory for the target tool.

| Tool | User-level directory | Project-level directory |
| --- | --- | --- |
| OpenCode | `~/.config/opencode/skills/<skill>` | `.opencode/skills/<skill>` |
| Qoder | `~/.qoder/skills/<skill>` | `.qoder/skills/<skill>` |
| Cursor | — | `.cursor/skills/<skill>` |
| Claude Code | — | `.claude/skills/<skill>` |
| Codex | — | `.codex/skills/<skill>` |
| Gemini CLI | — | `.gemini/commands/<skill>` |

Do not use a shared `.agents/skills/` directory. Each tool loads skills from its own directory. Install to each tool's native directory individually.

Do not create platform directories in a project unless that project already uses the platform or the user explicitly asks for that platform.

## Install Modes

### Symlink Installation (Recommended for Personal Development)

Symlink installation creates a symbolic link from the AI editor's skill directory to the source skill directory. This is the recommended approach for personal development because:

- **Automatic updates**: When you update the source repository (e.g., `git pull`), all symlinked skills are automatically updated
- **Single source of truth**: All skills are maintained in one location
- **Easy management**: Install, update, and uninstall operations are centralized

```bash
# Using the generic installer (recommended)
./skills/install-skill.sh --skill <skill-name> --tool opencode

# Manual symlink creation
ln -s /path/to/skills/skills/<skill> ~/.config/opencode/skills/<skill>
```

### Copy Installation (For Standalone Distribution)

Copy installation creates a complete copy of the skill in the AI editor's skill directory. Use this approach when:

- **Standalone machines**: Machines that should not depend on the source checkout
- **Project distribution**: When distributing skills as part of a project
- **Offline usage**: When the source repository is not available

```bash
# Using the generic installer (recommended)
./skills/install-skill.sh --skill <skill-name> --tool opencode --copy

# Manual copy
cp -R /path/to/skills/skills/<skill> ~/.config/opencode/skills/<skill>
```

### Comparison Table

| Aspect | Symlink | Copy |
|--------|---------|------|
| **Updates** | Automatic via `git pull` | Manual reinstall required |
| **Source dependency** | Requires source repository | Independent after install |
| **Disk space** | Minimal (link only) | Full copy |
| **Use case** | Personal development | Standalone distribution |

### Default Symlink Source Directory

When installing skills via symlink and no explicit `--source` path is given, follow the vendor convention:

```text
~/.skills/vendor/<repo-name>/skills/<skill-name>
```

This keeps all skill sources under a single vendor tree and avoids scattered clones. The convention:

- Clone or maintain skill repositories under `~/.skills/vendor/`
- For example, the `maomao94/skills` repo lives at `~/.skills/vendor/maomao94-skills`
- When the user does not specify `--source`, default to resolving the source from `~/.skills/vendor/<repo-name>/skills/<skill-name>`

If `~/.skills/vendor/<repo-name>` does not exist, fall back to the repository-relative path (the directory containing `skills/install-skill.sh`). Prefer the vendor convention over random temp directories to keep symlinks stable across reboots and session restarts.

## Generic Installation Script

The repository provides a generic installation script `skills/install-skill.sh` that supports all AI tools and installation modes.

### Basic Usage

```bash
# Install a skill (symlink by default)
./skills/install-skill.sh --skill <skill-name> --tool <tool>

# Install with copy mode
./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy

# Install to project-level directory
./skills/install-skill.sh --skill <skill-name> --tool cursor --project /path/to/project

# Check installation status
./skills/install-skill.sh --skill <skill-name> --tool <tool> --status

# Uninstall a skill
./skills/install-skill.sh --skill <skill-name> --tool <tool> --uninstall
```

### Supported Tools

- `opencode` - OpenCode editor (~/.config/opencode/skills/)
- `qoder` - Qoder editor (~/.qoder/skills/)
- `cursor` - Cursor editor (.cursor/skills/)
- `claude-code` - Claude Code editor (.claude/skills/)
- `codex` - Codex editor (.codex/skills/)
- `gemini-cli` - Gemini CLI editor (.gemini/commands/)

### Examples

```bash
# Install agent-delegation-visibility to OpenCode
./skills/install-skill.sh --skill agent-delegation-visibility --tool opencode

# Install to Qoder with copy mode
./skills/install-skill.sh --skill agent-delegation-visibility --tool qoder --copy

# Install to a project's .cursor/skills directory
./skills/install-skill.sh --skill skill-installation-guide --tool cursor --project /path/to/project

# Check if a skill is installed
./skills/install-skill.sh --skill agent-delegation-visibility --tool opencode --status
```

## Verification Script

The repository provides a verification script `skills/verify-skills.sh` to check the health of installed skills.

### Basic Usage

```bash
# Verify all installed skills
./skills/verify-skills.sh

# Verify skills for a specific tool
./skills/verify-skills.sh --tool opencode

# Verify a specific skill across all tools
./skills/verify-skills.sh --skill caveman

# Verbose output with detailed information
./skills/verify-skills.sh --verbose
```

### What It Checks

- **Symlink validity**: Ensures symlinks point to existing directories
- **SKILL.md presence**: Verifies each skill has a SKILL.md file
- **Directory structure**: Checks for adapters and scripts directories
- **Installation type**: Identifies symlink vs copy installations

## Update Workflow

### For Symlink Installations

1. **Update the source repository**:
   ```bash
   cd /path/to/skills
   git pull
   ```

2. **Verify the update**:
   ```bash
   ./skills/verify-skills.sh --tool opencode
   ```

3. **Refresh the AI editor**: Restart or reload the AI editor to pick up changes

### For Copy Installations

1. **Reinstall the skill**:
   ```bash
   ./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy
   ```

2. **Verify the update**:
   ```bash
   ./skills/verify-skills.sh --tool opencode --skill <skill-name>
   ```

3. **Refresh the AI editor**: Restart or reload the AI editor

## Refreshing Skills

### Symlink Installations

For symlink installations, refreshing is typically not needed because:

- Symlinks automatically reflect changes in the source directory
- The AI editor reads the skill files through the symlink
- Changes are immediate after saving files in the source directory

If a skill doesn't appear to update:

1. **Verify the symlink is valid**:
   ```bash
   ./skills/verify-skills.sh --tool opencode --skill <skill-name> --verbose
   ```

2. **Check file permissions**: Ensure the source files are readable

3. **Restart the AI editor**: Some editors cache skill contents

### Copy Installations

For copy installations, refreshing requires reinstallation:

1. **Reinstall the skill**:
   ```bash
   ./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy
   ```

2. **Verify the installation**:
   ```bash
   ./skills/verify-skills.sh --tool opencode --skill <skill-name>
   ```

## Git Install Workflow

When this repository is used as a git-backed skill source:

```bash
# Clone the repository into the vendor directory (recommended)
git clone <skills-repo-url> ~/.skills/vendor/<repo-name>
cd ~/.skills/vendor/<repo-name>

# Install a skill (symlink by default, resolves from current dir or ~/.skills/vendor/)
./skills/install-skill.sh --skill agent-delegation-visibility --tool opencode

# Update all skills
git pull
./skills/verify-skills.sh

# Install multiple skills
for skill in agent-delegation-visibility skill-installation-guide; do
  ./skills/install-skill.sh --skill "$skill" --tool opencode
done
```

## Packaging Rules

- `SKILL.md` must include frontmatter with `name` and `description`.
- The description must say when to use the skill.
- Keep platform-specific setup in `adapters/<tool>.md`.
- Put deterministic installers or validators in `scripts/`.
- Never store secrets, personal tokens, ledger data, or project runtime state inside a skill package.
- Do not edit Trellis-managed blocks when installing skills into Trellis projects.

## AI Model Guidance

This section is for AI assistants helping users install skills. Follow these patterns when a user asks you to set up skills.

### 1. Auto-detect Location

First, detect which AI tool you are running in. Look for:

| Sign | Tool |
|------|------|
| `~/.config/opencode/` exists or `.opencode/` dir in project | OpenCode |
| `.claude/` dir or Claude config files present | Claude Code |
| `.cursor/` dir or `.cursorrules` file present | Cursor |
| `.codex/` dir present | Codex |
| `.qoder/` dir present | Qoder |

### 2. Choose Installation Mode

- **User has a local clone of the skills repo**: Use symlink install (`ln -s` / `--link`). Prefer cloning to `~/.skills/vendor/<repo-name>` for stable symlinks.
- **User wants one-time setup, no git repo**: Use copy install (`cp -R` / `--copy`)
- **Project-level install**: Install to `.opencode/skills/`, `.claude/skills/`, etc. under the project root

### 3. Determine Source Path

When using symlink install, determine the source path:

1. If user has a local checkout, use that path directly
2. If the repo exists under `~/.skills/vendor/<repo-name>`, use that
3. If neither, clone to `~/.skills/vendor/<repo-name>` first, then symlink from there

Never symlink to temporary directories (e.g., `/tmp`, `/var/folders/`). Symlinks must point to stable, persistent paths.

### 4. Run Installation

For symlink (most common):

```bash
# Clone if needed to vendor directory
git clone <skills-repo-url> ~/.skills/vendor/<repo-name> 2>/dev/null || true

# Symlink into OpenCode (prefer absolute paths)
ln -sfn ~/.skills/vendor/<repo-name>/skills/<skill-name> ~/.config/opencode/skills/<skill-name>

# Verify
ls -la ~/.config/opencode/skills/<skill-name>/SKILL.md
```

Or use the generic installer:

```bash
cd ~/.skills/vendor/<repo-name>
./skills/install-skill.sh --skill <skill-name> --tool opencode
```

### 5. Verify Installation

After installing, always verify:

```bash
# Check the SKILL.md is accessible
test -f ~/.config/opencode/skills/<skill-name>/SKILL.md && echo "installed" || echo "missing"
```

### 6. Batch Install All Skills

```bash
for skill in agent-delegation-visibility skill-installation-guide; do
  ./skills/install-skill.sh --skill "$skill" --tool opencode
done
```

### Recommended Install Command (Quick Start)

Tell the user to run:

```bash
git clone <skills-repo-url> ~/.skills/vendor/<repo-name> && cd ~/.skills/vendor/<repo-name> && \
for skill in agent-delegation-visibility skill-installation-guide; do
  ./skills/install-skill.sh --skill "$skill" --tool opencode
done
```

If they don't have git or prefer copy mode:

```bash
# Copy SKILL.md directly (simplest approach)
mkdir -p ~/.config/opencode/skills/<skill-name>
cp /path/to/skills/skills/<skill-name>/SKILL.md ~/.config/opencode/skills/<skill-name>/
```

## Troubleshooting

### Skill Not Found

If a skill doesn't appear in the AI editor:

1. **Check installation status**:
   ```bash
   ./skills/install-skill.sh --skill <skill-name> --tool <tool> --status
   ```

2. **Verify the skill directory**:
   ```bash
   ls -la ~/.config/opencode/skills/<skill-name>
   ```

3. **Check SKILL.md exists**:
   ```bash
   test -f ~/.config/opencode/skills/<skill-name>/SKILL.md && echo "OK" || echo "Missing"
   ```

### Broken Symlinks

If a symlink is broken:

1. **Check the target**:
   ```bash
   readlink ~/.config/opencode/skills/<skill-name>
   ls -la $(readlink ~/.config/opencode/skills/<skill-name>)
   ```

2. **Reinstall the skill**:
   ```bash
   ./skills/install-skill.sh --skill <skill-name> --tool <tool> --uninstall
   ./skills/install-skill.sh --skill <skill-name> --tool <tool>
   ```

### Permission Issues

If you encounter permission errors:

1. **Check file permissions**:
   ```bash
   ls -la ~/.config/opencode/skills/
   ```

2. **Fix permissions if needed**:
   ```bash
   chmod -R 755 ~/.config/opencode/skills/<skill-name>
   ```

### Editor Not Loading Skills

If the AI editor doesn't load installed skills:

1. **Restart the editor**: Some editors cache skill contents
2. **Check editor configuration**: Ensure the editor is configured to load skills from the correct directory
3. **Verify skill format**: Ensure SKILL.md has the correct frontmatter
