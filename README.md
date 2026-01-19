# Oh My Claude Code Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-blue.svg)](https://code.claude.com/docs/en/plugins)

> 一个强大且可扩展的 Claude Code 插件模板,提供常用功能和最佳实践

## ✨ 特性

- 🚀 **开箱即用**: 包含常用命令和代理
- 🎯 **最佳实践**: 遵循 SOLID、KISS、DRY、YAGNI 原则
- 🔧 **高度可定制**: 易于扩展和修改
- 📚 **完善文档**: 详细的注释和说明
- 🛡️ **安全可靠**: 包含 pre-commit 钩子和代码审查
- 🌐 **MCP 集成**: 内置多个 MCP 服务器支持 (文件系统、Git、搜索、内存、数据库)

## 📦 安装

### 方式一:通过 Git 安装

```bash
# 克隆仓库到 Claude Code 插件目录
git clone https://github.com/zwmmm/oh-my-claudecode.git ~/.claude/plugins/oh-my-claudecode

# 或者作为子模块添加
cd ~/.claude/plugins
git submodule add https://github.com/zwmmm/oh-my-claudecode.git oh-my-claudecode
```

### 方式二:项目级别自动安装

在项目根目录创建 `.claude/plugins.json`:

```json
{
  "plugins": [
    {
      "name": "oh-my-claudecode",
      "source": "https://github.com/zwmmm/oh-my-claudecode.git"
    }
  ]
}
```

## 🎯 快速开始

安装后,即可使用以下命令:

```bash
# Hello World 示例
/hello-world

# 代码审查
/code-review

# 审查特定文件
/code-review src/components/Button.tsx
```

## 📁 项目结构

```
oh-my-claudecode/
├── .claude-plugin/
│   └── plugin.json              # 插件元数据
├── commands/                    # Slash 命令定义
│   ├── hello-world.md
│   └── code-review.md
├── agents/                      # AI 代理定义
│   └── review-agent.md
├── skills/                      # Agent Skills
│   └── code-review/
│       └── SKILL.md
├── hooks/                       # 钩子配置
│   ├── hooks.json
│   └── pre-commit.sh
├── .mcp.json                    # MCP 服务器配置
├── docs/
│   └── MCP.md                   # MCP 详细文档
├── CLAUDE.md                    # Claude Code 配置
└── README.md                    # 本文档
```

## 🛠️ 可用命令

### `/hello-world`
一个简单的示例命令,展示插件的基本功能。

**用法:**
```bash
/hello-world
/hello-world --create-file
```

### `/code-review`
执行全面的代码审查,包括:
- 代码质量分析
- 安全性检查
- 性能优化建议
- 最佳实践验证

**用法:**
```bash
# 审查整个项目
/code-review

# 审查特定文件
/code-review path/to/file.ts

# 审查多个文件
/code-review src/utils/*.ts
```

## 🤖 可用代理

### Review Agent
专业的代码审查代理,提供深入的代码分析和改进建议。

**特点:**
- 系统化的代码分析流程
- 建设性的反馈
- 可操作的改进建议
- 教学导向的说明

## 🔌 MCP 服务器集成

本插件内置以下 MCP 服务器支持:

### 已配置的服务器

- **Filesystem Server** - 文件系统访问
- **Git Server** - Git 版本控制操作
- **Brave Search** - 网络搜索 (需要 API key)
- **Memory Server** - 持久化内存存储
- **PostgreSQL** - 数据库操作 (需要配置)

### 配置 MCP 服务器

1. **安装 MCP 服务器**

```bash
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-memory

# 可选
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-postgres
```

2. **配置环境变量** (如需要)

```bash
# Brave Search API
export BRAVE_API_KEY="your-api-key"

# PostgreSQL
export POSTGRES_CONNECTION_STRING="postgresql://user:password@localhost:5432/dbname"
```

3. **自定义 `.mcp.json`**

编辑 `.mcp.json` 文件:
- 移除不需要的服务器
- 修改项目路径
- 配置环境变量

4. **重启 Claude Code**

```bash
claude --plugin-dir ./
```

### 验证 MCP 服务器

```bash
# 在 Claude Code 中检查
/mcp list

# 查看可用工具
/tools
```

**详细文档**: 参见 [docs/MCP.md](docs/MCP.md)

## 🔧 配置

### Pre-commit Hook

安装 Git hooks:

```bash
# 复制 hook 到 Git hooks 目录
cp hooks/pre-commit.sh .git/hooks/pre-commit

# 或使用符号链接
ln -s hooks/pre-commit.sh .git/hooks/pre-commit
```

## 📝 开发指南

### 添加新命令

1. 在 `commands/` 创建新的 Markdown 文件
2. 添加 frontmatter 元数据
3. 定义命令的功能和执行步骤

**示例:**

```markdown
---
description: 你的命令描述
allowed-tools: Bash, Read, Write
---

# 命令标题

## 功能说明
描述命令的功能...

## 执行步骤
1. 步骤一
2. 步骤二
...
```

### 添加新代理

1. 在 `agents/` 创建新的 Markdown 文件
2. 定义代理的角色和能力
3. 指定工作流程和沟通风格

### 添加新 Skill

1. 在 `skills/` 创建新目录
2. 添加 `SKILL.md` 文件
3. 定义触发条件和工作流程

**示例:**

```markdown
---
name: my-skill
description: 技能描述
---

# Skill Title

技能的详细说明...
```

### 添加 MCP 服务器

在 `.mcp.json` 的 `mcpServers` 对象中添加:

```json
{
  "my-server": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-myserver"],
    "env": {
      "API_KEY": "your-key"
    },
    "description": "我的 MCP 服务器"
  }
}
```

### 添加新钩子

1. 在 `hooks/` 创建脚本文件
2. 添加执行权限 (`chmod +x`)
3. 在 `hooks/hooks.json` 中注册

## 🤝 贡献指南

欢迎贡献!请遵循以下步骤:

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat:添加某个功能'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 提交消息规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式:

- `feat:` 新功能
- `fix:` 修复 bug
- `docs:` 文档更新
- `style:` 代码格式调整
- `refactor:` 重构代码
- `test:` 测试相关
- `chore:` 构建/工具相关

## 📄 许可证

[MIT](LICENSE) License

## 🔗 相关资源

- [Claude Code 官方文档](https://code.claude.com/docs/en/plugins)
- [插件开发指南](https://agnost.ai/blog/claude-code-plugins-guide)
- [Agent SDK 文档](https://docs.claude.com/en/docs/claude-code/sdk/sdk-overview)
- [MCP 协议文档](https://modelcontextprotocol.io)
- [MCP 服务器列表](https://github.com/modelcontextprotocol/servers)

## 📮 联系方式

- 问题反馈: [GitHub Issues](https://github.com/zwmmm/oh-my-claudecode/issues)
- 功能建议: [GitHub Discussions](https://github.com/zwmmm/oh-my-claudecode/discussions)

---

⭐ 如果这个项目对你有帮助,请给个 Star!
