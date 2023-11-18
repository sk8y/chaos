#!/bin/bash


set -euo pipefail

max_pods_to_kill="${1:-5}"
pods_selector_to_kill="${2:-test-app-hello}"

while true; do
    for pod_name in $(kubectl -n default get pods --selector "app=${pods_selector_to_kill}" --no-headers -o=custom-columns='NAME:.metadata.name' | tail -"${max_pods_to_kill}"); do
        echo "Deleting pod ${pod_name}"
        kubectl -n default delete pod "${pod_name}"
        sleep 1
    done
    sleep 10
done
