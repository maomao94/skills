# Qoder Skill Installation Standard

## Target Directories

| Scope | Directory |
| --- | --- |
| User-level | `~/.qoder/skills/<skill-name>` |
| Project-level | `.qoder/skills/<skill-name>` |

Prefer user-level installation for personal workflow rules. Use project-level installation only when the project should carry the skill for every Qoder user.

Do not assume Qoder reads `.agents/skills/` or any shared directory. Install to `.qoder/skills/` directly.

## Install

Use the generic installer from the skills repository root:

```bash
./skills/install-skill.sh --skill <skill-name> --tool qoder
./skills/install-skill.sh --skill <skill-name> --tool qoder --copy
./skills/install-skill.sh --skill <skill-name> --tool qoder --status
```

Manual install is a fallback only. Use stable absolute paths and avoid temporary directories.

```bash
ln -s /stable/source/skills/<skill-name> ~/.qoder/skills/<skill-name>
cp -R /stable/source/skills/<skill-name> ~/.qoder/skills/<skill-name>
```

## Verify

```bash
./skills/verify-skills.sh --tool qoder --skill <skill-name> --verbose
```

Restart or reload Qoder if it caches skill content.

## Reference

For symlink vs copy decisions, vendor source conventions, updates, and troubleshooting, read [../REFERENCE.md](../REFERENCE.md).
