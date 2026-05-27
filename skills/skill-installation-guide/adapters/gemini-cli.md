# Gemini CLI Skill Installation Standard

Install into the Gemini CLI commands directory:

```text
.gemini/commands/
```

If the Gemini setup uses commands instead of skills, preserve the same behavior in `.gemini/commands/` and keep the canonical rules in `skills/<skill-name>/SKILL.md`.

Do not use a shared `.agents/skills/` directory. Each tool loads skills from its own native directory.
