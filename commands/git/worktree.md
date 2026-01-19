# Git Worktree 详细指南

管理 Git worktree，支持智能默认、IDE 集成和内容迁移。

> 💡 **建议**: 执行本命令前,建议先运行 `/clear` 命令清理上下文,以获得更好的分析效果。

## 目录

- [选项说明](#选项说明)
- [执行流程](#执行流程)
- [路径计算逻辑](#路径计算逻辑)
- [环境文件处理](#环境文件处理)
- [IDE 集成](#ide-集成)
- [示例](#示例)
- [目录结构](#目录结构)

---

## 选项说明

| 选项 | 说明 |
|------|------|
| `add [<path>]` | 在 `../.zcf/项目名/<path>` 添加新的 worktree |
| `migrate <target>` | 迁移内容到指定 worktree |
| `list` | 列出所有 worktree 及其状态 |
| `remove <path>` | 删除指定路径的 worktree |
| `prune` | 清理无效的 worktree 引用 |
| `-b <branch>` | 创建新分支并检出到 worktree |
| `-o, --open` | 创建成功后直接用 IDE 打开 |
| `--from <source>` | 指定迁移源路径（migrate 专用） |
| `--stash` | 迁移当前 stash 内容（migrate 专用） |
| `--track` | 设置新分支跟踪对应的远程分支 |
| `--guess-remote` | 自动猜测远程分支进行跟踪 |
| `--detach` | 创建分离 HEAD 的 worktree |
| `--lock` | 创建后锁定 worktree |

---

## 执行流程

1. **环境检查**
   - 通过 `git rev-parse --is-inside-work-tree` 验证 Git 仓库
   - 检测是否在主仓库或现有 worktree 中，进行智能路径计算

2. **智能路径管理**
   - 使用 worktree 检测自动从主仓库路径计算项目名
   - 在结构化的 `../.zcf/项目名/<path>` 目录创建 worktree
   - 正确处理主仓库和 worktree 执行上下文

3. **Worktree 操作**
   - **add**: 使用智能分支/路径默认创建新 worktree
   - **list**: 显示所有 worktree 的分支和状态
   - **remove**: 安全删除 worktree 并清理引用
   - **prune**: 清理孤立的 worktree 记录

4. **智能默认**
   - **分支创建**: 未指定 `-b` 时，使用路径名创建新分支
   - **基础分支**: 新分支从 main/master 分支创建
   - **路径解析**: 未指定路径时使用分支名作为路径

5. **环境文件处理**
   - 自动检测并复制 `.gitignore` 中列出的环境文件

---

## 路径计算逻辑

```bash
get_main_repo_path() {
  local git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
  local current_toplevel=$(git rev-parse --show-toplevel 2>/dev/null)

  # 检测是否在 worktree 中
  if [[ "$git_common_dir" != "$current_toplevel/.git" ]]; then
    # 在 worktree 中，从 git-common-dir 推导主仓库路径
    dirname "$git_common_dir"
  else
    # 在主仓库中
    echo "$current_toplevel"
  fi
}

MAIN_REPO_PATH=$(get_main_repo_path)
PROJECT_NAME=$(basename "$MAIN_REPO_PATH")
WORKTREE_BASE="$MAIN_REPO_PATH/../.zcf/$PROJECT_NAME"
```

**关键点**: 在现有 worktree 内创建新 worktree 时，始终使用绝对路径以防止路径嵌套问题。

---

## 环境文件处理

```bash
copy_environment_files() {
    local main_repo="$MAIN_REPO_PATH"
    local target_worktree="$ABSOLUTE_WORKTREE_PATH"
    local gitignore_file="$main_repo/.gitignore"

    if [[ ! -f "$gitignore_file" ]]; then
        return 0
    fi

    # 检测 .env 文件
    if [[ -f "$main_repo/.env" ]] && grep -q "^\.env$" "$gitignore_file"; then
        cp "$main_repo/.env" "$target_worktree/.env"
        echo "✅ 已复制 .env"
    fi

    # 检测 .env.* 模式文件（排除 .env.example）
    for env_file in "$main_repo"/.env.*; do
        if [[ -f "$env_file" ]] && [[ "$(basename "$env_file")" != ".env.example" ]]; then
            local filename=$(basename "$env_file")
            if grep -q "^\.env\.\*$" "$gitignore_file"; then
                cp "$env_file" "$target_worktree/$filename"
                echo "✅ 已复制 $filename"
            fi
        fi
    done
}
```

---

## IDE 集成

**支持的 IDE**（按优先级）：
1. VS Code
2. Cursor
3. WebStorm
4. Sublime Text
5. Vim

**自定义配置**：

```bash
# 配置自定义 IDE
git config worktree.ide.custom.sublime "subl %s"
git config worktree.ide.preferred "sublime"

# 控制自动检测
git config worktree.ide.autodetect true  # 默认
```

---

## 示例

```bash
# 基本用法
git worktree add feature-ui                       # 从 main/master 创建新分支
git worktree add feature-ui -b my-feature         # 创建新分支，路径为 feature-ui
git worktree add feature-ui -o                    # 创建并直接用 IDE 打开

# 内容迁移
git worktree add feature-ui -b feature/new-ui     # 创建新功能 worktree
# 然后迁移未提交改动或 stash 内容

# 管理操作
git worktree list                                 # 查看所有 worktree
git worktree remove feature-ui                    # 删除不需要的 worktree
git worktree prune                                # 清理无效引用
```

**示例输出**:

```
✅ Worktree created at ../.zcf/项目名/feature-ui
✅ 已复制 .env
✅ 已复制 .env.local
📋 已从 .gitignore 复制 2 个环境文件
🖥️ 是否在 IDE 中打开？[y/n]: y
🚀 正在用 VS Code 打开...
```

---

## 目录结构

```
parent-directory/
├── your-project/            # 主项目
│   ├── .git/
│   └── src/
└── .zcf/                    # worktree 管理
    └── your-project/        # 项目 worktree
        ├── feature-ui/      # 功能分支
        ├── hotfix/          # 修复分支
        └── debug/           # 调试 worktree
```

---

## 注意事项

- **性能**: worktree 共享 `.git` 目录，节省磁盘空间
- **安全**: 路径冲突防护和分支检出验证
- **迁移**: 仅限未提交改动；已提交内容需使用 `git cherry-pick`
- **IDE 要求**: 命令行工具必须在 PATH 中
- **跨平台**: 支持 Windows、macOS、Linux
