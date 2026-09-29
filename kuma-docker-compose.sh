#!/bin/bash
set -euo pipefail

kumaURL="http://kuma:9070"

push() {
  local token="$1" status="$2" msg="$3"
  curl -fsS -o /dev/null --retry 5 -m 10 -G "$kumaURL/api/push/$token" \
    --data-urlencode "status=$status" --data-urlencode "msg=$msg"
}

# Checks all services of one compose project (services with a non-active profile are ignored).
# A service is "down" if it has no container, is not running or its healthcheck is unhealthy.
notifyKuma() {
  local dir="$1"
  local token="$2"
  local excluded=" ${3:-} "   # optional: space separated services to skip
  local failed=() service ids id state health

  if ! services=$(docker compose --project-directory "$dir" config --services 2>/dev/null); then
    push "$token" down "ComposeConfigError"
    return
  fi

  for service in $services; do
    [[ "$excluded" == *" $service "* ]] && continue

    ids=$(docker compose --project-directory "$dir" ps -q "$service" 2>/dev/null || true)
    if [[ -z "$ids" ]]; then
      failed+=("$service:missing")
      continue
    fi

    for id in $ids; do
      state=$(docker inspect -f '{{.State.Status}}' "$id")
      health=$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{end}}' "$id")
      if [[ "$state" != "running" ]]; then
        failed+=("$service:$state")
      elif [[ "$health" == "unhealthy" ]]; then
        failed+=("$service:unhealthy")
      fi
    done
  done

  if [[ ${#failed[@]} -eq 0 ]]; then
    push "$token" up "OK"
  else
    push "$token" down "${failed[*]}"
  fi
}

# Example usage:
# notifyKuma "directory of the compose file" "kuma Token" "optional: services to ignore (space separated)"
notifyKuma "/opt/squid" ""
notifyKuma "/opt/openvpn" "" "setup"

exit 0
