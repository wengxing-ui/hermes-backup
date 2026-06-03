#!/bin/bash
# Hermes 每日自动备份脚本
# 同步到 GitHub 和 Gitee 双平台

set -e
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DATE=$(date '+%Y%m%d')

# —— hermes-backup 仓库 ——
BACKUP_DIR="/home/agentuser/hermes-backup"

# 同步会话记录
mkdir -p "$BACKUP_DIR/sessions"
cp -r /home/agentuser/.hermes/sessions/*.jsonl "$BACKUP_DIR/sessions/" 2>/dev/null || true
cp -r /home/agentuser/.hermes/sessions/*.json "$BACKUP_DIR/sessions/" 2>/dev/null || true

# 同步记忆数据
mkdir -p "$BACKUP_DIR/memory"
cp -r /home/agentuser/.hermes/memory/* "$BACKUP_DIR/memory/" 2>/dev/null || true

# 同步配置文件 (去掉敏感密钥)
mkdir -p "$BACKUP_DIR/config"
sed '/_API_KEY=/d; /_KEY=/d; /_SECRET=/d; /_TOKEN=/d' /home/agentuser/.hermes/.env > "$BACKUP_DIR/config/dot_env" 2>/dev/null || true
cp /home/agentuser/.hermes/config.yaml "$BACKUP_DIR/config/" 2>/dev/null || true

# 同步自定义技能
mkdir -p "$BACKUP_DIR/skills"
cp -r /home/agentuser/.hermes/skills/* "$BACKUP_DIR/skills/" 2>/dev/null || true

# 提交并推送
cd "$BACKUP_DIR"
git add -A
git commit -m "自动备份 $TIMESTAMP" || true
git push origin main 2>&1 || git push origin master 2>&1 || true

# —— knowledge-base 仓库 ——
KB_DIR="/home/agentuser/knowledge-base"
mkdir -p "$KB_DIR/notes" "$KB_DIR/documents"
touch "$KB_DIR/notes/.gitkeep" "$KB_DIR/documents/.gitkeep"

cd "$KB_DIR"
git add -A
git commit -m "自动备份 $TIMESTAMP" || true
git push origin main 2>&1 || git push origin master 2>&1 || true

echo "[$TIMESTAMP] 备份完成"
