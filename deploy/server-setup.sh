#!/usr/bin/env bash
set -euo pipefail
DEPLOY_DIR="${DEPLOY_DIR:-/opt/archam}"
KEY_FILE="/root/.ssh/github_deploy"
info() { printf '\033[0;32m==> %s\033[0m\n' "$*"; }
die()  { printf '\033[0;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }
[ "$(id -u)" -eq 0 ] || die "Запустите под root (sudo -i)."
if ! command -v docker >/dev/null 2>&1; then
  info "Устанавливаю Docker..."
  curl -fsSL https://get.docker.com | sh
fi
systemctl enable --now docker >/dev/null 2>&1 || true
docker compose version >/dev/null 2>&1 || die "Нет docker compose plugin."
if [ -z "$(swapon --show 2>/dev/null)" ]; then
  info "Добавляю swap 2 ГБ..."
  fallocate -l 2G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=2048
  chmod 600 /swapfile; mkswap /swapfile >/dev/null; swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi
info "Готовлю $DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR/config" "$DEPLOY_DIR/img" "$DEPLOY_DIR/migrations" "$DEPLOY_DIR/scripts"
PW="$DEPLOY_DIR/config/postgres_password.txt"
[ -d "$PW" ] && rmdir "$PW"
if [ ! -s "$PW" ]; then openssl rand -hex 32 > "$PW"; chmod 644 "$PW"; fi
[ -f "$DEPLOY_DIR/.env" ] || printf 'HTTP_PORT=80\n# ASSET_HOST=https://assets.arkhamhorror.app\n' > "$DEPLOY_DIR/.env"
mkdir -p /root/.ssh && chmod 700 /root/.ssh
[ -f "$KEY_FILE" ] || ssh-keygen -t ed25519 -N "" -C "github-actions-deploy" -f "$KEY_FILE" >/dev/null
touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
grep -qF "$(cat "$KEY_FILE.pub")" /root/.ssh/authorized_keys || cat "$KEY_FILE.pub" >> /root/.ssh/authorized_keys
info "Сервер готов."
