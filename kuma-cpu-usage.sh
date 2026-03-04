#!/bin/bash

# Notify Treshold in CPUs, e.g. 400 is 4.00 CPUs
notifyThreshold=400
kumaToken="123456"
kumaURL="http://kuma:9070"

set -euo pipefail

# Will use latest value, CPU usage for last 15 min.
# Convert to integer scaled by 100 (e.g. 3.42 → 342)
read -r _ _ cpuUsage15Min _ < /proc/loadavg
cpuUsageScaled=$(awk -v val="$cpuUsage15Min" 'BEGIN { printf "%.0f", val * 100 }')

if [[ "$cpuUsageScaled" -le "$notifyThreshold" ]]; then
  curl -fsS -o /dev/null --retry 2 -m 10 "$kumaURL/api/push/$kumaToken?status=up&msg=OK&ping=$cpuUsage15Min"
else
  # Try longer for a high CPU useage
  curl -fsS -o /dev/null --retry 5 -m 60 "$kumaURL/api/push/$kumaToken?status=down&msg=HighCpuUsage-$cpuUsage15Min&ping=$cpuUsage15Min"
fi

exit 0
