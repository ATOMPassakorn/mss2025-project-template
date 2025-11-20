#!/bin/bash

OUTPUT_FILE="/var/www/html/data.json"

NOW=$(date +"%Y-%m-%d %H:%M:%S")

HOSTNAME=$(hostname)
OS=$(lsb_release -d 2>/dev/null | awk -F"\t" '{print $2}')
if [ -z "$OS" ]; then OS=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2); fi
KERNEL=$(uname -r)
LOCAL_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(curl -s -m 3 ifconfig.me)
UPTIME=$(uptime -p)
PROC_COUNT=$(ps -e --no-headers | wc -l)
# ---------------------------------------------

CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
MEM=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
DISK=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

PROCESS_JSON="["
while read -r line; do
    if [ -z "$line" ]; then continue; fi
    PID=$(echo "$line" | awk '{print $1}')
    USER=$(echo "$line" | awk '{print $2}')
    CPU_P=$(echo "$line" | awk '{print $3}')
    MEM_P=$(echo "$line" | awk '{print $4}')
    CMD=$(echo "$line" | awk '{for(i=5;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/"/\\"/g')
    PROCESS_JSON="$PROCESS_JSON {\"pid\":\"$PID\", \"user\":\"$USER\", \"cpu\":\"$CPU_P\", \"mem\":\"$MEM_P\", \"command\":\"$CMD\"},"
done < <(ps -eo pid,user,%cpu,%mem,args --sort=-%cpu | tail -n +2 | head -n 5)

PROCESS_JSON="${PROCESS_JSON%,}]"
if [ "$PROCESS_JSON" == "]" ]; then PROCESS_JSON="[]"; fi

cat <<EOF > $OUTPUT_FILE
{
    "timestamp": "$NOW",
    "cpu": $(printf "%.0f" $CPU),
    "memory": $MEM,
    "disk": $DISK,
    "hostname": "$HOSTNAME",
    "os": "$OS",
    "kernel": "$KERNEL",
    "local_ip": "$LOCAL_IP",
    "public_ip": "$PUBLIC_IP",
    "uptime": "$UPTIME",
    "proc_count": "$PROC_COUNT",
    "processes": $PROCESS_JSON
}
EOF
