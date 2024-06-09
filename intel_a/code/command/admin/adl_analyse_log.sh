#!/bin/ksh

if [ -z "$ADL_MULTISITE_LOG_DIR" ]
then
	echo "No variable ADL_MULTISITE_LOG_DIR defined. Please run AdeleMultiSite_profile shell script before run this command"
	exit 2
fi

sort -k 3,4 -k 6,6 -k 1,1 $ADL_MULTISITE_LOG_DIR/_log_transfer | nawk 'BEGIN{ouser="";otid="";opid="";otype="";ohost=""}
{
# print $0 
	if (ouser != $3 || otid != $4 || ohost != $5 || opid != $6)
	{
		# print "---> 1"
		if (otype == "B")
		{
			print line
		}
		# print "---> 2"
		otype=$2
		ouser=$3
		otid=$4
		ohost=$5
		opid=$6
		line=$0
		# print " "otype" "ouser" "otid" "ohost" "opid
	 }
	 else if ( $2 == "E")
	 {
		# print "---> 3"
		otype=""
		ouser=""
		otid=""
		ohost=""
		opid=""
	 }
}
END{
	if (otype == "B")
	{ print line }
}' | sort 
