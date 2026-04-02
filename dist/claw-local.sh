#!/bin/bash

# Claw Code 本地模型启动脚本
# 用于连接 LM Studio、Ollama 等本地模型服务

set -e

# 默认配置
OPENAI_BASE_URL="${OPENAI_BASE_URL:-http://localhost:1234/v1}"
OPENAI_API_KEY="${OPENAI_API_KEY:-local-model}"
MODEL="${MODEL:-gpt-3.5-turbo}"

# 解析命令行参数
ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --model)
            MODEL="$2"
            shift 2
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done

# 设置环境变量
export OPENAI_BASE_URL
export OPENAI_API_KEY

# 获取 claw 的路径
CLAW_BIN="$(dirname "$0")/claw"

# 检查 claw 是否存在
if [ ! -f "$CLAW_BIN" ]; then
    echo "❌ 错误: 找不到 claw 二进制文件"
    echo "   期望位置: $CLAW_BIN"
    exit 1
fi

# 检查本地服务是否运行
echo "🔍 检查本地服务: $OPENAI_BASE_URL"
if ! curl -s -f "$OPENAI_BASE_URL/models" > /dev/null 2>&1; then
    echo "⚠️  警告: 无法连接到本地服务 $OPENAI_BASE_URL"
    echo "   请确保本地模型服务正在运行"
    echo ""
    echo "   LM Studio: Settings → Server → 启用服务器"
    echo "   Ollama: 确保 ollama 服务正在运行"
fi

# 运行 claw
echo "🚀 启动 Claw Code..."
echo "   API 地址: $OPENAI_BASE_URL"
echo "   模型: $MODEL"
echo ""

exec "$CLAW_BIN" --model "$MODEL" "${ARGS[@]}"