#!/bin/bash


set -euo pipefail

max_pods_to_kill="${1:-10}"
kill_interval="${2:-10}"

while true; do

    for pod_name in $(kubectl -n default get pods \
            --selector "app in (test-app-hello, test-app-employee)" \
            -o custom-columns=POD:metadata.name,READY-true:status.containerStatuses[*].ready \
            --no-headers \
                | grep true \
                | awk '{print $1}' \
                | shuf -n "${max_pods_to_kill}"
            ); do
        echo "$(date +%y%m%d-%H%M%S) - deleting pod ${pod_name}"
        kubectl -n default delete pod "${pod_name}"
        sleep 0.1
    done
    sleep "${kill_interval}"
done
