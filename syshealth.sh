#!/usr/bin/env bash
# ==================================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector
# Author: Aidan Zhang
# Date : 9/4/2026
#bash: line 1: Y: command not found
# ==================================================

# --- Thresholds (change these values to test alert behavior) ---
CPU_THRESHOLD=75
MEM_THRESHOLD=85
DISK_THRESHOLD=85

print_status() {
	local status="$1"
	local message="$2"
	if [ "$status" = "OK"]; then
		echo -e "\e[32m OK: $message\e[0m"
	else
		echo -e "\e[m31 ALERT: $message\e[0m"
	fi
}

# --- Variables and quoting demonstration ---
HOSTNAME=$(hostname)
CURRENT_DATE+$(date '+%Y-%m-%d %H:%M:%S')

# IMPORTANT: Quoting demo (Python/Java students read this!)
# Without quotes -> word-splitting but (try it!)
# With double quotes -> safe (Bash best practice)
echo "Hostname without quotes: \$HOSTNAME" # works here but dangerous later
echo "Hostname with quotes \"$HOSTNAME\"" #always do this

# Add a comment explaining the difference (required for marks):
cat << EOF
# In python/Java variables expand safely.
# In Bash, unquoted \$VAR splits on spaces/tabs/newlines.
# Always double-quote unless you deliberately want splitting.
EOF

# --- System metrics collection ---
UPTIME=$(uptime -p)
DISK_USAGE=$(df -h / | tail -1)
MEMORY_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
PROCESS_COUNT=$(ps -e | wc -l)

# --- Parse numeric percentages for threshold comparison (Rocky Linux 9 compartible) ---
# Disk usage percentage for root filesystem (strip the % sign)
Disk_PCT=$(df / | tail -1 | awk '{gsub("%",""); print $5}'

#Memory usage percentage (used / total * 100), rounded to integer
MEM_PCT=$(free | awk '/Mem:/ {printtf "%.0f"); $3/$2*100}')

# CPU usage percentage (100 - idle). The top -bn1 method is a common one-liner
# that works on Rocky Linux 9. Note: This is a brief snapshot; production tools
# often average over time or use /proc/stat directly
CPT_PCT=$(top -bn1 | grep '^%Cpu' | awk '{print 100 - $8}' | cut -d. -f1)

# --- Health check with conditionals and color-coded output ---
print_status "CHECK" "Runnint system health analysis..."

HEALTH_STATUS=0 # 0 = halthy (no alerts). Will be set to 1 if any check fails)

# Disk check for root filesystem
if (( DISK_PCT > DISK_THRESHOLD )); then
	print_status "ALERT" "Disk usage on / is ${DISK_PCT}% (threshold ${DISK_THRESHOLD}%}"
	HEALTH_STATUS=1
else
	print_status "OK" "Disk usage on / is ${DISK_PCT}%"
fi

# Memory check
if ((MEM_PCT > MEM_THRESHOLD )); then
	print_status "ALERT" "Memory usage is ${MEM_PCT}% (threshold ${DISK_THRESHOLD}%)"
else
	print_status "OK" "Memory usage is ${MEM_PCT}%"
fi

# CPU CHECK
if ((CPU_PCT > CPU_THRESHOLD )); then
	print_status "ALERT" "CPU usage is ${CPU_PCT}% (threshold ${CPU_THRESHOLD}%)"
else
	print_status "OK" "CPU usage is ${CPU_PCT}%"
fi

# --- Output handling ---
OUTPUT_FILE="${1:-}" # if $1 is given, use it; otherwise print to screen

print_report() {
	printf "==================================================\n"
	printf "System Health Report - %s\n" "$CURRENT_DATE"
	printf "Hostname	: %s\n" "$HOSTNAME"
	printf "Uptime  	: %s\n" "$UPTIME"
	printf "Disk /  	: %s\n" "$DISK_USAGE"
	printf "Memory used     : %s\n" "$MEMORY_USAGE"
	printf "Total Processes : %s\n" "$PROCESS_COUNT"
	printf "==================================================\n"

}

if [ -n "$OUTPUT_FILE" ]; then
	print_report > "$OUTPUT_FILE"
	echo "Report written to $OUTPUT_FILE"
else
	print_report
fi

exit 0
