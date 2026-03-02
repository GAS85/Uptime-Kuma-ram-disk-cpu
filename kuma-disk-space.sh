#!/bin/bash
set -euo pipefail

kumaURL="http://kuma:9070"
defaultThreshold=85

notifyKuma() {
  local disk="$1"
  local token="$2"
  local threshold="${3:-$defaultThreshold}"

  usedPercent=$(df -P "$disk" 2>/dev/null | awk 'NR==2 {gsub("%","",$5); print $5}' || true)

  if [[ -z "$usedPercent" ]]; then
    curl -fsS -o /dev/null --retry 5 -m 10 "$kumaURL/api/push/$token?status=down&msg=DiskNotFound"
    return
  fi

  if [[ "$usedPercent" -le "$threshold" ]]; then
    curl -fsS -o /dev/null --retry 5 -m 10 "$kumaURL/api/push/$token?status=up&msg=OK&ping=$usedPercent"
  else
    curl -fsS -o /dev/null --retry 5 -m 10 "$kumaURL/api/push/$token?status=down&msg=DiskUsageHigh&ping=$usedPercent"
  fi
}

# Example usage:
# notifyKuma "disk that is mounted" "kuma Token" "optional threshold in percent"
notifyKuma "/mnt/disk1" "1y2x3v4b5"
notifyKuma "/dev/mapper/ubuntu--vg-ubuntu--lv" "yxcvbn" 90
notifyKuma "/dev/mapper/ubuntu--vg-something-lv" "123456" 90

exit 0