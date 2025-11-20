#!/bin/bash

SERVER_USER="augustanan"
SERVER_IP="192.168.188.130"
REMOTE_SCRIPT_PATH="/home/augustanan/67070106_script.sh"

PROJECT_DIR="/home/august-anan/mss2025-project-template/67070106"
LOCAL_OUTPUT_FILE="$PROJECT_DIR/67070106.html"

ssh $SERVER_USER@$SERVER_IP "$REMOTE_SCRIPT_PATH" > $LOCAL_OUTPUT_FILE

cd "$PROJECT_DIR" || exit

git add .
git commit -m "Auto update $(date '+%Y-%m-%d %H:%M:%S')"

git push
