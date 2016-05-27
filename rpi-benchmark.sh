#!/bin/bash

printf "\n"
printf "Raspberry Pi microSD Benshmakrs\n"

CLOCK="$(grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}')"
if [ -n "$CLOCK" ]; then
  echo "microSD clock: $CLOCK"
fi
printf "\n"

# Install dependencies.
if [ ! `which hdparm` ]; then
  printf "Installing hdparm...\n"
  apt-get install -y hdparm
  printf "Install complete!\n\n"
fi

# Run benchmarks.
printf "Running hdparm test...\n"
hdparm -t /dev/mmcblk0
printf "\n"

printf "Running dd test...\n\n"
dd if=/dev/zero of=~/test.tmp bs=8k count=50k conv=fsync; rm -f ~/test.tmp
printf "\n"

printf "microSD card benchmark complete!\n\n"
