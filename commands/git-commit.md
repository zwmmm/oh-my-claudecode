---
description: 仅用 Git 分析改动并自动生成 conventional commit 信息（可选 emoji）；默认自动拆分提交，强制使用中文，默认运行本地 Git 钩子（可 --no-verify 跳过）
model: claude-haiku-4-5
allowed-tools: Read(**), Exec(git status, git diff, git add, git restore --staged, git commit, git rev-parse, git config), Write(.git/COMMIT_EDITMSG)
argument-hint: [--no-verify] [--all] [--amend] [--signoff] [--emoji] [--scope <scope>] [--type <type>]
# examples:
#   - /git-commit                           # 分析当前改动，生成提交信息（中文，自动拆分）
#   - /git-commit --all                     # 暂存所有改动并提交
#   - /git-commit --no-verify               # 跳过 Git 钩子检查
#   - /git-commit --emoji                   # 在提交信息中包含 emoji
#   - /git-commit --scope ui --type feat    # 指定作用域和类型
#   - /git-commit --amend --signoff         # 修补上次提交并签名
---

# Claude Command: Commit (Git-only)

该命令在**不依赖任何包管理器/构建工具**的前提下，仅通过 **Git**：

- 读取改动（staged/unstaged）
- **默认自动拆分**为多次提交（无需手动确认）
- 为每个提交生成 **Conventional Commits** 风格的**中文**信息（可选 emoji）
- 按需执行 `git add` 与 `git commit`（默认运行本地 Git 钩子；可 `--no-verify` 跳过）

## ⚡ 核心特性

1. **🇨🇳 强制中文**：所有提交信息均使用中文生成，无视仓库历史语言
2. **✂️ 默认拆分**：检测到多组独立变更时自动拆分为多个提交，保持提交原子性

---

## Usage

```bash
/git-commit
/git-commit --no-verify
/git-commit --emoji
/git-commit --all --signoff
/git-commit --amend
/git-commit --scope ui --type feat --emoji
```

### Options

- `--no-verify`：跳过本地 Git 钩子（`pre-commit`/`commit-msg` 等）。
- `--all`：当暂存区为空时，自动 `git add -A` 将所有改动纳入本次提交。
- `--amend`：在不创建新提交的情况下**修补**上一次提交（保持提交作者与时间，除非本地 Git 配置另有指定）。
- `--signoff`：附加 `Signed-off-by` 行（遵循 DCO 流程时使用）。
- `--emoji`：在提交信息中包含 emoji 前缀（省略则使用纯文本）。
- `--scope <scope>`：指定提交作用域（如 `ui`、`docs`、`api`），写入消息头部。
- `--type <type>`：强制提交类型（如 `feat`、`fix`、`docs` 等），覆盖自动判断。

> 注：如框架不支持交互式确认，可在 front-matter 中开启 `confirm: true` 以避免误操作。

---

## What This Command Does

1. **仓库/分支校验**

   - 通过 `git rev-parse --is-inside-work-tree` 判断是否位于 Git 仓库。
   - 读取当前分支/HEAD 状态；如处于 rebase/merge 冲突状态，先提示处理冲突后再继续。

2. **改动检测**

   - 用 `git status --porcelain` 与 `git diff` 获取已暂存与未暂存的改动。
   - 若已暂存文件为 0：
     - 若传入 `--all` → 执行 `git add -A`。
     - 否则提示你选择：继续仅分析未暂存改动并给出**建议**，或取消命令后手动分组暂存。

3. **拆分建议（Split Heuristics）**

   - **默认行为：主动拆分**。检测到多组独立变更时，**自动拆分**为多个提交，无需用户确认。
   - 按**关注点**、**文件模式**、**改动类型**聚类（示例：源代码 vs 文档、测试；不同目录/包；新增 vs 删除）。
   - 若检测到**多组独立变更**或 diff 规模过大（如 > 300 行 / 跨多个顶级目录），自动拆分提交，并给出每一组的 pathspec（便于后续执行 `git add <paths>`）。

4. **提交信息生成（Conventional 规范，可选 Emoji）**

   - 自动推断 `type`（`feat`/`fix`/`docs`/`refactor`/`test`/`chore`/`perf`/`style`/`ci`/`revert` …）与可选 `scope`。
   - 生成消息头：`[<emoji>] <type>(<scope>)?: <subject>`（首行 ≤ 72 字符，祈使语气，仅在使用 `--emoji` 时包含 emoji）。
   - 生成消息体：
     - 必须在 subject 之后空一行。
     - 使用列表格式，每项以 `-` 开头。
     - 每项**必须使用动词开头的祈使句**（如 "add…"、"fix…"、"update…"）。
     - **禁止使用冒号分隔的格式**（如 ~~"Feature: description"~~、~~"Impl: content"~~）。
     - 说明变更的动机、实现要点或影响范围（3 项以内为宜）。
   - 生成消息脚注（如有）：
     - 必须在 Body 之后空一行。
     - **BREAKING CHANGE**：若存在破坏性变更，必须包含 `BREAKING CHANGE: <description>`，或在类型后添加感叹号（如 `feat!:`）。
     - 其它脚注采用 git trailer 格式（如 `Closes #123`、`Refs: #456`、`Reviewed-by: Name`）。
   - **强制使用中文**生成所有提交信息，无论 Git 历史使用何种语言。
   - 将草稿写入 `.git/COMMIT_EDITMSG`，并用于 `git commit`。

