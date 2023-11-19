#!/bin/bash


#set -euo pipefail

max_pods_to_kill="${1:-4}"
kill_interval="${2:-1}"
set -x

while true; do

    pod_list="$(kubectl -n test-app get pods \
            --selector "app in (test-app-hello, test-app-employee)" \
            -o custom-columns=POD:metadata.name,READY-true:status.containerStatuses[*].ready \
            --no-headers \
                | grep true \
                | awk '{print $1}' \
                | shuf -n "${max_pods_to_kill}" \
                | xargs echo
            )"

    if [[ "x${pod_list}" == "x" ]]; then
        echo "$(date +%y%m%d-%H%M%S) - no pods to kill"
    else
        echo "$(date +%y%m%d-%H%M%S) - deleting pods: ${pod_list}"
        kubectl -n test-app delete pod ${pod_list} 2>&1 | sed 's/^/    /'
    fi
    sleep "${kill_interval}"
done
