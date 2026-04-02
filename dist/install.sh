#!/bin/bash

# Claw Code 安装脚本
# 版本: 0.1.0

set -e

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
CLAW_BIN="$INSTALL_DIR/claw"

echo "🚀 开始安装 Claw Code..."
echo "📁 安装目录: $INSTALL_DIR"

# 创建安装目录
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📂 创建安装目录..."
    mkdir -p "$INSTALL_DIR"
fi

# 复制二进制文件
echo "📦 复制二进制文件..."
cp "$(dirname "$0")/claw" "$CLAW_BIN"

# 设置执行权限
chmod +x "$CLAW_BIN"

# 验证安装
echo "✅ 验证安装..."
if "$CLAW_BIN" --version > /dev/null 2>&1; then
    echo "✨ 安装成功！"
    echo ""
    echo "📝 使用方法:"
    echo "  claw                    # 启动交互式 REPL"
    echo "  claw -p \"你的提示词\"    # 单次提示"
    echo "  claw --help             # 查看帮助"
    echo ""
    echo "🔧 配置本地模型 (如 LM Studio):"
    echo "  export OPENAI_BASE_URL=\"http://localhost:1234/v1\""
    echo "  export OPENAI_API_KEY=\"your-api-key\""
    echo ""
    echo "📚 更多信息: https://github.com/instructkr/claw-code"
else
    echo "❌ 安装失败！"
    exit 1
fi

# 检查 PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠️  警告: $INSTALL_DIR 不在 PATH 中"
    echo "请将以下行添加到你的 shell 配置文件 (~/.bashrc 或 ~/.zshrc):"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
fi