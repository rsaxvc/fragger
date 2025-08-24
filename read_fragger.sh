#!/bin/bash

echo "Reading ZVOL"
for n in $(seq 1 3); do
    echo 3 > /proc/sys/vm/drop_caches
    dd if=/dev/zvol/tank/fragger bs=1M count=1048576 of=/dev/null
done

