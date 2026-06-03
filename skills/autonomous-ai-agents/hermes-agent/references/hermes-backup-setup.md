# Hermes 数据备份方案：GitHub + Gitee 双平台

## 适用场景

用户通过飞书等平台使用 Hermes Agent，Hermes 运行在云服务器上。为防止服务器故障导致数据丢失，需要将对话记录、记忆、配置、技能定时备份到两个独立平台。

## 备份内容

| 数据 | 源路径 |
|------|--------|
| 对话会话 | `~/.hermes/sessions/` |
| 记忆数据 | `~/.hermes/memory/MEMORY.md`, `USER.md` |
| 配置文件 | `~/.hermes/config.yaml`, `~/.hermes/.env`（去敏后） |
| 自定义技能 | `~/.hermes/skills/` |
| 用户文档 | 用户指定的知识库目录 |

## 架构

```
两个 Git 仓库（hermes-backup + knowledge-base）
每个仓库配两个 remote（GitHub + Gitee）
一个 Hermes cron job 每天定时执行备份脚本
备份脚本同步数据 → git commit → 同时 push 到两个平台
```

## 步骤概览

1. 用户在 GitHub 和 Gitee 各创建两个空仓库
2. 生成 SSH 密钥，用户添加公钥到两个平台
3. 本地初始化仓库，配置双 remote
4. 创建备份脚本 `backup.sh`
5. 创建 Hermes cron job（`cronjob` 工具）

## 详细步骤

### 1. 用户创建仓库

GitHub：`hermes-backup` + `knowledge-base`（建议设为 Private）
Gitee：`hermes-backup` + `knowledge-base`

仓库地址格式：
- GitHub：`git@github.com:<用户名>/hermes-backup.git`
- Gitee：`git@gitee.com:<用户名>/hermes-backup.git`

### 2. SSH 密钥配置

```bash
ssh-keygen -t ed25519 -C "hermes-backup" -f ~/.ssh/id_ed25519 -N ""
cat ~/.ssh/id_ed25519.pub
```

将公钥分别添加到：
- GitHub：https://github.com/settings/keys
- Gitee：https://gitee.com/profile/sshkeys

### 3. 本地仓库初始化

每个仓库配一个 fetch URL + 两个 push URL：

```bash
mkdir -p ~/hermes-backup && cd ~/hermes-backup
git init
git remote add origin git@gitee.com:<用户>/hermes-backup.git
git remote set-url --add origin git@github.com:<用户>/hermes-backup.git
```

knowledge-base 同理。

### 4. Git 用户配置

```bash
git config --global user.name "Hermes Agent"
git config --global user.email "agent@hermes.local"
```

### 5. 备份脚本

创建 `~/hermes-backup/backup.sh`，核心逻辑：

- 复制会话文件 → `sessions/`
- 复制记忆文件 → `memory/`
- 复制配置（去敏 .env）→ `config/`
- 复制自定义技能 → `skills/`
- knowledge-base 也做同样同步
- `git add -A && git commit -m "自动备份 $(date)"`
- `git push origin main`（会同时推到两个 remote）

### 6. Cron Job

使用 Hermes 的 `cronjob` 工具创建定时任务：

```python
cronjob(
    action="create",
    name="每日备份到GitHub和Gitee",
    schedule="0 2 * * *",  # 每天凌晨2点
    prompt="执行备份脚本 /home/agentuser/hermes-backup/backup.sh...",
    deliver="feishu:<用户ID>",  # 完成后飞书通知
)
```

## 注意事项

- SSH host key 需要提前添加：`ssh-keyscan github.com >> ~/.ssh/known_hosts`
- `.env` 文件中的 API Key 必须在备份前去除，用 `sed` 过滤
- GitHub 的 SSH host key 验证可能失败，需要在 cron job 运行前先手动 `ssh-keyscan` 一次
- Gitee 默认分支是 `master`，GitHub 可能是 `main`，注意统一
- push 到一个 remote 失败不应阻塞另一个，脚本用 `|| true` 容错

## 用户沟通要点

用户是计算机初学者，不需要展示：
- 终端命令行输出
- Git 操作细节
- SSH 密钥技术细节
- 脚本内容

只需要告诉用户：
1. 去 GitHub/Gitee 建两个空仓库（给出名字）
2. 把 SSH 公钥添加到平台（给出一段文字让用户复制粘贴）
3. 仓库地址发给我

其余全部由 Agent 在后端完成，不向用户展示过程。
