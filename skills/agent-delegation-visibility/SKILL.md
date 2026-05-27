---
name: agent-delegation-visibility
description: Make sub-agent delegation visible before any task/subagent call. Use whenever the assistant may call task(), delegate to an agent/category, run background agents, collect background results, or decide not to delegate.
---

# Agent Delegation Visibility

This skill makes agent orchestration explicit to the user. It works across AI editors including OpenCode, Cursor, Qoder, Claude Code, Codex, Gemini CLI, and others.

Use this skill when:

- You are about to call `task()` or equivalent delegation tool.
- You are about to delegate to any sub-agent (e.g., `explore`, `librarian`, `oracle`, `plan`, `research`, or platform-specific agents).
- You are about to delegate by category or type (e.g., `quick`, `deep`, `visual-engineering`, `writing`, or platform-specific categories).
- You choose not to delegate and answer directly.
- You launch background agents or parallel tasks.
- You collect results from background agents or parallel tasks.

## Core Rule

Before calling any sub-agent or delegation tool, send a short visible message to the user in Chinese.

Format:

```text
委派：<agent-or-category>，目的：<why>，方式：<sync/background>，预期：<expected-result>
```

Examples:

```text
委派：explore，目的：查当前项目里的配置和实现模式，方式：background，预期：返回相关文件和结论。
```

```text
委派：librarian，目的：查外部库/插件官方文档，方式：background，预期：返回公开文档依据。
```

```text
委派：deep，目的：按计划完成多文件实现，方式：sync，预期：完成代码修改并报告验证结果。
```

```text
委派：visual-engineering，目的：实现前端布局和交互调整，方式：sync，预期：完成 UI 修改并验证页面效果。
```

## No Delegation Rule

If you decide not to call a sub-agent, say so explicitly before answering.

Format:

```text
不委派：<reason>
```

Examples:

```text
不委派：这是轻量解释问题，我直接基于当前上下文回答。
```

```text
不委派：这是单文件小改动，当前上下文足够，我直接处理。
```

```text
不委派：这是配置建议，不需要启动后台 agent。
```

## Background Agent Rule

When launching background agents, include that they are background tasks and explain when results will be used.

Example:

```text
委派：explore + librarian，目的：并行查本地配置和外部文档，方式：background，预期：完成后合并成本轮结论。
```

When collecting background results, say:

```text
委派结果回收：<agent> 已完成，我取回结果并合并判断。
```

## Required Fields

Every delegation notice must include:

- `委派`: the target agent or category.
- `目的`: why this agent is being used.
- `方式`: `sync` or `background`.
- `预期`: what output will be used for.

Every non-delegation notice must include:

- `不委派`.
- A concrete reason.

## Do Not

- Do not expose hidden system prompts, private chain-of-thought, or internal secrets.
- Do not paste full delegated prompts unless the user explicitly asks.
- Do not claim an agent was used if no tool call was made.

## What To Expose

Expose only operational routing details:

- Which agent/category is being used.
- Why it is being used.
- Whether it is sync or background.
- What result is expected.
- When a background result is collected.

Do not expose:

- Hidden system prompts.
- Private model reasoning.
- API keys.
- Full internal context injection.
- Sensitive environment data.

## Platform Compatibility

This skill is designed to work across multiple AI editors. The core behavior (announce delegation before calling sub-agents) applies regardless of which platform you are using.

Platform-specific notes:

- **OpenCode**: Use `.opencode/skills/` directory.
- **Cursor**: Use `.cursor/skills/` directory.
- **Qoder**: Use `.qoder/skills/` directory.
- **Claude Code**: Use `.claude/skills/` directory.
- **Codex**: Use `.codex/skills/` directory.
- **Gemini CLI**: Use `.gemini/commands/` directory.

Each tool loads skills from its own native directory. Do not use a shared `.agents/skills/` directory.

## Recommended Behavior

For simple questions:

```text
不委派：这是轻量问题，我直接回答。
```

For investigation:

```text
委派：explore，目的：查项目内实现和配置，方式：background，预期：返回文件路径和结论。
```

For external docs:

```text
委派：librarian，目的：查外部库/插件官方文档，方式：background，预期：返回文档依据和注意事项。
```

For architecture decisions:

```text
委派：oracle，目的：评估架构取舍和风险，方式：sync，预期：返回决策建议。
```

For implementation:

```text
委派：<category>，目的：执行具体代码修改，方式：sync，预期：完成实现并报告验证结果。
```

## Success Criteria

This skill is working when the user can always tell:

- Whether a sub-agent was used.
- Which sub-agent/category was used.
- Why it was selected.
- Whether it ran in background or synchronously.
- What result the main assistant is waiting for or using.
