# Oh My Claude Code Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-blue.svg)](https://code.claude.com/docs/en/plugins)

> 一个强大的 Claude Code 插件集合，提供 Git 工作流增强、UI/UX 设计智能、MCP
> 工具检测等实用功能

## 📦 安装

在 Claude Code 中执行以下命令：

```bash
/plugin marketplace add zwmmm/oh-my-claudecode
```

## 👤 用户配置命令

### `/user:init` - 初始化用户配置

将插件的全局规则追加到 `~/.claude/CLAUDE.md` 文件。

```bash
/user:init
```

**功能：**

- 读取 `plugins/core/templates/user/CLAUDE.md` 模板
- 将模板内容追加到全局配置文件 `~/.claude/CLAUDE.md`
- 规则对所有 Claude Code 会话生效

---

## 🛠️ Git 命令

### `/commit` - 智能提交

自动分析代码改动，生成 Conventional Commits 风格的中文提交信息。

```bash
/commit              # 分析暂存区改动并提交
/commit --all        # 暂存所有改动后提交
/commit --amend      # 修补上一次提交
/commit --emoji      # 在提交信息中包含 emoji
/commit --no-verify  # 跳过 Git 钩子
```

**特性：**

- 自动推断提交类型 (feat/fix/refactor/docs 等)
- 智能拆分：检测到多组独立变更时自动建议拆分提交
- 支持 BREAKING CHANGE 和 Signed-off-by

### `/rollback` - 交互式回滚

安全回滚 Git 分支到历史版本，支持 reset 和 revert 两种模式。

```bash
/rollback                           # 交互式选择分支和目标版本
/rollback --mode reset              # 硬回滚（改变历史）
/rollback --mode revert             # 生成反向提交（保持历史完整）
/rollback --branch feature --target v1.0.0
```

**安全护栏：**

- 默认 dry-run 模式，预览即将执行的命令
- 保护分支检测 (main/master/production)
- 自动备份当前 HEAD 到 reflog

### `/clean-branches` - 清理分支

安全识别并清理已合并或过期的 Git 分支。

```bash
/clean-branches                    # 预览将要清理的分支
/clean-branches --remote           # 同时清理远程分支
/clean-branches --stale 90         # 清理 90 天未更新的分支
/clean-branches --yes              # 跳过确认直接执行
```

### `/worktree` - Worktree 管理

管理 Git worktree，支持智能默认、IDE 集成和环境文件迁移。

```bash
/worktree add feature-ui           # 创建新 worktree
/worktree add feature-ui -o        # 创建并用 IDE 打开
/worktree list                     # 列出所有 worktree
/worktree remove feature-ui        # 删除 worktree
```

**特性：**

- 自动复制 `.env` 等环境文件
- 支持 VS Code、Cursor、WebStorm 等 IDE
- 统一的目录结构管理 (`../.zcf/项目名/`)

## 🎨 Skills (技能)

### UI/UX Pro Max

UI/UX 设计智能，包含 50 种样式、21 种配色方案、50 种字体搭配。

**触发场景：** 设计、构建、创建、实现 UI/UX 相关任务

**支持的技术栈：**

- Web: React, Next.js, Vue, Svelte, HTML+Tailwind
- Mobile: SwiftUI, React Native, Flutter

**示例：**

```
帮我设计一个 SaaS 产品的 landing page
创建一个暗色主题的 dashboard
```

### Skill Creator

创建和管理 Claude Code 技能的指南。

**触发场景：** 创建新技能、更新现有技能

### MCP Detector

自动检测用户查询意图，推荐合适的 MCP 工具。

**自动识别：**

- **文档查询** → 推荐 context7 (官方文档)
- **代码示例** → 推荐 grep_app (GitHub 代码搜索)
- **最新信息** → 推荐 web_search (网络搜索)

## 🤖 Agents (代理)

### Code Simplifier

代码简化专家，自动精简和优化最近修改的代码。

**工作原则：**

- 保持功能不变，只优化实现方式
- 遵循项目编码规范
- 减少不必要的复杂性和嵌套
- 避免嵌套三元运算符

## 🔔 Hooks (钩子)

### 通知钩子

在以下事件时发送系统通知：

- Claude 提问等待用户输入
- 权限请求
- 任务完成

## 📄 许可证

[MIT](LICENSE) License

## 🔗 相关资源

- [Claude Code 官方文档](https://code.claude.com/docs/en/plugins)
- [MCP 协议文档](https://modelcontextprotocol.io)

## 📮 联系方式

- 问题反馈: [GitHub Issues](https://github.com/zwmmm/oh-my-claudecode/issues)
- 功能建议:
  [GitHub Discussions](https://github.com/zwmmm/oh-my-claudecode/discussions)

---

⭐ 如果这个项目对你有帮助，请给个 Star!
