---
name: github-fork-pr
description: GitHub 协作与发布规范：PR 分支命名、职责隔离、主项目与 fork 项目的 tag/release 命名。Use when fork 仓库、提 PR 到上游、主项目打 tag、fork 项目打 tag、发 release、分支命名。
---

# GitHub PR 与发布协作规范

## 硬性约束

- PR 分支不写版本号——版本由合并时选的 target branch 决定
- PR 分支只做一件事，一个 commit，不允许交叉合并其他 PR 分支
- 不在 PR 分支上做合并——合并只在本地分支上进行
- merge 错方向先停止，不要带错继续；如需 `reset --hard`，必须先确认用户授权
- 涉及 `reset --hard`、`branch -D`、强推等破坏性操作时，必须先确认用户授权

## 使用本 skill 时

- 先判断用户是在处理上游 PR、本地 fork 集成、主项目发布，还是 fork 版本发布
- 用户说这是自有项目、主项目、源项目、非派生项目时，必须按主项目发布处理，不得使用 `-fork` tag
- 提 PR 时优先保护 PR 分支纯净：一个功能、一个分支、不要混入其他 PR 改动
- 发布任何版本时，Tag 是机器使用的版本坐标，Release 是人看的说明页
- 打 tag / release 前必须先由大模型判断项目身份、版本号、tag 名、release 标题和 notes 摘要，列给用户确认
- 只有用户明确回复 `可以`、`确认`、`就这样` 等批准后，才能执行 `git tag`、`git push <tag>` 或 `gh release create`
- Go 项目必须优先保证 tag 符合 semver；release 标题不参与 Go modules 解析
- Release notes 必须用真实 Markdown 换行；不要把包含字面量 `\n` 的字符串直接传给 `gh release create --notes`
- 如果用户混淆 tag 和 release，先解释两者关系，再给具体命名和命令

## 分支命名

| 分支模式 | 用途 | 示例 |
|---|---|---|
| `pr/<feature>` | 提往上游的单功能 PR | `pr/priority-lock` |
| `local/<version>` | 本地自用，合并所有 PR | `local/v4.1.8` |

PR 分支禁止合并其他 PR 分支；本地分支允许合入所有 `pr/*`。

## 流程 Checklist

创建 PR 分支：
1. 基于上游目标分支创建 `pr/<feature>`
2. 只包含该功能的改动，一个 commit
3. 编译/vet 通过后提交

创建本地集成分支：
1. 基于上游目标分支创建 `local/<version>`
2. 按需合并各 `pr/*` 分支
3. 编译/vet 通过

提 PR：
1. 选择上游对应 target branch
2. 确认 PR 分支干净（无其他 PR 的改动）
3. 确认 PR 分支名不含版本号

合并方向检查：
- 合并前确认：从哪个分支合并到哪个分支
- PR 分支之间禁止互相合并
- 合并仍在进行中 → 优先 `git merge --abort`
- merge commit 已生成 → 先解释风险，用户确认后再考虑 `git reset --hard HEAD~1`

## 回退操作

| 场景 | 命令 | 是否需要用户确认 |
|---|---|---|
| 放弃进行中的 merge | `git merge --abort` | 否 |
| 放弃进行中的 rebase | `git rebase --abort` | 否 |
| 从 commit 创建新分支 | `git branch <new> <commit>` | 否 |
| 撤销 merge commit | `git reset --hard HEAD~1` | 是 |
| 重置当前分支到另一个分支 | `git reset --hard <branch>` | 是 |
| 强制删本地分支 | `git branch -D <branch>` | 是 |

## Tag 与 Release

### 本质区别

| | Tag | Release |
|---|---|---|
| 作用 | 给代码“打坐标”，标记版本点 | 给人看的“发布页” |
| 面向 | 机器（Go / npm / Maven / CI） | 人（changelog、下载） |
| 内容 | 纯指针，指向某个 commit | 绑定一个 tag + 说明 + 产物 |
| 依赖解析 | Go / npm / Maven 只认 tag | 完全不参与依赖解析 |
| 命名约束 | 必须符合 semver 规则 | 完全自由 |

**Release = Tag + 说明书**

- Release 必须绑定一个 Tag，Tag 不依赖 Release（可以只有 tag，没有 release）
- 两者不需要完全一致——tag 是版本编号，release 是版本说明书

### 发布确认门禁

执行任何会创建或公开发布版本坐标的命令前，先输出候选方案并停止等待用户确认。

必须列出：
- 项目身份判断：主项目 / fork 项目 / 不确定
- 目标 commit：`<short-sha> <subject>`
- 建议 tag：例如 `v0.0.17`
- Release 标题：例如 `v0.0.17`
- Release notes 摘要：真实 Markdown 内容摘要
- 将执行的命令：只列命令，不执行

只有用户明确回复 `可以`、`确认`、`就这样`、`按这个发` 等批准语后，才能继续执行创建 tag、推送 tag 或创建 release。用户只是说“帮我看看 tag 是啥”“先看一下”“你决定下”时，只能分析和列方案，不能执行。


### Tag 命名（严格）

先确认项目身份，再决定 tag 格式：

| 项目身份 | Tag 格式 | 示例 | 适用场景 |
|---|---|---|---|
| 主项目 / 自有项目 / 非派生项目 | `v<MAJOR>.<MINOR>.<PATCH>` | `v0.0.17` | 正常发布当前项目的新版本 |
| fork 项目 / 派生项目 | `v<上游版本>-fork.<YYYYMMDDHHmmss>` | `v4.1.8-fork.20260101143020` | 基于上游版本发布自用 fork 坐标 |

主项目发布规则：
- 不加 `-fork`，除非用户明确说这是 fork 或派生项目。
- 优先查看已有 tag，按 semver 递增 patch/minor/major；不确定版本级别时先询问用户。
- 示例：已有最新 tag 为 `v0.0.16`，普通修复或小改动默认建议 `v0.0.17`。

fork 项目发布规则：
- 格式：上游版本 + `-fork` + `YYYYMMDDHHmmss`
- 日期时间合成一个数字标识符，避免 `HHmmss` 出现前导零导致 semver 非法
- 按字母序 = 按时间序，Go semver 兼容
- 不会和上游 tag 冲突

### Release 命名（自由）

推荐格式：
- 主项目：`v<版本> - <核心改动>` 或 `<项目名> v<版本>`
- fork 项目：`Fork v<上游版本> - <核心改动>`

| Release | 含义 |
|---|---|
| `v0.0.17 - Record journal` | 主项目普通版本 |
| `Fork v4.1.8 - Use error type fix + Priority lock` | fork 项目包含两个改动 |
| `Fork v4.1.8 - Add connection retry logic` | fork 项目单个改动 |

标题可以写成任何人类可读的形式，不影响任何依赖解析。

### 打 tag / Release 执行

下面命令只能在用户确认候选方案后执行。

```bash
# 主项目：按 semver 打正式 tag
git tag v0.0.17

# fork 项目：按上游版本 + fork 时间戳打 tag
git tag v4.1.8-fork.$(date +%Y%m%d%H%M%S)

# 用 gh 推送（绕过 HTTPS 超时问题）
RELEASE_NOTES=$(cat <<'EOF'
Fork release based on upstream v4.1.8.

Included changes:
- <改动 1>
- <改动 2>

Commit: <commit-sha>
EOF
)

gh release create <tag> \
  --repo <owner/repo> \
  --title "Fork v4.1.8 - <改动摘要>" \
  --notes "$RELEASE_NOTES"
```
