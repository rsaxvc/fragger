# Fragger

A simple benchark to fragment ZFS zvols with varying block sizes.

## Description

An attempt to demonstrate the impacts of fragmentations.

### Dependencies

* ZFS
* DD
* bash

### Executing fragger

```
#Run one block size and report to console
sudo ./fragger.sh 512
```

### Executing frag_many

```
#Run each block size and save to file
sudo ./frag_many.sh 512 1024
```

### Interpreting Report output

Fragger will print a step-line like "Reading ZVOL", followed by several dd status lines.

Notable steps

* Creating ZVOL
* Reading ZVOL: this is done 3 times after creation, before any data is written
* Populating ZVOL: volume is filled from /dev/urandom
* Updating ZVOL even blocks: the first byte in every even-numbered block is zeroed in random order
* Reading ZVOL: this is done 3 times
* Updating ZVOL odd blocks: the first byte in every odd-numbered block is zeroed in random order
* Reading ZVOL: this is done 3 times

## Authors

RSAXVC
