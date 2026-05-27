# Skills

个人技能包仓库，用于管理和分享各种 AI 工具的使用技能、自动化脚本和最佳实践。

## 项目定位

这是一个技能包仓库，为不同的 AI 编辑器和工具提供统一的技能管理和使用体验。当前包含 **Agent Delegation Visibility** 和 **Skill Installation Guide** 等技能包，用于统一管理多 AI 编辑器下的个人工作流、安装规范和 agent 可见性。

## 核心功能

- **多编辑器支持**：优先适配 OpenCode 和 Qoder，支持 Claude Code、Cursor、Copilot、Codex、Gemini CLI 等
- **Agent 调度可见性**：在调用子 agent / 后台任务前显式说明委派对象、目的和预期
- **技能安装规范**：统一 OpenCode、Qoder、Cursor、Claude Code、Codex、Gemini CLI 等工具的技能安装目录和 copy/symlink 策略

## AI Tool Skills

Reusable skill packages live under `skills/<skill-name>/`:

```text
skills/<skill-name>/
├── SKILL.md               # Core skill documentation
├── adapters/              # Tool-specific installation guides
└── scripts/               # Optional automation scripts
```

Current skill packages:

| Skill | Purpose |
|-------|---------|
| [agent-delegation-visibility](skills/agent-delegation-visibility/SKILL.md) | Make sub-agent delegation visible before `task()` / background agent calls. |
| [skill-installation-guide](skills/skill-installation-guide/SKILL.md) | Standardize skill installation directories and copy/symlink strategy across AI editors. |

### Installation

Choose the adapter guide for the target AI tool. Most skills include guides for OpenCode, Qoder, Cursor, Claude Code, Codex, and Gemini CLI.

Common targets:

| AI Tool | User-level | Project-level |
|---------|-----------|---------------|
| OpenCode | `~/.config/opencode/skills/<skill>` | `.opencode/skills/<skill>` |
| Qoder | `~/.qoder/skills/<skill>` | `.qoder/skills/<skill>` |
| Cursor | — | `.cursor/skills/<skill>` |
| Claude Code | — | `.claude/skills/<skill>` |
| Codex | — | `.codex/skills/<skill>` |
| Gemini CLI | — | `.gemini/commands/<skill>` |

Each AI tool loads skills from its own native directory. Do not use a shared `.agents/skills/` directory — install to each tool's native path instead.

Prefer symlink installs for a personal git checkout, and copy installs for standalone project distribution.

### Skill Installation

Use the generic installer to install any skill from this repository:

```bash
# Symlink install (default, updates automatically via git pull)
./skills/install-skill.sh --skill <skill-name> --tool <tool>

# Copy install (standalone, manual reinstall for updates)
./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy

# Check installation status
./skills/install-skill.sh --skill <skill-name> --tool <tool> --status

# Uninstall
./skills/install-skill.sh --skill <skill-name> --tool <tool> --uninstall

# List all available skills in this repository
./skills/install-skill.sh --list
```

Each skill also has its own installer script for convenience:

```bash
# Install Agent Delegation Visibility to OpenCode with a symlink
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool opencode

# Install to Qoder by copying files
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool qoder --copy

# Install to a project's .cursor/skills directory
./skills/agent-delegation-visibility/scripts/install-skill.sh \
  --tool cursor \
  --project /path/to/project

# Uninstall from OpenCode
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool opencode --uninstall
```

Verify installed skills:

```bash
# Check all installed skills
./skills/verify-skills.sh

# Check only OpenCode skills
./skills/verify-skills.sh --tool opencode

# Detailed check on a specific skill
./skills/verify-skills.sh --tool opencode --skill <skill> --verbose
```

Update skills:

```bash
# For symlink installs: pull the repo and verify
git pull && ./skills/verify-skills.sh

# For copy installs: reinstall
./skills/install-skill.sh --skill <skill-name> --tool <tool> --copy
```

For skills without an installer, follow the target tool adapter under `skills/<skill>/adapters/`.

## Push To Your Own Remote

```bash
cd /path/to/your/skills
git init
git add README.md skills
git commit -m "feat: initialize skills"
git remote add origin <your-repository-url>
git push -u origin main
```
