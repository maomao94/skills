# Codex 安装指南

## Codex 专用目录

Codex 从项目级 `.codex/skills/` 加载技能：

```bash
mkdir -p /path/to/project/.codex/skills
cp -R skills/agent-delegation-visibility \
  /path/to/project/.codex/skills/agent-delegation-visibility
```

每个 AI 工具使用自己的原生目录，不使用共享的 `.agents/skills/`。
