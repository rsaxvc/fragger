#!/usr/bin/bash
set -e
ZVOL=tank/fragger
READS=3
BLOCK_SIZE=4096
ZVOL_SIZE=1073741824

if [[ $# -gt 0 ]]; then
    echo "Get arguments: $@"
    BLOCK_SIZE=$1
fi
echo Using volblocksize "$BLOCK_SIZE"

zfs destroy "$ZVOL" || true

echo "Creating ZVOL:$ZVOL"

zfs create -V 1T -s -b "$BLOCK_SIZE" "$ZVOL"
zfs set compression=off "$ZVOL"
zfs set logbias=throughput tank/fragger

echo "Reading ZVOL"
for n in $(seq 1 "$READS"); do
    echo 3 > /proc/sys/vm/drop_caches
    dd if=/dev/zvol/"$ZVOL" bs=1M count=1048576 of=/dev/null 2>&1
done

echo "Populating ZVOL"
echo 3 > /proc/sys/vm/drop_caches
dd if=/dev/urandom bs=1M count=1048576 of=/dev/zvol/"$ZVOL" 2>&1
sync

echo "Reading ZVOL"
for n in $(seq 1 "$READS"); do
    echo 3 > /proc/sys/vm/drop_caches
    dd if=/dev/zvol/"$ZVOL" bs=1M count=1048576 of=/dev/null 2>&1
done

echo "Updating ZVOL even blocks"
for ((i=$((BLOCK_SIZE)); i<$((ZVOL_SIZE)); i += $((BLOCK_SIZE * 2)) )); do
    echo "$i"
done | shuf | while IFS= read -r p; do
    dd bs=1 count=1 seek="$p" if=/dev/zero of=/dev/zvol/"$ZVOL" 2>&1
done | grep copied | tail -n 3
sync
echo "done"

echo "Reading ZVOL"
for n in $(seq 1 "$READS"); do
    echo 3 > /proc/sys/vm/drop_caches
    dd if=/dev/zvol/"$ZVOL" bs=1M count=1048576 of=/dev/null 2>&1
done

echo "Updating ZVOL odd blocks"
for ((i=$((BLOCK_SIZE)); i<$((ZVOL_SIZE)); i += $((BLOCK_SIZE * 2)) )); do
    echo "$i"
done | shuf | while IFS= read -r p; do
    dd bs=1 count=1 seek="$p" if=/dev/zero of=/dev/zvol/"$ZVOL" 2>&1
done | grep copied | tail -n 3
sync
echo "done"

echo "Reading ZVOL"
for n in $(seq 1 "$READS"); do
    echo 3 > /proc/sys/vm/drop_caches
    dd if=/dev/zvol/"$ZVOL" bs=1M count=1048576 of=/dev/null 2>&1
done
