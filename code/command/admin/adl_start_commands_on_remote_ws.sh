#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName -tid TransferId -rhost RemoteHost -rl RemoteAdeleLevel -rp RemoteAdeleProfile -rw RemoteWs [-rimage image] [-rtree tree] -rb RemoteBase [-rproj Project] -rmaint -ltd TraceDir
   [-r_photo] [-r_collect] [-r_sync] [-r_publish] [-r_promote] [-ru username]

-tid TransferId         : Id of the transfer (example: ENO, DSA, DSP, ...
-rhost RemoteHost       : Remote host name (example: centaur.deneb.com)
-rl RemoteAdeleLevel    : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp RemoteAdeleProfile  : Path of the Adele profile to find adele installation
-rw RemoteWs            : Remote workspace name
-rimage image           : Image name of remote workspace (For Adele V5 purpose only)
-rtree tree             : Tree on remote workspace (For Adele V5 purpose only)
-rb RemoteBase          : Remote base (Mandatory in Adele V3, ignored in Adele V5)
-rproj RemoteProject    : Project in Remote base (For Adele V3 test purpose only)
-rmaint MaintenanceMode : Maintenance mode is activated on remote base
-ru username            : remote user login name

-r_photo                : To check-in all files and freeze the workspace
-r_collect              : To collect remote workspace
-r_sync                 : To synchronize remote workspace
-r_publish              : To publish remote workspace
-r_promote              : To publish and promote remote workspace
-r_lock_req             : To lock promotion request in remote workspace
-r_unlock_req           : To unlock promotion request in remote workspace
-ltd TraceDir           : The local trace directory
"
# =====================================================================

OS=$(uname -s)
case $OS in
	AIX)					
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		RSH="/usr/bin/rsh"
		;;
	HP-UX)
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		RSH="/bin/remsh"
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		RSH="/usr/bsd/rsh"
		;;
	SunOS)
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
		RSH="/bin/rsh"
		;;
esac


# =====================================================================
# Out function
# =====================================================================
Out()
{
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	if [ $# -ge 2 ]
	then
		shift
		echo "$*"
	fi
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM
# =====================================================================
# Options treatment
# =====================================================================
typeset -L1 OneChar
CheckOptArg()
{
	# Usage : CheckOptArg opt arg
	OneChar="$2"
	if [ "$2" = "" -o "$OneChar" = "-" ]
	then
		Out 3 "Option $1: one argument is required"
	fi
}

_R_USER=$($WHOAMI)
unset _TID
unset _R_HOST
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_WS
unset _R_IMAGE
unset _R_WS_TREE
unset _R_BASE
unset _R_PROJECT
unset _R_MAINT
unset _R_PHOTO
unset _R_COLLECT
unset _R_SYNC
unset _R_PUBLISH
unset _R_PROMOTE
unset _R_LOCK_REQ
unset _R_UNLOCK_REQ
unset _ADL_TRACE_DIR

while [ $# -ge 1 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
				;;
		-tid ) #-------------------> TRANSFER ID
			CheckOptArg "$1" "$2"
			_TID=$2
			shift 2
				;;
		-rhost ) #-------------------> REMOTE NODE
			CheckOptArg "$1" "$2"
			_R_HOST=$2
			shift 2
				;;
		-rl ) #-------------------> REMOTE ADELE LEVEL
			CheckOptArg "$1" "$2"
			_R_ADL_VERSION=$2
		[ $_R_ADL_VERSION != "3" ] && [ $_R_ADL_VERSION != "5" ] && Out 3 "Unknown remote Adele level: $_R_ADL_VERSION"
			shift 2
				;;
		-rp ) #-------------------> REMOTE ADELE PROFILE
			CheckOptArg "$1" "$2"
			_R_ADL_PROFILE=$2
			shift 2
				;;
		-rw ) #-------------------> REMOTE WORKSPACE
			CheckOptArg "$1" "$2"
			_R_WS=$2
			shift 2
				;;
		-rimage ) #-------------------> REMOTE IMAGE (OPTIONAL)
			CheckOptArg "$1" "$2"
			_R_IMAGE=$2
			shift 2
				;;
		-rtree ) #-------------------> REMOTE TREE (OPTIONAL)
			CheckOptArg "$1" "$2"
			_R_WS_TREE=$2
			shift 2
				;;
		-rb ) #-------------------> REMOTE BASE
			CheckOptArg "$1" "$2"
			_R_BASE=$2
			shift 2
				;;
		-rproj ) #-------------------> PROJECT IN REMOTE BASE
			CheckOptArg "$1" "$2"
			_R_PROJECT=$2
			shift 2
				;;
		-rmaint ) #-------------------> OPTIONAL: maintenance mode
			_R_MAINT=" -pu -down "
			shift
				;;
		-r_photo ) #-----------> OPTIONAL: REMOTE PHOTO
			_R_PHOTO="TRUE"
			shift
				;;
		-r_collect ) #-----------> OPTIONAL: REMOTE COLLECT
			_R_PHOTO="TRUE"
			_R_COLLECT="TRUE"
			shift
				;;
		-r_sync ) #--------------> OPTIONAL: REMOTE SYNCHRONIZATION
			_R_PHOTO="TRUE"
			_R_SYNC="TRUE"
			shift
				;;
		-r_publish ) #-----------> OPTIONAL: REMOTE PUBLISH
			_R_PHOTO="TRUE"
			_R_PUBLISH="TRUE"
			shift
				;;
		-r_promote ) #-----------> OPTIONAL: REMOTE PROMOTE
			_R_PHOTO="TRUE"
			_R_PROMOTE="TRUE"
			shift
				;;
		-r_lock_req ) #-----------> OPTIONAL: REMOTE LOCK PROMOTION REQUEST
			_R_LOCK_REQ="TRUE"
			shift
				;;
		-r_unlock_req ) #-----------> OPTIONAL: REMOTE UNLOCK PROMOTION REQUEST
			_R_UNLOCK_REQ="TRUE"
			shift
				;;
		-ltd ) #-------------------> LOCAL TRACE DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_TRACE_DIR=$2
			shift 2
				;;
		-ru ) #-------------------> REMOTE USER NAME
			CheckOptArg "$1" "$2"
			_R_USER=$2
			shift 2
				;;

		 * ) echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

