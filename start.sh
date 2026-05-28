#!/usr/bin/env bash
set -euo pipefail

public_port="${PORT:-10000}"
vane_port="${VANE_INTERNAL_PORT:-3000}"
vane_host="$(hostname)"
username="${BASIC_AUTH_USERNAME:-vane}"

if [[ -z "${BASIC_AUTH_PASSWORD:-}" ]]; then
  echo "BASIC_AUTH_PASSWORD must be set."
  exit 1
fi

htpasswd -Bbc /etc/nginx/.htpasswd "$username" "$BASIC_AUTH_PASSWORD" >/dev/null

sed \
  -e "s/__PUBLIC_PORT__/${public_port}/g" \
  -e "s/__VANE_HOST__/${vane_host}/g" \
  -e "s/__VANE_PORT__/${vane_port}/g" \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

PORT="$vane_port" /home/vane/entrypoint.sh &
vane_pid=$!

nginx -g "daemon off;" &
nginx_pid=$!

trap 'kill "$vane_pid" "$nginx_pid" 2>/dev/null || true' TERM INT

wait -n "$vane_pid" "$nginx_pid"
