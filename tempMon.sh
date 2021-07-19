#!/bin/bash

#according to https://developer.download.nvidia.com/assets/embedded/secure/jetson/Nano/docs/Jetson_Nano_Thermal_Design_Guide.pdf 
#we should monitor  /sys/devices/virtual/thermal/thermal_zone1/temp
#I wass initially monitoring /sys/class/thermal/thermal_zone0/temp


while [ 1 -lt 2 ]
do 
	rawTemp=`cat /sys/devices/virtual/thermal/thermal_zone1/temp`
	tempF=`echo "scale=2; $rawTemp/1000 * 1.8 + 32" | bc`
	fanPWM=`cat /sys/devices/pwm-fan/target_pwm `
	fanSpeed=`echo "scale=2; $fanPWM/255 *1700" | bc`
	echo "Temp : $tempF"
	echo "Fan  : $fanSpeed"
	sleep 30
done
