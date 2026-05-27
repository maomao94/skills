# Cursor 安装指南

## 推荐项目级安装

Cursor 项目级技能目录通常放在当前项目内：

```text
.cursor/skills/agent-delegation-visibility/SKILL.md
```

从个人技能包项目根目录复制：

```bash
mkdir -p /path/to/project/.cursor/skills
cp -R skills/agent-delegation-visibility \
  /path/to/project/.cursor/skills/agent-delegation-visibility
```

如果你的 Cursor 环境支持用户级或共享 skill 目录，也可以改用符号链接。

## 验证

重启 Cursor 或刷新 agent 上下文后，要求智能体遵守 `agent-delegation-visibility`。如果未自动加载，手动引用该 skill 文件或把规则加入项目的 Cursor skill/command 入口。
