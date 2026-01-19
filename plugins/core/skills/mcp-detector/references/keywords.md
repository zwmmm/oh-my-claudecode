# MCP 关键词识别规则

本文档定义了各个 MCP 工具的关键词触发规则和识别模式。

## context7 - 官方文档查询

### 英文关键词
- `how to use` - 如何使用
- `how do i` - 我如何...
- `best practice` / `best practices` - 最佳实践
- `documentation` / `docs` - 文档
- `api` - API 接口
- `reference` - 参考
- `guide` - 指南
- `tutorial` - 教程
- `manual` - 手册
- `specification` / `spec` - 规范

### 中文关键词
- `如何使用`
- `怎么用`
- `最佳实践`
- `文档`
- `教程`
- `指南`
- `手册`
- `规范`
- `API 文档`
- `官方文档`

### 日语关键词
- `使い方` (tsukaikata) - 使用方法
- `ドキュメント` (dokyumento) - 文档
- `ガイド` (gaido) - 指南
- `チュートリアル` (chūtoriaru) - 教程
- `マニュアル` (manyuaru) - 手册
- `仕様` (shiyō) - 规范
- `リファレンス` (rifarensu) - 参考

### 韩语关键词
- `사용법` (sayongbeop) - 使用方法
- `최적의` (choejeogui) - 最佳的
- `문서` (munseo) - 文档
- `가이드` (gaideu) - 指南
- `튜토리얼` (tyutorieol) - 教程
- `매뉴얼` (maenyueol) - 手册
- `사양` (sayang) - 规范

### 正则表达式模式
```regex
/\b(how\s+to\s+use|how\s+do\s+i|best\s+practice|documentation|docs|api|reference|guide|tutorial|manual|specification)\b|如何使用|最佳实践|文档|教程|使い方|ドキュメント|ガイド|사용법|최적의|문서|가이드|튜토리얼/i
```

---

## grep_app - GitHub 代码搜索

### 英文关键词
- `example` / `examples` - 示例
- `implementation` - 实现
- `source code` - 源代码
- `github` - GitHub
- `repo` / `repository` - 仓库
- `code sample` - 代码样本
- `usage example` - 使用示例
- `real world` - 真实世界
- `demo` - 演示
- `sample code` - 示例代码
- `open source` - 开源
- `code pattern` - 代码模式

### 中文关键词
- `例子`
- `示例`
- `实现`
- `源码`
- `源代码`
- `代码`
- `仓库`
- `开源`
- `案例`
- `实际代码`

### 日语关键词
- `実装` (jissō) - 实现
- `ソース` (sōsu) - 源码
- `例` (rei) - 例子
- `サンプル` (sanpuru) - 示例
- `コード` (kōdo) - 代码
- `リポジトリ` (ripojitori) - 仓库
- `オープンソース` (ōpun sōsu) - 开源

### 韩语关键词
- `구현` (guhyeon) - 实现
- `소스` (soseu) - 源码
- `예제` (yeje) - 例子
- `코드` (kodeu) - 代码
- `샘플` (saempeul) - 示例
- `저장소` (jeojangso) - 仓库
- `오픈소스` (opeun soseu) - 开源

### 正则表达式模式
```regex
/\b(example|implementation|source\s+code|github|repo|repository|code\s+sample|usage\s+example|real\s+world|demo|sample\s+code)\b|例子|实现|源码|示例|代码|구현|소스|예제|코드|実装|ソース|例|サンプル/i
```

---

## web_search - 最新信息搜索

### 英文关键词
- `2025` / `2026` - 年份
- `latest` - 最新
- `new` - 新的
- `recent` - 最近的
- `news` - 新闻
- `update` / `updates` - 更新
- `version X` - 版本号
- `release` - 发布
- `changelog` - 变更日志
- `what's new` - 新特性
- `current` - 当前
- `modern` - 现代的
- `upcoming` - 即将到来
- `fix bug` / `fix bugs` - 修复 bug
- `error` - 错误
- `issue` - 问题/issue
- `troubleshooting` - 故障排除
- `debug` - 调试

### 中文关键词
- `最新`
- `最近`
- `新闻`
- `更新`
- `版本`
- `发布`
- `变更`
- `新特性`
- `当前`
- `现代`
- `即将`
- `修复 bug`
- `fix bug`
- `解决错误`
- `排除故障`
- `调试`

