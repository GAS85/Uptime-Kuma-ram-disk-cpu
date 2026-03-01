#!/bin/bash

# Notify Treshold in CPUs, e.g. 400 is 4.00 CPUs
notifyThreshold="400"
kumaToken="123456"
kumaURL="http://kuma:9070/api/push/"

# Will use latest value, CPU usage for last 15 min.
cpuUsage15Min=$(uptime | awk '{print $NF}' | sed 's/,//' ) #| tr '.' '')

if [[ "$(($cpuUsage15Min))" -le "$notifyThreshold" ]]; then
  curl -fs -o /dev/null --retry 2 -m 10 "$kumaURL/$kumaToken?status=up&msg=OK&ping=$cpuUsage15Min"
else
  # Try longer for a high CPU useage
  curl -fs -o /dev/null --retry 5 -m 60 "$kumaURL/$kumaToken?status=down&msg=HighCpuUsage-$cpuUsage15Min&ping=$cpuUsage15Min"
fi

exit 0
