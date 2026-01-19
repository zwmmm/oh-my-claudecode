# Git Commit 详细指南

智能分析改动并自动生成 Conventional Commits 风格的中文提交信息。

## 目录

- [选项说明](#选项说明)
- [执行流程](#执行流程)
- [最佳实践](#最佳实践)
- [拆分提交指南](#拆分提交指南)
- [示例](#示例)

---

## 选项说明

| 选项 | 说明 |
|------|------|
| `--no-verify` | 跳过本地 Git 钩子（`pre-commit`/`commit-msg` 等） |
| `--all` | 当暂存区为空时，自动 `git add -A` 将所有改动纳入提交 |
| `--amend` | 修补上一次提交（保持提交作者与时间） |
| `--signoff` | 附加 `Signed-off-by` 行（遵循 DCO 流程） |
| `--emoji` | 在提交信息中包含 emoji 前缀 |
| `--scope <scope>` | 指定提交作用域（如 `ui`、`docs`、`api`） |
| `--type <type>` | 强制提交类型（覆盖自动判断） |

---

## 执行流程

1. **仓库/分支校验**
   - 通过 `git rev-parse --is-inside-work-tree` 判断是否位于 Git 仓库
   - 读取当前分支/HEAD 状态；如处于 rebase/merge 冲突状态，先提示处理

2. **改动检测**
   - 用 `git status --porcelain` 与 `git diff` 获取已暂存与未暂存的改动
   - 若已暂存文件为 0：
     - 若传入 `--all` → 执行 `git add -A`
     - 否则继续分析未暂存改动并自动执行拆分提交

3. **自动拆分提交（默认行为）**
   - 检测到多组独立变更时，自动拆分为多个提交并立即执行
   - 按关注点、文件模式、改动类型聚类分组
   - 若 diff 规模过大（如 > 300 行 / 跨多个顶级目录），自动拆分
   - 不询问用户确认，直接按最佳实践执行拆分

4. **提交信息生成（Conventional 规范）**
   - 自动推断 `type` 与可选 `scope`
   - 生成消息头：`[<emoji>] <type>(<scope>)?: <subject>`（首行 ≤ 72 字符）
   - 生成消息体：必须在 subject 之后空一行，使用列表格式，每项以 `-` 开头
   - 生成消息脚注：如有 BREAKING CHANGE 或其它 git trailer

5. **执行提交**
   - 单提交场景：`git commit [-S] [--no-verify] [-s] -F .git/COMMIT_EDITMSG`
   - 多提交场景：自动拆分，按分组执行 `git add <paths> && git commit ...`

---

## 最佳实践

- **Atomic commits**：一次提交只做一件事，便于回溯与审阅
- **先分组再提交**：按目录/模块/功能点拆分
- **清晰主题**：首行 ≤ 72 字符，祈使语气
- **正文含上下文**：说明动机、方案、影响范围（禁止冒号分隔格式）
- **遵循 Conventional Commits**：`<type>(<scope>): <subject>`

---

## 拆分提交指南

1. **不同关注点**：互不相关的功能/模块改动应拆分
2. **不同类型**：不要将 `feat`、`fix`、`refactor` 混在同一提交
3. **文件模式**：源代码 vs 文档/测试/配置分组提交
4. **规模阈值**：超大 diff（> 300 行或跨多个顶级目录）建议拆分
5. **可回滚性**：确保每个提交可独立回退

---

## 示例

### 使用 emoji

```text
✨ feat(ui): 添加用户认证流程
🐛 fix(api): 处理令牌刷新竞态条件
📝 docs: 更新 API 使用示例
♻️ refactor(core): 提取重试逻辑到辅助函数
```

### 不使用 emoji

```text
feat(ui): 添加用户认证流程
fix(api): 处理令牌刷新竞态条件
docs: 更新 API 使用示例
refactor(core): 提取重试逻辑到辅助函数
```

### 包含 Body

```text
feat(auth): 添加 OAuth2 登录流程

- 实现 Google 和 GitHub 第三方登录
- 添加用户授权回调处理
- 改进登录状态持久化逻辑

Closes #42
```

### 包含 BREAKING CHANGE

```text
feat(api)!: 重新设计认证 API

- 从基于会话迁移到 JWT 认证
- 更新所有端点签名
- 移除已废弃的登录方法

BREAKING CHANGE: 认证 API 已完全重新设计，所有客户端必须更新其集成方式
```

---

## 重要说明

- **仅使用 Git**：不调用任何包管理器/构建命令
- **尊重钩子**：默认执行本地 Git 钩子；使用 `--no-verify` 可跳过
- **不改源码内容**：只读写 `.git/COMMIT_EDITMSG` 与暂存区
- **安全提示**：在 rebase/merge 冲突、detached HEAD 等状态下会先提示处理
