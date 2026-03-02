#!/bin/bash

# Notify Threshold in percent (e.g. 80 = 80%)
notifyThreshold=80
kumaToken="123456"
kumaURL="http://kuma:9070"

set -euo pipefail

# Get RAM usage percentage
# used / total *100
#memUsage=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')
# (1 - available/total) * 100
#memUsage=$(free | awk '/Mem:/ {printf("%.0f", ($2-$7)/$2 * 100)}')
# Use /proc/meminfo
memUsage=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {printf("%.0f", (t-a)/t*100)}' /proc/meminfo)

if [[ "$memUsage" -le "$notifyThreshold" ]]; then
  curl -fsS -o /dev/null --retry 2 -m 10 "$kumaURL/api/push/$kumaToken?status=up&msg=OK&ping=$memUsage"
else
  curl -fsS -o /dev/null --retry 2 -m 10 "$kumaURL/api/push/$kumaToken?status=down&msg=HighRamUsage-${memUsage}%&ping=$memUsage"
fi

exit 0
