#!/bin/bash

# Install dependencies
if [ ! `which hdparm` ]; then
  apt-get install -y hdparm
fi
if [ ! `which sysbench` ]; then
  apt-get install -y sysbench
fi

# Script start!
clear
sync
printf "\n"
printf "Raspberry Pi microSD Benchmark\n"
printf "Author: AikonCWD\n\n"

# Show current SD clock
CLOCK="$(grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}')"
printf "microSD clock: $CLOCK\n\n"

# Run benchmarks.
printf "Running HDPARM test...\n"
hdparm -t --direct /dev/mmcblk0 | grep Timing
printf "\n"

printf "Running DD WRITE test...\n"
rm -f ~/test.tmp && sync && dd if=/dev/zero of=~/test.tmp bs=1M count=512 conv=fsync 2>&1 | grep -v records
printf "\n"

printf "Running DD READ test...\n"
echo 3 > /proc/sys/vm/drop_caches && sync && dd if=~/test.tmp of=/dev/null bs=1M 2>&1 | grep -v records
rm -f ~/test.tmp
printf "\n"

printf "AikonCWD's Benchmark completed!\n\n"
