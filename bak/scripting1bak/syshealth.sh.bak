#!/usr/bin/env bash
# ==================================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector
# Author: Aidan Zhang
# Date : 9/4/2026
#bash: line 1: Y: command not found
# ==================================================
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
