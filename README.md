# Admin Template

[![pipeline status](https://gitlab.com/songhuangcn/admin-template/badges/main/pipeline.svg)](https://gitlab.com/songhuangcn/admin-template/-/commits/main)

后台管理系统模板，功能亮点：
- 完善的管理系统核心功能：包含基本的认证权限功能，权限系统基于 RBAC 模型，对所有接口进行了权限控制。权限列表由后端路由自动生成，不需要手动维护。完善的前后端多语言功能。
- 便捷的开发体验：所有环境容器化，本地只需安装 docker 即可快速进行开发。使用 Makefile 进行了常用命令的封装。
- 更可靠的项目管理：完善的 CI/CD 功能，让构建和部署变得更简单。添加了代码规范和单元测试检测，保证项目质量。
- 更简易的部署：生产环境独立为一个单独的文件夹，直接上传到服务器，配置完再启动即可。容器化部署不挑你的服务器版本。

## 系统演示

地址：https://admin-template.hdgcs.com/, 账户：`root/4OGoH9w9S9VaVtVE0ZK1`

账户是超级管理员，可以登录后进行相关功能测试。以下是一个示范测试步骤：
1. 登录超级管理员账户
1. 进入功能 “系统管理” -> “角色管理” -> “新建”，姓名填入 “只读角色”，然后权限选择 “用户列表” 和 “角色列表” 两项，点击确认创建
1. 进入功能 “系统管理” -> “用户管理” -> “新建”，姓名填入 “只读用户”，用户名和密码填入 “readonly”，“000000”，拥有角色填入上面创建的 “只读角色”，点击确认创建
1. 重新登录上面创建的用户：“readonly”，“000000”，重新进入 “角色管理” 和 “用户管理” 功能，发现只有列表展示功能，原来的 “新建”，“编辑” 和 “删除” 按钮都隐藏起来了。可以尝试绕过前端元素，直接调用后端接口，此时后端接口会响应 403

## 使用系统

你可以部署一套跟上面演示版本一样的系统，配置最低 1C1G，推荐 2C4G。部署步骤很简单：
1. 克隆代码：`git clone git@gitlab.com:songhuangcn/admin-template.git`
1. 上传部署文件夹到你的服务器：`ssh your-host "mkdir -p /home/ubuntu/admin-template" && scp -r admin-template/deploy your-host:/home/ubuntu/admin-template/`
1. 登录服务器并配置系统：
    - 配置环境变量：`cp secrets/.env.sample secrets/.env` 做模板，其中的 `APP_DOMAIN` 和 `SECRET_KEY_BASE` 需要配置你自己的，其他的可以根据需要来
    - 配置 SSL 证书：将你的域名证书上传到服务器，位置：`secrets/ssl.crt` 和 `secrets/ssl.key`
1. 在 GitLab 平台（gitlab.com 或者其他自建平台）中创建你的项目，进入 "Settings" -> "CI/CD" -> "Variables"，配置部署需要用到的变量（变量只需要输入 Key 和 Value 就行，其他都保持默认配置）：
    - `DEPLOY_SERVER`: 保持与上面服务器中配置的 `APP_DOMAIN` 一致
    - `SSH_PRIVATE_KEY`: 能访问你服务器的 SSH 私钥文本值，CI 机器需要权限部署到你的服务器
    - `DEPLOY_USERNAME`: 让你机器访问 CI 构建的镜像的凭证，"Settings" -> "Repository" -> "Deploy tokens" 中创建后填入
    - `DEPLOY_TOKEN`: 与 `DEPLOY_USERNAME` 一致
1. 然后将代码推送到 GitLab 平台中，CI/CD 会自动进行镜像构建和部署。
1. 后续有功能添加或者更改（文档见后续的 "本地开发"），提交 MR 则会进行构建和验证，MR 合并则会进行自动部署。

## CI/CD 说明

系统通过 GitLab CI/CD 来完成构建、测试和部署，流水线中总共有三个阶段：
1. build: 构建当前代码版本的 dev 镜像，供后面测试验证。如果当前流水线是在主分支上，还会额外构建 prod 镜像，供后续部署使用。前后端镜像只会在有代码更改时构建。
1. test: 使用上一个阶段构建的环境镜像运行测试，保证新代码的健康。前后端只会在有代码更改时进行验证。
1. deploy: 对 test 通过且 build 镜像成功的版本进行部署，只在主分支上运行。

## 本地开发

### 1. 安装依赖

所以依赖都使用 Docker 解决了，只需要安装 Docker 20+。技术栈：Ruby 3, Rails 7, Vue.js 3, MySQL 8。

```bash
brew install --cask docker # Docker 20 以上应该都可以
```

### 2. 安装应用

请使用封装好的脚本进行安装，包括 Docker 初始化、bundle install、pnpm install、数据库初始化等步骤。

```bash
make setup
```

### 3. 管理应用

项目通过 Makefile 封装常用命令，会将命令导向正确的执行容器，比如命令 `make console` 会实际解析成 `docker compose -f docker-compose.dev.yml run --rm rails bundle exec rails console`。

通过这个封装，能减短长命令，也能尽可能接近原生开发体验。

```bash
make up/upd/down    # 启动/后台启动/停止应用
make restart        # 后台重新启动，用于更新了 package 依赖需要重新启动进程的情况
make bash-rails     # 进入应用 rails 容器的 bash
make build          # 重新构建前后端镜像
make package        # 执行前后端的 package install 任务，例如：`bundle install`, `pnpm install`
make console        # 进入 Rails Console 控制台
```

### 4. 配置应用

1. 开发环境：`Makefile`, `docker-compose.dev.yml`, `backend/Dockerfile:dev`, `frontend/Dockerfile:dev`
1. 部署环境：`deployment/Makefile`, `deployment/docker-compose.prod.yml`, `backend/Dockerfile:prod`, `frontend/Dockerfile:prod`
