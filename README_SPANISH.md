# Raspberry Pi Benchmark

<p align="center"><img src="https://i.imgur.com/rgrumzQ.png"></p>

<p align="center">Copia y pega el siguiente comando en la consola/terminal de tu Raspberry Pi:</p>

     curl -L https://raw.githubusercontent.com/aikoncwd/rpi-benchmark/master/rpi-benchmark.sh | sudo bash

## Información

Éste script ejecutará 7 test de benchmark para estresar el hardware de tu Raspberry Pi:

1. **Speedtest-cli test:** Calcula el ping, velocidad de carga y descarga en Internet
2. **CPU sysbench test:** Calcula 5000 números primos
3. **CPU sysbench test:** Multihilo 4000 rendimientos and 5 bloqueos
4. **MEMORY RAM test:** Acceso sequencial a 3Gb de memoria RAM
5. **microSD HDParm test:** Calcula la velocidad máxima de lectura de la microSD
6. **microSD DD write test:** Calcula la velocidad máxima de escritura con 512Mb de datos
7. **microSD DD read test:** Calcula la velocidad máxima de lectura con 512Mb de datos


El script rpi-benchmark mostrará al inicio la actual configuración de hardware (overclock). Después de cada test, aparecerá la temperatura en ºC de tu CPU
<br>
<br>
## Cómo se usa

No necesitas descargar ni compilar código... Es muy fácil!
Simplemente copia el siguiente comando en la consola/terminal de tu Raspberry Pi:

     curl -L https://raw.githubusercontent.com/aikoncwd/rpi-benchmark/master/rpi-benchmark.sh | sudo bash

El script rpi-benchmark empezará automáticamente en 2 segundos :relaxed:
<br>
<br>
<br>
## Overclocking
### Quiero mejorar mis resultados, puedo overclockear mi RPi?

Sí, overclockear tu RPi otorgará más velocidad en cálculos de CPU, mejor velocidad en la lectura y escritura hacia la memoria RAM y mejores tiempos de acceso al leer o escribir en la tarjeta microSD  
Si utilizas tu RPi como MediaCenter con Kodi o para jugar en RetroPie, percibirás un mejor rendimiento y velocidad.

Recomiendo encarecidamente que utilices algñun método de ventilación/refrigeración para evitar alcanzar los 85ºC, ya que la RPi bajará su velocidad si alcanza esa temperatura
<br>
<br>
##### Raspberry Pi 3: Overclock settings

Edita tu fichero `/boot/config.txt` y pega el siguiente código, puedes ajustar los valores para tener más o menos overclock:

    force_turbo=1                   #Enable cpu-overclock over 1300MHz (default 0)
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

Edita tu fichero `/boot/config.txt` y pega el siguiente código, puedes ajustar los valores para tener más o menos overclock:

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