5. **执行提交**

   - 单提交场景：`git commit [-S] [--no-verify] [-s] -F .git/COMMIT_EDITMSG`
   - 多提交场景（默认行为）：检测到多组独立变更时，**自动拆分**为多个提交，按分组给出 `git add <paths> && git commit ...` 的明确指令并**自动执行**。

6. **安全回滚**
   - 如误暂存，可用 `git restore --staged <paths>` 撤回暂存（命令会给出指令，不修改文件内容）。

---

## Best Practices for Commits

- **Atomic commits**：一次提交只做一件事，便于回溯与审阅。
- **先分组再提交**：按目录/模块/功能点拆分。
- **清晰主题**：首行 ≤ 72 字符，祈使语气。
- **正文含上下文**：说明动机、方案、影响范围（禁止冒号分隔格式）。
- **遵循 Conventional Commits**：`<type>(<scope>): <subject>`。

---

## Type 与 Emoji 映射（使用 --emoji 时）

- ✨ `feat`：新增功能
- 🐛 `fix`：缺陷修复（含 🔥 删除代码/文件、🚑️ 紧急修复、👽️ 适配外部 API 变更、🔒️ 安全修复、🚨 解决告警、💚 修复 CI）
- 📝 `docs`：文档与注释
- 🎨 `style`：风格/格式（不改语义）
- ♻️ `refactor`：重构（不新增功能、不修缺陷）
- ⚡️ `perf`：性能优化
- ✅ `test`：新增/修复测试、快照
- 🔧 `chore`：构建/工具/杂务（合并分支、更新配置、发布标记、依赖 pin、.gitignore 等）
- 👷 `ci`：CI/CD 配置与脚本
- ⏪️ `revert`：回滚提交
- 💥 `feat`：破坏性变更（`BREAKING CHANGE:` 段落中说明）

> 若传入 `--type`/`--scope`，将**覆盖**自动推断。
> 仅在指定 `--emoji` 标志时才会包含 emoji。

---

## Guidelines for Splitting Commits

1. **不同关注点**：互不相关的功能/模块改动应拆分。
2. **不同类型**：不要将 `feat`、`fix`、`refactor` 混在同一提交。
3. **文件模式**：源代码 vs 文档/测试/配置分组提交。
4. **规模阈值**：超大 diff（示例：>300 行或跨多个顶级目录）建议拆分。
5. **可回滚性**：确保每个提交可独立回退。

---

## Examples

**Good (使用 --emoji)**

```text
- ✨ feat(ui): 添加用户认证流程
- 🐛 fix(api): 处理令牌刷新竞态条件
- 📝 docs: 更新 API 使用示例
- ♻️ refactor(core): 提取重试逻辑到辅助函数
- ✅ test: 为速率限制器添加单元测试
- 🔧 chore: 更新 git hooks 和仓库设置
- ⏪️ revert: 回滚 "feat(core): 引入流式 API"
```

**Good (不使用 --emoji)**

```text
- feat(ui): 添加用户认证流程
- fix(api): 处理令牌刷新竞态条件
- docs: 更新 API 使用示例
- refactor(core): 提取重试逻辑到辅助函数
- test: 为速率限制器添加单元测试
- chore: 更新 git hooks 和仓库设置
- revert: 回滚 "feat(core): 引入流式 API"
```

**Good (包含 Body)**

```text
feat(auth): 添加 OAuth2 登录流程

- 实现 Google 和 GitHub 第三方登录
- 添加用户授权回调处理
- 改进登录状态持久化逻辑

Closes #42
```

```text
fix(ui): 修复移动设备上的按钮间距

- 调整按钮内边距以适应小屏幕
- 修复 iOS Safari 上的样式问题
- 优化触摸目标大小
```

**Good (包含 BREAKING CHANGE)**

```text
feat(api)!: 重新设计认证 API

- 从基于会话迁移到 JWT 认证
- 更新所有端点签名
- 移除已废弃的登录方法

BREAKING CHANGE: 认证 API 已完全重新设计，所有客户端必须更新其集成方式
```

**Split Example (默认自动拆分)**

```text
- `feat(types): 为支付方式添加新类型定义`
- `docs: 更新新类型的 API 文档`
- `test: 为支付类型添加单元测试`
- `fix: 解决新文件中的 linter 警告` ←（如你的仓库有钩子报错）
```

---

## Important Notes

- **仅使用 Git**：不调用任何包管理器/构建命令（无 `pnpm`/`npm`/`yarn` 等）。
- **尊重钩子**：默认执行本地 Git 钩子；使用 `--no-verify` 可跳过。
- **不改源码内容**：命令只读写 `.git/COMMIT_EDITMSG` 与暂存区；不会直接编辑工作区文件。
- **安全提示**：在 rebase/merge 冲突、detached HEAD 等状态下会先提示处理/确认再继续。
- **可审可控**：如开启 `confirm: true`，每个实际 `git add`/`git commit` 步骤都会进行二次确认。
