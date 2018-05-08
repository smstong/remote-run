#################################################################
#
# App: Run bash scripts on multiple remote servers
# Author: jonathan.jq.zhao@gmail.com
# Version: v0.01
#
#################################################################
#!/bin/bash -

if [ $# -ne 2 ] ; then
	echo -e "Usage: \n\t$(basename $0) file1 file2" >&2
	echo -e "Note: \n\tRun cmds in file1 on all servers listed in file2" >&2
	exit
fi
CMDFILE=$1
SERVERLIST=$2
PWDFILE=sshpwd.private
LOGFILE=err.log

if [ ! -e $PWDFILE ] ; then
	echo "$PWDFILE doesn't exist" >&2
fi

USER=$(head -1 $PWDFILE)
PWD=$(tail -1 $PWDFILE)

while read server
do
	if echo $server | grep -E '^#|^$' > /dev/null ; then
		continue	
	fi
		echo  "running $CMDFILE on $server..."
		cat $CMDFILE | sshpass -p$PWD \
			ssh -q -o StrictHostKeyChecking=no $USER@$server bash --noprofile
done < $SERVERLIST

