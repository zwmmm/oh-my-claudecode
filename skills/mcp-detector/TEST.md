# MCP Detector Skill 测试指南

## 概述

`mcp-detector` skill 已成功创建,用于替代之前的 `keyword-detector` hook。该 skill 会自动识别用户查询并推荐合适的 MCP 工具。

## 文件结构

```
skills/mcp-detector/
├── SKILL.md                    # Skill 主文件,包含工作流程和触发规则
└── references/
    └── keywords.md             # 详细的关键词识别规则和示例
```

## 与 Hook 的区别

### 旧方案 (Hook)
- **时机**: 在用户输入提交前修改输入内容
- **方式**: 在用户消息前插入 MCP 建议文本
- **限制**: 只能被动添加建议,不能主动执行

### 新方案 (Skill)
- **时机**: Claude 分析用户查询时自动触发
- **方式**: Claude 主动识别并调用相应的 MCP 工具
- **优势**:
  - 更智能的上下文理解
  - 主动执行而非仅建议
  - 可根据对话历史动态调整
  - 支持多轮对话优化

## 测试场景

### 场景 1: 文档查询测试

**输入**: "How to use React hooks?"

**预期行为**:
- ✅ 识别为文档查询 (关键词: "how to use")
- ✅ 推荐使用 `context7` MCP
- ✅ 主动调用 `mcp__context7__resolve-library-id` 和 `mcp__context7__query-docs`

---

### 场景 2: 代码示例测试

**输入**: "Show me real-world examples of Express.js middleware"

**预期行为**:
- ✅ 识别为代码示例查询 (关键词: "examples", "real-world")
- ✅ 推荐使用 `grep_app` MCP
- ✅ 主动调用 `mcp__grep_app__searchGitHub`

---

### 场景 3: 最新信息测试

**输入**: "What's new in React 2025?"

**预期行为**:
- ✅ 识别为最新信息查询 (关键词: "what's new", "2025")
- ✅ 推荐使用 `web_search` MCP
- ✅ 主动调用 `mcp__web_search__web_search_exa`

---

### 场景 4: 多工具组合测试

**输入**: "React hooks 最佳实践和实际使用例子"

**预期行为**:
- ✅ 识别两个意图:
  - "最佳实践" → context7
  - "例子" → grep_app
- ✅ 推荐使用两个 MCP 工具
- ✅ 依次或同时调用两个工具

---

### 场景 5: 中文查询测试

**输入**: "Vue 3 的官方文档在哪里?"

**预期行为**:
- ✅ 识别中文关键词 "文档"
- ✅ 推荐使用 `context7` MCP
- ✅ 主动查询 Vue 3 文档

---

### 场景 6: 代码块过滤测试

**输入**:
```
我想修复这个函数:
\`\`\`javascript
// how to use this function?
function example() {
  return "demo";
}
\`\`\`
```

**预期行为**:
- ✅ 忽略代码块中的 "how to use", "example", "demo"
- ✅ 不触发任何 MCP 推荐
- ✅ 直接回答用户问题

---

## 如何测试

### 方法 1: 直接对话测试

在 Claude Code 中直接输入测试查询:

```bash
# 启动 Claude Code
claude

# 输入测试查询
> How to use React hooks?
```

观察 Claude 是否:
1. 识别到应该使用 MCP 工具
2. 主动调用相应的 MCP 工具
3. 返回有用的查询结果

---

### 方法 2: 验证 Skill 注册

检查 skill 是否正确注册:

```bash
# 查看已注册的 skills
ls -la skills/mcp-detector/

# 验证文件结构
cat skills/mcp-detector/SKILL.md
```

---

### 方法 3: 关键词识别测试

创建测试脚本验证关键词匹配逻辑:

```javascript
// test-keyword-matching.js
const keywords = {
  context7: /\b(how\s+to\s+use|documentation|docs|api|guide)\b|如何使用|文档/i,
  grep_app: /\b(example|implementation|source\s+code|github)\b|例子|示例/i,
  web_search: /\b(2025|latest|new|update)\b|最新|更新/i
};

const testQueries = [
  "How to use React hooks?",
  "Show me examples",
  "Latest React updates",
  "React hooks 最佳实践和例子"
];

testQueries.forEach(query => {
  console.log(`\nQuery: "${query}"`);
  Object.keys(keywords).forEach(mcp => {
    if (keywords[mcp].test(query)) {
      console.log(`  ✅ Matched: ${mcp}`);
    }
  });
});
```

---

## 常见问题

### Q1: Skill 没有被触发?

**可能原因**:
1. Description 不够明确
2. 查询关键词不匹配
3. Skill 文件路径不正确

**解决方法**:
- 检查 SKILL.md 的 frontmatter description
- 查看 references/keywords.md 确认关键词
- 验证文件在 `skills/mcp-detector/` 目录下

---

### Q2: 识别了但没有调用 MCP?

**可能原因**:
1. Claude 只建议但没有主动执行
2. MCP 工具不可用

**解决方法**:
- 在 SKILL.md 中明确说明"主动调用"而非"建议"
- 检查 MCP 配置是否正确

---

### Q3: 误判问题?

**可能原因**:
1. 关键词太宽泛
2. 没有过滤代码块

**解决方法**:
- 调整 keywords.md 中的关键词
- 确保 SKILL.md 中包含代码块过滤逻辑

---

## 持续优化建议

### 1. 收集真实使用数据
- 记录哪些查询被正确识别
- 记录哪些查询被误判
- 记录哪些查询应该触发但没触发

### 2. 迭代关键词规则
- 添加遗漏的关键词
- 移除导致误判的关键词
- 优化正则表达式

### 3. 改进触发逻辑
- 根据实际使用调整 description
- 增加更多语言支持
- 添加上下文感知能力

### 4. 遵循开发原则

**KISS**: 保持识别逻辑简单直接
**YAGNI**: 只添加真正需要的关键词
**DRY**: 复用识别模式,避免重复逻辑

---

## 下一步

1. ✅ Skill 创建完成
2. ✅ 文档编写完成
3. ⏭️ 实际测试验证
4. ⏭️ 根据反馈优化
5. ⏭️ 考虑禁用或移除旧的 hook

---

## 相关文件

- [SKILL.md](./SKILL.md) - Skill 主文件
- [keywords.md](./references/keywords.md) - 关键词识别规则
- [plugin.json](../../.claude-plugin/plugin.json) - 插件配置

---

**创建日期**: 2026-01-19
**版本**: 1.0.0
**状态**: 已完成,待测试
