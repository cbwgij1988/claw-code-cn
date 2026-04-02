#!/bin/bash

# Claw Code 完整打包脚本
# 创建包含所有必要文件的发布包

set -e

VERSION="0.1.0"
DIST_DIR="dist"
PACKAGE_NAME="claw-code-${VERSION}-linux-x86_64"
PACKAGE_FILE="${PACKAGE_NAME}.tar.gz"

echo "📦 开始打包 Claw Code v${VERSION}..."

# 清理旧的打包文件
rm -f "${PACKAGE_FILE}"

# 确保二进制文件是最新的
echo "🔨 编译二进制文件..."
cd rust
cargo build --release
cd ..

# 复制二进制文件
echo "📋 复制文件..."
cp rust/target/release/claw "${DIST_DIR}/"

# 创建临时打包目录
TEMP_DIR=$(mktemp -d)
mkdir -p "${TEMP_DIR}/${PACKAGE_NAME}"

# 复制所有必要文件
cp "${DIST_DIR}/claw" "${TEMP_DIR}/${PACKAGE_NAME}/"
cp "${DIST_DIR}/install.sh" "${TEMP_DIR}/${PACKAGE_NAME}/"
cp "${DIST_DIR}/claw-local.sh" "${TEMP_DIR}/${PACKAGE_NAME}/"
cp "${DIST_DIR}/INSTALL.md" "${TEMP_DIR}/${PACKAGE_NAME}/"
cp "${DIST_DIR}/USAGE.md" "${TEMP_DIR}/${PACKAGE_NAME}/"
cp "${DIST_DIR}/LOCAL_MODELS.md" "${TEMP_DIR}/${PACKAGE_NAME}/"
cp README.md "${TEMP_DIR}/${PACKAGE_NAME}/"

# 设置执行权限
chmod +x "${TEMP_DIR}/${PACKAGE_NAME}/claw"
chmod +x "${TEMP_DIR}/${PACKAGE_NAME}/install.sh"
chmod +x "${TEMP_DIR}/${PACKAGE_NAME}/claw-local.sh"

# 创建 tar 包
echo "📦 创建压缩包..."
cd "${TEMP_DIR}"
tar -czf "${OLDPWD}/${PACKAGE_FILE}" "${PACKAGE_NAME}"
cd "${OLDPWD}"

# 清理临时目录
rm -rf "${TEMP_DIR}"

# 显示包信息
echo ""
echo "✅ 打包完成！"
echo ""
echo "📦 包信息:"
echo "   文件名: ${PACKAGE_FILE}"
echo "   大小: $(du -h "${PACKAGE_FILE}" | cut -f1)"
echo "   内容:"
echo "   - claw          (主程序)"
echo "   - install.sh    (安装脚本)"
echo "   - claw-local.sh (本地模型启动脚本)"
echo "   - INSTALL.md     (安装说明)"
echo "   - USAGE.md      (使用指南)"
echo "   - LOCAL_MODELS.md (本地模型配置)"
echo "   - README.md     (项目说明)"
echo ""
echo "🚀 快速安装:"
echo "   tar -xzf ${PACKAGE_FILE}"
echo "   cd ${PACKAGE_NAME}"
echo "   ./install.sh"
echo ""
echo "🔧 使用本地模型:"
echo "   ./claw-local.sh -p \"你好\""
echo ""