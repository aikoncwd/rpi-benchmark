# Raspberry Pi Benchmark

![](https://i.imgur.com/xy0YlJF.png)

## Information

This script runs several benchmark to test different RPi hardware:

- CPU sysbench test: Calculate 5000 prime numbers
- CPU sysbench test: Multithread with 4000 yields and 5 locks
- MEMORY RAM test: Sequencial access to 3Gb of memory
- microSD HDParm test: Calculate maximun read speed for SD
- microSD DD write test: Calculate maximun write speed with 512Mb file
- microSD DD read test: Calculate maximun read speed with 512Mb file
- Speedtest-cli test: Calculate ping, upload and download internet speed
 
Rpi-benchmark script will show your current hardware (overclock) settings. After every test, it will show the current CPU temperature

## Usage

Copy and paste the following command in your Raspberry Pi:

     curl -L http://bit.ly/1Vm2eHP | sudo bash
