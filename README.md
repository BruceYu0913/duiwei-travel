# 对味 DUIWEI

美食社交旅行平台的 Laravel 全栈项目。当前仓库已完成《帮手全栈开发工作手册》的 W0 本地准备阶段。

## W0 状态

- Laravel 11.54、PHP 8.3、Composer 2 已安装
- Livewire 3.8、FluxUI 2.15 已接入
- Tailwind CSS 4、Vite 6、Node.js 24、pnpm 11 已接入
- 开发数据库使用 MySQL 8，实际地址、端口与账号由各电脑自己的 `.env` 配置
- `.env`、`APP_KEY`、数据库与默认迁移已完成
- 首页与 `/test-page` 可运行，TestPage 包含“表单 + 提交 + 显示结果”完整交互
- PHP 测试、Laravel Pint、Composer 校验与前端生产构建均可本地执行
- 原始静态原型保存在 `resources/prototypes/`，可通过 `/prototype` 查看

## 启动

不要照抄某位开发者电脑上的 `D:\...` 绝对目录。在 GitHub Desktop 中选中仓库，点击 **Repository → Open in PowerShell**，然后运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-dev.ps1
```

也可以不切换目录，直接传入脚本的真实绝对路径：

```powershell
powershell -ExecutionPolicy Bypass -File "C:\你的实际克隆目录\duiwei-travel\scripts\start-dev.ps1"
```

打开：

- 首页：<http://127.0.0.1:8000>
- Livewire 热身页：<http://127.0.0.1:8000/test-page>
- 原始静态原型：<http://127.0.0.1:8000/prototype>

`start-dev.ps1` 使用脚本自身位置定位项目，不要求仓库外部存在 `.runtime`，也不要求固定盘符。它会从 PATH 查找 PHP、Composer、Node.js 和 pnpm，并检查 `.env` 中配置的 MySQL 地址；随后同时启动 Laravel 和 Vite。为兼容最初的 W0 电脑，数据库脚本仍可识别旧的父目录 `.runtime/mysql/my.ini`，但新电脑无需创建这种目录结构。按 `Ctrl+C` 停止 Web 开发进程。

只检查环境和路径而不启动开发服务器：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-dev.ps1 -CheckOnly
```

`-CheckOnly` 只探测环境，不会启动 MySQL 或 Web 服务。如果当前只想检查 PHP/Composer/Node/pnpm 与项目文件，可跳过数据库探测：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-dev.ps1 -CheckOnly -SkipDatabaseCheck
```

如果 `.env` 指向的 MySQL 端口尚未监听，请先启动本机 MySQL 服务。标准安装通常使用 `3306`；原开发电脑的隔离实例使用 `3307`，该端口不能直接套用到其他电脑。若需要由项目脚本启动自定义实例，可传入自己的 MySQL 配置：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-mysql.ps1 -ConfigPath "C:\你的路径\my.ini"
```

只有由项目脚本启动并记录的 MySQL 进程才会被下列命令停止；系统 MySQL 服务不会被误停：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\stop-mysql.ps1
```

## 首次安装或重新拉取

```powershell
composer install
pnpm install --frozen-lockfile
Copy-Item .env.example .env
php artisan key:generate
```

新的电脑需要先准备 MySQL 8，并在 MySQL Workbench 或命令行中创建项目数据库和专用账号（也可以使用已有开发账号）。示例 SQL 中的密码必须换成自己的本地密码：

```sql
CREATE DATABASE duiwei CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'duiwei_app'@'localhost' IDENTIFIED BY '替换为本地密码';
GRANT ALL PRIVILEGES ON duiwei.* TO 'duiwei_app'@'localhost';
```

随后在 `.env` 中填写实际的 `DB_HOST`、`DB_PORT`、数据库名、账号和密码，再运行：

```powershell
php artisan migrate
```

不要提交 `.env`、数据库密码或任何外部服务密钥。

## 验证

```powershell
php artisan about
php artisan migrate:status
php artisan test
vendor\bin\pint --test
composer validate --strict
pnpm run build
```

开发服务器启动后，可直接验证对方反馈的两个路由：

```powershell
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:8000/test-page
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:8000/prototype
```

## Git 协作

当前 W0 工作位于 `feature/w0-setup` 分支。遵循以下规则：

- 不直接推送 `main`
- 功能开发使用 `feature/...`，修复使用 `fix/...`
- commit 使用 `feat:`、`fix:`、`docs:` 等前缀
- PR 描述必须写明测试方法
- GitHub 登录、提交者姓名/邮箱、推送和 PR 由仓库账号持有人完成

## 版本风险

手册指定 Laravel 11，但该版本已经停止安全维护，Composer 审计会报告 Laravel 11 的已知安全公告。本环境只用于完成 W0 和本地开发验证；进入正式功能开发或生产部署前，应由 Bruce / 高级开发确认升级到仍受支持的 Laravel 主版本。

Redis 不在 W0 的安装清单内，因此本阶段未启用；当前 session、queue 和 cache 使用 MySQL，后续按 W6/部署方案再接 Redis。
