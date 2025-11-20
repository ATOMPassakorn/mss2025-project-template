#!/usr/bin/env bash

# 1) CPU Usage
cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.2f", 100-$8}')

# 2) Memory Usage
mem_usage=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')

# 3) Disk Usage ของ root (/)
disk_usage=$(df -h / | awk 'NR==2{print $5}')
disk_used=$(df -h / | awk 'NR==2{print $3}')
disk_total=$(df -h / | awk 'NR==2{print $2}')

# 4) Last Updated
last_updated=$(date '+%Y-%m-%d %H:%M:%S %Z')

# 5) Neofetch (optional: ถ้าไม่มี ติดตั้งก่อน sudo apt install neofetch -y)
neofetch_raw=$(neofetch --stdout 2>/dev/null || echo "neofetch not available")
neofetch_json=$(printf '%s' "$neofetch_raw" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

# 6) Network Interface + Traffic
iface=$(ip route get 8.8.8.8 2>/dev/null | awk '
  /dev/ {
    for(i=1;i<=NF;i++) if ($i=="dev") {print $(i+1); exit}
  }')

if [ -z "$iface" ]; then
  iface=$(ip -o -4 addr show | awk 'NR==1{print $2}')
fi

rx_bytes=$(cat /sys/class/net/"$iface"/statistics/rx_bytes 2>/dev/null || echo 0)
tx_bytes=$(cat /sys/class/net/"$iface"/statistics/tx_bytes 2>/dev/null || echo 0)

rx_human=$(numfmt --to=iec "$rx_bytes" 2>/dev/null || echo "$rx_bytes B")
tx_human=$(numfmt --to=iec "$tx_bytes" 2>/dev/null || echo "$tx_bytes B")

# 7) Print JSON ออกไป (stdout)
cat <<EOF
{
  "cpu_usage": "$cpu_usage",
  "mem_usage": "$mem_usage",
  "disk_usage": "$disk_usage",
  "disk_used": "$disk_used",
  "disk_total": "$disk_total",
  "iface": "$iface",
  "rx_human": "$rx_human",
  "tx_human": "$tx_human",
  "neofetch": $neofetch_json,
  "last_updated": "$last_updated"
}
EOF
