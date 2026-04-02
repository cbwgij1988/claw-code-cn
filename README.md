# Claw Code CN

中文优化版的 Claw Code，支持本地模型部署，修复了编码问题和本地模型连接问题。

## 🚀 功能特点

- ✅ **本地模型支持** - 完全支持 LM Studio、Ollama 等本地模型服务
- ✅ **无编码问题** - 修复所有终端乱码问题，使用 ASCII 字符确保兼容性  
- ✅ **快速部署** - 一键安装，无需复杂配置
- ✅ **完整功能** - 保留所有原有功能（工具调用、流式响应、会话管理等）
- ✅ **离线可用** - 完全离线环境下即可使用所有功能

## 🛠️ 修复内容

### 主要修复
1. **编码问题修复**
   - 将所有 Unicode emoji 字符替换为 ASCII 字符
   - 修复终端显示乱码问题
   - Spinner 动画使用 `/`, `-`, `\`, `|` 简单字符

2. **本地模型连接修复** 
   - 优先检测 OpenAI API key 而非 Claw API
   - 支持 OpenAI 兼容的本地模型服务
   - 修复认证流程

3. **工具 Schema 修复**
   - 修复 StructuredOutput 工具的 JSON schema
   - 确保工具调用与本地模型兼容

### 技术变更
- 修改 `rust/crates/claw-cli/src/render.rs` - ASCII spinner
- 修改 `rust/crates/claw-cli/src/main.rs` - ProviderClient 支持
- 修改 `rust/crates/api/src/providers/mod.rs` - 认证优先级
- 修改 `rust/crates/tools/src/lib.rs` - 工具 schema

## 📦 安装使用

### 直接下载
```bash
wget https://github.com/[YOUR_USERNAME]/claw-code-cn/releases/download/v0.1.0/claw-code-0.1.0-linux-x86_64.tar.gz
tar -xzf claw-code-0.1.0-linux-x86_64.tar.gz
cd claw-code-0.1.0-linux-x86_64
./install.sh
```

### 本地模型配置
```bash
# LM Studio
export OPENAI_API_KEY="local-model"
export OPENAI_BASE_URL="http://localhost:1234/v1"

# 启动本地模型模式
./claw-local.sh --model qwen3.5-122b-a10b -p "你好"
```

## 🎯 支持的本地模型服务

- **LM Studio** - 完全支持
- **Ollama** - 完全支持（启用 OpenAI 兼容模式）
- **vLLM** - 支持
- **Text Generation WebUI** - 支持
- **其他 OpenAI 兼容服务** - 理论支持

## 🛡️ 许可证

MIT License