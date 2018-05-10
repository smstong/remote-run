#! /bin/bash -
HOSTNAME=$(hostname)
echo ""
echo "======================================================================="
echo "SERVER ${HOSTNAME}"
echo "======================================================================="

# detect CPU info
echo ""
echo "CPU"
echo "-----------------------------------------------------------------------"

cat /proc/cpuinfo | grep -E "^model name" | head -1 | tr -s ' ' | awk -F: '{printf("%-30s: %s\n","CPU model", $2)}'
cat /proc/cpuinfo | grep -E  "^physical id" | tail -1 |  awk -F: '{printf("%-30s: %d\n", "CPU Number", $2+1)}'
cat /proc/cpuinfo | grep -E "^cpu cores" | head -1 | awk -F: '{printf("%-30s: %d\n", "Cores per CPU", $2)}'
cat /proc/cpuinfo | grep -E "^siblings" | head -1 | awk -F: '{printf("%-30s: %d\n", "Threads per CPU", $2)}'

# detect memory info
echo ""
echo "MEMORY"
echo "-----------------------------------------------------------------------"

cat /proc/meminfo | grep -E '^MemTotal' | awk '{printf("%-30s: %d GB\n", "Total Memory", $2/1024/1024)}'

# detect network interfaces
echo ""
echo "NIC"
echo "-----------------------------------------------------------------------"
netstat -ia | grep -v -E "lo|docker|bond|sit|usb" | sed -ne '1,2!p' | awk \
	'{ sum += 1; print $1} END { printf("\n%-30s: %d\n", "Total NICs", sum)}'

# calculate disk info based on 'df' and 'swapon'
echo ""
echo "DISK"
echo "-----------------------------------------------------------------------"

{ /sbin/swapon -s | sed -ne '1!p'; df -PTk | sed -ne '1!p'; } | \
awk 	'BEGIN { printf("%-30s%8s%8s", "device","size(GB)","used(GB)\n")} \
$2 == "xfs" || $2=="ext3" || $2=="ext4" || $2=="acfs" || $2=="partition" { if ($2 != "acfs") {local_size += $3;} else {san_size+=$3;}\
   		printf("%-30s%8.2f%8.2f\n", $1,$3/(1024*1024),$4/(1024*1024)) } \
		END { printf("\n%-30s: %d GB, SAN size: %d GB\n", "Local Disk Space:", local_size/(1024*1024), san_size/(1024*1024))}'

