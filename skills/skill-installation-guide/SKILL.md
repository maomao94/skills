---
name: skill-installation-guide
description: Standardize installation of portable AI skills across OpenCode, Qoder, Cursor, Claude Code, Codex, and Gemini CLI. Use when adding a skill to this personal skills repository, installing skills into user or project directories, deciding copy vs symlink install modes, or troubleshooting skill discovery.
---

# Skill Installation Guide

Use this skill when packaging, installing, updating, or troubleshooting portable AI skills from this repository.

## Source Of Truth

- Edit repository source files under `skills/<skill-name>/`.
- Do not edit installed vendor copies directly.
- Prefer stable vendor checkouts for installed symlinks: `~/.skills/vendor/<repo-name>/skills/<skill-name>`.
- Development checkouts such as `~/PycharmProjects/skills` are for editing; vendor checkouts are for installation.
- If source changes must reach installed vendor skills, only commit/push/pull when the user explicitly asks.

## Native Directories

Each AI tool loads skills from its own native directory.

| Tool | User-level | Project-level |
| --- | --- | --- |
| OpenCode | `~/.config/opencode/skills/<skill>` | `.opencode/skills/<skill>` |
| Qoder | `~/.qoder/skills/<skill>` | `.qoder/skills/<skill>` |
| Cursor | - | `.cursor/skills/<skill>` |
| Claude Code | - | `.claude/skills/<skill>` |
| Codex | - | `.codex/skills/<skill>` |
| Gemini CLI | - | `.gemini/commands/<skill>` |

Rules:

- Do not use a shared `.agents/skills/` directory.
- Do not create platform directories in a project unless that project already uses the platform or the user explicitly asks.
- For project-level installs, target only the requested or detected tool.

## Install Mode Decision

Use symlink mode when:

- The user has a personal git checkout or vendor checkout.
- The user wants updates to flow from source edits or `git pull`.
- The machine can depend on the source checkout path.

Use copy mode when:

- The install must be standalone.
- The skill is distributed with a project.
- The target machine should not depend on the source checkout.

Default: symlink for personal workflows, copy for standalone or project distribution.

## Execution Rules

- First identify the target skill set, target tool set, install scope, install mode, and source path.
- If the user wants the personal skill pack installed broadly, prefer `--all-skills` and `--all-tools` over repeating per-skill commands.
- Prefer the repository's installer script over hand-written shell commands.
- Use absolute, stable paths for manual symlinks.
- Never symlink to temporary directories such as `/tmp` or `/var/folders/`.
- After install or update, verify `SKILL.md` is reachable from the target tool directory.
- Mention editor restart/reload if the tool may cache skill contents.
- Do not commit, push, or pull unless the user explicitly requests publishing or updating from remote.

## Command Templates

Generic installer:

```bash
./skills/install-skill.sh --skill <skill-name> --tool <tool>
./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy
./skills/install-skill.sh --skill <skill-name> --tool <tool> --project /path/to/project
./skills/install-skill.sh --skill <skill-name> --tool <tool> --status
./skills/install-skill.sh --all-skills --tool <tool>
./skills/install-skill.sh --all-skills --all-tools
./skills/install-skill.sh --all-skills --all-tools --project /path/to/project
```

Verification:

```bash
./skills/verify-skills.sh --tool <tool>
./skills/verify-skills.sh --tool <tool> --skill <skill-name> --verbose
```

Manual symlink fallback:

```bash
ln -s /stable/source/skills/<skill-name> ~/.config/opencode/skills/<skill-name>
```

## Packaging Rules

- `SKILL.md` must include frontmatter with `name` and `description`.
- The description must say when to use the skill.
- Keep platform-specific setup in `adapters/<tool>.md`.
- Put deterministic installers or validators in `scripts/`.
- Never store secrets, personal tokens, ledger data, or project runtime state inside a skill package.

## Reference

For detailed install workflows, update flows, troubleshooting, and adapter notes, read [REFERENCE.md](REFERENCE.md).
