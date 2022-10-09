#!/bin/bash

# drop file caches
echo 1 > /proc/sys/vm/drop_caches

# re-claim unused memory for windows host (wsl kernel runs this also periodically)
echo 1 > /proc/sys/vm/compact_memory