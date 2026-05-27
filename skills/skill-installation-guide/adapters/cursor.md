# Cursor Skill Installation Standard

Prefer project-level installation:

```text
.cursor/skills/<skill-name>
```

If a project does not already use `.cursor/`, do not create it unless the user explicitly wants Cursor support in that project.

For portable skills from this repository:

```bash
mkdir -p /path/to/project/.cursor/skills
cp -R skills/<skill-name> /path/to/project/.cursor/skills/<skill-name>
```
