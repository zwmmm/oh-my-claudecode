#!/bin/bash

# Pre-commit Hook for Claude Code Plugin
# 在 Git 提交前自动检查代码质量

set -e  # 遇到错误时退出

echo "🔍 运行 Pre-commit 检查..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否有暂存的文件
if git diff --cached --quiet; then
    echo "💭 没有暂存的文件,跳过检查"
    exit 0
fi

# 1. 检查文件大小 (防止意外提交大文件)
echo ""
echo "📦 检查文件大小..."
MAX_FILE_SIZE=1048576  # 1MB

LARGE_FILES=$(git diff --cached --name-only --diff-filter=A | \
    while read file; do
        if [ -f "$file" ]; then
            size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo 0)
            if [ "$size" -gt "$MAX_FILE_SIZE" ]; then
                echo "$file ($((size / 1024))KB)"
            fi
        fi
    done)

if [ -n "$LARGE_FILES" ]; then
    echo -e "${YELLOW}⚠️  警告:以下文件超过 1MB:${NC}"
    echo "$LARGE_FILES"
    echo "建议使用 Git LFS 或移除这些文件"
fi

# 2. 检查敏感信息
echo ""
echo "🔒 检查敏感信息..."
SECRETS_PATTERN="(password|secret|api_key|private_key|access_token|auth_token)\s*[:=]\s*[\"']?[^\s\"']+"

if git diff --cached --text | grep -iE "$SECRETS_PATTERN" > /dev/null; then
    echo -e "${RED}❌ 错误:检测到可能的敏感信息!${NC}"
    echo "请检查暂存的更改,确保没有提交密码、密钥或其他敏感信息"
    echo "运行 'git diff --cached' 查看暂存的更改"
    exit 1
fi

# 3. 检查代码规范 (如果项目配置了 linter)
if command -v eslint &> /dev/null && [ -f "package.json" ]; then
    echo ""
    echo "📏 运行 ESLint 检查..."
    # 只检查暂存的 JS/TS 文件
    STAGED_JS_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|jsx|ts|tsx)$' || true)

    if [ -n "$STAGED_JS_FILES" ]; then
        if npx eslint $STAGED_JS_FILES; then
            echo -e "${GREEN}✅ ESLint 检查通过${NC}"
        else
            echo -e "${RED}❌ ESLint 检查失败${NC}"
            echo "运行 'npm run lint' 或 'npx eslint <file>' 查看详细错误"
            echo "可以运行 'git commit --no-verify' 跳过此检查"
            exit 1
        fi
    fi
fi

# 4. 检查提交消息格式 (可选)
COMMIT_MSG_FILE=$1
if [ -f "$COMMIT_MSG_FILE" ]; then
    echo ""
    echo "📝 检查提交消息格式..."

    COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

    # 检查是否以空行开头 (避免)
    if [[ "$COMMIT_MSG" == ^[[:space:]] ]]; then
        echo -e "${YELLOW}⚠️  警告:提交消息以空行开头${NC}"
    fi

    # 建议使用 Conventional Commits 格式
    if ! echo "$COMMIT_MSG" | head -n1 | grep -qE '^(feat|fix|docs|style|refactor|test|chore|build|ci|perf|revert)(\(.+\))?: '; then
        echo -e "${YELLOW}💡 建议:使用 Conventional Commits 格式${NC}"
        echo "示例:feat:添加新功能,fix:修复bug,docs:更新文档"
    fi
fi

echo ""
echo -e "${GREEN}✅ Pre-commit 检查完成!${NC}"
echo "🚀 准备提交..."

exit 0
