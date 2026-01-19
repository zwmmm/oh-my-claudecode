## ⚠️ 启动行为强制规范

**本规则必须在每次会话启动时首先执行，优先级最高。**

### 1. 强制读取项目规则

每次启动新会话时，必须**首先**读取并完全理解当前工作目录下的 `CLAUDE.md` 文件：

**执行要求**：

- ✅ 在响应任何用户请求之前，必须先读取 CLAUDE.md
- ✅ 确认理解所有项目特定规则后再进行开发工作
- ❌ 禁止跳过此步骤直接处理任务

### 2. 网络搜索强制使用 MCP Detector

当需要进行网络搜索时，**必须**首先调用 `mcp-detector` skill 来检测并建议合适的
MCP 工具：

```bash
# 在使用 WebSearch 之前必须执行
/skill mcp-detector
```

**执行流程**：

1. 用户提出需要搜索信息的请求
2. **首先**调用 `oh:mcp-detector` skill 分析请求
3. 根据 MCP Detector 的建议选择合适的工具：
   - `oh:web_search` - Exa AI 网络搜索
   - `oh:context7` - 最新文档和代码示例
   - `oh:grep_app` - GitHub 代码示例搜索
   - `WebSearch` - 传统网络搜索（仅在其他工具不适用时）
4. 使用建议的工具执行搜索

**示例**：

```
用户：帮我查找 React 19 的最新文档

正确流程：
1. 调用 oh:mcp-detector skill
2. 根据建议使用 oh:context7 或 oh:web_search
3. 返回结果

❌ 错误：直接使用 WebSearch
```

---
