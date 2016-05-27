#!/bin/bash

# Install dependencies
if [ ! `which hdparm` ]; then
  apt-get install -y hdparm
fi

# Script start!
clear
printf "\n"
printf "Raspberry Pi microSD Benchmark\n"
printf "Author: AikonCWD\n"

# Show current SD clock
CLOCK="$(grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}')"
printf "microSD clock: $CLOCK\n"

# Run benchmarks.
printf "Running HDPARM test...\n"
hdparm -t --direct /dev/mmcblk0 | grep Timing
printf "\n"

printf "Running DD WRITE test...\n\n"
dd if=/dev/zero of=~/test.tmp bs=1M count=512 conv=fsync
printf "\n"

printf "Running DD READ test...\n\n"
dd if=~/test.tmp of=/dev/null bs=1M; rm -f ~/test.tmp
printf "\n"


printf "microSD card benchmark complete!\n\n"
