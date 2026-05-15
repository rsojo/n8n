#!/bin/sh
set -eu

: "${N8N_STAGING_HOST:?Missing N8N_STAGING_HOST}"
: "${N8N_STAGING_SSH_USER:?Missing N8N_STAGING_SSH_USER}"
: "${N8N_STAGING_SSH_KEY_PATH:?Missing N8N_STAGING_SSH_KEY_PATH}"
: "${N8N_STAGING_ENV_FILE:?Missing N8N_STAGING_ENV_FILE}"

REMOTE_DIR="${N8N_STAGING_REMOTE_DIR:-/home/${N8N_STAGING_SSH_USER}/n8n-staging}"
ARCHIVE_PATH="/tmp/n8n-staging.tar.gz"

tar --exclude='.git' --exclude='n8n-starter/.env' -czf "$ARCHIVE_PATH" n8n-starter package.json scripts README.md

scp -i "$N8N_STAGING_SSH_KEY_PATH" "$ARCHIVE_PATH" "${N8N_STAGING_SSH_USER}@${N8N_STAGING_HOST}:${REMOTE_DIR}.tar.gz"
scp -i "$N8N_STAGING_SSH_KEY_PATH" "$N8N_STAGING_ENV_FILE" "${N8N_STAGING_SSH_USER}@${N8N_STAGING_HOST}:${REMOTE_DIR}.env"

ssh -i "$N8N_STAGING_SSH_KEY_PATH" "${N8N_STAGING_SSH_USER}@${N8N_STAGING_HOST}" \
  "mkdir -p '$REMOTE_DIR' && tar -xzf '${REMOTE_DIR}.tar.gz' -C '$REMOTE_DIR' && mv '${REMOTE_DIR}.env' '$REMOTE_DIR/n8n-starter/.env' && cd '$REMOTE_DIR' && docker compose --env-file n8n-starter/.env -f n8n-starter/docker-compose.yml up -d"

rm -f "$ARCHIVE_PATH"
echo "n8n staging deployed to ${N8N_STAGING_HOST}"
