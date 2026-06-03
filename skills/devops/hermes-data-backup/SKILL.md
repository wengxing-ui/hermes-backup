---
name: hermes-data-backup
description: "Set up automated dual-remote (GitHub + Gitee) backup for Hermes Agent data — session history, memory, configs, skills, and user documents — using git and cron."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [backup, git, github, gitee, cron, data-recovery]
---

# Hermes Data Backup to GitHub + Gitee

Automated daily backup of Hermes Agent data to both GitHub and Gitee for
redundancy. Covers conversation history, memory files, configuration,
custom skills, and user knowledge documents.

## When to Use

- Hermes runs on a cloud server and you're worried about data loss
- You want daily, automated, zero-touch backups
- You want redundancy across two independent platforms (GitHub + Gitee)
- You maintain separate repos for agent data vs user documents

## Architecture

```
Two backup repos, each pushed to both GitHub + Gitee:

  hermes-backup/          → git push → github.com/user/hermes-backup
   ├── memory/                         gitee.com/user/hermes-backup
   ├── sessions/
   ├── config.yaml (sanitized)
   ├── skills/
   └── plugins/

  knowledge-base/         → git push → github.com/user/knowledge-base
   ├── docs/                           gitee.com/user/knowledge-base
   ├── notes/
   └── (user's documents)
```

## Step-by-Step

### 1. User creates repos (user action)

User needs to create four empty repos:

- GitHub: `hermes-backup` + `knowledge-base` (private recommended)
- Gitee: `hermes-backup` + `knowledge-base`

Do NOT initialize with README — the script pushes an initial commit.

### 2. Set up SSH keys

For each platform, generate or use existing SSH key, add the public key
to the user's account:

- GitHub: https://github.com/settings/keys
- Gitee: https://gitee.com/profile/sshkeys

Key generation command:
```bash
ssh-keygen -t ed25519 -C "hermes-backup" -f ~/.ssh/id_ed25519 -N ""
```

Verify with `ssh -T git@github.com` and `ssh -T git@gitee.com`.

**Pitfall:** If you show the user a public key to add, verify it matches
the local file EXACTLY (`cat ~/.ssh/id_ed25519.pub`) before asking them
to paste it. Keys can drift if they were regenerated.

### 3. Initialize backup repos on server

For `hermes-backup`:
```bash
mkdir -p ~/backups/hermes-backup
cd ~/backups/hermes-backup
git init
git remote add github git@github.com:<user>/hermes-backup.git
git remote add gitee git@gitee.com:<user>/hermes-backup.git
```

For `knowledge-base`:
```bash
mkdir -p ~/backups/knowledge-base/docs
cd ~/backups/knowledge-base
git init
git remote add github git@github.com:<user>/knowledge-base.git
git remote add gitee git@gitee.com:<user>/knowledge-base.git
```

### 4. Create the backup script

Save as `~/backups/backup.sh`:

```bash
#!/bin/bash
set -e
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

# --- Hermes backup ---
cd ~/backups/hermes-backup

# Sync files from Hermes home (sanitize API keys from config)
cp ~/.hermes/config.yaml config.yaml 2>/dev/null || true
cp -r ~/.hermes/memory/ memory/ 2>/dev/null || true
cp -r ~/.hermes/skills/ skills/ 2>/dev/null || true

# Sanitize: remove api_key / token lines from config backup
sed -i '/api_key:/d; /token:/d; /_KEY:/d' config.yaml 2>/dev/null || true

# Copy recent sessions (last 7 days)
mkdir -p sessions
find ~/.hermes/sessions/ -name '*.jsonl' -mtime -7 -exec cp {} sessions/ \; 2>/dev/null || true

git add -A
git commit -m "Backup: $TIMESTAMP" || true
git push github main 2>&1 || echo "GitHub push failed"
git push gitee main 2>&1 || echo "Gitee push failed"

# --- Knowledge base backup ---
cd ~/backups/knowledge-base

# Sync user documents from default path
cp -r ~/backups/knowledge-base/docs/ docs/ 2>/dev/null || true

git add -A
git commit -m "Backup: $TIMESTAMP" || true
git push github main 2>&1 || echo "GitHub push failed"
git push gitee main 2>&1 || echo "Gitee push failed"

echo "Backup complete: $TIMESTAMP"
```

Make executable: `chmod +x ~/backups/backup.sh`

### 5. Schedule with Hermes cron

Use the `cronjob` tool in a Hermes session:

```
cronjob(action='create',
  schedule='0 2 * * *',
  name='Daily backup',
  prompt='Run ~/backups/backup.sh and report success or failure.',
  skills=[],
  deliver='origin')
```

This runs daily at 2 AM, runs the script, and reports back to the user's chat.

Alternative: if `cronjob` is not available, use system crontab:
```bash
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backups/backup.sh >> ~/backups/backup.log 2>&1") | crontab -
```

### 6. Initial push and verify

After initializing, do a first manual run:
```bash
~/backups/backup.sh
```

Then verify the repos on GitHub and Gitee show the files.

## What Gets Backed Up

| Data | Source | Notes |
|------|--------|-------|
| Session history | `~/.hermes/sessions/` | Last 7 days of `.jsonl` files |
| Memory | `~/.hermes/memory/` | MEMORY.md, USER.md |
| Config | `~/.hermes/config.yaml` | API keys removed before commit |
| Skills | `~/.hermes/skills/` | Custom skills only |
| Documents | `~/backups/knowledge-base/docs/` | User-managed path |

## What Does NOT Get Backed Up

- API keys and tokens (stripped from config)
- Session files older than 7 days (to keep repo size manageable)
- The Hermes source code itself (`~/.hermes/hermes-agent/`) — that's on GitHub already
- System-level files outside `~/.hermes/`

## Recovery

If the server is lost, restore:

```bash
# Clone from either platform
git clone git@github.com:<user>/hermes-backup.git
git clone git@github.com:<user>/knowledge-base.git

# Copy files back
cp -r hermes-backup/memory ~/.hermes/memory
cp -r hermes-backup/skills ~/.hermes/skills
# Config needs manual API key re-entry (they were sanitized)
```

## Pitfalls

- **SSH key mismatch** — after generating a key, verify with `cat ~/.ssh/id_ed25519.pub` before asking user to add it. Showing a different (stale/cached) key breaks auth.
- **Branch name** — some repos default to `main`, others to `master`. Check and align.
- **API keys in backups** — never commit raw `.env` files. Always sanitize `config.yaml` before push.
- **Repo size** — session files accumulate quickly. The `-mtime -7` filter keeps only recent ones. Adjust as needed.
- **Gitee rate limits** — Gitee may throttle frequent pushes. Once-daily is safe.
- **Two-remote push failures** — if one platform is down, the script continues and pushes to the other. The `|| echo` pattern prevents one failure from killing the whole script.

## Non-Technical User Communication

When guiding a non-technical user through this:

- Don't show terminal commands. Explain what to do in plain language.
- For repo creation: "打开 GitHub 网站，点右上角加号，选 New repository，名字填 hermes-backup，不要勾选初始化，点创建"
- For SSH keys: "打开这个网页，点 SSH 公钥，把我给你的这段文字粘贴进去，标题随便填"
- After each step, confirm it worked before moving on
- Use Chinese if the user prefers Chinese
