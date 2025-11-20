#!/bin/bash

# --- 1. Config ---
OUTPUT_FILE="/var/www/html/data.json"

# --- 2. Collect Data ---
NOW=$(date +"%Y-%m-%d %H:%M:%S")

# System Info
HOSTNAME=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f 2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/up //')

# Resources
CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
MEM=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
DISK=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Processes
PROCESS_JSON="["
while read -r line; do
    if [ -z "$line" ]; then continue; fi
    PID=$(echo "$line" | awk '{print $1}')
    USER=$(echo "$line" | awk '{print $2}')
    CPU_P=$(echo "$line" | awk '{print $3}')
    MEM_P=$(echo "$line" | awk '{print $4}')
    # จัดการ Command ให้ไม่มี " กวน JSON
    CMD=$(echo "$line" | awk '{for(i=5;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/"/\\"/g') 
    PROCESS_JSON="$PROCESS_JSON {\"pid\":\"$PID\", \"user\":\"$USER\", \"cpu\":\"$CPU_P\", \"mem\":\"$MEM_P\", \"command\":\"$CMD\"},"
done < <(ps -eo pid,user,%cpu,%mem,args --sort=-%cpu | tail -n +2 | head -n 5)
PROCESS_JSON="${PROCESS_JSON%,}]"
if [ "$PROCESS_JSON" == "]" ]; then PROCESS_JSON="[]"; fi

# --- 3. Write JSON ---
cat <<EOF > $OUTPUT_FILE
{
    "timestamp": "$NOW",
    "system": {
        "hostname": "$HOSTNAME",
        "os": "$OS",
        "kernel": "$KERNEL",
        "uptime": "$UPTIME"
    },
    "cpu": $(printf "%.0f" $CPU),
    "memory": $MEM,
    "disk": $DISK,
    "processes": $PROCESS_JSON
}
EOF
