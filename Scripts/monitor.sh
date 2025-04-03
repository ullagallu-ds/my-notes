#!/bin/bash

# Log file
LOG_FILE="/home/ubuntu/system_monitor.log"

# Function to log system metrics
log_system_metrics() {
    echo "----------------------------------------" >> "$LOG_FILE"
    echo "Timestamp: $(date)" >> "$LOG_FILE"

    # CPU Usage
    echo "CPU Usage:" >> "$LOG_FILE"
    top -b -n1 | grep "Cpu(s)" | awk '{print "  User: "$2"%  System: "$4"%  Idle: "$8"%"}' >> "$LOG_FILE"

    # Memory Usage
    echo "Memory Usage:" >> "$LOG_FILE"
    free -h | awk 'NR==2{printf "  Used: %s / Total: %s\n", $3, $2}' >> "$LOG_FILE"

    # Disk Usage
    echo "Disk Usage:" >> "$LOG_FILE"
    df -h | grep "^/dev/" | awk '{print "  Partition: "$1"  Used: "$3" / "$2"  Available: "$4}' >> "$LOG_FILE"

    # Network Usage
    echo "Network Usage (bytes received/sent):" >> "$LOG_FILE"
    cat /proc/net/dev | awk 'NR>2 {print "  Interface: "$1"  Received: "$2"  Sent: "$10}' >> "$LOG_FILE"

    echo "----------------------------------------" >> "$LOG_FILE"
}

# Ensure log file exists
touch "$LOG_FILE"

# Log system metrics
log_system_metrics

# Print a success message
echo "System metrics logged in $LOG_FILE"

if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo "High CPU usage detected: $cpu_usage%" | mail -s "CPU Alert" sivaram0434@gmail.com
fi

