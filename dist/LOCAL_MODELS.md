# Claw Code 本地模型配置指南

## 🚀 快速开始

### 方法 1: 使用启动脚本（推荐）

```bash
# LM Studio (默认端口 1234)
./claw-local.sh -p "你好"

# 指定模型
./claw-local.sh --model qwen3.5-122b-a10b -p "你好"

# 自定义服务地址
OPENAI_BASE_URL="http://localhost:11434/v1" ./claw-local.sh
```

### 方法 2: 手动配置环境变量

```bash
# 设置本地服务地址
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="local-model"

# 运行 claw
./claw --model gpt-3.5-turbo -p "你好"
```

## 🔧 支持的本地模型服务

### 1. LM Studio

#### 安装和配置

1. 下载并安装 [LM Studio](https://lmstudio.ai/)
2. 启动 LM Studio
3. 下载你需要的模型（如 Qwen、Llama 等）
4. 启用服务器：
   - 点击 Settings → Server
   - 勾选 "Enable Server"
   - 默认端口：1234
   - 默认地址：`http://localhost:1234/v1`

#### 使用

```bash
# 使用默认配置
./claw-local.sh -p "你好"

# 指定模型名称（在 LM Studio 中查看）
./claw-local.sh --model qwen3.5-122b-a10b -p "你好"
```

### 2. Ollama

#### 安装和配置

```bash
# 安装 Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 拉取模型
ollama pull llama2
ollama pull qwen

# 启动服务
ollama serve
```

#### 使用

```bash
# 设置 Ollama 地址
export OPENAI_BASE_URL="http://localhost:11434/v1"
export OPENAI_API_KEY="ollama"

# 运行 claw
./claw --model llama2 -p "你好"
```

### 3. vLLM

#### 安装和配置

```bash
# 安装 vLLM
pip install vllm

# 启动 OpenAI 兼容服务器
python -m vllm.entrypoints.openai.api_server \
    --model Qwen/Qwen2.5-7B-Instruct \
    --port 8000
```

#### 使用

```bash
export OPENAI_BASE_URL="http://localhost:8000/v1"
export OPENAI_API_KEY="vllm"
./claw --model Qwen/Qwen2.5-7B-Instruct -p "你好"
```

### 4. Text Generation WebUI

#### 安装和配置

```bash
# 克隆仓库
git clone https://github.com/oobabooga/text-generation-webui
cd text-generation-webui

# 启动服务器（OpenAI API 模式）
python server.py --api --listen --openai-api
```

#### 使用

```bash
export OPENAI_BASE_URL="http://localhost:5000/v1"
export OPENAI_API_KEY="webui"
./claw --model your-model-name -p "你好"
```

## ⚙️ 环境变量说明

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `OPENAI_BASE_URL` | 本地服务的 API 地址 | `http://localhost:1234/v1` |
| `OPENAI_API_KEY` | API 密钥（本地服务通常可以是任意值） | `local-model` |
| `MODEL` | 模型名称 | `gpt-3.5-turbo` |

## 📝 常见问题

### 问题 1: "missing Claw credentials"

**原因**: claw 检测到模型名称不在预定义列表中，默认尝试使用 Claw API

**解决方案**:

```bash
# 方法 1: 使用 gpt-3.5-turbo 作为模型名称（强制使用 OpenAI 提供商）
./claw-local.sh --model gpt-3.5-turbo -p "你好"

# 方法 2: 设置环境变量
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="local-model"
./claw --model gpt-3.5-turbo -p "你好"
```

### 问题 2: 无法连接到本地服务

**检查步骤**:

```bash
# 测试服务是否运行
curl http://localhost:1234/v1/models

# 检查端口是否被占用
netstat -tlnp | grep 1234

# 查看 LM Studio 日志
# 在 LM Studio 界面中查看 Server 标签页
```

### 问题 3: 模型名称错误

**解决方案**:

1. 在本地服务中查看可用模型列表：
   ```bash
   curl http://localhost:1234/v1/models | jq
   ```

2. 使用实际的模型名称：
   ```bash
   ./claw-local.sh --model your-actual-model-name -p "你好"
   ```

### 问题 4: 权限问题

**解决方案**:

```bash
# 确保脚本有执行权限
chmod +x claw-local.sh

# 确保二进制文件有执行权限
chmod +x claw
```

## 🎯 使用示例

### 基本使用

```bash
# 单次提示
./claw-local.sh -p "帮我写一个 Python 函数"

# 交互式模式
./claw-local.sh

# 指定模型
./claw-local.sh --model qwen3.5-122b-a10b -p "你好"
```

### 权限模式

```bash
# 只读模式
./claw-local.sh --permission-mode read-only -p "查看代码"

# 工作区写入模式
./claw-local.sh --permission-mode workspace-write -p "修改代码"
```

### 会话管理

```bash
# 启动交互式会话
./claw-local.sh

# 在会话中使用斜杠命令
/help      # 显示帮助
/status    # 查看状态
/compact   # 压缩历史
```

## 🔍 调试技巧

### 查看详细日志

```bash
# 启用详细输出
RUST_LOG=debug ./claw-local.sh -p "你好"
```

### 测试 API 连接

```bash
# 测试本地服务
curl -X POST http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer local-model" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "你好"}]
  }'
```

### 检查环境变量

```bash
# 查看当前环境变量
echo "OPENAI_BASE_URL: $OPENAI_BASE_URL"
echo "OPENAI_API_KEY: $OPENAI_API_KEY"
```

## 📚 更多资源

- [LM Studio 官网](https://lmstudio.ai/)
- [Ollama 官网](https://ollama.ai/)
- [vLLM 官网](https://vllm.ai/)
- [Claw Code GitHub](https://github.com/instructkr/claw-code)
- [instruct.kr 社区](https://instruct.kr/)

## 💡 提示

1. **首次使用**: 建议先使用 LM Studio，它有友好的图形界面
2. **性能优化**: 根据你的硬件选择合适的模型大小
3. **模型选择**: 
   - 7B 模型：适合大多数现代 GPU
   - 14B 模型：需要更强的 GPU
   - 32B+ 模型：需要专业级硬件
4. **内存需求**: 确保有足够的 RAM（建议至少 16GB）