if [ -z "$_R_HOST" -o -z "$_R_WS" -o -z "$_R_ADL_VERSION" -o -z "$_R_ADL_PROFILE" ] 
then
	echo "$ShellName: Missing mandatory parameter." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter (base on an Adele V3 site and tck on an Adele V5 site)." 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_R_PROJECT" ] && [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter when you require Project in Adele V3 site." 1>&2
	Out 3 "$Usage"
fi

base=$_R_BASE
if [ ! -z "$_R_PROJECT" ]
then
	base=$_R_PROJECT
fi

if [ -z "$_TID" ]
then
	echo "$ShellName: The transfer id parameter is required to identify uniquely a data transfer."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_TRACE_DIR" ]
then
	echo "$ShellName: Local trace directory is required."
	Out 3 "$Usage"
fi
# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)

TraceFile=0trace_${ShellName}_${_TID}
if [ ! -d "$_ADL_TRACE_DIR" ]
then
	mkdir -p $_ADL_TRACE_DIR
fi
TraceFile=$_ADL_TRACE_DIR/$TraceFile
touch $TraceFile
rc=$?
if [ $rc -ne 0 ]
then
	Out 3 "Unable to create the trace file $TraceFile"
fi

if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	echo "____________________________________________________________"
	echo "$CurrentDate : Adele V3 flow commands on workspace $_R_WS at $_R_HOST "
	$RSH $_R_HOST -l $_R_USER \
	'
		Out()
		{
			trap " " HUP INT QUIT TERM
			ExitCode=$1
			if [ $# -ge 2 ]
			then
				shift
				echo "!!! KO : $*"
			fi
			exit $ExitCode
		}

		WriteDotFrequently()
		{
    		Frequency=10
		    if [ $# -ge 1 ]
		    then
		        Frequency=$1
		    fi

		    while true
		    do
		        sleep $Frequency
		        printf "%s" "."
		    done
		}

        Try_adl()
        {
			WriteDotFrequently 1 1>&2 &
			PID=$!
            #
            # Gestion des conflits d acces en Adele V3
            #
            compteur=0
            rc=207
            while [ $rc -eq 207 -a $compteur -lt 10 ]
            do
                "$@" </dev/null
                rc=$?
                compteur=`expr $compteur + 1`
            done
			kill $PID
            return $rc
        }

		echo "\n>>> adl_ch_ws"
		
		. '$_R_ADL_PROFILE' </dev/null

		CHLEV_OPT='$_R_BASE'
		[ ! -z "'$_R_PROJECT'" ] && CHLEV_OPT='$_R_PROJECT'" -r "'$_R_BASE'
		Try_adl chlev $CHLEV_OPT </dev/null
		rc_chlev=$?
		rc_chbase=0
		if [ $rc_chlev -ne 0 ]
		then
			 Try_adl adl_ch_base $CHLEV_OPT </dev/null
			 rc_chbase=$?
		fi
		if [ $rc_chlev -ne 0 -a $rc_chbase -ne 0 ]
		then
			Out 3 "chlev $rc_chlev AND adl_ch_base $rc_chbase"
		fi

		mdopt -nbf -necho </dev/null

		Try_adl adl_ch_ws '$_R_WS' </dev/null
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "adl_ch_ws $rc"
		fi
		unset ADL_W_BASE
		
		type_de_ws=$(lsa "WS>$ADL_W_IDENT" -a !realtype -n)
		if [ $rc -ne 0 ]
		then
			Out 3 "Cannot get workspace type: $rc"
		fi

		if [ ! -z "'$_R_PHOTO'" ]
		then
			echo "\n>>> adl_photo"
			Try_adl adl_photo '$_R_MAINT' </dev/null
			rc=$?
			if [ $rc -ne 0 -a $rc -ne 2 ]
			then
				Out 3 "adl_photo $rc"
			fi
		fi

		if [ ! -z "'$_R_COLLECT'" ]
		then
			if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "bsf" ]
			then
				echo "\n>>> adl_collect"
				Try_adl adl_collect '$_R_MAINT' </dev/null
				rc=$?
				if [ $rc -ne 0 -a $rc -ne 2 ]
				then
					Out 3 "adl_collect $rc"
				fi
			fi
		fi

		if [ ! -z "'$_R_SYNC'" ]
		then
			if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "dev" ]
			then
				echo "\n>>> adl_sync"
				export ADL_BATCH=true
				Try_adl adl_sync </dev/null
				rc=$?
				if [ $rc -ne 0 -a $rc -ne 2 ]
				then
					Out 3 "adl_sync $rc"
				fi
			fi
		fi

		if [ ! -z "'$_R_UNLOCK_REQ'" ]
		then
			echo "\n>>> adl_unlock_req"
			Try_adl adl_unlock_req </dev/null
			rc=$?
			if [ $rc -ne 0 -a $rc -ne 2 ]
			then
				Out 3 "adl_unlock_req $rc"
			fi
		fi

		if [ ! -z "'$_R_PUBLISH'" ] || [ ! -z "'$_R_PROMOTE'" ]
		then
			if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "bsf" ]
			then
				echo "\n>>> adl_publish"
				Try_adl adl_publish </dev/null
				rc=$?
				if [ $rc -ne 0 -a $rc -ne 2 ]
				then
					Out 3 "adl_publish $rc"
				fi
			fi
		fi

		if [ ! -z "'$_R_PROMOTE'" ]
		then
			if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "dev" ]
			then
				echo "\n>>> adl_promote"
				Try_adl adl_promote '$_R_MAINT' </dev/null
				rc=$?
				if [ $rc -ne 0 -a $rc -ne 2 ]
				then
					Out 3 "adl_promote $rc"
				fi
			fi
		fi

		if [ ! -z "'$_R_LOCK_REQ'" ]
		then
			echo "\n>>> adl_lock_req"
			Try_adl adl_lock_req </dev/null
			rc=$?
			if [ $rc -ne 0 -a $rc -ne 5 ]
			then
				Out 3 "adl_lock_req $rc"
			fi
		fi

	' </dev/null 2>&1 >>$TraceFile

