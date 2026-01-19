#!/bin/bash

# Claude Code Hook - 通用通知系统

# 日志文件(用于调试)
LOG_FILE="$HOME/.claude/hooks/notify.log"
log_debug() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log_debug "=== Hook triggered ==="
log_debug "Working directory: $(pwd)"

# 从 stdin 读取 JSON 数据(必须在第一次使用 stdin)
INPUT=$(cat 2>/dev/null || echo "{}")
log_debug "stdin content: $(echo "$INPUT" | head -c 500)"

# 解析 JSON 字段
if command -v jq >/dev/null 2>&1 && [[ -n "$INPUT" ]]; then
    HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty' 2>/dev/null)
    MESSAGE=$(echo "$INPUT" | jq -r '.message // empty' 2>/dev/null)
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

    log_debug "Parsed HOOK_EVENT: $HOOK_EVENT"
    log_debug "Parsed message: $MESSAGE"
    log_debug "Parsed tool_name: $TOOL_NAME"
else
    HOOK_EVENT=""
    MESSAGE=""
    TOOL_NAME=""
fi

log_debug "Final event type: $HOOK_EVENT"

# 通知函数
send_notification() {
    local title="$1"
    local message="$2"
    noti -t "$title" -m "$message"
    echo -ne "\a"
}

# 根据 hook 事件类型处理
case "$HOOK_EVENT" in
    "Notification")
        send_notification "🔔 通知" "${MESSAGE:-有新的通知}"
        ;;
    "Stop")
        send_notification "🏁 任务完成" "Claude 已完成当前任务"
        ;;
    "PreToolUse")
        # 只在需要用户确认时通知,不通知所有工具调用
        send_notification "💬 需要确认" "${MESSAGE:-Claude 需要您的确认}"
        ;;
    "PermissionRequest")
        send_notification "🔐 权限请求" "${MESSAGE:-Claude 请求权限}"
        ;;
    *)
        log_debug "Unknown hook event: $HOOK_EVENT"
        ;;
esac

exit 0
