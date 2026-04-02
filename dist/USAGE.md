# Claw Code 使用指南

## 📦 安装

### 方法 1: 使用安装脚本（推荐）

```bash
chmod +x install.sh
./install.sh
```

### 方法 2: 手动安装

```bash
# 复制到系统路径
sudo cp claw /usr/local/bin/
sudo chmod +x /usr/local/bin/claw
```

### 方法 3: 用户目录安装

```bash
mkdir -p ~/.local/bin
cp claw ~/.local/bin/
chmod +x ~/.local/bin/claw

# 添加到 PATH（如果尚未添加）
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc
```

## 🚀 快速开始

### 基本使用

```bash
# 启动交互式 REPL
claw

# 单次提示
claw -p "你好，请帮我写一个 Python 函数"

# 指定模型
claw --model claude-opus-4-6 -p "你的提示词"

# 查看版本
claw --version

# 查看帮助
claw --help
```

### 权限模式

```bash
# 只读模式（推荐用于敏感项目）
claw --permission-mode read-only

# 工作区写入模式
claw --permission-mode workspace-write

# 完全访问模式（默认）
claw --permission-mode danger-full-access
```

## 🔧 配置本地模型

### LM Studio

```bash
# 1. 在 LM Studio 中启用服务器
# Settings → Server → 启用服务器
# 默认地址: http://localhost:1234/v1

# 2. 设置环境变量
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="lm-studio"

# 3. 使用 claw
claw --model your-model-name
```

### Ollama

```bash
# 1. 安装 Ollama 并启动服务
# https://ollama.ai

# 2. 设置环境变量
export OPENAI_BASE_URL="http://localhost:11434/v1"
export OPENAI_API_KEY="ollama"

# 3. 使用 claw
claw --model llama2
```

### 其他 OpenAI 兼容服务

```bash
export OPENAI_BASE_URL="http://your-server:port/v1"
export OPENAI_API_KEY="your-api-key"
claw
```

## 📋 配置文件

创建配置文件 `~/.claw/settings.local.json`:

```json
{
  "api": {
    "base_url": "http://localhost:1234/v1",
    "api_key": "your-api-key"
  },
  "model": "your-model-name",
  "permission_mode": "workspace-write"
}
```

## 🎯 高级功能

### OAuth 登录（云端模型）

```bash
# 登录
claw login

# 登出
claw logout
```

### 斜杠命令（REPL 中）

```
/help      - 显示帮助
/status    - 显示当前会话状态
/compact   - 压缩本地会话历史
/agents    - 管理代理
/skills    - 管理技能
```

### 会话管理

```bash
# 恢复会话
claw --resume SESSION.json /status

# 初始化项目
claw init

# 查看系统提示词
claw system-prompt --cwd . --date 2026-03-31
```

## 🔍 故障排除

### 权限问题

```bash
# 确保二进制文件有执行权限
chmod +x claw

# 如果需要 sudo 权限
sudo claw
```

### PATH 问题

```bash
# 检查 claw 是否在 PATH 中
which claw

# 如果不在，添加到 PATH
export PATH="$PATH:/path/to/claw"
```

### API 连接问题

```bash
# 测试本地服务连接
curl http://localhost:1234/v1/models

# 检查环境变量
echo $OPENAI_BASE_URL
echo $OPENAI_API_KEY
```

## 📚 更多资源

- GitHub 仓库: https://github.com/instructkr/claw-code
- 文档: 查看 README.md
- 社区: https://instruct.kr/

## 📝 版本信息

当前版本: 0.1.0
构建日期: 2026-03-31