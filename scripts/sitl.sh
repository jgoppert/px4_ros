#!/bin/bash

set -e
set -x

rc_script=$1
model=$2
data_path=$3
program="gazebo"

echo PX4 ARGS
echo rc_script: $rc_script
echo model: $model
echo data_path: $data_path


mkdir -p $data_path
mkdir -p $data_path/rootfs/fs/microsd
mkdir -p $data_path/rootfs/eeprom
touch $data_path/rootfs/eeprom/parameters


if [ "$chroot" == "1" ]
then
	chroot_enabled=-c
	sudo_enabled=sudo
else
	chroot_enabled=""
	sudo_enabled=""
fi

if [ "$model" == "" ] || [ "$model" == "none" ]
then
	echo "empty model, setting iris as default"
	model="iris"
fi

if [ "$#" -lt 3 ]
then
	echo usage: $0 rc_script model data_path
	echo ""
	exit 1
fi

# Do not exit on failure now from here on because we want the complete cleanup
set +e
cd $data_path && $sudo_enabled px4 $chroot_enabled ${rc_script}_${program}_${model}
