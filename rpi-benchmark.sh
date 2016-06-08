#!/bin/bash

[ "$(whoami)" == "root" ] || { echo "Must be run as sudo!"; exit 1; }

# Install dependencies
if [ ! `which hdparm` ]; then
  apt-get install -y hdparm
fi
if [ ! `which sysbench` ]; then
  apt-get install -y sysbench
fi
if [ ! `which speedtest-cli` ]; then
  apt-get install -y speedtest-cli
fi

# Script start!
clear
sync
echo -e "Raspberry Pi Benchmark Test"
echo -e "Author: AikonCWD"
echo -e "Version: 2.0\n"

# Show current hardware
vcgencmd measure_temp
vcgencmd get_config int | grep arm_freq
vcgencmd get_config int | grep core_freq
vcgencmd get_config int | grep sdram_freq
vcgencmd get_config int | grep gpu_freq
echo -e "microsd_clock="
grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}'
echo -e "\n\n"

echo -e "Running InternetSpeed test...\n"
echo -e "\e[93m"
speedtest-cli --simple
echo -e "\e[0m"

echo -e "Running CPU test...\n"
sysbench --num-threads=4 --validate=on --test=cpu --cpu-max-prime=500 run | grep "total time:"
echo -e "    "
vcgencmd measure_temp
echo -e "\n"

echo -e "Running MEMORY test...\n"
sysbench --num-threads=4 --validate=on --test=memory --memory-block-size=1K --memory-total-size=1G --memory-access-mode=seq run | grep "total time:"
echo -e "    "
vcgencmd measure_temp
echo -e "\n"

echo -e "Running THREADS test...\n"
sysbench --num-threads=4 --validate=on --test=threads --thread-yields=300 run | grep "total time:"
echo -e "    "
vcgencmd measure_temp
echo -e "\n"

echo -e "Running HDPARM test...\n"
echo -e "   "
hdparm -t /dev/mmcblk0 | grep Timing
echo -e "    "
vcgencmd measure_temp
echo -e "\n"

echo -e "Running DD WRITE test...\n"
echo -e "    "
rm -f ~/test.tmp && sync && dd if=/dev/zero of=~/test.tmp bs=1M count=5 conv=fsync 2>&1 | grep -v records
echo -e "    "
vcgencmd measure_temp
echo -e "\n"

echo -e "Running DD READ test...\n"
echo -e "    "
echo -e 3 > /proc/sys/vm/drop_caches && sync && dd if=~/test.tmp of=/dev/null bs=1M 2>&1 | grep -v records
echo -e "    "
vcgencmd measure_temp
rm -f ~/test.tmp
echo -e "\n\n"

echo -e "AikonCWD's rpi-benchmark completed!\n"
