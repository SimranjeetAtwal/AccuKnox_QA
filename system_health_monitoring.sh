#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_health.log"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Check CPU usage
check_cpu_usage() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
    local cpu_usage_int=$(printf "%.0f" "$cpu_usage")  # Convert to integer for comparison
    if [ "$cpu_usage_int" -gt "$CPU_THRESHOLD" ]; then
        log_message "CPU usage is above threshold: ${cpu_usage}%"
    fi
}

# Check memory usage
check_memory_usage() {
    local memory_total=$(free | awk '/Mem/ {print $2}')
    local memory_used=$(free | awk '/Mem/ {print $3}')
    local memory_usage=$(awk -v total="$memory_total" -v used="$memory_used" 'BEGIN {printf "%.2f", (used / total) * 100}')
    local memory_usage_int=${memory_usage%.*}  # Extract integer part for comparison
    if [ "$memory_usage_int" -gt "$MEMORY_THRESHOLD" ]; then
        log_message "Memory usage is above threshold: ${memory_usage}%"
    fi
}

# Check disk usage
check_disk_usage() {
    local disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
        log_message "Disk usage is above threshold: ${disk_usage}%"
    fi
}

# Check number of running processes
check_running_processes() {
    local process_count=$(ps -e --no-headers | wc -l)
    log_message "Number of running processes: ${process_count}"
}

# Main function to run all checks
main() {
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_running_processes
}

# Run the main function
main

