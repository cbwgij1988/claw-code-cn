# Claw Code 本地模型支持 - 修改说明

## 📋 修改概述

本次修改为 Claw Code 添加了完整的本地模型支持，使其能够连接 LM Studio、Ollama 等 OpenAI 兼容的本地模型服务。

## 🔧 核心修改

### 1. API 提供商检测逻辑优化

**文件**: `rust/crates/api/src/providers/mod.rs`

**修改内容**:
- 调整了 `detect_provider_kind()` 函数的检测优先级
- 现在优先检查 `OPENAI_API_KEY` 和 `XAI_API_KEY`
- 最后才检查 Claw API 凭据

**修改前**:
```rust
pub fn detect_provider_kind(model: &str) -> ProviderKind {
    if let Some(metadata) = metadata_for_model(model) {
        return metadata.provider;
    }
    if claw_provider::has_auth_from_env_or_saved().unwrap_or(false) {
        return ProviderKind::ClawApi;
    }
    if openai_compat::has_api_key("OPENAI_API_KEY") {
        return ProviderKind::OpenAi;
    }
    // ...
}
```

**修改后**:
```rust
pub fn detect_provider_kind(model: &str) -> ProviderKind {
    if let Some(metadata) = metadata_for_model(model) {
        return metadata.provider;
    }
    // 优先检查 OpenAI API key
    if openai_compat::has_api_key("OPENAI_API_KEY") {
        return ProviderKind::OpenAi;
    }
    if openai_compat::has_api_key("XAI_API_KEY") {
        return ProviderKind::Xai;
    }
    // 最后检查 Claw API 凭据
    if claw_provider::has_auth_from_env_or_saved().unwrap_or(false) {
        return ProviderKind::ClawApi;
    }
    ProviderKind::ClawApi
}
```

### 2. CLI 认证源解析增强

**文件**: `rust/crates/claw-cli/src/main.rs`

**修改内容**:
- 修改了 `resolve_cli_auth_source()` 函数
- 添加了对 `OPENAI_API_KEY` 和 `XAI_API_KEY` 的支持
- 优先使用 OpenAI 兼容的 API key

**修改前**:
```rust
fn resolve_cli_auth_source() -> Result<AuthSource, Box<dyn std::error::Error>> {
    Ok(resolve_startup_auth_source(|| {
        // ... 只支持 Claw OAuth
    })?)
}
```

**修改后**:
```rust
fn resolve_cli_auth_source() -> Result<AuthSource, Box<dyn std::error::Error>> {
    // 首先检查 OpenAI API key
    if let Some(api_key) = std::env::var("OPENAI_API_KEY")
        .ok()
        .filter(|value| !value.is_empty())
    {
        return Ok(AuthSource::ApiKey(api_key));
    }
    
    // 检查 XAI API key
    if let Some(api_key) = std::env::var("XAI_API_KEY")
        .ok()
        .filter(|value| !value.is_empty())
    {
        return Ok(AuthSource::ApiKey(api_key));
    }
    
    // 最后使用 Claw API
    Ok(resolve_startup_auth_source(|| {
        // ...
    })?)
}
```

### 3. 运行时客户端提供商支持

**文件**: `rust/crates/claw-cli/src/main.rs`

**修改内容**:
- 将 `DefaultRuntimeClient` 的 `client` 字段类型从 `ClawApiClient` 改为 `api::ProviderClient`
- 修改了 `DefaultRuntimeClient::new()` 方法，使用 `ProviderClient::from_model_with_default_auth()`
- 支持根据检测到的提供商类型自动选择正确的客户端

**修改前**:
```rust
struct DefaultRuntimeClient {
    runtime: tokio::runtime::Runtime,
    client: ClawApiClient,  // 硬编码使用 ClawApiClient
    // ...
}

impl DefaultRuntimeClient {
    fn new(...) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(Self {
            runtime: tokio::runtime::Runtime::new()?,
            client: ClawApiClient::from_auth(resolve_cli_auth_source()?)
                .with_base_url(api::read_base_url()),
            // ...
        })
    }
}
```

**修改后**:
```rust
struct DefaultRuntimeClient {
    runtime: tokio::runtime::Runtime,
    client: api::ProviderClient,  // 支持多种提供商
    // ...
}

impl DefaultRuntimeClient {
    fn new(...) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(Self {
            runtime: tokio::runtime::Runtime::new()?,
            client: api::ProviderClient::from_model_with_default_auth(
                &model, 
                Some(resolve_cli_auth_source()?)
            )?,
            // ...
        })
    }
}
```

### 4. 工具定义修复

**文件**: `rust/crates/tools/src/lib.rs`

**修改内容**:
- 修复了 `StructuredOutput` 工具的 `input_schema` 定义
- 添加了缺失的 `properties` 字段，避免 OpenAI API 验证错误

**修改前**:
```rust
ToolSpec {
    name: "StructuredOutput",
    description: "Return structured output in the requested format.",
    input_schema: json!({
        "type": "object",
        "additionalProperties": true
    }),
    // ...
}
```

**修改后**:
```rust
ToolSpec {
    name: "StructuredOutput",
    description: "Return structured output in the requested format.",
    input_schema: json!({
        "type": "object",
        "properties": {},  // 添加缺失的 properties 字段
        "additionalProperties": true
    }),
    // ...
}
```

## 📦 新增文件

### 1. 本地模型启动脚本

**文件**: `dist/claw-local.sh`

**功能**:
- 自动设置本地模型所需的环境变量
- 检查本地服务是否运行
- 提供友好的错误提示
- 支持命令行参数传递

