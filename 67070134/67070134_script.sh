#!/usr/bin/env bash

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/67070134_template.html"
HTML="$SCRIPT_DIR/67070134.html"
OUT_JSON="$SCRIPT_DIR/data.json"

# Server info
SERVER_USER="atom"
SERVER_HOST="10.110.192.167"

# SSH เข้า server ดึง JSON
ssh "${SERVER_USER}@${SERVER_HOST}" "/usr/local/bin/server_metrics.sh" > "$OUT_JSON"

# อ่านค่า JSON
CPU=$(jq -r '.cpu_usage' "$OUT_JSON")
MEM=$(jq -r '.mem_usage' "$OUT_JSON")
DISK=$(jq -r '.disk_used + "/" + .disk_total' "$OUT_JSON")
TIME=$(jq -r '.last_updated' "$OUT_JSON")

# คัดลอก template → แทนค่า placeholder
cp "$TEMPLATE" "$HTML"
sed -i "s|{{CPU}}|$CPU|g" "$HTML"
sed -i "s|{{MEM}}|$MEM|g" "$HTML"
sed -i "s|{{DISK}}|$DISK|g" "$HTML"
sed -i "s|{{TIME}}|$TIME|g" "$HTML"

