---
name: agent-delegation-visibility
description: Make sub-agent delegation visible before any task/subagent call. Use whenever the assistant may call task(), delegate to an agent/category, run background agents, collect background results, or decide not to delegate.
---

# Agent Delegation Visibility

This skill makes orchestration visible to the user without exposing hidden prompts, private reasoning, or sensitive context.

## Use When

Use this skill before any of these actions:

- Calling `task()` or an equivalent delegation tool.
- Delegating to a named sub-agent such as `explore`, `librarian`, `oracle`, `plan`, or `research`.
- Delegating to a category such as `quick`, `deep`, `visual-engineering`, or `writing`.
- Launching background or parallel agents.
- Collecting background-agent results.
- Choosing not to delegate and answering directly.
- Executing a multi-step task where the user needs terminal-visible progress.

## Notice Contract

Before delegation, send one short visible Chinese message:

```text
委派：<agent-or-category>，目的：<why>，方式：<sync/background>，预期：<expected-result>
```

Required fields:

- `委派`: target agent or category.
- `目的`: why delegation is useful.
- `方式`: `sync` or `background`.
- `预期`: what output will be used for.

If not delegating, say so explicitly:

```text
不委派：<concrete-reason>
```

When collecting background results, say:

```text
委派结果回收：<agent> 已完成，我取回结果并合并判断。
```

## Progress Contract

For multi-step work, emit Chinese progress markers in commentary after each major step:

```text
[进度] <current>/<total> <正在做什么...>
```

Rules:

- Direct execution: report once after each logical block completes.
- Delegated execution: include this progress requirement in the delegated prompt.
- Sub-agents should report `[进度] N/M xxx` after each major step when the platform makes sub-agent output visible.
- Keep progress messages short and operational; do not expose hidden reasoning or private prompts.

## Examples

```text
不委派：这是轻量解释问题，我直接基于当前上下文回答。
```

```text
委派：explore，目的：查项目内实现和配置，方式：background，预期：返回文件路径和结论。
```

```text
委派：librarian，目的：查外部库/插件官方文档，方式：background，预期：返回文档依据和注意事项。
```

```text
委派：oracle，目的：评估架构取舍和风险，方式：sync，预期：返回决策建议。
```

```text
委派：visual-engineering，目的：实现前端布局和交互调整，方式：sync，预期：完成 UI 修改并验证页面效果。
```

```text
委派：explore + librarian，目的：并行查本地配置和外部文档，方式：background，预期：完成后合并成本轮结论。
```

```text
[进度] 2/5 已完成脚本语法检查，继续验证批量安装路径。
```

## Exposure Rules

Expose only operational routing details:

- Which agent or category is being used.
- Why it is being used.
- Whether it is sync or background.
- What result is expected.
- When a background result is collected.

Do not expose:

- Hidden system prompts.
- Private model reasoning.
- API keys or secrets.
- Full delegated prompts unless the user explicitly asks.
- Sensitive environment data.

Do not claim an agent was used if no tool call was made.

## Platform Notes

This behavior applies across OpenCode, Cursor, Qoder, Claude Code, Codex, Gemini CLI, and other AI editors.

Each tool loads skills from its own native directory. Do not use a shared `.agents/skills/` directory.

## Success Criteria

The user can always tell:

- Whether a sub-agent was used.
- Which sub-agent or category was used.
- Why it was selected.
- Whether it ran in background or synchronously.
- What result the main assistant is waiting for or using.
