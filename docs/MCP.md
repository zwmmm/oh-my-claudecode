# MCP 服务器配置指南

## 概述

本插件包含 Model Context Protocol (MCP) 服务器集成,可扩展 Claude Code 的能力。

## 已配置的服务器

### 1. Filesystem Server
**用途**: 文件系统访问
**功能**: 读写项目文件、目录操作

```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "<项目路径>"]
}
```

**工具**:
- `read_file`: 读取文件内容
- `write_file`: 写入文件
- `create_directory`: 创建目录
- `list_directory`: 列出目录内容
- `move_file`: 移动/重命名文件

### 2. Git Server
**用途**: Git 版本控制操作
**功能**: 提交、分支、历史查看

```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-git"]
}
```

**工具**:
- `git_status`: 查看 Git 状态
- `git_diff`: 查看改动
- `git_commit`: 创建提交
- `git_branch`: 分支管理
- `git_log`: 查看历史

### 3. Brave Search Server
**用途**: 网络搜索
**功能**: 实时网络信息检索

**配置要求**:
需要 Brave Search API key:
1. 访问 https://brave.com/search/api/
2. 获取 API key
3. 设置环境变量 `BRAVE_API_KEY`

```json
{
  "env": {
    "BRAVE_API_KEY": "your-api-key-here"
  }
}
```

**工具**:
- `brave_web_search`: 网页搜索
- `brave_news_search`: 新闻搜索

### 4. Memory Server
**用途**: 持久化内存存储
**功能**: 跨会话存储和检索信息

```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-memory"]
}
```

**工具**:
- `memory_write`: 存储信息
- `memory_read`: 读取信息
- `memory_search`: 搜索存储的信息
- `memory_delete`: 删除信息

### 5. PostgreSQL Server
**用途**: 数据库操作
**功能**: SQL 查询、数据库管理

**配置要求**:
需要 PostgreSQL 连接字符串:

```json
{
  "env": {
    "POSTGRES_CONNECTION_STRING": "postgresql://user:password@localhost:5432/dbname"
  }
}
```

**工具**:
- `postgres_query`: 执行 SQL 查询
- `postgres_execute`: 执行 SQL 命令

## 安装和配置

### 步骤 1: 安装 MCP 服务器

```bash
# 全局安装常用服务器
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-memory

# 可选: 安装其他服务器
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-postgres
```

### 步骤 2: 配置环境变量

创建 `.env` 文件或设置系统环境变量:

```bash
# Brave Search API Key (可选)
export BRAVE_API_KEY="your-brave-api-key"

# PostgreSQL 连接字符串 (可选)
export POSTGRES_CONNECTION_STRING="postgresql://user:password@localhost:5432/dbname"
```

### 步骤 3: 自定义配置

编辑 `.mcp.json` 文件:

1. **移除不需要的服务器** - 加快启动速度
2. **修改项目路径** - Filesystem server 的路径参数
3. **配置环境变量** - 设置 API keys 和连接信息

### 步骤 4: 重启 Claude Code

```bash
# 重启以加载 MCP 服务器
claude --plugin-dir ./
```

## 验证安装

检查 MCP 服务器是否正常工作:

```bash
# 在 Claude Code 中运行
/mcp list

# 或查看可用工具
/tools
```

## 常见问题

### Q: 如何禁用某个 MCP 服务器?
**A**: 在 `.mcp.json` 中删除对应的配置条目

### Q: 如何添加自定义 MCP 服务器?
**A**: 在 `.mcp.json` 的 `mcpServers` 对象中添加新条目

### Q: API key 应该存储在哪里?
**A**: 推荐使用环境变量而非硬编码在配置文件中

### Q: MCP 服务器启动失败怎么办?
**A**: 检查:
- Node.js 版本 (需要 Node 18+)
- 网络连接 (npx 需要网络)
- 环境变量配置
- 服务器依赖是否已安装

## 高级配置

### 使用本地 MCP 服务器

```json
{
  "my-custom-server": {
    "command": "node",
    "args": ["/path/to/local/server.js"],
    "description": "自定义 MCP 服务器"
  }
}
```

### 使用 Docker 运行服务器

```json
{
  "docker-server": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "my-mcp-server"],
    "description": "Docker 容器中的 MCP 服务器"
  }
}
```

## 相关资源

- [MCP 官方文档](https://modelcontextprotocol.io)
- [可用 MCP 服务器列表](https://github.com/modelcontextprotocol/servers)
- [MCP 规范](https://modelcontextprotocol.io/docs/concepts)

## 最佳实践

1. **按需启用**: 只启用项目需要的服务器
2. **安全第一**: 不要将 API key 提交到版本控制
3. **性能优化**: 移除不常用的服务器以提高启动速度
4. **版本管理**: 固定服务器版本以避免兼容性问题
5. **错误处理**: 配置适当的超时和重试机制
