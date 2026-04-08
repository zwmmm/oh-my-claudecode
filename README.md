# Oh My Claude Code Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-blue.svg)](https://code.claude.com/docs/en/plugins)

> 一个强大的 Claude Code 插件集合，提供 Git 工作流技能、UniApp UI 生成器等实用功能

## 安装

```bash
/plugin marketplace add zwmmm/oh-my-claudecode
```

## Git 技能 (手动触发)

通过 `/git` 触发，包含以下子命令：

### Commit - 智能提交

自动分析代码改动，生成 Conventional Commits 风格的中文提交信息。

```bash
/git:commit              # 分析暂存区改动并提交
/git:commit --all       # 暂存所有改动后提交
/git:commit --emoji     # 在提交信息中包含 emoji
```

### Worktree - 管理

管理 Git worktree，支持智能默认、IDE 集成和环境文件迁移。

```bash
/git:worktree add feature-ui  # 创建新 worktree
/git:worktree list           # 列出所有 worktree
```

### Clean Branches - 清理分支

安全识别并清理已合并或过期的 Git 分支。

```bash
/git:clean-branches         # 预览将要清理的分支
/git:clean-branches --remote # 同时清理远程分支
```

### Rollback - 回滚

安全回滚 Git 分支到历史版本，支持 reset 和 revert 两种模式。

```bash
/git:rollback                    # 交互式选择
/git:rollback --mode revert      # 生成反向提交
```

## Skills

### UniApp UI

UniApp + UnoCSS + WotUI 页面生成器，将设计稿截图转换为 UniApp 代码。

**触发场景：** 生成 UniApp 页面、转换设计稿

### oh:search

自动检测查询意图，推荐合适的 MCP 工具：

- 文档查询 → context7
- 代码示例 → grep_app
- 网络搜索 → web_search

## 许可证

[MIT](LICENSE) License

## 相关资源

- [Claude Code 官方文档](https://code.claude.com/docs/en/plugins)
- [MCP 协议文档](https://modelcontextprotocol.io)

---

⭐ 如果这个项目对你有帮助，请给个 Star!