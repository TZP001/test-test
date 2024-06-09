processlist=$*

# conditionnal killit CATIAServerManager
if [ "$ReplayKillCATIAServerManager" != "" ]; then
	export IT_USE_CONFIG_FILE=yes
	killit CATIAServerManager
fi

# kill -9
for processname in $processlist
do
	echo "## process name : $processname"
	pid=`ps -ef | grep $processname | egrep -vi "cmd|grep" | grep -vi TAKillListOfProcess | awk '{ print $2 }'`
	if [ -n "$pid" ]; then
 		echo "kill -9 $pid"
		kill -9 "$pid"
		sleep 15
	else
		echo "Process $processname is not running"
	fi
done
