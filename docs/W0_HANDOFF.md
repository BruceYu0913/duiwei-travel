# W0 交接记录

更新时间：2026-07-14（Asia/Shanghai）

## Day 1：环境搭建

- [x] PHP 8.3.32，并启用 curl、fileinfo、gd、intl、mbstring、openssl、pdo_mysql、sodium、zip
- [x] Composer 2.10.2，已通过 `composer diagnose`
- [x] Node.js 24.18.0、pnpm 11.3.0
- [x] MySQL 8.0.16 与 MySQL Workbench
- [x] Git 2.55.0
- [x] VS Code
- [x] PHP Intelephense、Laravel Blade、Tailwind CSS IntelliSense
- [ ] GitHub 提交者姓名/邮箱与登录：必须由账号持有人填写，项目没有代填身份信息

## Day 2：项目骨架

- [x] 从 `BruceYu0913/duiwei-travel` 的 `main` 分支克隆
- [x] 发现远端只有静态原型后，在保留原型的前提下补齐 Laravel 骨架
- [x] 安装 Composer 与 pnpm 依赖，生成唯一的 `pnpm-lock.yaml`
- [x] 从 `.env.example` 创建本地 `.env`
- [x] 生成 `APP_KEY`
- [x] 建立隔离 MySQL 开发实例、项目数据库与最小权限应用账户
- [x] 运行默认迁移并核验状态
- [x] 启动 Laravel，并验证首页 HTTP 200
- [x] 浏览器确认 FluxUI 正常渲染

## Day 3-4：技术热身

- [x] 创建 `App\Livewire\TestPage`
- [x] 实现姓名表单、服务端验证、无刷新提交与结果展示
- [x] 添加 Livewire 组件测试和首页测试
- [x] 浏览器实际填写 `Bruce` 并提交，得到“验证通过”结果
- [x] 浏览器控制台无 warning / error

继续学习时以官方文档为准：

- Laravel 11：<https://laravel.com/docs/11.x>
- Livewire 3：<https://livewire.laravel.com/docs/3.x/quickstart>
- FluxUI：<https://fluxui.dev/docs/installation>

## Day 5：协作流程

- [x] 创建并切换到 `feature/w0-setup`
- [x] 保持 `main` 未被提交或推送
- [x] 添加 PR 模板和 Bug Issue 模板
- [x] PR 模板包含测试方法
- [ ] 推送分支与创建 PR：等待仓库账号持有人配置 GitHub 身份并授权登录

建议由账号持有人执行：

```powershell
git config --global user.name "你的 GitHub 显示名"
git config --global user.email "你的 GitHub 提交邮箱"
```

完成代码复核后，再决定是否提交、推送并创建 PR；不要直接推送 `main`。

## 验收结果

- `php artisan test`：5 passed，11 assertions
- `vendor/bin/pint --test`：passed
- `composer validate --strict`：valid
- `pnpm run build`：passed
- `composer audit --locked`：Laravel 11 存在 3 条安全公告，详见 README 的版本风险说明

## 与原手册的差异

1. 远端仓库并非手册所述的 Laravel 骨架，而是静态 HTML 原型。本次在同一 Git 历史中补齐了骨架，并将原型移到 `resources/prototypes/`。
2. 手册同时写了 pnpm 和 npm。本项目统一使用 pnpm，避免双锁文件。
3. Redis 属于总技术栈，但不在 W0 安装清单内。本阶段 session、queue、cache 使用 MySQL，Redis 延后到需要缓存/队列时接入。
4. Laravel 11 已停止安全维护；W0 按手册复现，进入正式开发前需确认升级计划。
