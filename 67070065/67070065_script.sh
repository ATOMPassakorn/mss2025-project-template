# current script directort
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# json output
OUT_JSON="$SCRIPT_DIR/data.json"

# sever information
SERVER_USER="admin1"         # server name
SERVER_HOST="172.16.85.128"    # server ip

ssh "${SERVER_USER}@${SERVER_HOST}" "/usr/local/bin/server_metrics.sh" > "$OUT_JSON"

