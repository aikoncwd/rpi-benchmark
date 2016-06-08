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
printf "sd_clock="
grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}'
echo -e "\n"

echo -e "Running InternetSpeed test...\e[93m"
#speedtest-cli --simple
echo -e "\e[0m"

echo -e "Running CPU test...\e[93m"
sysbench --num-threads=4 --validate=on --test=cpu --cpu-max-prime=500 run | grep -A1 "total time:"
vcgencmd measure_temp
echo -e "\e[0m"

echo -e "Running MEMORY test...\e[93m"
sysbench --num-threads=4 --validate=on --test=memory --memory-block-size=1K --memory-total-size=1G --memory-access-mode=seq run | grep "total time:"
vcgencmd measure_temp
echo -e "\e[0m"

echo -e "Running THREADS test...\e[93m"
sysbench --num-threads=4 --validate=on --test=threads --thread-yields=300 run | grep "total time:"
vcgencmd measure_temp
echo -e "\e[0m"

echo -e "Running HDPARM test...\e[93m"
#hdparm -t /dev/mmcblk0 | grep Timing
vcgencmd measure_temp
echo -e "\e[0m"

echo -e "Running DD WRITE test...\e[93m"
#rm -f ~/test.tmp && sync && dd if=/dev/zero of=~/test.tmp bs=1M count=5 conv=fsync 2>&1 | grep -v records
vcgencmd measure_temp
echo -e "\e[0m"

echo -e "Running DD READ test...\e[93m"
#echo -e 3 > /proc/sys/vm/drop_caches && sync && dd if=~/test.tmp of=/dev/null bs=1M 2>&1 | grep -v records
vcgencmd measure_temp
#rm -f ~/test.tmp
echo -e "\e[0m"

echo -e "\e[92mAikonCWD's rpi-benchmark completed!\e[0m\n"
