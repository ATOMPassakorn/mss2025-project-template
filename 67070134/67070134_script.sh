#!/usr/bin/env bash

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/67070134_template.html"
HTML="$SCRIPT_DIR/67070134.html"
OUT_JSON="$SCRIPT_DIR/data.json"

# Server info
SERVER_USER="atom"
SERVER_HOST="10.110.192.96"

# SSH เข้า server → สร้าง JSON
ssh "${SERVER_USER}@${SERVER_HOST}" "/usr/local/bin/server_metrics.sh" > "$OUT_JSON"

# อ่านค่า JSON
CPU=$(jq -r '.cpu_usage' "$OUT_JSON")
MEM=$(jq -r '.mem_usage' "$OUT_JSON")
DISK=$(jq -r '.disk_used + "/" + .disk_total' "$OUT_JSON")
TIME=$(jq -r '.last_updated' "$OUT_JSON")
NEO=$(jq -r '.neofetch' "$OUT_JSON")
TOP=$(jq -r '.top' "$OUT_JSON")
RX=$(jq -r '.rx_human' "$OUT_JSON")
TX=$(jq -r '.tx_human' "$OUT_JSON")

# ใช้ <pre> ใน HTML แสดงเนื้อหา multi-line
NEO_HTML="<pre>$NEO</pre>"
TOP_HTML="<pre>$TOP</pre>"

# คัดลอก template → HTML
cp "$TEMPLATE" "$HTML"

# แทนค่า placeholder ด้วย awk (ปลอดภัยต่อ newline และอักขระพิเศษ)
awk -v cpu="$CPU" \
    -v mem="$MEM" \
    -v disk="$DISK" \
    -v time="$TIME" \
    -v neo="$NEO_HTML" \
    -v top="$TOP_HTML" \
    -v rx="$RX" \
    -v tx="$TX" '
{
    gsub(/\{\{CPU\}\}/, cpu)
    gsub(/\{\{MEM\}\}/, mem)
    gsub(/\{\{DISK\}\}/, disk)
    gsub(/\{\{TIME\}\}/, time)
    gsub(/\{\{NEOFETCH\}\}/, neo)
    gsub(/\{\{TOP\}\}/, top)
    gsub(/\{\{RX\}\}/, rx)
    gsub(/\{\{TX\}\}/, tx)
    print
}' "$HTML" > "$HTML.tmp" && mv "$HTML.tmp" "$HTML"

