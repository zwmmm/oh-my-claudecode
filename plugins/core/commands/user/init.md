# 用户配置初始化

将插件的全局规则追加到 `~/.claude/CLAUDE.md` 文件。

> 💡 **说明**: 本命令读取 `${CLAUDE_PLUGIN_ROOT}/templates/user/CLAUDE.md`
> 模板，并将其内容追加到全局配置文件 `~/.claude/CLAUDE.md`。

---

## 执行流程

1. **检查全局文件**
   - 检查 `~/.claude/CLAUDE.md` 是否存在
   - 若不存在，则创建新文件

2. **读取模板内容**
   - 读取 `${CLAUDE_PLUGIN_ROOT}/templates/user/CLAUDE.md`
   - 验证模板文件格式

3. **追加内容**
   - 将模板内容追加到全局文件末尾
   - 添加适当的分隔符标识
