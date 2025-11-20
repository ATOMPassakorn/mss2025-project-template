#!/bin/bash

SERVER_USER="worapx"
SERVER_IP="192.168.74.130"
REMOTE_SCRIPT_PATH="/home/worapx/67070277.sh"

PROJECT_DIR="/home/worapx/mss2025-project-template/67070277"
LOCAL_OUTPUT_FILE="$PROJECT_DIR/67070277.html"

ssh $SERVER_USER@$SERVER_IP "$REMOTE_SCRIPT_PATH" > $LOCAL_OUTPUT_FILE

cd "$PROJECT_DIR" || exit

git add .
git commit -m "Auto update $(date '+%Y-%m-%d %H:%M:%S')"

git push