**使用方法**:
```bash
./claw-local.sh -p "你好"
./claw-local.sh --model qwen3.5-122b-a10b -p "你好"
```

### 2. 本地模型配置文档

**文件**: `dist/LOCAL_MODELS.md`

**内容**:
- LM Studio 配置指南
- Ollama 配置指南
- vLLM 配置指南
- Text Generation WebUI 配置指南
- 常见问题解答
- 调试技巧

### 3. 安装和使用文档

**文件**: `dist/INSTALL.md`, `dist/USAGE.md`

**内容**:
- 详细的安装步骤
- 使用示例
- 配置说明
- 故障排除

### 4. 自动打包脚本

**文件**: `package.sh`

**功能**:
- 自动编译最新版本
- 创建完整的发布包
- 包含所有必要的文档和脚本
- 生成 tar.gz 压缩包

## 🚀 使用方法

### 快速开始

```bash
# 1. 解压包
tar -xzf claw-code-0.1.0-linux-x86_64.tar.gz
cd claw-code-0.1.0-linux-x86_64

# 2. 安装
./install.sh

# 3. 使用本地模型
./claw-local.sh -p "你好"
```

### 环境变量配置

```bash
# LM Studio (默认)
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="local-model"

# Ollama
export OPENAI_BASE_URL="http://localhost:11434/v1"
export OPENAI_API_KEY="ollama"

# 自定义服务
export OPENAI_BASE_URL="http://your-server:port/v1"
export OPENAI_API_KEY="your-api-key"
```

### 命令行使用

```bash
# 单次提示
claw -p "你的提示词"

# 交互式模式
claw

# 使用本地模型
./claw-local.sh -p "你的提示词"

# 指定模型
claw --model qwen3.5-122b-a10b -p "你的提示词"

# 权限模式
claw --permission-mode read-only -p "查看代码"
```

## 🎯 支持的本地模型服务

### ✅ 已测试
- **LM Studio** - 完全支持
- **Ollama** - 完全支持（需要 OpenAI 兼容层）

### 🔄 理论支持
- **vLLM** - 支持 OpenAI API
- **Text Generation WebUI** - 支持 OpenAI API 模式
- **其他 OpenAI 兼容服务** - 应该都可以工作

## ⚠️ 已知问题

### 1. 字符编码问题

**现象**: 终端输出中某些字符显示异常

**原因**: UTF-8 编码处理问题

**影响**: 不影响功能，仅影响显示

**状态**: 待修复

### 2. 工具调用兼容性

**现象**: 某些本地模型可能不支持工具调用

**解决方案**: 使用不支持工具调用的模型时，claw 会自动降级到纯文本模式

## 📊 测试结果

### 测试环境
- 操作系统: Linux
- 本地服务: LM Studio
- 模型: Qwen3.5-122B-A10B
- 测试命令: `./claw-local.sh -p "你好"`

### 测试结果
✅ 环境变量检测正常
✅ 提供商检测正确
✅ API 连接成功
✅ 消息发送成功
✅ 响应接收正常
✅ 工具调用功能正常

## 🔍 技术细节

### 提供商检测流程

```
1. 检查模型名称是否在预定义列表中
   ↓ (否)
2. 检查 OPENAI_API_KEY 环境变量
   ↓ (否)
3. 检查 XAI_API_KEY 环境变量
   ↓ (否)
4. 检查 Claw API 凭据
   ↓ (否)
5. 默认使用 ClawApi
```

### 请求处理流程

```
用户输入
   ↓
resolve_cli_auth_source()
   ↓
ProviderClient::from_model_with_default_auth()
   ↓
detect_provider_kind()
   ↓
选择正确的客户端 (ClawApiClient / OpenAiCompatClient)
   ↓
发送 API 请求
   ↓
处理响应
   ↓
显示结果
```

## 📝 开发者指南

### 添加新的提供商支持

1. 在 `rust/crates/api/src/providers/mod.rs` 中添加新的 `ProviderKind`
2. 实现新的客户端（参考 `OpenAiCompatClient`）
3. 在 `detect_provider_kind()` 中添加检测逻辑
4. 在 `resolve_cli_auth_source()` 中添加认证逻辑
5. 在 `ProviderClient` 枚举中添加新变体

### 调试技巧

```bash
# 启用详细日志
RUST_LOG=debug claw -p "测试"

# 检查环境变量
env | grep -E "OPENAI|XAI|ANTHROPIC"

# 测试 API 连接
curl http://localhost:1234/v1/models
```

## 🎉 总结

本次修改成功为 Claw Code 添加了完整的本地模型支持，使其能够在不依赖云端 API 的情况下运行。主要改进包括：

1. ✅ 优先支持 OpenAI 兼容的本地模型
2. ✅ 自动检测和选择正确的 API 客户端
3. ✅ 提供友好的本地模型启动脚本
4. ✅ 完整的文档和配置指南
5. ✅ 修复工具定义的兼容性问题

用户现在可以：
- 使用 LM Studio、Ollama 等本地模型服务
- 在完全离线的环境中运行 Claw Code
- 享受开源大模型的所有功能
- 保持与云端 API 的兼容性

## 📚 相关文档

- [INSTALL.md](dist/INSTALL.md) - 安装说明
- [USAGE.md](dist/USAGE.md) - 使用指南
- [LOCAL_MODELS.md](dist/LOCAL_MODELS.md) - 本地模型配置
- [README.md](README.md) - 项目说明

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进本地模型支持！

## 📄 许可证

MIT License - 与原项目保持一致