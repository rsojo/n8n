#!/bin/sh
set -eu

node scripts/prepare-env.js
docker compose --env-file n8n-starter/.env -f n8n-starter/docker-compose.yml up -d
echo "n8n local available at http://localhost:5678"
