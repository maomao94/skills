# OpenCode Skill Installation Standard

## Target Directories

| Scope | Directory |
| --- | --- |
| User-level | `~/.config/opencode/skills/<skill-name>` |
| Project-level | `.opencode/skills/<skill-name>` |

Prefer user-level installation for personal workflow rules. Use project-level installation only when the project should carry the skill for every OpenCode user.

## Install

Use the generic installer from the skills repository root:

```bash
./skills/install-skill.sh --skill <skill-name> --tool opencode
./skills/install-skill.sh --skill <skill-name> --tool opencode --copy
./skills/install-skill.sh --skill <skill-name> --tool opencode --status
```

Manual install is a fallback only. Use stable absolute paths and avoid temporary directories.

```bash
ln -s /stable/source/skills/<skill-name> ~/.config/opencode/skills/<skill-name>
cp -R /stable/source/skills/<skill-name> ~/.config/opencode/skills/<skill-name>
```

## Verify

```bash
./skills/verify-skills.sh --tool opencode --skill <skill-name> --verbose
```

Restart or reload OpenCode if it caches skill content.

## Reference

For symlink vs copy decisions, vendor source conventions, updates, and troubleshooting, read [../REFERENCE.md](../REFERENCE.md).
