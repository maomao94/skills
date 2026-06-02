# Skills

个人技能包仓库，用于集中管理可复用的 AI 工具技能、安装规则、协作规范和自动化脚本。

## 项目定位

这是一个面向个人工作流的技能包仓库。它把多个 AI 编辑器使用的技能放在同一个 git 仓库里维护，通过 symlink/copy 安装到各编辑器原生目录，让一次仓库更新可以同步到 OpenCode、Qoder、Cursor、Claude Code、Codex、Gemini CLI 等工具。

当前技能覆盖三类核心场景：技能安装规则、GitHub 协作与发布规范、AI 子智能体委派通知。

## 核心功能

- **多编辑器支持**：优先适配 OpenCode 和 Qoder，支持 Claude Code、Cursor、Codex、Gemini CLI 等
- **一次维护，多端安装**：所有技能在一个 git 仓库维护，可批量安装到一个或多个 AI 编辑器
- **Agent 调度可见性**：在调用子 agent / 后台任务前显式说明委派对象、目的和预期，并在终端回收结果时提示
- **技能安装规范**：统一 OpenCode、Qoder、Cursor、Claude Code、Codex、Gemini CLI 等工具的原生目录和 copy/symlink 策略
- **GitHub 协作与发布规范**：规范 PR 分支、本地集成分支、主项目与 fork 项目的 tag/release 命名

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
| [github-fork-pr](skills/github-fork-pr/SKILL.md) | Standardize GitHub PR branches, local integration branches, and main/fork tag/release naming. |
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

# Install all skills to one editor
./skills/install-skill.sh --all-skills --tool opencode

# Install all skills to all user-level editors (OpenCode and Qoder by default)
./skills/install-skill.sh --all-skills --all-tools

# Install all skills to all supported project-level editor directories
./skills/install-skill.sh --all-skills --all-tools --project /path/to/project
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
