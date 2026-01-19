---
name: mcp-detector
description: Automatically detect and suggest appropriate MCP tools (context7, grep_app, web_search) based on user queries. Use when queries contain documentation keywords like 如何使用、怎么用、最佳实践、文档、教程、指南、手册、规范、API 文档、官方文档; code search keywords like 例子、示例、实现、源码、源代码、代码、仓库、开源、案例、实际代码; or latest information keywords like 最新、最近、新闻、更新、版本、发布、变更、新特性、当前、现代、即将; bug fixing keywords like 修复 bug、fix bug、解决错误、error、issue、troubleshooting、debug.
---

# MCP 检测器

自动识别用户查询意图并推荐合适的 MCP 工具。

## 工作流程

### 1. 分析用户查询

分析用户的查询内容,识别关键模式和意图:

- **文档查询**: 查找官方文档、API 参考、使用指南
- **代码示例**: 搜索 GitHub 代码实现和真实案例
- **最新信息**: 获取最新版本、更新、新闻

### 2. 匹配 MCP 工具

根据查询特征匹配最合适的 MCP 工具:

#### context7 - 官方文档查询

**触发关键词**: how to use, best practice, documentation, docs, API, reference,
guide, tutorial, 如何使用, 最佳实践, 文档, 教程, 使い方, ドキュメント, 가이드,
사용법 等

**适用场景**:

- 查找官方 API 文档
- 学习库的最佳实践
- 了解功能使用方法
- 查阅技术规范

**示例查询**:

- "How to use React hooks?"
- "Next.js API 文档"
- "Vue 3 最佳实践"

#### grep_app - GitHub 代码搜索

**触发关键词**: example, implementation, source code, github, repository, code
sample, usage example, real world, demo, 例子, 实现, 源码, 示例, 구현, 예제,
実装, サンプル 等

**适用场景**:

- 查找真实代码实现
- 学习实际使用案例
- 参考开源项目代码
- 查看代码模式

**示例查询**:

- "React form validation example"
- "Express.js 认证实现示例"
- "真实的 TypeScript 项目结构"

#### web_search - 最新信息搜索

**触发关键词**: 2025, 2026, latest, new, recent, news, update, version,
release, changelog, what's new, fix bug, error, issue, troubleshooting, debug,
最新, 更新, 版本, 修复 bug, 解决错误, 发表, 最新, 리리스, 뉴스, 업데이트,
버전, 버그 수정, 오류 해결 等

**适用场景**:

- 查找最新版本信息
- 了解最近更新内容
- 获取新闻和发布公告
- 查看变更日志
- **修复 bug 和错误** - 查找最新的错误解决方案、已知问题、issue 跟踪

**示例查询**:

- "React 2025 最新特性"
- "Node.js latest version changelog"
- "Vue 3 最近更新了什么"
- "修复 bug: 连接数据库超时"
- "fix bug: TypeError in useEffect"
- "解决错误: Cannot find module"

### 3. 提供建议

当检测到合适的 MCP 工具时:

1. **识别所有匹配的工具** - 可能同时推荐多个工具
2. **说明推荐理由** - 解释为什么推荐该工具
3. **主动调用工具** - 不要只是建议,而是直接调用相应的 MCP 工具

### 4. 执行查询

根据推荐的 MCP 工具执行实际查询:

```markdown
## MCP 工具使用

检测到您的查询适合使用以下 MCP 工具:

### context7 - 官方文档

查找 React hooks 的官方文档和最佳实践

### grep_app - 代码示例

搜索 GitHub 上 React hooks 的实际使用案例

现在我将使用这些工具为您查询...
```

## 重要原则

### KISS - 简洁高效

- 快速识别查询意图
- 直接调用合适的工具
- 避免过度解释

### YAGNI - 精准匹配

- 只推荐真正需要的工具
- 不做过度推测
- 基于明确的关键词模式

### DRY - 统一识别逻辑

- 使用统一的关键词匹配规则
- 避免重复的判断逻辑
- 复用识别模式

## 多语言支持

本 skill 支持多语言关键词识别:

- 英语 (English)
- 简体中文
- 日语 (日本語)
- 韩语 (한국어)

参考 [references/keywords.md](references/keywords.md)
获取完整的多语言关键词列表。

## 注意事项

1. **代码块过滤**: 忽略代码块中的关键词,避免误判
2. **多工具推荐**: 一个查询可能适合使用多个 MCP 工具
3. **主动执行**: 检测到匹配后应主动调用工具,而非仅建议
4. **保持简洁**: 快速识别和响应,避免冗长说明
