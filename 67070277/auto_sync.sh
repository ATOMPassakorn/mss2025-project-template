#!/usr/bin/env bash

REPO_DIR="/home/worapx/mss2025-project-template/67070277"
BRANCH="wangcan"

cd "$REPO_DIR" || exit 1

git checkout $BRANCH
git pull origin $BRANCH

git add worapa.html

if ! git diff --cached --quiet; then
    git commit -m "Auto Update at $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin $BRANCH
fi
