#!/bin/bash

# Notify Threshold in percent (e.g. 80 = 80%)
notifyThreshold="80"
kumaToken="123456"
kumaURL="http://kuma:9070/api/push"

# Get RAM usage percentage
memUsage=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')

if [[ "$memUsage" -le "$notifyThreshold" ]]; then
  curl -fs -o /dev/null --retry 2 -m 10 "$kumaURL/$kumaToken?status=up&msg=OK&ping=$memUsage"
else
  curl -fs -o /dev/null --retry 2 -m 10 "$kumaURL/$kumaToken?status=down&msg=HighRamUsage-${memUsage}%&ping=$memUsage"
fi

exit 0
