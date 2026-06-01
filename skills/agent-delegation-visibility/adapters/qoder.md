# Qoder 安装指南

## 推荐安装

从个人技能包项目根目录执行：

```bash
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool qoder
```

默认安装到：

```text
~/.qoder/skills/agent-delegation-visibility
```

## 复制安装

```bash
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool qoder --copy
```

## 手动安装

```bash
mkdir -p ~/.qoder/skills
ln -s "$(pwd)/skills/agent-delegation-visibility" \
  ~/.qoder/skills/agent-delegation-visibility
```

## 验证

重启 Qoder 后，要求智能体加载 `agent-delegation-visibility`。之后每次使用子 agent 或后台任务前，应按 Notice Contract 说明委派对象、目的、方式和预期产物；不委派时说明具体原因；多步骤任务按 `[进度] N/M ...` 输出中文进度。
