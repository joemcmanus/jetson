#!/bin/bash
# File    : nano-fan.sh - A script to control the fan speed on jetson nanos
# Author  : Joe McManus josephmc@alumni.cmu.edu
# Version : 0.1 05/10/2021
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

#Set temp to turn fan speeds up
lowTemp=22
medTemp=30
highTemp=35

maxFanSpeed=1700

if [ `whoami` != "root" ] 
then
	echo "Sorry must be run as root, only root can control fans" 
	echo "Try sudo ./$0 " 
	exit 1
fi 

#read the temp and divide by 1000
tempRaw=`cat /sys/class/thermal/thermal_zone0/temp`
tempC=`expr $tempRaw / 1000`

if [ $tempC -lt $lowTemp ] 
then
	fanSpeed=64
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
if ! [ -z $1 ] 
then
	fanRPM=`echo "scale=2; $fanSpeed/255*$maxFanSpeed "| bc`
	echo " Temp      : $tempC" 
	echo " Fan speed : $fanRPM"
fi

