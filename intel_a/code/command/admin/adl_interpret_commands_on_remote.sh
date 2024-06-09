#!/bin/ksh

FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName -tid TransferId -rhost RemoteHost -rl RemoteAdeleLevel -rp RemoteAdeleProfile -rw RemoteWs -rwd RemoteWorkingDir [-rimage RemoteWsImage] -rb RemoteBase [-rproj RemoteProject] -f FileList -rtmp RemoteTmp [-ru username] -ltmp LocalTmpWs -lwd WorkingDir -ltd TraceDir -c CommandFileName -v CommandsVersion -r RecoveryFileName [-simul] [-verbose]

-tid TransferId       : Id of the transfer (example: ENO, DSA, DSP, ...)
-rhost RemoteHost     : Remote host name (example: centaur.deneb.com)
-rl RemoteAdeleLevel  : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp RemoteAdeleProfile: Path of the Adele profile to find adele installation
-rw RemoteWs          : Remote workspace name
-rb RemoteBase        : Remote base (for chlev in Adele V3, for tck_profile in Adele V5)
-rimage RemoteWsImage : Remote workspace image name (For Adele V5 purpose only)
-rproj RemoteProject  : Project in Remote base (For Adele V3 test purpose only)
-f Filelist           : File list path on local site
-ltmp LocalTmp        : The local temporary directory to store compressed data to transfer
-rtmp RemoteTmpWs     : The remote temporary directory to store transfered data
-ru username          : The remote user name
-lwd WorkingDir       : The local working directory
-ltd TraceDir         : The local trace directory
-c CommandFileName    : command file to transfer on remote site
-v                    : Version of Adele commands to generate
-r                    : Name of the recovery file indicating the operation is under way
-simul                : Commands are displayed
-verbose : Execution traces will be also displayed on standard output.
PURPOSE: same as adl_interpret_commands.sh but launched from local site
and performed on remote site.

