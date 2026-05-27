# OpenCode Skill Installation Standard

## Target Directories

Install user-level skills into:

```text
~/.config/opencode/skills/<skill-name>
```

Install project-level skills into:

```text
.opencode/skills/<skill-name>
```

Prefer user-level installation for personal workflow rules. Prefer project-level installation only when the project should carry the skill for every OpenCode user.

## Installation

### Using the Generic Installer (Recommended)

```bash
# Symlink install (default, updates automatically via git pull)
./skills/install-skill.sh --skill <skill-name> --tool opencode

# Copy install (standalone, manual reinstall needed for updates)
./skills/install-skill.sh --skill <skill-name> --tool opencode --copy

# Check status
./skills/install-skill.sh --skill <skill-name> --tool opencode --status

# Uninstall
./skills/install-skill.sh --skill <skill-name> --tool opencode --uninstall
```

### Manual Installation

```bash
# Symlink
ln -s /path/to/skills/skills/<skill-name> ~/.config/opencode/skills/<skill-name>

# Copy
cp -R /path/to/skills/skills/<skill-name> ~/.config/opencode/skills/<skill-name>
```

## Verification

```bash
# Verify all OpenCode skills
./skills/verify-skills.sh --tool opencode

# Verify a specific skill
./skills/verify-skills.sh --tool opencode --skill <skill-name> --verbose
```

## Update

For symlink installs, update the source repository and restart OpenCode:

```bash
cd /path/to/skills && git pull
./skills/verify-skills.sh --tool opencode
```

For copy installs, reinstall the skill:

```bash
./skills/install-skill.sh --skill <skill-name> --tool opencode --copy
```

## Troubleshooting

### Skill not appearing in OpenCode
- Restart OpenCode to reload skill cache
- Verify SKILL.md has correct frontmatter: `name` and `description`
- Check `~/.config/opencode/skills/<skill-name>/SKILL.md` exists

### Broken symlink
```bash
# Check link target
readlink ~/.config/opencode/skills/<skill-name>

# Reinstall
./skills/install-skill.sh --skill <skill-name> --tool opencode --uninstall
./skills/install-skill.sh --skill <skill-name> --tool opencode
```
