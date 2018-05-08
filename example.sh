UPDAYS=$(uptime | sed -ne 's/\(^.*up\)\(.*\)\(days.*$\)/\2/p')
CPU=$(cat /proc/cpuinfo | grep "^model name" | head -1 | cut -d: -f2 | tr -s ' ')
MEM=$(cat /proc/meminfo | grep "^MemTotal" | awk -F: '{print $2/1024/1024}'
)
echo "${UPDAYS} days, $CPU, ${MEM} GB"
