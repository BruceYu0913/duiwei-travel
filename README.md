# 对味 DUIWEI

美食社交旅行平台的 Laravel 全栈项目。当前仓库已完成《帮手全栈开发工作手册》的 W0 本地准备阶段。

## W0 状态

- Laravel 11.54、PHP 8.3、Composer 2 已安装
- Livewire 3.8、FluxUI 2.15 已接入
- Tailwind CSS 4、Vite 6、Node.js 24、pnpm 11 已接入
- 项目专用 MySQL 8 开发实例位于工作区 `.runtime/mysql`，只监听 `127.0.0.1:3307`
- `.env`、`APP_KEY`、数据库与默认迁移已完成
- 首页与 `/test-page` 可运行，TestPage 包含“表单 + 提交 + 显示结果”完整交互
- PHP 测试、Laravel Pint、Composer 校验与前端生产构建均可本地执行
- 原始静态原型保存在 `resources/prototypes/`，可通过 `/prototype` 查看

## 启动

在新 PowerShell 中运行：

```powershell
cd D:\对味项目开发\duiwei-travel
powershell -ExecutionPolicy Bypass -File .\scripts\start-dev.ps1
```

打开：

- 首页：<http://127.0.0.1:8000>
- Livewire 热身页：<http://127.0.0.1:8000/test-page>
- 原始静态原型：<http://127.0.0.1:8000/prototype>

`start-dev.ps1` 会先启动隔离的 MySQL，再同时启动 Laravel 和 Vite。按 `Ctrl+C` 停止 Web 开发进程。需要停止项目 MySQL 时运行：

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

本机 W0 使用独立 MySQL 数据目录和本地应用账户。新的电脑需要先准备 MySQL 8，并在 `.env` 中填写自己的数据库密码，再运行：

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