elif [ $_R_ADL_VERSION = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	echo "____________________________________________________________"
	echo "$CurrentDate : Adele V5 flow commands on workspace $_R_WS at $_R_HOST "
	$RSH $_R_HOST -l $_R_USER \
	'
		Out()
		{
			trap " " HUP INT QUIT TERM
			ExitCode=$1
			if [ $# -ge 2 ]
			then
				shift
				echo "!!! KO : $*"
			fi
			exit $ExitCode
		}

		WriteDotFrequently()
		{
    		Frequency=10
		    if [ $# -ge 1 ]
		    then
		        Frequency=$1
		    fi

		    while true
		    do
		        sleep $Frequency
		        printf "%s" "."
		    done
		}

        RunCmd()
        {
			WriteDotFrequently 1 1>&2 &
			PID=$!
            "$@" </dev/null
            rc=$?
			kill $PID
            return $rc
        }
		echo "\n>>> adl_ch_ws"
		
		. '$_R_ADL_PROFILE' </dev/null

		OPTIONS='$_R_BASE'
		RunCmd tck_profile $OPTIONS </dev/null
		rc_tck=$?
		if [ $rc_tck -ne 0 ]
		then
			Out 3 "tck_profile $OPTIONS - $rc_tck"
		fi

		OPTIONS='$_R_WS'
		[ ! -z "'$_R_IMAGE'" ] && OPTIONS="$OPTIONS -image '$_R_IMAGE'"
		RunCmd adl_ch_ws $OPTIONS </dev/null
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "adl_ch_ws $OPTIONS - $rc"
		fi
		
	    if [ ! -z "'$_R_WS_TREE'" ]
	   	then
	        OPTION_WS_TREE=" -tree '$_R_WS_TREE'"
	    else
	        OPTION_WS_TREE=""
	    fi

		if [ ! -z "'$_R_PHOTO'" ]
		then
			Cmd="adl_photo $OPTION_WS_TREE"
			echo "\n>>> $Cmd"
			RunCmd $Cmd </dev/null
			rc=$?
			[ $rc -ne 0 ] && Out 3 "adl_photo KO - $rc"
		fi

		if [ ! -z "'$_R_COLLECT'" ]
		then
       		Cmd="adl_collect $OPTION_WS_TREE"
        	echo "\n>>> $Cmd"
        	RunCmd $Cmd </dev/null
        	rc=$?
        	[ $rc -ne 0 ] && Out 3 "adl_collect KO - $rc"
		fi

		if [ ! -z "'$_R_SYNC'" ]
		then
       		Cmd="adl_sync -no_manual_merge $OPTION_WS_TREE"
        	echo "\n>>> $Cmd"
			export ADL_BATCH=true
        	RunCmd $Cmd </dev/null
        	rc=$?
        	[ $rc -ne 0 ] && Out 3 "adl_sync KO - $rc"
		fi

		if [ ! -z "'$_R_UNLOCK_REQ'" ]
		then
       		Cmd="adl_unlock_req $OPTION_WS_TREE"
        	echo "\n>>> $Cmd"
        	RunCmd $Cmd </dev/null
        	rc=$?
        	if [ $rc -ne 0 ]
		then
			# on reessaye sans -tree
			Cmd="adl_unlock_req"
			echo "\n>>> $Cmd"
			RunCmd $Cmd </dev/null
	            	rc=$?
			[ $rc -ne 0 ] && Out 3 "adl_unlock_req KO - $rc"
		fi
		fi

		if [ ! -z "'$_R_PUBLISH'" ] || [ ! -z "'$_R_PROMOTE'" ]
		then
       		Cmd="adl_publish $OPTION_WS_TREE"
        	echo "\n>>> $Cmd"
        	RunCmd $Cmd </dev/null
        	rc=$?
        	[ $rc -ne 0 ] && Out 3 "adl_publish KO - $rc"
		fi

		if [ ! -z "'$_R_PROMOTE'" ]
		then
       		Cmd="adl_promote -adm_no_check_caa_rules $OPTION_WS_TREE"
        	echo "\n>>> $Cmd"
        	RunCmd $Cmd </dev/null
        	rc=$?
        	[ $rc -ne 0 ] && Out 3 "adl_promote KO - $rc"
		fi

		if [ ! -z "'$_R_LOCK_REQ'" ]
		then
       		Cmd="adl_lock_req $OPTION_WS_TREE"
        	echo "\n>>> $Cmd"
        	RunCmd $Cmd </dev/null
        	rc=$?
        	if [ $rc -ne 0 ]
		then
			# on reessaye sans -tree
			Cmd="adl_lock_req"
			echo "\n>>> $Cmd"
			RunCmd $Cmd </dev/null
	            	rc=$?
			[ $rc -ne 0 ] && Out 3 "adl_lock_req KO - $rc"
		fi
		fi
	' </dev/null 2>&1 >>$TraceFile

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown _R_ADL_VERSION in $ShellName: $_R_ADL_VERSION"
fi

grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
if [ $rc -eq 0 ]
then
	Out 3 "Consult traces in: $TraceFile"
fi

cat $TraceFile
Out 0
