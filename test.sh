#!/bin/bash

DATAMB=${1:-512}
FILENM=~/test.dat
[ -f /flash/config.txt ] && CONFIG=/flash/config.txt || CONFIG=/boot/config.txt

trap "rm -f ${FILENM}" EXIT

[ "$(whoami)" == "root" ] || { echo "Must be run as root!"; exit 1; }

HDCMD="hdparm -t --direct /dev/mmcblk0 | grep Timing"
WRCMD="rm -f ${FILENM} && sync && dd if=/dev/zero of=${FILENM} bs=1M count=${DATAMB} conv=fsync 2>&1 | grep -v records"
RDCMD="echo 3 > /proc/sys/vm/drop_caches && sync && dd if=${FILENM} of=/dev/null bs=1M 2>&1 | grep -v records"
grep OpenELEC /etc/os-release >/dev/null && DDTIME=5 || DDTIME=6

getperfmbs()
{
  local cmd="${1}" fcount="${2}" ftime="${3}" bormb="${4}"
  local result count _time perf

  result="$(eval "${cmd}")"
  count="$(echo "${result}" | awk "{print \$${fcount}}")"
  _time="$(echo "${result}" | awk "{print \$${ftime}}")"
  if [ "${bormb}" == "MB" ]; then
    perf="$(echo "${count}" "${_time}" | awk '{printf("%0.2f", $1/$2)}')"
  else
    perf="$(echo "${count}" "${_time}" | awk '{printf("%0.2f", $1/$2/1024/1024)}')"
  fi
  echo "${perf}"
  echo "${result}" >&2
}

getavgmbs()
{
  echo "${1} ${2} ${3}" | awk '{r=($1 + $2 + $3)/3.0; printf("%0.2f MB/s",r)}'
}

systemctl stop kodi 2>/dev/null
clear
sync

[ -f /sys/kernel/debug/mmc0/ios ] || mount -t debugfs none /sys/kernel/debug

overlay="$(grep -E "^dtoverlay" ${CONFIG} | grep -E "mmc|sdhost")"
clock="$(grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}')"
core_now="$(vcgencmd measure_clock core | awk -F= '{print $2/1000000}')"
core_max="$(vcgencmd get_config int | grep core_freq | awk -F= '{print $2}')"
turbo="$(vcgencmd get_config int | grep force_turbo | awk -F= '{print $2}')"
[ -n "${turbo}"    ] || turbo=0
[ ${turbo} -eq 0 ]   && turbo="$(cat /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy)"
[ -n "${core_max}" ] || core_max="${core_now}"

echo "CONFIG: ${overlay}"
echo "CLOCK : ${clock}"
echo "CORE  : ${core_max} MHz, turbo=${turbo}"
echo "DATA  : ${DATAMB} MB, ${FILENM}"
echo

echo "HDPARM:"
echo "======"
HD1="$(getperfmbs "${HDCMD}" 5 8 MB)"
HD2="$(getperfmbs "${HDCMD}" 5 8 MB)"
HD3="$(getperfmbs "${HDCMD}" 5 8 MB)"
HDA="$(getavgmbs "${HD1}" "${HD2}" "${HD3}")"

echo
echo "WRITE:"
echo "====="
WR1="$(getperfmbs "${WRCMD}" 1 ${DDTIME} B)"
WR2="$(getperfmbs "${WRCMD}" 1 ${DDTIME} B)"
WR3="$(getperfmbs "${WRCMD}" 1 ${DDTIME} B)"
WRA="$(getavgmbs "${WR1}" "${WR2}" "${WR3}")"

echo
echo "READ:"
echo "===="
RD1="$(getperfmbs "${RDCMD}" 1 ${DDTIME} B)"
RD2="$(getperfmbs "${RDCMD}" 1 ${DDTIME} B)"
RD3="$(getperfmbs "${RDCMD}" 1 ${DDTIME} B)"
RDA="$(getavgmbs "${RD1}" "${RD2}" "${RD3}")"

echo
echo "RESULT (AVG):"
echo "============"
printf "%-33s   core_freq   turbo   overclock_50    WRITE        READ        HDPARM\n" "Overlay config"
printf "%-33s      %d        %d     %11s   %10s   %10s   %10s\n" "${overlay}" "${core_max}" "${turbo}" "${clock}" "${WRA}" "${RDA}" "${HDA}"
