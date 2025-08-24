#!/usr/bin/bash
for item in "$@";do
    ./fragger.sh "$item" | tee fragger_run_"$item"
done
