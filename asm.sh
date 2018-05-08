#!/bin/bash

printf "%-30s%-10s\n" "DISK"  "SIZE(GB)"

for asm in /sys/block/asm*
do
	DISK=$(basename $asm)
	cd $asm
	SIZE=$(cat size | awk '{printf("%-.2f", $1/(1024.0*1024.0))}')
	#cd $asm/device
	#VENDOR=$(cat vendor)
	#SCSI=$(ls -d scsi_device:* | sed 's/scsi_device://')

	printf "%-30s%-10.2f\n" $DISK $SIZE

done 2>/dev/null
