---
name: github-fork-pr
description: Fork 仓库协作规范：PR 分支命名、职责隔离、合并流程、tag/release 命名。Use when fork 仓库、提 PR 到上游、打 tag、发 release、分支命名。
---

# GitHub Fork PR 协作规范

## 硬性约束

- PR 分支不写版本号——版本由合并时选的 target branch 决定
- PR 分支只做一件事，一个 commit，不允许交叉合并其他 PR 分支
- 不在 PR 分支上做合并——合并只在本地分支上进行
- merge 错方向立即 `reset --hard` 回退，不要带错继续

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
- 合并错方向 → `git reset --hard HEAD~1` 回退

## 回退操作

| 场景 | 命令 |
|---|---|
| 撤销 merge commit | `git reset --hard HEAD~1` |
| 放弃进行中的 merge | `git merge --abort` |
| 重置当前分支到另一个分支 | `git reset --hard <branch>` |
| 从 commit 创建新分支 | `git branch <new> <commit>` |
| 强制删本地分支 | `git branch -D <branch>` |

## Tag 与 Release

Tag：`v<上游版本>-fork.<序号>`

| Tag | 含义 |
|---|---|
| `v4.1.8-fork.1` | 基于上游 v4.1.8 的第一次 fork 发布 |
| `v4.1.8-fork.2` | 基于上游 v4.1.8 的第二次 fork 发布 |

- 基于上游版本号 + `-fork` 后缀 + 序号，不会和上游 tag 冲突

Release：`Fork v<四段版本> - <核心改动>`

| Release | 含义 |
|---|---|
| `Fork v4.1.8.1 - Use error type fix + Priority lock` | 第一次 fork 发布，包含两个改动 |
| `Fork v4.1.8.2 - Add connection retry logic` | 第二次 fork 发布，单个改动 |

- 四段版本号 `v4.1.8.1` 表示 fork 的 patch 序号
- 后面跟本次发布的核心改动摘要
