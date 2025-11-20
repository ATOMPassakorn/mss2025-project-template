#!/usr/bin/env bash

# CPU Usage
cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.2f", 100-$8}')

# Memory Usage
mem_usage=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')

# Disk Usage
disk_usage=$(df -h / | awk 'NR==2{print $5}')
disk_used=$(df -h / | awk 'NR==2{print $3}')
disk_total=$(df -h / | awk 'NR==2{print $2}')

# Last Updated
last_updated=$(date '+%Y-%m-%d %H:%M:%S %Z')

# Neofetch
neofetch_raw=$(neofetch --stdout 2>/dev/null || echo "neofetch not available")
neofetch_json=$(printf '%s' "$neofetch_raw" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

# top
top_raw=$(COLUMNS=200 top -bn1 | head -n 20)
top_json=$(printf '%s\n' "$top_raw" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

# JSON
cat <<EOF
{
  "cpu_usage": "$cpu_usage",
  "mem_usage": "$mem_usage",
  "disk_usage": "$disk_usage",
  "disk_used": "$disk_used",
  "disk_total": "$disk_total",
  "neofetch": $neofetch_json,
  "last_updated": "$last_updated",
  "top": $top_json
}
EOF
