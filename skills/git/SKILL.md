---
name: git
description: |
  Git 工作流管理技能，提供完整的 Git 操作支持。使用场景：
  (1) 提交代码：智能分析改动，自动生成 Conventional Commits 风格的中文提交信息，支持自动拆分提交
  (2) 分支管理：创建/管理 Git worktree，在独立目录并行开发多个功能
  (3) 分支清理：安全识别并清理已合并或过期的分支
  (4) 版本回滚：交互式回滚分支到历史版本，支持 reset 和 revert 两种模式
  触发关键词：git commit, git worktree, git 提交, git 分支, git 清理, git 回滚, 版本回退
---

# Git 工作流

完整的 Git 操作工具集，涵盖日常开发中的核心工作流。

## 功能概览

| 功能 | 用途 | 详细文档 |
|------|------|----------|
| **提交** | 智能生成 Conventional Commits 风格提交信息 | [commit.md](references/commit.md) |
| **Worktree** | 并行开发多个功能分支 | [worktree.md](references/worktree.md) |
| **清理分支** | 安全清理已合并/过期分支 | [clean-branches.md](references/clean-branches.md) |
| **回滚** | 交互式回滚到历史版本 | [rollback.md](references/rollback.md) |

---

## 快速使用

### 提交代码

```bash
# 分析改动并生成提交信息（默认自动拆分）
git status && git diff  # 先查看改动
# 然后根据改动生成 Conventional Commits 格式的提交

# 使用 emoji 风格
# ✨ feat(ui): 添加用户认证流程

# 纯文本风格
# feat(ui): 添加用户认证流程
```

**核心特性**：
- 强制中文提交信息
- 默认自动拆分独立改动为多个原子提交
- 支持 `--emoji` 添加表情前缀
- 支持 `--no-verify` 跳过 Git 钩子

### Worktree 管理

```bash
# 在 ../.zcf/项目名/ 目录创建 worktree
git worktree add <path>                    # 从 main/master 创建新分支
git worktree add <path> -b <branch>        # 指定分支名
git worktree list                          # 列出所有 worktree
git worktree remove <path>                 # 删除 worktree
```

**核心特性**：
- 统一路径结构：`../.zcf/项目名/<worktree名>`
- 自动复制 `.gitignore` 中的环境文件
- IDE 集成：支持自动打开新 worktree

### 清理分支

```bash
# 预览将要清理的分支（安全模式）
git fetch --all --prune
git branch --merged main                   # 查看已合并分支

# 清理操作
git branch -d <branch>                     # 删除本地已合并分支
git push origin --delete <branch>          # 删除远程分支
```

**核心特性**：
- 默认 `--dry-run` 只读预览
- 支持保护分支配置
- 支持 `--stale <days>` 清理长期未更新分支

### 版本回滚

```bash
# 查看历史版本
git log --oneline -n 20
git reflog -n 20

# reset 模式（改变历史）
git reset --hard <target>

# revert 模式（保留历史）
git revert --no-edit <target>..HEAD
```

**核心特性**：
- 默认 `--dry-run` 只读预览
- 支持 `reset`（硬回滚）和 `revert`（反向提交）两种模式
- 自动备份到 reflog

---

## 类型与 Emoji 映射

| Emoji | 类型 | 说明 |
|-------|------|------|
| ✨ | `feat` | 新增功能 |
| 🐛 | `fix` | 缺陷修复 |
| 📝 | `docs` | 文档与注释 |
| 🎨 | `style` | 风格/格式 |
| ♻️ | `refactor` | 重构 |
| ⚡️ | `perf` | 性能优化 |
| ✅ | `test` | 测试 |
| 🔧 | `chore` | 构建/工具/杂务 |
| 👷 | `ci` | CI/CD |
| ⏪️ | `revert` | 回滚 |

---

## 安全提示

1. **提交前检查**：确保不提交敏感文件（`.env`、凭证等）
2. **清理前预览**：始终先用 `--dry-run` 预览
3. **回滚需谨慎**：`reset` 会改变历史，需要强推
4. **保护分支**：配置 `git config --add branch.cleanup.protected <branch>`
