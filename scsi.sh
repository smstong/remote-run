#!/bin/bash

printf "%-8s%-10s%-20s%-10s\n" "DISK" "VENDOR" "host:chanel:id:lun" "SIZE(GB)"

OS=$(uname -r)

for sd in /sys/block/sd*
do
	DISK=$(basename $sd)
	cd $sd
	SIZE=$(cat size | awk '{printf("%-.2f", $1/(1024.0*1024.0))}')
	cd $sd/device
	VENDOR=$(cat vendor)
	if echo $OS | grep el5 >/dev/null; then
		SCSI=$(ls -d scsi_device:* | sed 's/scsi_device://')
	else
		SCSI=$(ls scsi_device)
	fi

	printf "%-8s%-15s%-20s%-10.2f\n" $DISK $VENDOR $SCSI $SIZE

done
