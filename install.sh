#!/usr/bin/env bash
set -e

echo "=================================================="
echo "      🚀 开始全量安装 API HUB (Uni-API) 面板       "
echo "=================================================="

# 1. 检查并安装 Docker
if ! command -v docker &> /dev/null; then
    echo "⚠️ 未检测到 Docker，正在自动安装 Docker..."
    curl -fsSL https://get.docker.com | bash
fi

INSTALL_DIR="/opt/uni-api-panel"
mkdir -p "$INSTALL_DIR/static" "$INSTALL_DIR/data"
cd "$INSTALL_DIR"

# 2. 尝试从 GitHub Releases 拉取最新打包包
echo "📦 正在拉取 GitHub 最新发行包..."
LATEST_TAG=$(curl -s https://api.github.com/repos/Pinevu/uni-api/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v1.2.0"
fi

DOWNLOAD_URL="https://github.com/Pinevu/uni-api/releases/download/${LATEST_TAG}/release_package.tar.gz"

if curl -sSL "$DOWNLOAD_URL" -o release_package.tar.gz 2>/dev/null && tar -tzf release_package.tar.gz >/dev/null 2>&1; then
    tar -xzf release_package.tar.gz
    rm -f release_package.tar.gz
    echo "✓ 发行包下载并解压成功"
else
    echo "ℹ️ 使用 GitHub 源码直链拉取核心组件..."
    curl -sSL "https://raw.githubusercontent.com/Pinevu/uni-api/main/static/index.html" -o static/index.html
    curl -sSL "https://raw.githubusercontent.com/Pinevu/uni-api/main/docker-compose.release.yml" -o docker-compose.yml
    if [ ! -f api.yaml ]; then
        curl -sSL "https://raw.githubusercontent.com/Pinevu/uni-api/main/api.yaml" -o api.yaml 2>/dev/null || true
    fi
fi

# 3. 如果不存在 api.yaml，则生成安全随机配置
if [ ! -f api.yaml ]; then
    echo "🔑 初始化生成 api.yaml 配置文件..."
    RAND_KEY=$(head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 32)
    cat << EOF > api.yaml
api_keys:
- api: uh_${RAND_KEY}
  role: admin
providers: []
EOF
    echo "=================================================="
    echo "🔑 初始管理员登录密码: uh_${RAND_KEY}"
    echo "（请妥善保管，也可后续在 /opt/uni-api-panel/api.yaml 中修改）"
    echo "=================================================="
fi

# 4. 启动服务
echo "🐳 启动 Docker 容器..."
docker compose up -d

echo "=================================================="
echo "🎉 API HUB 已成功全量安装并启动！"
echo "🌐 管理面板访问地址: http://$(curl -s ifconfig.me || echo '你的VPS公网IP'):8000"
echo "=================================================="
