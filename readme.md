# run bash scripts on remote servers

# example usage

cat cmdfile
	#!/bin/bash - 
	uptime

cat serverlistfile
	192.168.0.19
	server1

remote-run example.sh example-servers 2>/dev/null
