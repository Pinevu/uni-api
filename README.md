# API HUB 面板发行版

精简优化后的 uni-api 管理面板（API HUB），基于 [uni-api](https://github.com/yym68686/uni-api) 进行二次开发。

## ✨ 功能特点
- 现代化、清爽的白色 iOS 风格 UI
- 五大功能页：概览仪表盘、渠道监控、Token用量分析、渠道可视化配置、API Key 管理
- **渠道一键拉取**：可自动从上游接口拉取可用模型列表，支持多选与全选
- **Key 权限管理**：可视化设置 Key 的模型授权范围、有效期、启用状态，支持一键随机生成
- 纯前端静态文件，一键挂载，即开即用

## 🚀 快速部署

**1. 克隆仓库**
```bash
git clone https://github.com/Pinevu/uni-api.git
cd uni-api
```

**2. 配置 `api.yaml`**
参考根目录下的 `api.yaml` 示例，填入你自己的 Key 和上游 Provider 配置。

**3. 启动服务**
我们已经为你准备好了现成的 Docker Compose 配置，一键启动：
```bash
cp docker-compose.release.yml docker-compose.yml
docker compose up -d
```

服务将默认监听 `3000` 端口：访问 `http://<你的VPS IP>:3000` 即可进入控制台（默认使用 api.yaml 中的 admin 密钥登录）。

## 🛠️ 自定义与开发

如果你只需要自定义管理面板界面，只需要修改并替换 `static/index.html` 文件，然后重启 Docker 容器即可生效，无需重新编译 Rust 后端。

```bash
docker compose restart
```

## 📦 架构说明

本项目仅提供前端 UI 的独立优化与管理功能。底层的 API 代理与后端核心逻辑依然由上游的 [uni-api](https://github.com/yym68686/uni-api) 提供支持。
