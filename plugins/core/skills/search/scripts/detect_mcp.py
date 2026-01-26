#!/usr/bin/env python3
"""
MCP 工具检测脚本

根据用户查询内容，自动推荐合适的 MCP 工具。

用法:
    python detect_mcp.py "用户查询内容"
    echo "用户查询" | python detect_mcp.py

输出:
    JSON 格式的工具推荐结果
"""

import json
import re
import sys
from typing import Dict, List


def remove_code_blocks(text: str) -> str:
    """移除代码块和行内代码，避免误判"""
    # 移除代码块
    text = re.sub(r'```[\s\S]*?```', '', text)
    # 移除行内代码
    text = re.sub(r'`[^`]+`', '', text)
    return text


# MCP 工具关键词配置 (DRY: 统一的数据结构)
MCP_TOOLS = {
    "context7": {
        "name": "官方文档查询",
        "tool_name": "mcp__plugin_oh_context7__query-docs",
        "patterns": [
            # 英文
            r'\bhow\s+to\s+use\b', r'\bhow\s+do\s+i\b', r'\bbest\s+practice', r'\bdocumentation\b', r'\bdocs\b',
            r'\bapi\b', r'\breference\b', r'\bguide\b', r'\btutorial\b', r'\bmanual\b', r'\bspecification\b',
            # 中文
            r'如何使用', r'怎么用', r'最佳实践', r'文档', r'教程', r'指南', r'手册', r'规范', r'API\s*文档', r'官方文档',
        ]
    },
    "grep_app": {
        "name": "GitHub 代码搜索",
        "tool_name": "mcp__plugin_oh_grep_app__searchGitHub",
        "patterns": [
            # 英文
            r'\bexample', r'\bimplementation\b', r'\bsource\s+code\b', r'\bgithub\b', r'\brepo\b', r'\brepository\b',
            r'\bcode\s+sample\b', r'\busage\s+example\b', r'\breal\s+world\b', r'\bdemo\b', r'\bsample\s+code\b',
            r'\bopen\s+source\b', r'\bcode\s+pattern\b',
            # 中文
            r'例子', r'示例', r'实现', r'源码', r'源代码', r'代码', r'仓库', r'开源', r'案例', r'实际代码',
        ]
    },
    "web_search": {
        "name": "最新信息搜索",
        "tool_name": "mcp__plugin_oh_web_search__web_search_exa",
        "patterns": [
            # 英文 - 年份和最新信息
            r'\b2025\b', r'\b2026\b', r'\blatest\b', r'\bnew\b', r'\brecent\b', r'\bnews\b',
            r'\bupdate', r'\bversion\s+\d+', r'\brelease\b', r'\bchangelog\b', r"\bwhat's\s+new\b",
            r'\bcurrent\b', r'\bmodern\b', r'\bupcoming\b',
            # 英文 - Bug 修复
            r'\bfix\s+bug', r'\berror\b', r'\bissue\b', r'\btroubleshooting\b', r'\bdebug\b',
            # 中文 - 最新信息
            r'最新', r'最近', r'新闻', r'更新', r'版本', r'发布', r'变更', r'新特性', r'当前', r'现代', r'即将',
            # 中文 - Bug 修复
            r'修复\s*bug', r'fix\s*bug', r'解决错误', r'排除故障', r'调试', r'报错',
        ]
    },
}


def detect_tools(query: str) -> List[Dict]:
    """
    检测适合的 MCP 工具

    Args:
        query: 用户查询内容

    Returns:
        匹配的工具列表，按优先级排序
    """
    # 移除代码块避免误判
    clean_query = remove_code_blocks(query).lower()

    matched_tools = []

    for tool_key, tool_config in MCP_TOOLS.items():
        # 检查是否匹配任何关键词模式
        for pattern in tool_config['patterns']:
            if re.search(pattern, clean_query, re.IGNORECASE):
                matched_tools.append({
                    'key': tool_key,
                    'name': tool_config['name'],
                    'tool_name': tool_config['tool_name'],
                    'matched_pattern': pattern,
                })
                break  # 找到匹配即可，不需要检查所有模式

    return matched_tools


def main():
    """主函数"""
    # 读取输入
    if len(sys.argv) > 1:
        query = ' '.join(sys.argv[1:])
    else:
        query = sys.stdin.read().strip()

    if not query:
        print(json.dumps({"error": "No query provided"}, ensure_ascii=False))
        sys.exit(1)

    # 检测工具
    matched = detect_tools(query)

    # 构建结果
    result = {
        "query": query,
        "matched_tools": matched,
        "recommendations": []
    }

    # 生成推荐说明
    if matched:
        for tool in matched:
            result["recommendations"].append({
                "tool": tool['key'],
                "name": tool['name'],
                "tool_name": tool['tool_name'],
                "reason": f"匹配关键词: {tool['matched_pattern']}"
            })
    else:
        result["recommendations"].append({
            "tool": "none",
            "name": "无需特定 MCP 工具",
            "tool_name": None,
            "reason": "未检测到相关关键词"
        })

    # 输出 JSON
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
