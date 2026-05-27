# OpenCode 安装指南

## 推荐安装

从个人技能包项目根目录执行：

```bash
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool opencode
```

默认使用符号链接，方便后续通过 git 更新技能包。

## 复制安装

如果目标环境不适合符号链接：

```bash
./skills/agent-delegation-visibility/scripts/install-skill.sh --tool opencode --copy
```

## 手动安装

```bash
mkdir -p ~/.config/opencode/skills
ln -s "$(pwd)/skills/agent-delegation-visibility" \
  ~/.config/opencode/skills/agent-delegation-visibility
```

## 验证

重启 OpenCode 后，让智能体加载：

```text
使用 agent-delegation-visibility，以后调用子 agent 前先显式说明委派对象。
```

成功时，后续委派前应出现类似：

```text
委派：explore，目的：查项目内实现和配置，方式：background，预期：返回文件路径和结论。
```
