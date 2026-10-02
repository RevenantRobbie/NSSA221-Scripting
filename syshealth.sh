#!/usr/bin/env bash
# ==================================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector
# Author: Aidan Zhang
# Date : 9/4/2026
# bash: line 1: Y: command not found
# ==================================================

# --- Thresholds (change these values to test alert behavior) ---
CPU_THRESHOLD=75
MEM_THRESHOLD=85
DISK_THRESHOLD=85

# --- Function definitions will go here --- 

main() {
	parse_arguments "$@"
	run_health_checks
	generate_report
}

# The single call that starts everything -must be the very last line
main


