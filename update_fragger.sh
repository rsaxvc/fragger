#!/bin/bash

ZVOL=tank/fragger
set -e

echo "Updating ZVOL"
for i in {4096..1073741823..8192}; do
    echo "$i"
done | shuf | while IFS= read -r p; do
    dd bs=1 count=1 seek="$p" if=/dev/zero of=/dev/zvol/"$ZVOL" 2>&1
done | tail -n 3
sync
echo "done"
