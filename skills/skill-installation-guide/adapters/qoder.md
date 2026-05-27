# Qoder Skill Installation Standard

## Target Directories

Install user-level skills into:

```text
~/.qoder/skills/<skill-name>
```

Install project-level skills into:

```text
.qoder/skills/<skill-name>
```

Prefer user-level installation for personal workflow rules. Prefer project-level installation only when the project should carry the skill for every Qoder user.

Do not assume Qoder reads `.agents/skills/` or any shared directory. Install to `.qoder/skills/` directly.

## Installation

### Using the Generic Installer (Recommended)

```bash
# Symlink install (default, updates automatically via git pull)
./skills/install-skill.sh --skill <skill-name> --tool qoder

# Copy install (standalone, manual reinstall needed for updates)
./skills/install-skill.sh --skill <skill-name> --tool qoder --copy

# Check status
./skills/install-skill.sh --skill <skill-name> --tool qoder --status

# Uninstall
./skills/install-skill.sh --skill <skill-name> --tool qoder --uninstall
```

### Manual Installation

```bash
# Symlink
ln -s /path/to/skills/skills/<skill-name> ~/.qoder/skills/<skill-name>

# Copy
cp -R /path/to/skills/skills/<skill-name> ~/.qoder/skills/<skill-name>
```

## Verification

```bash
# Verify all Qoder skills
./skills/verify-skills.sh --tool qoder

# Verify a specific skill
./skills/verify-skills.sh --tool qoder --skill <skill-name> --verbose
```

## Update

For symlink installs, update the source repository and restart Qoder:

```bash
cd /path/to/skills && git pull
./skills/verify-skills.sh --tool qoder
```

For copy installs, reinstall the skill:

```bash
./skills/install-skill.sh --skill <skill-name> --tool qoder --copy
```

## Troubleshooting

### Skill not appearing in Qoder
- Restart Qoder to reload skill cache
- Verify SKILL.md has correct frontmatter: `name` and `description`
- Check `~/.qoder/skills/<skill-name>/SKILL.md` exists

### Broken symlink
```bash
# Check link target
readlink ~/.qoder/skills/<skill-name>

# Reinstall
./skills/install-skill.sh --skill <skill-name> --tool qoder --uninstall
./skills/install-skill.sh --skill <skill-name> --tool qoder
```
