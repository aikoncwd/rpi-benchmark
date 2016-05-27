#!/bin/bash

[ "$(whoami)" == "root" ] || { echo "Must be run as root!"; exit 1; }

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
printf "Raspberry Pi microSD Benchmark\n"
printf "Author: AikonCWD\n\n"

# Show current hardware
vcgencmd measure_temp
vcgencmd get_config int | grep arm_freq
vcgencmd get_config int | grep core_freq
vcgencmd get_config int | grep sdram_freq
printf "microsd_clock="
grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}'
printf "\n"

printf "Running CPU test..."
sysbench --num-threads=4 --validate=on --test=cpu --cpu-max-prime=5000 run | grep "total time:"
printf "\n"

printf "Running MEMORY test..."
sysbench --num-threads=4 --validate=on --test=memory --memory-block-size=1K --memory-total-size=3G --memory-access-mode=seq run | grep "total time:"
printf "\n"

printf "Running THREADS test..."
sysbench --num-threads=4 --validate=on --test=threads --thread-yields=3000 run | grep "total time:"
printf "\n"

printf "Running HDPARM test...\n"
hdparm -t /dev/mmcblk0 | grep Timing
printf "\n"

printf "Running SD WRITE test...\n"
rm -f ~/test.tmp && sync && dd if=/dev/zero of=~/test.tmp bs=1M count=512 conv=fsync 2>&1 | grep -v records
printf "\n"

printf "Running SD READ test...\n"
echo 3 > /proc/sys/vm/drop_caches && sync && dd if=~/test.tmp of=/dev/null bs=1M 2>&1 | grep -v records
rm -f ~/test.tmp
printf "\n"

printf "AikonCWD's Benchmark completed!\n\n"
