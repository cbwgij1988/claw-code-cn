# Claw Code CN

中文优化版的 Claw Code，支持本地模型部署，修复了编码问题和本地模型连接问题。

## 🚀 功能特点

- ✅ **本地模型支持** - 完全支持 LM Studio、Ollama 等本地模型服务
- ✅ **无编码问题** - 修复所有终端乱码问题，使用 ASCII 字符确保兼容性  
- ✅ **快速部署** - 一键构建，无需复杂配置
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

## 📦 构建安装

### 从源代码构建
```bash
# 克隆仓库
git clone https://github.com/cbwgij1988/claw-code-cn.git
cd claw-code-cn

# 构建项目
cd rust
cargo build --release

# 主程序位于
./target/release/claw
```

### 依赖要求
- Rust 1.70+
- Cargo

## 🎯 支持的本地模型服务

- **LM Studio** - 完全支持
- **Ollama** - 完全支持（启用 OpenAI 兼容模式）
- **vLLM** - 支持
- **Text Generation WebUI** - 支持
- **其他 OpenAI 兼容服务** - 理论支持

## 🛡️ 许可证

MIT License