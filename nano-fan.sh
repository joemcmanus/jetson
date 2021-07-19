#!/bin/bash
# File    : nano-fan.sh - A script to control the fan speed on jetson nanos
# Author  : Joe McManus josephmc@alumni.cmu.edu
# Version : 0.2 07/18/2021
# Copyright (C) 2021 Joe McManus

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#New Info! 
#according to https://developer.download.nvidia.com/assets/embedded/secure/jetson/Nano/docs/Jetson_Nano_Thermal_Design_Guide.pdf
#we should monitor  /sys/devices/virtual/thermal/thermal_zone1/temp
#I was initially monitoring /sys/class/thermal/thermal_zone0/temp
#in table 4.1 it sets the PWM speeds to 61, 71, 82iC for cooling,

#Set temp to turn fan speeds up
lowTemp=30
medTemp=40
highTemp=70

maxFanSpeed=1700

if [ `whoami` != "root" ] 
then
	echo "Sorry must be run as root, only root can control fans" 
	echo "Try sudo ./$0 " 
	exit 1
fi 

#read the temp and divide by 1000
tempRaw=`cat /sys/devices/virtual/thermal/thermal_zone1/temp`
tempC=`expr $tempRaw / 1000`

if [ $tempC -lt $lowTemp ] 
then
	fanSpeed=80
elif [ $tempC -lt $medTemp ] 
then
	fanSpeed=128
elif [ $tempC -lt $highTemp ]
then
	fanSpeed=196
else 
	fanSpeed=255
fi

#Here is where we actually control the fan, it is a PWM from 0-255
echo $fanSpeed > /sys/devices/pwm-fan/target_pwm

#If you add debug, or really anything after nano-fan.sh it will display this
#convert C to F 
tempF=`echo "scale=2; $tempC * 1.8 + 32" | bc`

if ! [ -z $1 ] 
then
	fanRPM=`echo "scale=2; $fanSpeed/255*$maxFanSpeed "| bc`
	echo " Temp      : $tempF" 
	echo " Fan speed : $fanRPM"
fi

