# kill de tous les process java

ps -ef | grep jview | awk '{ print $2 }' | while read pid
do
	kill -9 $pid
done