### 日语关键词
- `最新` (saishin) - 最新
- `リリース` (ririsu) - 发布
- `ニュース` (nyūsu) - 新闻
- `アップデート` (appudēto) - 更新
- `バージョン` (bājon) - 版本
- `新機能` (shinkinou) - 新功能
- `最近` (saikin) - 最近

### 韩语关键词
- `최신` (choesin) - 最新
- `뉴스` (nyuseu) - 新闻
- `업데이트` (eobdeiteu) - 更新
- `버전` (beojeon) - 版本
- `발표` (balpyo) - 发布
- `변경` (byeongyeong) - 变更
- `최근` (choegeun) - 最近

### 正则表达式模式
```regex
/\b(2025|2026|latest|new|recent|news|update|version\s+\d+|release|changelog|what's\s+new|current|modern|fix\s+bug|error|issue|troubleshooting|debug)\b|最新|新闻|更新|版本|发布|修复\s*bug|fix\s*bug|解决错误|排除故障|调试|최신|뉴스|업데이트|버전|버그\s*수정|오류\s*해결|최신|リリース|ニュース|アップデート|バージョン|バグ\s*修正/i
```

---

## 识别逻辑

### 1. 文本预处理
在进行关键词匹配前,需要:
- 移除代码块 (``` 包裹的内容)
- 移除行内代码 (` 包裹的内容)
- 保留自然语言文本

### 2. 多工具匹配
- 一个查询可能同时匹配多个 MCP 工具
- 按优先级推荐所有匹配的工具
- 不要过度限制,允许多个工具同时使用

### 3. 优先级规则
当多个工具都匹配时:
1. **context7** - 优先用于获取官方文档和规范
2. **grep_app** - 用于查找实际代码实现
3. **web_search** - 用于获取最新信息和更新

### 4. 误判预防
避免误判的规则:
- 忽略代码块中的关键词
- 需要完整的词匹配,不匹配部分词
- 考虑上下文语境

## 示例场景

### 场景 1: 纯文档查询
**用户输入**: "How to use React useEffect hook?"

**匹配结果**:
- ✅ context7 (关键词: "how to use")
- ❌ grep_app (无匹配)
- ❌ web_search (无匹配)

**推荐**: 仅使用 context7 查找官方文档

---

### 场景 2: 代码示例查询
**用户输入**: "Show me real-world examples of Express.js authentication"

**匹配结果**:
- ❌ context7 (无匹配)
- ✅ grep_app (关键词: "examples", "real-world")
- ❌ web_search (无匹配)

**推荐**: 仅使用 grep_app 搜索 GitHub 代码

---

### 场景 3: 最新信息查询
**用户输入**: "What's new in React 2025?"

**匹配结果**:
- ❌ context7 (无匹配)
- ❌ grep_app (无匹配)
- ✅ web_search (关键词: "what's new", "2025")

**推荐**: 仅使用 web_search 查找最新信息

---

### 场景 4: 多工具组合查询
**用户输入**: "React hooks 最佳实践和实际使用例子"

**匹配结果**:
- ✅ context7 (关键词: "最佳实践")
- ✅ grep_app (关键词: "例子")
- ❌ web_search (无匹配)

**推荐**: 同时使用 context7 和 grep_app

---

### 场景 5: Bug 修复查询
**用户输入**: "修复 bug: useEffect 报错 Too many re-renders"

**匹配结果**:
- ❌ context7 (无匹配)
- ❌ grep_app (无匹配)
- ✅ web_search (关键词: "修复 bug", "报错")

**推荐**: 使用 web_search 查找该错误的最新解决方案

---

### 场景 6: 代码块过滤
**用户输入**:
```
我想修复这段代码:
\`\`\`js
// how to use this function?
function example() {}
\`\`\`
```

**匹配结果**:
- ❌ context7 (代码块中的 "how to use" 被忽略)
- ❌ grep_app (代码块中的 "example" 被忽略)
- ✅ web_search (关键词: "修复", 虽然在自然语言中)

**推荐**: 使用 web_search 查找相关信息

---

## 持续优化

本关键词列表应该根据实际使用情况持续优化:

1. **添加遗漏的关键词** - 发现新的常用查询模式
2. **移除误判关键词** - 删除导致频繁误判的关键词
3. **调整优先级** - 根据使用效果调整工具推荐顺序
4. **扩展语言支持** - 添加更多语言的关键词

遵循 **YAGNI** 原则,只添加真正需要的关键词。
