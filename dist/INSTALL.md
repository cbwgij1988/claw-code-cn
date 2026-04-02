# Claw Code v0.1.0

## 📦 包含内容

- `claw` - 主程序二进制文件 (13MB)
- `install.sh` - 自动安装脚本
- `USAGE.md` - 详细使用指南
- `README.md` - 项目说明文档

## 🚀 快速安装

### Linux/macOS

```bash
# 1. 解压包
tar -xzf claw-code-0.1.0-linux-x86_64.tar.gz
cd claw-code-0.1.0

# 2. 运行安装脚本
chmod +x install.sh
./install.sh

# 3. 验证安装
claw --version
```

## ✨ 主要特性

- ✅ 支持多种 AI 模型（Claude、Grok、OpenAI 兼容）
- ✅ 支持本地模型（LM Studio、Ollama 等）
- ✅ 交互式 REPL 模式
- ✅ 单次提示模式
- ✅ 权限管理（只读、写入、完全访问）
- ✅ OAuth 认证
- ✅ 会话管理
- ✅ 插件系统
- ✅ 工具调用

## 🔧 系统要求

- Linux 或 macOS
- x86_64 架构
- 至少 50MB 可用磁盘空间

## 📝 使用示例

```bash
# 启动交互式模式
claw

# 单次提示
claw -p "帮我写一个 Python 函数"

# 使用本地模型
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="lm-studio"
claw --model llama-3-8b-instruct
```

## 📚 更多信息

详细使用指南请查看 `USAGE.md`

项目主页: https://github.com/instructkr/claw-code

## 📄 许可证

MIT License