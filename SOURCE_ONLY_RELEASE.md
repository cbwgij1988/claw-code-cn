# 发布源代码到 GitHub 的说明

## 步骤 1: 准备源代码仓库

此版本只包含源代码，不包含预编译的二进制文件或发布包。

## 步骤 2: 需要包含的目录结构

- rust/ - 主要源代码
- assets/ - 资源文件
- .github/ - GitHub 配置
- 其他配置文件

## 步骤 3: 排除的文件类型

- 预编译的二进制文件
- 发布包 (.tar.gz)
- 临时构建文件
- 会话数据

## 步骤 4: 用户构建说明

用户可以通过以下方式构建项目：

```bash
# 克隆仓库
git clone https://github.com/cbwgij1988/claw-code-cn.git
cd claw-code-cn

# 构建项目
cd rust
cargo build --release

# 运行程序
./target/release/claw
```