---
name: github-fork-pr
description: Fork 仓库协作规范：PR 分支命名、职责隔离、合并流程、tag/release 命名。Use when fork 仓库、提 PR 到上游、打 tag、发 release、分支命名。
---

# GitHub Fork PR 协作规范

## 硬性约束

- PR 分支不写版本号——版本由合并时选的 target branch 决定
- PR 分支只做一件事，一个 commit，不允许交叉合并其他 PR 分支
- 不在 PR 分支上做合并——合并只在本地分支上进行
- merge 错方向先停止，不要带错继续；如需 `reset --hard`，必须先确认用户授权
- 涉及 `reset --hard`、`branch -D`、强推等破坏性操作时，必须先确认用户授权

## 使用本 skill 时

- 先判断用户是在处理上游 PR、本地 fork 集成，还是 fork 版本发布
- 提 PR 时优先保护 PR 分支纯净：一个功能、一个分支、不要混入其他 PR 改动
- 发布 fork 版本时，Tag 是机器使用的版本坐标，Release 是人看的说明页
- Go 项目必须优先保证 tag 符合 semver；release 标题不参与 Go modules 解析
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

### Tag 命名（严格）

Tag：`v<上游版本>-fork.<YYYYMMDDHHmmss>`

| Tag | 含义 |
|---|---|
| `v4.1.8-fork.20260101143020` | 基于上游 v4.1.8，2026-01-01 14:30:20 发布 |
| `v4.1.8-fork.20260115091500` | 基于上游 v4.1.8，2026-01-15 09:15:00 发布 |

- 格式：上游版本 + `-fork` + `YYYYMMDDHHmmss`
- 日期时间合成一个数字标识符，避免 `HHmmss` 出现前导零导致 semver 非法
- 按字母序 = 按时间序，Go semver 兼容
- 不会和上游 tag 冲突

### Release 命名（自由）

推荐格式：`Fork v<上游版本> - <核心改动>`

| Release | 含义 |
|---|---|
| `Fork v4.1.8 - Use error type fix + Priority lock` | 包含两个改动 |
| `Fork v4.1.8 - Add connection retry logic` | 单个改动 |

标题可以写成任何人类可读的形式，不影响任何依赖解析。

### 推送 tag

```bash
# 本地打 tag（自动取当前时间）
git tag v4.1.8-fork.$(date +%Y%m%d%H%M%S)

# 用 gh 推送（绕过 HTTPS 超时问题）
gh release create <tag> \
  --repo <owner/repo> \
  --title "Fork v4.1.8 - <改动摘要>" \
  --notes ""
```
