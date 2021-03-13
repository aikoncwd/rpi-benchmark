# Raspberry Pi Benchmark

<p align="center"><img src="https://i.imgur.com/rgrumzQ.png"></p>

Copy and paste the following command in your Raspberry Pi console:

     curl -L https://raw.githubusercontent.com/aikoncwd/rpi-benchmark/master/rpi-benchmark.sh | sudo bash


## Information

This script runs 7 benchmark tests to stress your Raspberry Pi hardware:

1. **Speedtest-cli test:** Calculate ping, upload and download internet speed
2. **CPU sysbench test:** Calculate 5000 prime numbers
3. **CPU sysbench test:** Multithread with 4000 yields and 5 locks
4. **MEMORY RAM test:** Sequencial access to 3Gb of memory
5. **microSD HDParm test:** Calculate maximun read speed for SD
6. **microSD DD write test:** Calculate maximun write speed with 512Mb file
7. **microSD DD read test:** Calculate maximun read speed with 512Mb file


Rpi-benchmark script will show your current hardware (overclock) settings. After every test, it will show the current CPU temperature
<br>
<br>
## Usage

You don't need to download any program, compile sources, etc... It's so easy!  
Just copy and paste the following command in your Raspberry Pi console:

     curl -L https://raw.githubusercontent.com/aikoncwd/rpi-benchmark/master/rpi-benchmark.sh | sudo bash

The rpi-benchmark script will start in 2 seconds :relaxed:
<br>
If you want to run this without the Internet Speed Test being run, then use:

     curl -L https://raw.githubusercontent.com/aikoncwd/rpi-benchmark/master/rpi-benchmark.sh | sudo bash -s -- --no-speedtest

<br>
<br>

## Overclocking

### I want better results, can I overclock my RPi?

Yes, overclocking your RPi will give you more power for your **CPU calculations**, more speed while read/write into your **memory ram** and better speeds while read/write into your microSD card.  
If you use your RPi as a MediaCenter with Kodi or to play games with RetroPie, you will find a nice perfomance boost.

I strongly recommend to use some cooling on your RPi to avoid CPU throttling (at 85ºC)
<br>
<br>

##### Raspberry Pi 3: Overclock settings

Edit your `/boot/config.txt` file and paste the following code, you can adjust values to get more or less overclock:

    force_turbo=0                   #Enable cpu-overclock over 1300MHz (default 0)
    avoid_pwm_pll=1                 #Enable no-relative freq between cpu and gpu cores (default 0)
    
    arm_freq=1300                   #Frequency of ARM processor core in MHz (default 1200)
    core_freq=550                   #Frequency of GPU processor core in MHz (default 400)
    over_voltage=6                  #ARM/GPU voltage adjust, values over 6 voids warranty (default 0)
    
    sdram_freq=575                  #Frequency of SDRAM in MHz (default 450)
    sdram_schmoo=0x02000020         #Set SDRAM schmoo to get more than 500MHz freq (default unset)
    over_voltage_sdram_p=6          #SDRAM phy voltage adjust (default 0)
    over_voltage_sdram_i=4          #SDRAM I/O voltage adjust (default 0)
    over_voltage_sdram_c=4          #SDRAM controller voltage adjust (default 0)
    
    gpu_mem=256                     #GPU memory in MB. Memory split between ARM and GPU (default 64?)
    gpu_freq=550                    #Sets core_freq h264_freq isp_freq v3d_freq together (default 300)
    v3d_freq=500                    #Frequency of 3D block in MHz (default ?)
    h264_freq=350                   #Frequency of hardware video block in MHz (default ?)
    
    dtparam=sd_overclock=90         #Clock in MHz to use for MMC micrSD (default 50)
    dtparam=audio=on                #Enables the onboard ALSA audio (always use this ON)
    dtparam=spi=on                  #Enables the SPI interfaces (default OFF)
    
    temp_limit=80                   #Overheat protection. Disable overclock if SoC reaches this temp
    initial_turbo=60                #Enables turbo mode from boot for the given value in seconds
    
    start_x=1                       #Enable software decoding (MPEG-2, VC-1, VP6, VP8, Theora, etc)
    overscan_scale=1                #Respect the overscan settings with the use of an LCD display
<br>

##### Raspberry Pi 2: Overclock settings

Edit your `/boot/config.txt` file and paste the following code, you can adjust values to get more or less overclock:

    gpu_mem=256
    gpu_mem_256=128
    gpu_mem_512=256
    gpu_mem_1024=256
    
    arm_freq=1100
    core_freq=550
    sdram_freq=483
    over_voltage=6
    over_voltage_sdram=2
    temp_limit=70
    force_turbo=0
    initial_turbo=60
    
    hdmi_drive=2
    hdmi_ignore_cec=0
    hdmi_ignore_cec_init=1
    hdmi_ignore_hotplug=0
    hdmi_force_hotplug=1
    
    #disable_overscan=0
    #overscan_scale=1
    
    #overscan_left=49
    #overscan_right=49
    #overscan_top=29
    #overscan_bottom=25
    
    max_usb_current=1
    dtparam=audio=on
    dtparam=spi=on
