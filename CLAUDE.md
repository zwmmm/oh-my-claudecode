# CLAUDE.md

本文件为 Claude Code 提供项目特定的指导和配置。

## 项目概述

这是一个 Claude Code 插件开发模板,旨在提供:
- 标准的插件结构和最佳实践
- 可复用的命令和代理模板
- 完善的开发文档和示例

## 核心原则

本项目严格遵循以下软件开发原则:

### KISS (Keep It Simple, Stupid)
- 保持代码和设计简洁明了
- 优先选择最直观的解决方案
- 避免不必要的复杂性

### YAGNI (You Aren't Gonna Need It)
- 只实现当前明确需要的功能
- 抵制过度设计和未来特性预留
- 删除未使用的代码和依赖

### DRY (Don't Repeat Yourself)
- 自动识别重复代码模式
- 主动抽象和复用
- 统一相似功能的实现方式

### SOLID 原则
- **单一职责**: 每个组件/函数只做一件事
- **开闭原则**: 对扩展开放,对修改封闭
- **里氏替换**: 子类型可以替换父类型
- **接口隔离**: 接口专一,避免"胖接口"
- **依赖倒置**: 依赖抽象而非具体实现

## 开发工作流

### 常用命令

```bash
# 安装依赖 (如果有)
npm install

# 运行测试 (如果有)
npm test

# 代码格式化 (如果有)
npm run format

# 代码检查 (如果有)
npm run lint

# 构建 (如果有)
npm run build
```

### 插件测试

```bash
# 在 Claude Code 中测试命令
/hello-world
/code-review

# 测试 Git hooks
git commit -m "test: 测试 pre-commit hook"
```

## 项目结构

```
oh-my-claudecode/
├── .claude-plugin/           # 插件元数据
│   └── plugin.json          # 插件配置文件
├── .claude/                 # Claude Code 配置目录
│   ├── commands/            # Slash 命令定义
│   ├── agents/              # AI 代理定义
│   ├── hooks/               # 自动化钩子脚本
│   └── skills/              # 技能定义
├── CLAUDE.md               # 本文件
└── README.md               # 用户文档
```

## 插件开发指南

### 创建新命令

1. 在 `.claude/commands/` 创建 `.md` 文件
2. 添加 frontmatter 元数据
3. 定义命令功能、执行步骤、示例用法

### 创建新代理

1. 在 `.claude/agents/` 创建 `.md` 文件
2. 定义代理角色、核心能力、工作流程
3. 指定沟通风格和输出格式

### 创建新钩子

1. 在 `.claude/hooks/` 创建脚本文件
2. 添加可执行权限 (`chmod +x`)
3. 在 `plugin.json` 中注册

## 代码规范

### Markdown 文件
- 使用清晰的标题层次
- 代码块指定语言
- 列表使用一致的格式
- 添加适当的表格和分隔线

### 脚本文件
- 使用 shebang (`#!/bin/bash`)
- 添加错误处理 (`set -e`)
- 添加清晰的注释
- 使用有意义的变量名

### JSON 文件
- 使用 2 空格缩进
- 键名使用双引号
- 必要的字段添加注释

## 测试指南

### 命令测试
1. 使用 Claude Code CLI 执行命令
2. 验证输出是否符合预期
3. 测试边界情况和错误处理

### 钩子测试
1. 触发 Git 操作测试钩子
2. 验证钩子是否正常执行
3. 测试失败场景

### 代理测试
1. 与代理进行对话交互
2. 验证代理的建议和反馈
3. 测试代理的工具使用

## 发布流程

1. 更新版本号 (在 `plugin.json` 中)
2. 更新 CHANGELOG.md
3. 创建 Git tag
4. 推送到 GitHub
5. 发布 Release

## 注意事项

- 所有文件使用 UTF-8 编码
- 日期使用 ISO 8601 格式
- 遵循语义化版本控制
- 保持文档的更新和同步

## 相关资源

- [Claude Code 插件文档](https://code.claude.com/docs/en/plugins)
- [插件开发最佳实践](https://agnost.ai/blog/claude-code-plugins-guide)
- [Agent SDK 文档](https://docs.claude.com/en/docs/claude-code/sdk/sdk-overview)