IMPORTANT: assume the current workspace is the local report workspace
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

	rm -fr /tmp/*_$$ /tmp/*_$$.Z
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM

# =====================================================================
# try_rcp function
# =====================================================================
try_rcp()
{
	nbtry=1
	while [ $nbtry -lt 3 ]
	do
		rcp $1 $2
		rtcode=$?
		[ $rtcode -eq 0 ] && break
		nbtry=$(expr $nbtry + 1)
	done
	return $rtcode
}

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

unset CommandFileName
unset Simulation
unset Verbose

unset _TID

unset _R_HOST
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_WS
unset _R_BASE
unset _R_IMAGE
unset _R_PROJECT
unset _R_TMP
unset _L_TMP
unset _ADL_LOCAL_WORKING_DIR
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
		-rimage ) #-------------------> REMOTE WORKSPACE IMAGE
			CheckOptArg "$1" "$2"
			_R_IMAGE=$2
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
		-rwd ) #-------------------> REMOTE WORKING DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_REMOTE_WORKING_DIR=$2
			shift 2
				;;

		-rtmp ) #-------------------> REMOTE TEMPORARY DIRECTORY
			CheckOptArg "$1" "$2"
			_R_TMP=$2
			shift 2
				;;
		-ru ) #-------------------> REMOTE USER NAME
			CheckOptArg "$1" "$2"
			_R_USER=$2
			shift 2
				;;
		-ltmp ) #-------------------> LOCAL REMOTE TEMPORARY DIRECTORY
			CheckOptArg "$1" "$2"
			_L_TMP=$2
			shift 2
				;;
		-lwd ) #-------------------> LOCAL WORKING DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_LOCAL_WORKING_DIR=$2
			shift 2
				;;

		-ltd ) #-------------------> LOCAL TRACE DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_TRACE_DIR=$2
			shift 2
				;;
		-c ) #-------------------> MANDATORY: COMMANDS FILE NAME
			CheckOptArg "$1" "$2"
			CommandFileName=$2
			shift 2
				;;

		-v ) #-------------------> MANDATORY: COMMAND VERSION
			CheckOptArg "$1" "$2"
			RemoteCommandVersion=$2
			shift 2
			;;

		-r ) #-------------------> MANDATORY: RECOVERY FILE NAME
			CheckOptArg "$1" "$2"
			RemoteRecoveryFileName=$2
			shift 2
			;;

		-simul ) #---------------> OPTIONAL : SIMULATION MODE
			Simulation="-simul"
			shift
			;;

		-verbose ) #-------------> OPTIONAL : TRACE ACTIVATION
			Verbose="-verbose"
			shift
			;;

		 * ) echo "Unknown option: $1" 1>&2
		Out 3 "$Usage"
		;;
	esac
done

[ ! -f $ShellDir/adl_interpret_commands.sh ] && Out 3 "Cannot find adl_interpret_commands.sh program"

if [ -z "$_R_HOST" -o -z "$_R_WS" -o -z "$_R_ADL_VERSION" -o -z "$_R_ADL_PROFILE" ] 
then
	echo "$ShellName: Missing mandatory parameter." 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_R_PROJECT" ] && [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter when you require Project in Adele V3 site." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter." 1>&2
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

if [ -z "$_R_TMP" ]
then
	echo "$ShellName: Remote temporary directory is required."
	Out 3 "$Usage"
fi
if [ -z "$_L_TMP" ]
then
	echo "$ShellName: Local temporary directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_LOCAL_WORKING_DIR" ]
then
	echo "$ShellName: Local working directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_TRACE_DIR" ]
then
	echo "$ShellName: Local trace directory is required."
	Out 3 "$Usage"
fi

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

# partie de shell pour les rsh regroupant les fonctions communes
rsh_functions='

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
			RSH="/usr/bin/rsh"
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

	Out()
	{
		trap " " HUP INT QUIT TERM
		ExitCode=$1
		if [ $# -ge 2 ]
		then
			shift
			echo "!!! KO : $*"
		fi

		rm -fr /tmp/*_$$ /tmp/*_$$.Z
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

	'

# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate : Copy command file from local to remote site"
	
if [ ! -s "$CommandFileName" ]
then
	Out 0 "There is no command to execute on remote site"
fi


#
# On a besoin de calculer le repertoire courant de travail sur le site distant
#

if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Remote Adele version 3
	# ----------------------------------------------------------------------
	rsh_adl_environment='
		Try_adl()
		{
			#
			# Gestion des conflits d acces en Adele V3
			#
			compteur=0
			rc=207
			while [ $rc -eq 207 -a $compteur -lt 10 ]
			do
				RunCmd "$@" </dev/null
				rc=$?
				compteur=`expr $compteur + 1`
			done
			return $rc
		}

		echo "\n>>> adl_ch_ws $_R_WS"

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
		export _ADL_REMOTE_WORKING_DIR=$ADL_W_DIR/.Adele/MultiSite/'$_TID'
		print "\n_ADL_REMOTE_WORKING_DIR=$_ADL_REMOTE_WORKING_DIR"

		if [ ! -d $_ADL_REMOTE_WORKING_DIR ]
		then
			mkdir -p $_ADL_REMOTE_WORKING_DIR
			rc=$?
			if [ $rc -ne 0 ]
			then
				Out 3 "mkdir $_ADL_REMOTE_WORKING_DIR $rc"
			fi
		fi
		'
else
	# ----------------------------------------------------------------------
	# Remote Adele version 5
	# ----------------------------------------------------------------------
	rsh_adl_environment='

		echo "\n>>> adl_ch_ws"

		. '$_R_ADL_PROFILE' </dev/null
	
		OPTIONS='$_R_BASE'	
		RunCmd tck_profile $OPTIONS </dev/null
		rc_tck=$?
		if [ $rc_tck -ne 0 ]
		then
			Out 3 "tck_profile $rc_tck"
		fi

		OPTIONS='$_R_WS'
		[ ! -z "'$_R_IMAGE'" ] && OPTIONS="${OPTIONS} -image "'$_R_IMAGE'
		RunCmd adl_ch_ws $OPTIONS </dev/null
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "adl_ch_ws $OPTIONS $rc"
		fi

		export _ADL_REMOTE_WORKING_DIR=$ADL_IMAGE_DIR/ToolsData/MultiSite/'$_TID'
		print "\n_ADL_REMOTE_WORKING_DIR=$_ADL_REMOTE_WORKING_DIR"

		if [ ! -d $_ADL_REMOTE_WORKING_DIR ]
		then
			mkdir -p $_ADL_REMOTE_WORKING_DIR
			rc=$?
			if [ $rc -ne 0 ]
			then
				Out 3 "mkdir $_ADL_REMOTE_WORKING_DIR $rc"
			fi
		fi

		'
fi

rsh_program="$rsh_functions $rsh_adl_environment"

$RSH $_R_HOST -l $_R_USER "$rsh_program" </dev/null 2>&1 >$TraceFile

# On verifie que le rsh s'est bien passe
grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
cat $TraceFile
if [ $rc -eq 0 ]
then
	Out 3 "\nRsh for computing _ADL_REMOTE_WORKING_DIR is KO. Traces on local site in: $TraceFile"
fi
# On recupere le path vers le repertoire temporaire sur le site distant
export _ADL_REMOTE_WORKING_DIR=$(grep '_ADL_REMOTE_WORKING_DIR=' $TraceFile | $_AWK -F= '{print $2}')

# =====================================================================
# Transfert de la liste des commandes a executer sur le site distant
# =====================================================================

RemoteCommandFileName=$_ADL_REMOTE_WORKING_DIR/0RemoteCommandFile_${_TID}_$$.Z
try_rcp $CommandFileName ${_R_USER}@$_R_HOST:$RemoteCommandFileName
rc=$?
if [ $rc -ne 0 ]
then
	Out 3 "\nCannot transfer the command file with command: rcp $CommandFileName $_R_HOST:$RemoteCommandFileName"
fi

# =====================================================================
# Transfert des programmes necessaires a l'interpretation des commandes
# sur le site distant
# =====================================================================

try_rcp $ShellDir/adl_interpret_commands.sh ${_R_USER}@$_R_HOST:$_ADL_REMOTE_WORKING_DIR/adl_interpret_commands.sh
rc=$?
if [ $rc -ne 0 ]
then
	Out 3 "\nCannot transfer the adl_interpret tool with command: rcp $ShellDir/adl_interpret_commands.sh $_R_HOST:$_ADL_REMOTE_WORKING_DIR/adl_interpret_commands.sh"
fi

try_rcp $ShellDir/adl_get_current_date.sh ${_R_USER}@$_R_HOST:$_ADL_REMOTE_WORKING_DIR/adl_get_current_date.sh
rc=$?
if [ $rc -ne 0 ]
then
	Out 3 "\nCommand failed: rcp $ShellDir/adl_get_current_date.sh $_R_HOST:$_ADL_REMOTE_WORKING_DIR/adl_get_current_date.sh"
fi

# =====================================================================
# On execute a distance le programme d'interpretation des commandes
# =====================================================================
touch $RemoteRecoveryFileName
rsh_program="$rsh_functions $rsh_adl_environment"'

	cd '$_ADL_REMOTE_WORKING_DIR'
	chmod 777 adl_interpret_commands.sh
	chmod 777 adl_get_current_date.sh

	RunCmd '$_ADL_REMOTE_WORKING_DIR'/adl_interpret_commands.sh -c '$RemoteCommandFileName' -v '$RemoteCommandVersion' -r '$_ADL_REMOTE_WORKING_DIR'/0RecoveryCommands -t '$_R_TMP'/0trace_adl_interpret_commands.recovery'_${_TID}' '$Simulation' '$Verbose'
	rc=$?

	if [ $rc -ne 0 ] 
	then
		Out 3 "Remote execution of adl_interpret_commands.sh is KO"
	fi
	echo "All Adele commands have been executed successfully"

	echo "\n>>> Checking-in all files in database"
	RunCmd adl_photo </dev/null

	if [ $rc -ne 0 ] 
	then
		Out 3 "Check-in is KO"
	fi

	rm -f '$_ADL_REMOTE_WORKING_DIR'/adl_interpret_commands.sh
	rm -f '$_ADL_REMOTE_WORKING_DIR'/adl_get_current_date.sh
'

$RSH $_R_HOST -l $_R_USER "$rsh_program" </dev/null 2>&1 >$TraceFile

# On verifie que le rsh c'est bien passe
grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
cat $TraceFile
if [ $rc -eq 0 ]
then
	Out 3 "\nRsh for executing commands on remote site is KO. Traces on local site in: $TraceFile"
fi

# Tout est termine, on peut effacer le fichier indiquant que l'operation etait en cours
rm -f $RemoteRecoveryFileName

Out 0
