# Claude Code 安装指南

## 项目级安装

```bash
mkdir -p /path/to/project/.claude/skills
cp -R skills/agent-delegation-visibility \
  /path/to/project/.claude/skills/agent-delegation-visibility
```

如果你维护个人级 Claude Code skills，可以将同一目录复制或链接到你的个人 skills 目录。

## 验证

重新打开 Claude Code 会话后，让智能体加载 `agent-delegation-visibility`。之后在调用 sub-agent、Task 或后台代理前，应先用中文说明委派对象、目的、方式和预期结果。
