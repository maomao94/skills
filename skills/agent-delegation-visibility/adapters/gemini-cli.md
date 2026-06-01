# Gemini CLI 安装指南

## Gemini 专用入口

Gemini CLI 使用 `.gemini/commands/` 目录。把核心规则整理成命令或 prompt 文件，保持语义与 `SKILL.md` 一致。

```bash
mkdir -p /path/to/project/.gemini/commands
cp -R skills/agent-delegation-visibility \
  /path/to/project/.gemini/commands/agent-delegation-visibility
```

每个 AI 工具使用自己的原生目录，不使用共享的 `.agents/skills/`。

## 验证

刷新 Gemini CLI 会话后，让智能体按 `agent-delegation-visibility` 的 Notice Contract 执行：委派前说明，不委派时说明，回收后台结果时说明，多步骤任务按 `[进度] N/M ...` 输出中文进度。
