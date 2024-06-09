#!/bin/ksh
[ ! -z "$ADL_DEBUG" ] && set -x

FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

CmdLine="$@"
# =====================================================================
Usage="$ShellName -tid TransferId [-mail [addr...]] [-http HttpServer] [-simul] [-trace_adl_cmd]
		[-keep_trace n] -rhost RemoteHost 
		[-rsite SiteName] -rl AdeleLevel -rp AdeleProfile -rb Base [-rproj Project] -rw Ws [-rimage image] [-rtree ws_tree] -rtmp TmpDir -rmaint
        [-fw Fw... | -lfw Filename]
        [-lsite SiteName] -ll AdeleLevel -lp AdeleProfile -lb Base [-lproj Project] -lw Ws [-limage image] [-ltree ws_tree] -ltmp TmpDir 
        [-r_collect] [-r_sync] [-r_publish] [-r_promote] 
		[-l_collect WSi ... ] [-l_sync]
        [-l_publish] [-l_promote WSi ... ] [-l_cr CRi ... ]
		[-no_update_cr]
		[-keep_trace n]

Golbal parameters:
-tid TransferId  : TransferId (example: ENO, DSA, DSP, ...
-mail [addr...]  : Results will be sent by mail to specified addresses; if no address is specified, the mail will be sent to people declared in \$MAIL_ADDR_LIST list
     (example: export MAIL_ADDR_LIST=\"ygd@soleil apa@soleil\")
-http HttpServer : Address of the http server which be able to display generated HTML page
             (example: http://herrero:8016)
-simul           : To simulate the data transfer. Adele command will be displayed but won't be launched
-trace_adl_cmd   : To display Adele command traces on terminal
-keep_trace n    : Number of trace directories to keep ; the trace directories are created into the wlocal workspace directory ws_dir
    Adele V3: <ws_dir>/.Adele/MultiSite/<TransferId>/Tracexxx
    Adele V5: <ws_dir>/ToolsData/MultiSite/<TransferId>/Tracexxx

REMOTE parameters of the data transfer:
-rhost RemoteHost: Remote host name (example: centaur.deneb.com)
-rsite SiteName  : Name of the remote site (If Adele V5, this name must the same name as returned by adl_ls_site command)
-rl AdeleLevel   : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp AdeleProfile : Path of the Adele profile to find adele installation
-rb Base         : Base in Adele V3, tck in Adele V5
-rw Ws           : Workspace name
-rimage image    : Image name (For Adele V5 purpose only)
-rtree ws_tree   : Workspace tree in case of multitree ws (optional for Adele V5 workspace)
-rproj Project   : Project in base (For Adele V3 test purpose only)
-rmaint          : Maintenance mode is activated on base
-rtmp TmpDir     : Temporary directory to store file to be copied

-fw Fw...        : Frameworks to consider
-lfw Filename    : Filename containing a list of Frameworks to consider (one framework name per line)
	 (if neither -fw option, nor -lfw option precised, all frameworks are considered)

-r_photo         : To check-in all files and freeze the remote workspace BEFORE the transfer
-r_collect       : To collect remote workspace
-r_sync          : To synchronize remote workspace
-r_publish       : To publish remote workspace
-r_promote       : To publish and promote remote workspace

LOCAL parameters of the data transfer:
-rsite SiteName  : Name of the local site (If Adele V5, this name must the same name as returned by adl_ls_site command)
-ll AdeleLevel   : Level of local Adele tool ('3' for Adele V3 and '5' for Adele V5)
-lp AdeleProfile : Path of the Adele profile to find adele installation
-lb Base         : Base in Adele V3, tck in Adele V5
-lw Ws           : Workspace name
-limage image    : Image name (For Adele V5 purpose only)
-ltree ws_tree   : Workspace tree for the new frameworks (mandatory for Adele V5 workspace)
-lproj Project   : Project in base (For Adele V3 test purpose only)
-C               : Maintenance mode is activated on base
-ltmp TmpDir     : Temporary directory to store file to be copied

-l_collect WSi ... : To run adl_collect into the local workspace BEFORE the transfer for all promoted workspace or only for the specified ones
-l_sync          : To synchronize the local workspace BEFORE the transfer
   This option is recommended in order to avoid merges.

-l_publish       : To publish local workspace AFTER the transfer
-l_promote WSi...: To publish and promote local workspace to the parent workspace in Adele V3 or to the specified workspace(s) in Adele V5
-l_cr CRi...     : To precise change request number list with local workspace promotion
-no_update_cr    : To disconnect update change request phase
"
# =====================================================================
export _L_HOST=$(uname -n)

export DISPLAY=""

OS=$(uname -s)
case $OS in
	AIX)					
		OS_LOCAL=aix410
		OS_INST=aix_a
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		RSH="/usr/bin/rsh"
		;;
	HP-UX)
		OS_LOCAL=hp1020ansi
		OS_INST=hpux_a
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		RSH="/bin/remsh"
		;;
	IRIX | IRIX64)
		OS_LOCAL=irix53
		OS_INST=irix_a
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		RSH="/usr/bsd/rsh"
		;;
	SunOS)
		OS_LOCAL=sun53
		OS_INST=solaris_a
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
		RSH="/bin/rsh"
		;;
esac

ShellVersion=${shellName}"("$(ls -lL $FullShellName | $_AWK '{print $6" "$7" "$8}')")"
# Global variable initialization
export TempTraceDir
export _ADL_WORKING_DIR
export _ADL_TRACE_DIR
typeset -i SyncExitCode
SyncExitCode=0
export SyncExitCode

# =====================================================================
# Out function
# =====================================================================
Out()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	shift
	if [ $# -ge 1 ]
	then
		echo "KO: $*"
	fi

	EndTransferDate=$($ShellDir/adl_get_current_date.sh)
	echo "
____________________________________________________________
End of the transfer: $EndTransferDate
END_${_L_BASE}_${_L_WS_TREE}"

	if [ ! -z "$_ADL_WORKING_DIR" ] && [ -d "$_ADL_WORKING_DIR" ]
	then
		# On recopie les fichiers de _ADL_WORKING_DIR dans _ADL_TRACE_DIR
		ls -l $_ADL_WORKING_DIR | grep -v '^total' | grep -v '^d' | $_AWK '{print $NF}' > /tmp/TraceFilelist_$$
		while read fic
		do
			cp -p $_ADL_WORKING_DIR/$fic $_ADL_TRACE_DIR/$fic 2>/dev/null
		done < /tmp/TraceFilelist_$$
	fi

	# On recopie les fichiers de $TempTraceDir dans _ADL_TRACE_DIR
	if [ ! -z "$TempTraceDir" ] && [ -d "$TempTraceDir" ]
	then
		mv -f $TempTraceDir/* $_ADL_TRACE_DIR 2>/dev/null
		\rm -rf $TempTraceDir
	fi

	if [ "$_SENDMAIL" = "TRUE" -a ! -z "$MAIL_ADDR_LIST" ] 
	then
		tmpfile=/tmp/envoi_$$
		echo "\nBegining of the transfer (Paris time): $BeginTransferDate \n" >$tmpfile
		echo "How the source data exchange went: \n" >>$tmpfile

		if [ $ExitCode -le 2 ]
		then
			Status=SUCCESSFUL
			TITLE="Data transfer $_TID -> DS: successful"
			echo "Operation is: OK\n" >>$tmpfile
		elif [ $ExitCode -eq 9999 ]
		then
			Status=INTERRUPTED
			TITLE="Data transfer $_TID -> DS: interrupted"
			echo "Operation is: INTERRUPTED\n" >>$tmpfile
		else
			Status=FAILED
			TITLE="Data transfer $_TID -> DS: failed"
			echo "Operation is: KO\n" >>$tmpfile
		fi
		whence creation_bilan_html >/dev/null
		if [ $? -eq 0 ]
		then
			creation_bilan_html $Status
		fi

		# cas ou la synchro a plantee
		if [ ! -z "$SyncExitCode" ] && [ $SyncExitCode -ne 0 ]
		then
			if [ -f "$_TRACE_SYNCHRO" ]
			then
				cat $_TRACE_SYNCHRO >>$tmpfile
			fi
		fi

		if [ $# -ge 1 ]
		then
			echo "$*" >>$tmpfile
		fi

		if [ $ExitCode -le 2 ] && [ ! -z "$_PROMOTED_OBJECTS_FILE" ] && [ -s $_PROMOTED_OBJECTS_FILE ]
		then
			# on ajoute la liste des fichiers promus
			echo "\n\nHere's what has been promoted to the parent workspace: \n\n" >> $tmpfile
			cat $_PROMOTED_OBJECTS_FILE >> $tmpfile

			echo >> $tmpfile
			if [ ! -z "$_COMMAND_RESULT_FILE" ] && [ -s "$_COMMAND_RESULT_FILE" ]
			then
				grep 'has not evolved' $_COMMAND_RESULT_FILE | grep -v "^###" >> $tmpfile 2>/dev/null
			fi

			if [ ! -z "$_COMMAND_RESULT_FILE.not_rm_conf" ] && [ -s "$_COMMAND_RESULT_FILE.not_rm_conf" ]
			then
				echo "\nNot deleted configuration" >> $tmpfile
				cat $_COMMAND_RESULT_FILE.not_rm_conf </dev/null >> $tmpfile 2>/dev/null
			fi

		fi

		if [ ! -z "$_ADL_DIFF_RESULT" ] && [ -s "$_ADL_DIFF_RESULT" ]
		then
			echo "------ WARNING -------- WARNING ---------" >> $tmpfile
			echo "\nThere is some differences between Remote workspace contents and Local's" >>	$tmpfile
			echo "Please take a look to diagnostic if it is normal state" >>	$tmpfile
			echo "\nHere are these differences:"	>>	$tmpfile
			cat	$_ADL_DIFF_RESULT >>	$tmpfile
			echo "------ WARNING -------- WARNING ---------" >> $tmpfile
		fi
		
		if [ ! -z "$BilanHtml" ] && [ ! -z "$_HTTP_SERVER" ]
		then
			echo "\nYou will able to find more traces in the following directory: ${_HTTP_SERVER}${BilanHtml}" >> $tmpfile
		fi
		echo "\nEnd of the transfer (local time on $_L_HOST): $EndTransferDate" >>$tmpfile

		$MAIL -s "$TITLE" $MAIL_ADDR_LIST <$tmpfile 

		\rm -f $tmpfile 2>/dev/null
	fi

	if [ ! -z "$_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE" -a -f "$_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE" ]
	then
		\rm -f $_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE
	fi

	if [ ! -z "$ADL_MULTISITE_LOG_DIR" ]
	then
		echo "$EndTransferDate E $($WHOAMI) $_TID $_L_HOST $$ $ExitCode" >> $ADL_MULTISITE_LOG_DIR/_log_transfer
	fi 

	\rm -fr /tmp/*_$$

	exit $ExitCode
}

trap 'Out 9999 "Command interrupted" ' HUP INT QUIT TERM
# =====================================================================
# ValidateLSOUT function
# =====================================================================
ValidateLSOUT()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	
	if [ "$_LSOUT_CURRENT1" = "$_LSOUT_CURRENT2" ]
	then
		# Sans filtre
		cp -p $_LSOUT_CURRENT1 $_LSOUT_REF1
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate file list from CURRENT to REFERENCE: $_LSOUT_CURRENT1 / $_LSOUT_REF1"
		fi
	else
		# Avec filtre
		fgrep -vf "$_FW_FILTER_REF" $_LSOUT_REF1 >$_LSOUT_REF1.OutFilter # Partie de l'outlist precedente non touchee par ce report
		cat $_LSOUT_CURRENT2 $_LSOUT_REF1.OutFilter >$_LSOUT_REF1
		# La nouvelle reference = partie de l'ancienne hors du filtre + partie de la nouvelle filtree
		# ce qui permet d'ajouter ou d'enlever des frameworks entre chaque report.
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate file list from CURRENT to REFERENCE: $_LSOUT_CURRENT2 + $_LSOUT_REF1.OutFilter / $_LSOUT_REF1"
		fi

		rm -f $_LSOUT_REF1.OutFilter

		cp -p $_LSOUT_CURRENT2 $_LSOUT_REF2
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate filtered file list from CURRENT to REFERENCE: $_LSOUT_CURRENT2 / $_LSOUT_REF2"
		fi
	fi

	cp -p $_DB_ATTR $_DB_ATTR_REF
	if [ $? -ne 0 ]
	then
		Out 3 "Cannot validate database attribute files from CURRENT to REFERENCE: $_DB_ATTR / $_DB_ATTR_REF"
	fi

	if [ ! -z "$ADL_MULTISITE_LOG_DIR" ]
	then
		# On sauvegarde quelque part les lsout de reference, au cas ou on les perdrait
		if [ ! -d $ADL_MULTISITE_LOG_DIR/SaveLsoutReference ]
		then
			mkdir $ADL_MULTISITE_LOG_DIR/SaveLsoutReference
			chmod 777 $ADL_MULTISITE_LOG_DIR/SaveLsoutReference
		fi
		cp -p $_LSOUT_REF1 $ADL_MULTISITE_LOG_DIR/SaveLsoutReference/$_LSOUT_REF1.$_TID 
	fi 
}
# =====================================================================
# ValidateLSOUTforRI function
# =====================================================================
ValidateLSOUTforRI()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	
	if [ "$_LSOUT_LOCAL_RI1" = "$_LSOUT_LOCAL_RI2" ]
	then
		# Sans filtre
		cp -pf $_LSOUT_LOCAL_RI1 $_LSOUT_LOCAL_RI_REF1
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate LOCAL file list for RI from CURRENT to REFERENCE: $_LSOUT_LOCAL_RI1 / $_LSOUT_LOCAL_RI_REF1"
		fi
	else
		[ -z "$_FW_FILTER_REF" ] && Out 5 "ValidateLSOUTforRI function: _FW_FILTER_REF variable is empty"
		# Avec filtre
		fgrep -vf "$_FW_FILTER_REF" $_LSOUT_LOCAL_RI_REF1 >$_LSOUT_LOCAL_RI_REF1.OutFilter # Partie de l'outlist precedente non touchee par ce report
		cat $_LSOUT_LOCAL_RI2 $_LSOUT_LOCAL_RI_REF1.OutFilter >$_LSOUT_LOCAL_RI_REF1
		# La nouvelle reference = partie de l'ancienne hors du filtre + partie de la nouvelle filtree
		# ce qui permet d'ajouter ou d'enlever des frameworks entre chaque report.
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate LOCAL file list for RI from CURRENT to REFERENCE: $_LSOUT_LOCAL_RI2 + $_LSOUT_LOCAL_RI_REF1.OutFilter / $_LSOUT_LOCAL_RI_REF1"
		fi

		rm -f $_LSOUT_LOCAL_RI_REF1.OutFilter

		cp -pf $_LSOUT_LOCAL_RI2 $_LSOUT_LOCAL_RI_REF2
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate LOCAL filtered file list for RI from CURRENT to REFERENCE: $_LSOUT_LOCAL_RI2 / $_LSOUT_LOCAL_RI_REF2"
		fi
	fi

	if [ "$_LSOUT_REF1" = "$_LSOUT_REF2" ]
	then
		# Sans filtre
		cp -pf $_LSOUT_REF1 $_LSOUT_CURRENT_RI_REF1
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate CURRENT file list for RI from CURRENT to REFERENCE: $_LSOUT_REF1 / $_LSOUT_CURRENT_RI_REF1"
		fi
	else
		[ -z "$_FW_FILTER_CURRENT" ] && Out 5 "ValidateLSOUTforRI function: _FW_FILTER_CURRENT variable is empty"
		# Avec filtre
		fgrep -vf "$_FW_FILTER_CURRENT" $_LSOUT_CURRENT_RI_REF1 >$_LSOUT_CURRENT_RI_REF1.OutFilter # Partie de l'outlist precedente non touchee par ce report
		cat $_LSOUT_REF2 $_LSOUT_CURRENT_RI_REF1.OutFilter >$_LSOUT_CURRENT_RI_REF1
		# La nouvelle reference = partie de l'ancienne hors du filtre + partie de la nouvelle filtree
		# ce qui permet d'ajouter ou d'enlever des frameworks entre chaque report.
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate CURRENT file list for RI from CURRENT to REFERENCE: $_LSOUT_REF2 + $_LSOUT_CURRENT_RI_REF1.OutFilter / $_LSOUT_CURRENT_RI_REF1"
		fi

		rm -f $_LSOUT_CURRENT_RI_REF1.OutFilter

		cp -pf $_LSOUT_REF2 $_LSOUT_CURRENT_RI_REF2
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate CURRENT filtered file list for RI from CURRENT to REFERENCE: $_LSOUT_REF2 / $_LSOUT_CURRENT_RI_REF2"
		fi
	fi
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

unset _TID
unset _SENDMAIL
unset _HTTP_SERVER
unset _SIMUL

unset _R_HOST
unset _R_SITE
unset _R_BASE
unset _R_PROJECT
unset _R_WS
unset _R_IMAGE
unset _R_WS_TREE
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_MAINT
unset _R_PHOTO
unset _R_COLLECT
unset _R_SYNC
unset _R_PUBLISH
unset _R_PROMOTE
unset _R_TMP

unset _L_SITE
unset _L_BASE
unset _L_PROJECT
unset _L_WS
unset _L_IMAGE
unset _L_WS_TREE
unset _L_ADL_VERSION
unset _L_ADL_PROFILE
unset _L_MAINTENANCE
unset _L_COLLECT
unset _L_COLLECT_LIST
unset _L_SYNC
unset _L_PUBLISH
unset _L_PROMOTE
unset _L_PROMOTE_LIST
unset _L_CR_LIST
unset _L_TMP
unset _NO_UPDATE_CR

unset _FW_OPTION
unset _LFW_OPTION
unset _FW_LIST
unset _NB_TRACE_DIR
unset _TRACE_ADL_CMD

while [ $# -ge 1 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
			;;
		-mail ) #----------------> MAIL NEEDED
			_SENDMAIL=TRUE
			_MAIL_ADDR=""
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_MAIL_ADDR="$_MAIL_ADDR $1"
					shift
				else
					break
				fi
			done
			if [ ! -z "$_MAIL_ADDR" ] 
			then
				MAIL_ADDR_LIST=$_MAIL_ADDR # -> Par defaut, on conserve la variable MAIL_ADDR_LIST
			fi
			;;
		-http ) #----------------> HTTP SERVER NEEDED
			CheckOptArg "$1" "$2"
			_HTTP_SERVER=$2
			shift 2
			;;
		-simul ) #---------------> OPTIONAL: SIMULATION MODE
			_SIMUL="TRUE"
			shift
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
		-rsite ) #-------------------> REMOTE SITE
			CheckOptArg "$1" "$2"
			_R_SITE=$2
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
        -rtree ) #-------------------> REMOTE WORKSPACE TREE
            CheckOptArg "$1" "$2"
            _R_WS_TREE=$2
            shift 2
            ;;
		-rimage ) #-------------------> REMOTE IMAGE (OPTIONAL)
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
		-rmaint ) #-------------------> OPTIONAL: REMOTE maintenance mode
			_R_MAINT=" -pu -down "
			shift
			;;
		-r_photo ) #-----------> OPTIONAL: REMOTE PHOTO
			_R_PHOTO="TRUE"
			shift
			;;
		-r_collect ) #-----------> OPTIONAL: REMOTE COLLECT
			_R_COLLECT="TRUE"
			shift
			;;
		-r_sync ) #--------------> OPTIONAL: REMOTE SYNCHRONISATION
			_R_SYNC="TRUE"
			shift
			;;
		-r_publish ) #-----------> OPTIONAL: REMOTE PUBLISH
			_R_PUBLISH="TRUE"
			shift
			;;
		-r_promote ) #-----------> OPTIONAL: REMOTE PROMOTE
			_R_PROMOTE="TRUE"
			shift
			;;
		-rtmp ) #-------------------> REMOTE TEMPORARY DIRECTORY
			CheckOptArg "$1" "$2"
			_R_TMP=$2
			shift 2
			;;
		-fw ) #----------------> OPTIONAL: Framework list
			_FW_OPTION=Y
			shift
			if [ ! -z "$_LFW_OPTION" ] 
			then
				echo 1>&2 "-fw and -lfw options cannot be precised together"
				Out 3 "$Usage"
			fi
			_FW_LIST_FILENAME=/tmp/FW_LIST_$$
			rm -f $_FW_LIST_FILENAME
			touch $_FW_LIST_FILENAME
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					echo "$1" >> $_FW_LIST_FILENAME
					shift
				else
					break
				fi
			done
			if [ ! -s "$_FW_LIST_FILENAME" ] 
			then
				echo 1>&2 "-fw option has been requested without parameters"
				Out 3 "$Usage"
			fi
			;;
		-lfw ) #----------------> OPTIONAL: filename of Framework list
			_LFW_OPTION=Y
			if [ ! -z "$_FW_OPTION" ] 
			then
				echo 1>&2 "-fw and -lfw options cannot be precised together"
				Out 3 "$Usage"
			fi
			CheckOptArg "$1" "$2"
			Input_FW_LIST_FILENAME=$2
			shift 2
			[ ! -f "$Input_FW_LIST_FILENAME" ] && Out 3 "Cannot find file containing framework list: $Input_FW_LIST_FILENAME"
			_FW_LIST_FILENAME=/tmp/FW_LIST_$$
			rm -f $_FW_LIST_FILENAME
			touch $_FW_LIST_FILENAME
			/bin/sed 's/#.*$//g' $Input_FW_LIST_FILENAME > $_FW_LIST_FILENAME
			[ $? -ne 0 ] && Out 3 "Cannot remove comments from file: $Input_FW_LIST_FILENAME"
			;;
		-lsite ) #-------------------> LOCAL SITE
			CheckOptArg "$1" "$2"
			_L_SITE=$2
			shift 2
			;;
		-ll ) #-------------------> LOCAL ADELE LEVEL
			CheckOptArg "$1" "$2"
			_L_ADL_VERSION=$2
			[ $_L_ADL_VERSION != "3" ] && [ $_L_ADL_VERSION != "5" ] && Out 3 "Unknown local Adele level: $_L_ADL_VERSION"
			shift 2
			;;
		-lp ) #-------------------> LOCAL ADELE PROFILE
			CheckOptArg "$1" "$2"
			_L_ADL_PROFILE=$2
			shift 2
			;;
		-lw ) #-------------------> LOCAL WORKSPACE
			CheckOptArg "$1" "$2"
			_L_WS=$2
			shift 2
			;;
		-limage ) #-------------------> LOCAL IMAGE (OPTIONAL)
			CheckOptArg "$1" "$2"
			_L_IMAGE=$2
			shift 2
			;;
		-ltree ) #-------------------> LOCAL WORKSPACE TREE for adl_mk_fw
			CheckOptArg "$1" "$2"
			_L_WS_TREE=$2
			shift 2
			;;
		-lb ) #-------------------> LOCAL BASE
			CheckOptArg "$1" "$2"
			_L_BASE=$2
			shift 2
			;;
		-lproj ) #-------------------> PROJECT IN LOCAL BASE
			CheckOptArg "$1" "$2"
			_L_PROJECT=$2
			shift 2
			;;
		-C ) #-------------------> OPTIONAL: LOCAL maintenance mode
			_L_MAINTENANCE=" -pu -down "
			shift
			;;
		-l_collect ) #-----------> OPTIONAL: LOCAL COLLECT
			_L_COLLECT="TRUE"
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_L_COLLECT_LIST="$_L_COLLECT_LIST $1"
					shift
				else
					break
				fi
			done
			shift
			;;
		-l_sync ) #--------------> OPTIONAL: LOCAL SYNC
			_L_SYNC="TRUE"
			shift
			;;
		-l_publish ) #-----------> OPTIONAL: LOCAL PUBLISH
			_L_PUBLISH="TRUE"
			shift
			;;
		-l_promote ) #-----------> OPTIONAL: LOCAL PROMOTE
			_L_PROMOTE="TRUE"
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_L_PROMOTE_LIST="$_L_PROMOTE_LIST $1"
					shift
				else
					break
				fi
			done
			;;
		-l_cr ) #----------------> OPTIONAL: CHANGE REQUEST NUMBER LIST
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_L_CR_LIST="$_L_CR_LIST $1"
					shift
				else
					break
				fi
			done
			if [ -z "$_L_CR_LIST" ] 
			then
				echo 1>&2 "-l_cr option has been requested without parameters"
				Out 3 "$Usage"
			fi
			;;
		-no_update_cr ) #-----------> OPTIONAL: DISCONNECT UPDATE PHASE OF CHANGE REQUEST
			_NO_UPDATE_CR="TRUE"
			shift
			;;
		-ltmp ) #-------------------> LOCAL TEMPORARY DIRECTORY
			CheckOptArg "$1" "$2"
			_L_TMP=$2
			[ ! -d $_L_TMP ] && Out 3 "Unknown local temporary directory: $_L_TMP"
			shift 2
			;;
		-keep_trace ) #-------------------> NB OF LOCAL TRACE DIRECTORIES
			CheckOptArg "$1" "$2"
			let "_NB_TRACE_DIR = $2 - 1"
			if [ $? -ne 0 -o $_NB_TRACE_DIR -le 0 ]
			then
				Out 3 "The -keep_trace parameter must be a number greater than 0"
			fi
			shift 2
			;;
		-trace_adl_cmd ) #----------> OPTIONAL: ADELE COMMAND WILL BE DISPLAYED ON TERMINAL
			_TRACE_ADL_CMD=TRUE
			shift
			;;
		* ) echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

if [ -z "$_R_HOST" -o -z "$_R_WS" -o -z "$_R_ADL_VERSION" -o -z "$_R_ADL_PROFILE" -o -z "$_R_TMP" ]
then
	echo "$ShellName: Missing mandatory remote parameter." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_L_WS" -o -z "$_L_ADL_VERSION" -o -z "$_L_ADL_PROFILE" -o -z "$_L_TMP" ]
then
	echo "$ShellName: Missing mandatory local parameter." 1>&2
	Out 3 "$Usage"
fi

if [ $_L_ADL_VERSION = 3 -a ! -z "$_L_WS_TREE" ]
then
	echo "$ShellName: -ltree option is reserved for an Adele V5 workspace." 1>&2
	Out 3 "$Usage"
elif [ $_L_ADL_VERSION = 5 -a -z "$_L_WS_TREE" ]
then
	echo "$ShellName: -ltree option is MANDATORY for an Adele V5 workspace." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_R_BASE" ]
then
	echo "$ShellName: Remote Adele base is a mandatory parameter (base on an Adele V3 site and tck for an Adele V5 site)." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_L_BASE" ]
then
	echo "$ShellName: Local Adele base is a mandatory parameter (base on an Adele V3 site and tck for an Adele V5 site)." 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_R_PROJECT" ] && [ -z "$_R_BASE" ]
then
	echo "$ShellName: Remote Adele base is a mandatory parameter when you require Project in Adele V3 site." 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_L_PROJECT" ] && [ -z "$_L_BASE" ]
then
	echo "$ShellName: Local Adele base is a mandatory parameter when you require Project in Adele V3 site." 1>&2
	Out 3 "$Usage"
fi

_r_base=$_R_BASE
if [ ! -z "$_R_PROJECT" ]
then
	_r_base=$_R_PROJECT
fi
export _r_base

_l_base=$_L_BASE
if [ ! -z "$_L_PROJECT" ]
then
	_l_base=$_L_PROJECT
fi
export _l_base

if [ -z "$_TID" ]
then
	echo "$ShellName: site parameter is required to identify uniquely a data transfer."
	Out 3 "$Usage"
fi

# =====================================================================
# _Trace function
# =====================================================================
_Trace()
{
Username=$($WHOAMI)
echo "
_____________________________________________________________
Begining of the transfer: $BeginTransferDate"
echo "Command: $FullShellName - Version: $ShellVersion\n"
if [ ! -z "$_SIMUL" ]
then
	echo "_____________________________________________________________"
	echo "_ _ _ _ _ _ _ _ S I M U L A T I O N   M O D E _ _ _ _ _ _ _ _"
fi
echo "____________________________________________________________
Command args: '$CmdLine'
Local host  : $_L_HOST
User        : $Username
____________________________________________________________
Transfer is to be done 
from
      server: $_R_HOST"
[ ! -z "$_R_SITE" ]    && echo "      site  : $_R_SITE"
echo "      id    : $_TID
      base  : $_r_base
      ws    : $_R_WS"
[ ! -z "$_R_WS_TREE" ] && echo "      tree  : $_R_WS_TREE"

echo "
to:"
[ ! -z "$_L_SITE" ]    && echo "      site  : $_L_SITE"
echo "      base  : $_l_base
      ws    : $_L_WS"
[ ! -z "$_L_WS_TREE" ] && echo "      tree  : $_L_WS_TREE"
echo " 
And...
  SENDMAILTO  : $MAIL_ADDR_LIST
  SENDMAIL    : $_SENDMAIL
____________________________________________________________
"
}
# ===========================================================
# Creation du bilan HTML
# ===========================================================
creation_bilan_html()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	Status=$1
	if [ "$Status" = "SUCCESSFUL" ]
	then
		color=GREEN
	else
		color=RED
	fi
	# On cree un bilan HTML 
	unset BilanHtml
	if [ ! -z "$_ADL_TRACE_DIR" ] && [ -s "$_ADL_TRACE_DIR" ]
	then
		ls -ltr $_ADL_TRACE_DIR | tail +2 > /tmp/DataTransferTraceFile.List_$$
		export BilanHtml=$_ADL_TRACE_DIR/index.html
	
		echo " </body>
</html>
<b>Html report of data transfer named $_TID --> <font color=$color>$Status</font></b>
<br>
<table BORDER COLS=7>
<td><center><b>Rights</b></center></td>
<td><center><b>User</b></center></td>
<td><center><b>Group</b></center></td>
<td><center><b>Size</b></center></td>
<td><center><b>Date</b></center></td>
<td><center><b>Filename</b></center></td>
" > $BilanHtml

		while read rights link_nb user group size month day time file
		do
			echo "
<tr>
<td>$rights</td>
<td>$user</td>
<td>$group</td>
<td><div align=right>$size</div></td>
<td>$month $day $time</td>
<td><a href=\"$_ADL_TRACE_DIR/$file\">$file</a></td>
</tr>
" >> $BilanHtml
		done < /tmp/DataTransferTraceFile.List_$$ 
		\rm -f /tmp/DataTransferTraceFile.List_$$

		echo "
</table>" >> $BilanHtml

		if [ ! -z "$_ADL_WORKING_DIR" ] && [ -s "$_ADL_WORKING_DIR" ]
		then
			echo "
<br>
<b>Previous data transfers from ($_R_SITE,$_R_BASE)</b>
<br>
<table BORDER COLS=1>
<td><center><b>Transfer</b></center></td>" >> $BilanHtml
			find $_ADL_WORKING_DIR -name 'trace_*' -type d | sort -r > /tmp/DataTransferTraceList_$$
			while read trace_directory
			do
			echo "
<tr>
<td><a href=\"${trace_directory}/index.html\">${trace_directory##*/}</a></td>
</tr>
" >> $BilanHtml
			done < /tmp/DataTransferTraceList_$$
		echo "
</table>" >> $BilanHtml
		fi
		
		echo "
</body>
</html>" >> $BilanHtml
	fi
}

# =====================================================================
# StartADLDiffImageContents function
# =====================================================================
StartADLDiffImageContents()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	(
	# Pour trouver les differents outils du report
	if [ ! -z "$ADL_MULTISITE_INSTALL" ]
	then
		export _MULTISITE_TOOLS=$ADL_MULTISITE_INSTALL/$OS_INST
		export _MULTISITE_PREQ_TOOLS=
		export LIBPATH=$_MULTISITE_TOOLS/code/bin
		export SHLIB_PATH=$_MULTISITE_TOOLS/code/bin
		export LD_LIBRARY_PATH=:$_MULTISITE_TOOLS/code/bin
	else
		echo "### DEBUG 2 - Tools have been found in Development workspace"
		export _MULTISITE_TOOLS=/u/users/ygd/Adele/ygdreportv5/$OS_INST
		echo "### DEBUG 2 - _MULTISITE_TOOLS=$_MULTISITE_TOOLS"
		export LIBPATH=$_MULTISITE_TOOLS/code/bin
		export SHLIB_PATH=$_MULTISITE_TOOLS/code/bin
		export LD_LIBRARY_PATH=$_MULTISITE_TOOLS/code/bin
	fi

	#export PATH=$_MULTISITE_TOOLS/code/bin:$PATH
	export PATH=$_MULTISITE_TOOLS/code/bin
	export CATDictionaryPath=$_MULTISITE_TOOLS/code/dictionary
	export CATMsgCatalogPath=$_MULTISITE_TOOLS/resources/msgcatalog

	ADLDiffImageContents "$@"
    )
	return $?
}

# =====================================================================
# Try_adl function
# =====================================================================
Try_adl()
{
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
	return $rc
}

# ======================================================================
# Global process
# ======================================================================
BeginTransferDate=$($ShellDir/adl_get_current_date.sh)
TraceDirName=trace_${_TID}_$(date +"%Y_%m_%d_%H_%M")

TempTraceDir=/tmp/$TraceDirName
if [ ! -d "$TempTraceDir" ]
then
	mkdir -p $TempTraceDir
	[ $? -ne 0 ] && Out 3 "Cannot create temporary trace directory: $TempTraceDir"
fi

TempTraceFile=$TempTraceDir/$ShellName.$_TID

_Trace

# ----------------------------------------------------------------------
# Nettoyage de l'environnement Adele 3.2, V5, Tck (pas mkmk, quand meme...)
# ----------------------------------------------------------------------
[ ! -f "$ShellDir/adl_transfer_clean_env.sh" ] && Out 3 "adl_transfer_clean_env.sh not found"
. "$ShellDir/adl_transfer_clean_env.sh"

if [ $_L_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "____________________________________________________________" 
	echo "$CurrentDate - Positioning in local base $_L_BASE and ws $_L_WS ...\n"
	unset ADL_FR_CATIA
	if [ ! -x "$_L_ADL_PROFILE" ]
	then
		Out 3 "Local Adele profile not found: $_L_ADL_PROFILE"
	fi
	. $_L_ADL_PROFILE < /dev/null 

	CHLEV_OPT=$_L_BASE
	[ ! -z "$_L_PROJECT" ] && CHLEV_OPT="$_L_PROJECT -r $CHLEV_OPT"
	Try_adl chlev $CHLEV_OPT </dev/null	|| Out 3 "chlev $CHLEV_OPT KO"
	Try_adl adl_ch_ws $_L_WS </dev/null || Out 3 "adl_ch_ws $_L_WS KO"
	unset ADL_W_BASE
	ADL_WS=$ADL_W_ID

	# On se positionne dans le repertoire de travail des transferts
	export _ADL_WORKING_DIR=$ADL_W_DIR/.Adele/MultiSite/$_TID

	_COMMANDS_VERSION=3

elif [ $_L_ADL_VERSION = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "____________________________________________________________" 
	echo "$CurrentDate - Positioning in local base $_L_BASE and ws $_L_WS ...\n"
	unset ADL_FR_CATIA
	if [ ! -x "$_L_ADL_PROFILE" ]
	then
		Out 3 "Local Adele profile not found: $_L_ADL_PROFILE"
	fi
	. $_L_ADL_PROFILE < /dev/null 

	tck_profile $_L_BASE </dev/null	|| Out 3 "tck_profile $_L_BASE KO"
	OPTIONS=$_L_WS
	[ ! -z "$_L_IMAGE" ] && OPTIONS="${OPTIONS} -image $_L_IMAGE"
	adl_ch_ws $OPTIONS </dev/null || Out 3 "adl_ch_ws $OPTIONS KO"

	# On value le repertoire de travail des transferts
	export _ADL_WORKING_DIR=$ADL_IMAGE_DIR/ToolsData/MultiSite/$_TID

	_COMMANDS_VERSION=5

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown _L_ADL_VERSION in $ShellName: $_L_ADL_VERSION"
fi

# On cree si besoin, le repertoire de travail des transferts
if [ ! -d "$_ADL_WORKING_DIR" ]
then
	mkdir -p $_ADL_WORKING_DIR
	rc=$?
	if [ $rc -ne 0 ]
	then
		Out 3 "Cannot create working directory on local ws: $_ADL_WORKING_DIR"
	fi
fi

# On se positionne dans le repertoire de travail des transferts
cd $_ADL_WORKING_DIR

if [ ! -z "$ADL_DEBUG_ENV" ] 
then
	echo "---------------- Begin of environment -----------------"
	echo "$FullShellName $LINENO : Environment variables"
	env | sort
	echo "---------------- End of environment -----------------"
fi
# ------------------------------------------------------------
# Avant de commencer un report on verifie qu'il n'y en aurait pas
# deja un qui trournerait deja
# ------------------------------------------------------------
_ADL_CURRENT_DATA_TRANSFER="0LockCurrentDataTransfer"
if [ -f "$_ADL_CURRENT_DATA_TRANSFER" ]
then
	# Il en existe peut deja un. On verifie qu'il existe toujours
	read CurHost CurPid CurDate < $_ADL_CURRENT_DATA_TRANSFER
    if [ ! -z "$CurHost" -a ! -z "$CurPid" ]
	then
		$RSH $CurHost ps -p $CurPid -f | grep "$ShellName" > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			Out 3 "A running data transfer already exist now on host: $CurHost with pid: $CurPid. It was launch at $CurDate.\nYou have to wait for its finishing before start a new data transfer."
		fi
	else
		# Il n'existe plus, on supprime le verrou 
		rm -f $_ADL_CURRENT_DATA_TRANSFER
	fi
fi

# On met un verrou de lancement de ce report
echo $_L_HOST $$ $BeginTransferDate > $_ADL_CURRENT_DATA_TRANSFER
sync
sleep 1
read CurHost CurPid CurDate < $_ADL_CURRENT_DATA_TRANSFER
if [ "$_L_HOST" != "$CurHost" -o "$$" != "$CurPid" -o "$BeginTransferDate" != "$CurDate" ]
then
	Out 3 "A running data transfer already exist now on host: $CurHost with pid: $CurPid. It was launch at $CurDate.\nYou have to wait for its finishing before start a new data transfer."
fi
_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE=$PWD/$_ADL_CURRENT_DATA_TRANSFER

# ------------------------------------------------------------
# Avant de commencer un report on ecrit dans la log des reports qu'on demarre 
# ------------------------------------------------------------
if [ ! -z "$ADL_MULTISITE_LOG_DIR" ]
then
	if [ ! -f $ADL_MULTISITE_LOG_DIR/_log_transfer ]
	then
		touch $ADL_MULTISITE_LOG_DIR/_log_transfer
		chmod 777 $ADL_MULTISITE_LOG_DIR/_log_transfer
	fi
	if [ ! -w $ADL_MULTISITE_LOG_DIR/_log_transfer ]
	then
		chmod 777 $ADL_MULTISITE_LOG_DIR/_log_transfer
	fi
	echo "$BeginTransferDate B $($WHOAMI) $_TID $_L_HOST $$ -" >> $ADL_MULTISITE_LOG_DIR/_log_transfer
fi 

# ------------------------------------------------------------
# On nettoie les repertoires de trace
# ------------------------------------------------------------
if [ ! -z "$_NB_TRACE_DIR" -a $_NB_TRACE_DIR -ge 1 ]
then
	ls -d1 trace_* >/tmp/ls_trace_$$ 2>/dev/null
	nb=$(wc -l /tmp/ls_trace_$$ | $_AWK '{print $1}')
	let "nb = $nb - $_NB_TRACE_DIR"
	if [ $nb -gt 0 ]
	then
		head -$nb /tmp/ls_trace_$$ | while read dir
		do
			if [ -d $dir ]
			then
				\rm -fr $dir
			fi
		done
	fi
fi

# On cree le repertoire des traces du transfert
export _ADL_TRACE_DIR=$_ADL_WORKING_DIR/$TraceDirName
if [ ! -d "$_ADL_TRACE_DIR" ]
then
	mkdir -p $_ADL_TRACE_DIR
	rc=$?
	if [ $rc -ne 0 ]
	then
		Out 3 "Cannot create transfer trace directory on local ws: $_ADL_TRACE_DIR"
	fi
fi

echo "<<<<<<<<<<<< Working directory: $_ADL_WORKING_DIR >>>>>>>>>>>>"
echo "<<<<<<<<<<<< Trace directory: $_ADL_TRACE_DIR >>>>>>>>>>>>"

# ----------------------------------------------------------------------
# Common process
# ----------------------------------------------------------------------
if [ "$_R_ADL_VERSION" = 3 ]
then
	_LSOUT_VERSION=3
elif [ "$_R_ADL_VERSION" = 5 ]
then
	_LSOUT_VERSION=5
else
	Out 3 "Unknown _R_ADL_VERSION in $ShellName: $_R_ADL_VERSION"
fi
_COMMANDS_FILE=$_ADL_WORKING_DIR/0CommandsToExecute
_RECOVERY_FILE=$_ADL_WORKING_DIR/0RecoveryCommands
_FILESTOBECOPIED_FILE=$_ADL_TRACE_DIR/0FileListToCopy
_FILESTOBECOPIEDSIZE_FILE=$_ADL_TRACE_DIR/0SizeOfFilesToCopy
_FILETOBECOPIED_DIR=$_L_TMP/adl_transfer_${_TID}/$ADL_WS

_COMP_LIST_CURRENT1=0CompList.current
_COMP_LIST_CURRENT2=0CompList.current.filtered
_LSOUT_CURRENT1=0Lsout.current
_LSOUT_REF1=$_LSOUT_CURRENT1.Reference
_FW_FILTER_CURRENT=0FwFilterCurrent
_FW_FILTER_REF=0FwFilterReference
_LSOUT_CURRENT2=0Lsout.current.filtered
_LSOUT_REF2=$_LSOUT_CURRENT2.Reference

_LSOUT_LOCAL1=0Lsout.local
_LSOUT_LOCAL2=0Lsout.local.filtered

_LSOUT_LOCAL_RI1=0Lsout.local.RI
_LSOUT_LOCAL_RI2=0Lsout.local.RI.filtered
_LSOUT_LOCAL_RI_REF1=${_LSOUT_LOCAL_RI1}.Reference
_LSOUT_LOCAL_RI_REF2=${_LSOUT_LOCAL_RI2}.Reference

_LSOUT_CURRENT_RI1=0Lsout.current.RI
_LSOUT_CURRENT_RI2=0Lsout.current.RI.filtered
_LSOUT_CURRENT_RI_REF1=${_LSOUT_CURRENT_RI1}.Reference
_LSOUT_CURRENT_RI_REF2=${_LSOUT_CURRENT_RI2}.Reference

_DB_ATTR=0DatabaseAttributes
_DB_ATTR_REF=$_DB_ATTR.Reference

_RSITE_ATTR=0SiteAttributes.txt

if [ -f $_RECOVERY_FILE ]
then
	# ----------------------------------------------------------------------
	# Un fichier de recovery existe alors on joue le recovery 
	# ----------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "____________________________________________________________"
	echo "$CurrentDate - A recovery of a previous command set exist."

	if [ ! -f $_COMMANDS_FILE ]
	then
		Out 3 "A recovery has to be run, but the commands file $_COMMANDS_FILE doesn't exist"
	fi
	if [ ! -d $_FILETOBECOPIED_DIR ]
	then
		Out 3 "A recovery has to be run, but the files to copy directory $_FILETOBECOPIED_DIR doesn't exist"
	fi

	unset OPTIONS
	if [ ! -z "$_SIMUL" ] 
	then
		echo "A recovery of a previous data transfer exist, simulation mode is ignored"
	fi
	[ ! -z "$_TRACE_ADL_CMD" ] && OPTIONS="$OPTIONS -verbose" 
	_RECOVERY_RESULT_FILE=$_ADL_TRACE_DIR/0trace_adl_interpret_commands.recovery
	$ShellDir/adl_interpret_commands.sh -c $_COMMANDS_FILE -v $_COMMANDS_VERSION -r $_RECOVERY_FILE -t $_RECOVERY_RESULT_FILE $OPTIONS
	rc=$?
	if [ $rc -ne 0 ] 
	then
		Out 3 "adl_interpret_commands.sh for recovery is KO"
	fi

	if [ -f $_RECOVERY_FILE ]
	then
		Out 3 "FATAL INTERNAL ERROR: the recovery has been run, but the recovery file $_RECOVERY_FILE still exists"
	fi

	# On valide les lsout
	if [ ! -f $_LSOUT_CURRENT2 ]
	then
		# Pas de filtre au tour precedent
		_FW_FILTER_CURRENT=""
		_FW_FILTER_REF=""
		_LSOUT_CURRENT2=$_LSOUT_CURRENT1
		_LSOUT_REF2=$_LSOUT_REF1
	fi

	ValidateLSOUT

	_FW_FILTER_CURRENT=0FwFilterCurrent
	_FW_FILTER_REF=0FwFilterReference
	_LSOUT_CURRENT2=0Lsout.current.filtered
	_LSOUT_REF2=$_LSOUT_CURRENT2.Reference

	# On deplace les commandes executees
	mv $_COMMANDS_FILE $_ADL_TRACE_DIR/0CommandsForRecovery
fi

# ----------------------------------------------------------------------
# On teste la ligne du site distant
# ----------------------------------------------------------------------
_TRACE_TEST_LINE=$_ADL_TRACE_DIR/0trace_adl_test_line
$ShellDir/adl_test_line.sh -rhost $_R_HOST 2>&1 > $_TRACE_TEST_LINE
export TestLineExitCode=$?
cat "$_TRACE_TEST_LINE"
[ $TestLineExitCode -ne 0 ] && Out 3 "adl_test_line.sh is KO"

# ----------------------------------------------------------------------
# On impose une photo et un refresh de l espace local
# ----------------------------------------------------------------------
_TRACE_PHOTO_REFRESH=$_ADL_TRACE_DIR/0trace_adl_photo_refresh_local_ws1
OPTIONS="-l_photo -l_refresh"
[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_PHOTO_REFRESH
rc=$?
cat "$_TRACE_PHOTO_REFRESH"
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"

# ----------------------------------------------------------------------
# On lance la collecte de l espace local
# ----------------------------------------------------------------------
if [ ! -z "$_L_COLLECT" ]
then
	_TRACE_COLLECT=$_ADL_TRACE_DIR/0trace_adl_collect_local_ws
	OPTIONS="-l_collect $_L_COLLECT_LIST"
	[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"

	$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_COLLECT
	export CollectExitCode=$?
	cat "$_TRACE_COLLECT"
	[ $CollectExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
fi

# ----------------------------------------------------------------------
# On lance la synchronisation de l espace local
# ----------------------------------------------------------------------
if [ ! -z "$_L_SYNC" ]
then
	_TRACE_SYNCHRO=$_ADL_TRACE_DIR/0trace_adl_sync_local_ws
	OPTIONS="-l_sync"
	[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
	$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_SYNCHRO
	export SyncExitCode=$?
	cat "$_TRACE_SYNCHRO"
	[ $SyncExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
fi

# ----------------------------------------------------------------------
# On verifie qu'il n'y a pas de fusion a resoudre dans cet espace de travail
# ----------------------------------------------------------------------

# A FAIRE

# ----------------------------------------------------------------------
# On lance la collecte de l espace distant
# ----------------------------------------------------------------------
# On calcule les options de lancement pour le site remote
OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
[ ! -z "$_R_IMAGE" ]   && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
[ ! -z "$_R_WS_TREE" ] && OPTIONS="$OPTIONS -rtree $_R_WS_TREE"
[ ! -z "$_R_BASE" ]    && OPTIONS="$OPTIONS -rb $_R_BASE"
[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
[ ! -z "$_R_MAINT" ]   && OPTIONS="$OPTIONS -rmaint $_R_MAINT"
OPTIONS2=""
[ ! -z "$_R_PHOTO" ]   && OPTIONS2="$OPTIONS2 -r_photo"
[ ! -z "$_R_COLLECT" ] && OPTIONS2="$OPTIONS2 -r_collect"
[ ! -z "$_R_SYNC" ]    && OPTIONS2="$OPTIONS2 -r_sync"
[ ! -z "$_R_PUBLISH" ] && OPTIONS2="$OPTIONS2 -r_publish"
[ ! -z "$_R_PROMOTE" ] && OPTIONS2="$OPTIONS2 -r_promote"

if [ "$OPTIONS2" != "" ]
then
	$ShellDir/adl_start_commands_on_remote_ws.sh $OPTIONS $OPTIONS2 -ltd $_ADL_TRACE_DIR
	rc=$?
	[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_remote_ws.sh is KO"
fi

# ----------------------------------------------------------------------
# Separateur des champs
# ----------------------------------------------------------------------
if [ $_R_ADL_VERSION = 5 -o $_L_ADL_VERSION = 5 ]
then
	export _FIELD_SEP="|" # Histoire de supporter les chemins avec espaces

	# * Changement eventuel du separateur des champs
	for ref_file in $_LSOUT_REF1 $_LSOUT_LOCAL_RI_REF1 $_LSOUT_LOCAL_RI_REF2 $_LSOUT_CURRENT_RI_REF1
	do
		if [ -f "$ref_file" ]
		then
			head -1 $ref_file >$_L_TMP/head_$$
			fgrep "|" $_L_TMP/head_$$ >/dev/null
			if [ $? -ne 0 ]
			then
				# Le fichier ne contient pas de |
				# A priori, aucun chemin contenu ne contient d'espace...
				sed 's/  */|/g' $ref_file >$ref_file.new
				[ $? -ne 0 ] && Out 3 "Unable to treat field separators in $ref_file"
				mv -f $ref_file.new $ref_file
			fi
		fi
	done

else
	export _FIELD_SEP=" " # -> Comme avant
fi

# ----------------------------------------------------------------------
# On calcule la liste des frameworks, modules, data et fichiers de l espace distant
# ----------------------------------------------------------------------
$ShellDir/adl_get_remote_lists.sh $OPTIONS -f $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 -a $_ADL_WORKING_DIR/$_DB_ATTR -c $_ADL_WORKING_DIR/$_COMP_LIST_CURRENT1 -rsiteattr $_ADL_WORKING_DIR/$_RSITE_ATTR -ltd $_ADL_TRACE_DIR -rtmp $_R_TMP -s "$_FIELD_SEP"
rc=$?
[ $rc -ne 0 ] && Out 3 "adl_get_remote_lists.sh is KO"

echo "ENDLSOUT_${_L_BASE}_${_L_WS_TREE}" # -> Pour synchroniser des reports concurrents

# ----------------------------------------------------------------------
# On traite la liste des fichiers
# ----------------------------------------------------------------------
if [ ! -f $_LSOUT_REF1 ]
then
	Out 3 "No reference file list has been found: $_LSOUT_REF1 in directory: $_ADL_WORKING_DIR"
	# Charge a l'utilisateur ou a l'administrateur de creer le necessaire.
else
	# Craderie pour rattraper les doublons DIR_ELEM contenus dans les outlist V3
	sort -T "$_L_TMP" -o $_LSOUT_REF1 -k 4 -t "$_FIELD_SEP" -u $_LSOUT_REF1
fi

# ----------------------------------------------------------------------
# On filtre avec les frameworks passes eventuellement en argument
# ----------------------------------------------------------------------
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Calculate the filtered list of frameworks."

if [ ! -z "$_FW_LIST_FILENAME" ]
then
	# Filtre
	_FW_LIST_REF_FILENAME=$_L_TMP/FW_LIST_REF_$$
	rm -f $_FW_FILTER_CURRENT $_FW_FILTER_REF $_FW_LIST_REF_FILENAME
	touch $_FW_FILTER_CURRENT $_FW_FILTER_REF $_FW_LIST_REF_FILENAME

	while read fw remainder
	do
		[ ! -z "$remainder" ] && Out 3 "File containing the framework list must have one framework per line (file: $_FW_LIST_FILENAME)"
		echo "${_FIELD_SEP}${fw}${_FIELD_SEP}" >>$_FW_FILTER_CURRENT
		echo "${_FIELD_SEP}${fw}/" >>$_FW_FILTER_CURRENT
		
		# On recherche ce framework dans la lsout de reference par son id au cas ou il aurait change de nom
		FwId=$($_AWK -F "$_FIELD_SEP" '($4 == "'$fw'") && ($5 == "FRAMEWORK") {print $1}' $_LSOUT_CURRENT1)
		NbFw=$(echo $FwId | wc -w)
		[ $NbFw -gt 1 ] && Out 3 "Find more than only one framework: $fw in file $_LSOUT_CURRENT1"
		if [ $NbFw -eq 1 ]
		then
			export FwIdERE=$(echo "$FwId" | sed 's/+/\\+/g') # Histoire de supporter les Id V5 dans awk : le + = 1 ou n occurences
			FwRef=$($_AWK -F "$_FIELD_SEP" '/^'$FwIdERE'/ && ($5 == "FRAMEWORK") {print $3}' $_LSOUT_REF1)
			NbFw=$(echo $FwRef | wc -w)
			[ $NbFw -gt 1 ] && Out 3 "Find more than only one framework: $FwId in file $_LSOUT_REF1"
			if [ $NbFw -eq 1 ]
			then
				echo "${_FIELD_SEP}${FwRef}${_FIELD_SEP}" >>$_FW_FILTER_REF
				echo "${_FIELD_SEP}${FwRef}/" >>$_FW_FILTER_REF
				echo $FwRef >> $_FW_LIST_REF_FILENAME
			fi
		fi
	done < $_FW_LIST_FILENAME

	fgrep -f $_FW_FILTER_CURRENT $_LSOUT_CURRENT1 >$_LSOUT_CURRENT2
	fgrep -f $_FW_FILTER_REF $_LSOUT_REF1 >$_LSOUT_REF2

	echo "\n>>> Filter applied on framework list in workspace: $_R_WS in base: $_R_BASE"
	cat $_FW_LIST_FILENAME
	echo "\n>>> Filter applied on framework list in workspace: $_L_WS in base: $_L_BASE"
	cat $_FW_LIST_REF_FILENAME

	# On verifie que dans la liste des frameworks donnes, il n'y en a aucun de detache et qu'aucun des frameworks attaches n'a des modules ou data detaches
	sed 's/^'"$_FIELD_SEP"'//g' $_FW_FILTER_CURRENT > ${_FW_FILTER_CURRENT}.2
	fgrep -f ${_FW_FILTER_CURRENT}.2 $_COMP_LIST_CURRENT1 >$_COMP_LIST_CURRENT2
	\rm -f ${_FW_FILTER_CURRENT}.2
	_DETACHED_COMP_LIST=$_L_TMP/DETACHED_COMP_LIST_$$
	$_AWK -F "$_FIELD_SEP" '{if ($3==0){print $0}}' $_COMP_LIST_CURRENT2 > $_DETACHED_COMP_LIST
	if [ -s "$_DETACHED_COMP_LIST" ]
	then
		echo "\nFollowing framework, module and/or data components are detached from workspace: $_R_WS in base: $_R_BASE \n"
		cat $_DETACHED_COMP_LIST
		echo
		Out 3 "You must attach all framework, module and data components that you want transfer"
	fi
else
	# Pas de filtre
	\rm -f $_FW_FILTER_CURRENT $_FW_FILTER_REF $_LSOUT_CURRENT2 $_LSOUT_REF2
	_FW_FILTER_CURRENT=""
	_FW_FILTER_REF=""
	_LSOUT_CURRENT2=$_LSOUT_CURRENT1
	_LSOUT_REF2=$_LSOUT_REF1
	_COMP_LIST_CURRENT2=$_COMP_LIST_CURRENT1
	echo "\n>>> No filter applied on framework list in both workspaces"
fi

# on verifie que les frameworks appartiennent tous a la meme arborescence dans le cas Adele V5
export _R_TREE="-"
if [ "$_R_ADL_VERSION" = 5 ]
then
	_R_TREE_LIST=TreeList_$$
	$_AWK -F "$_FIELD_SEP" '{if ($5 == "FRAMEWORK") print $7;}' $_LSOUT_CURRENT2 | sort -T "$_L_TMP" -u > $_L_TMP/$_R_TREE_LIST
	if [ $(cat $_L_TMP/$_R_TREE_LIST | wc -l) -ne 1 ]
	then
		echo "Here is the list of workspace trees containing frameworks to transfer:"
		cat $_L_TMP/$_R_TREE_LIST
		\rm -f $_L_TMP/$_R_TREE_LIST
		Out 3 "You cannot specify a list of frameworks whose are in more than only one wokspace tree."
	fi
	_R_TREE=$(cat $_L_TMP/$_R_TREE_LIST)
	\rm -f $_L_TMP/$_R_TREE_LIST
fi
# ----------------------------------------------------------------------
# On calcule les commandes a faire sur le site local et les fichiers a ramener du site distant 
# ----------------------------------------------------------------------
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Calculating all differences between the last data transfer"

\rm -f $_COMMANDS_FILE $_FILESTOBECOPIED_FILE $_FILESTOBECOPIEDSIZE_FILE

[ ! -z "$ADL_DEBUG" ] && echo $LD_LIBRARY_PATH

unset _WS_TREE_OPT
if [ "$_L_WS_TREE" != "" ]
then
	_WS_TREE_OPT="-tree $_L_WS_TREE"
fi

StartADLDiffImageContents -reference_outlist $_LSOUT_REF2 -current_outlist $_LSOUT_CURRENT2 -sep "$_FIELD_SEP" \
	-outlist_version $_LSOUT_VERSION -commands_version $_COMMANDS_VERSION \
	-commands_file_name $_COMMANDS_FILE -files_list_file_name $_FILESTOBECOPIED_FILE \
	-files_size_file_name $_FILESTOBECOPIEDSIZE_FILE -files_directory $_FILETOBECOPIED_DIR $_WS_TREE_OPT
rc=$?
[ $rc -ne 0 ] && Out 3 "ADLDiffImageContents is KO"

# ----------------------------------------------------------------------
# On transfere les fichiers necessaires
# ----------------------------------------------------------------------
if [ -s $_FILESTOBECOPIED_FILE ]
then
	OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
	[ ! -z "$_R_IMAGE" ] && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
	[ ! -z "$_R_BASE" ] && OPTIONS="$OPTIONS -rb $_R_BASE"
	[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
	OPTIONS="$OPTIONS -f $_FILESTOBECOPIED_FILE -rtmp $_R_TMP -ltmp $_FILETOBECOPIED_DIR"
	$ShellDir/adl_file_transfer.sh $OPTIONS -lwd $_ADL_WORKING_DIR -ltd $_ADL_TRACE_DIR
	rc=$?
	[ $rc -ne 0 ] && Out 3 "adl_file_transfer.sh is KO"
fi

# ----------------------------------------------------------------------
# On s'occupe des attributs de la base
# ----------------------------------------------------------------------
if [ -s $_DB_ATTR ]
then
	_UPDATE_DB_ATTR_TRACES=$_ADL_TRACE_DIR/adl_update_database_attributes
	$ShellDir/adl_update_database_attributes.sh -a $_DB_ATTR -p $_DB_ATTR_REF 2>&1 > $_UPDATE_DB_ATTR_TRACES 
	rc=$?
	if [ $rc -ne 0 ] 
	then
		cat "$_UPDATE_DB_ATTR_TRACES"
		Out 3 "adl_update_database_attributes.sh is KO"
	fi
fi

# ----------------------------------------------------------------------
# On execute les commandes pour mettre a jour l'espace local
# ----------------------------------------------------------------------
if [ -f $_COMMANDS_FILE ]
then
	_COMMAND_RESULT_FILE=$_ADL_TRACE_DIR/0trace_adl_interpret_commands
	unset OPTIONS
	[ ! -z "$_SIMUL" ] && OPTIONS="-simul" 
	[ ! -z "$_TRACE_ADL_CMD" ] && OPTIONS="$OPTIONS -verbose" 

	$ShellDir/adl_interpret_commands.sh -c $_COMMANDS_FILE -v $_COMMANDS_VERSION -r $_RECOVERY_FILE -t $_COMMAND_RESULT_FILE $OPTIONS
	rc=$?
	if [ $rc -ne 0 ] 
	then
		Out 3 "adl_interpret_commands.sh is KO"
	fi
	echo "All Adele commands have been successfully performed"
else
	sort  -T "$_L_TMP" -o $_LSOUT_CURRENT2 $_LSOUT_CURRENT2 
	sort  -T "$_L_TMP" -o $_LSOUT_REF2 $_LSOUT_REF2
	/bin/cmp -s $_LSOUT_CURRENT2 $_LSOUT_REF2
	rc=$?
	if [ $rc -eq 0 ]
	then
		CurrentDate=$($ShellDir/adl_get_current_date.sh)
		echo "____________________________________________________________"
		echo "$CurrentDate - Launch Adele commands in local workspace"
		echo "There was no differences since the last transfer. No Adele commands have been run"
	else
		Out 3 "Horror !! There is some differences between the last and the current file list and no command file has been created. Contact you Adele administrator"
	fi
fi

# ----------------------------------------------------------------------
# On valide les lsout si on n'est pas en mode de simulation
# ----------------------------------------------------------------------
[ -z "$_SIMUL" ] && ValidateLSOUT

# On move le fichier des commandes dans le repertoire des traces
if [ -f $_COMMANDS_FILE ] 
then
	CommandFileName=$(basename $_COMMANDS_FILE)
	mv $_COMMANDS_FILE $_ADL_TRACE_DIR/$CommandFileName
fi
# ----------------------------------------------------------------------
# On impose une photo de l espace local
# ----------------------------------------------------------------------
_TRACE_PHOTO=$_ADL_TRACE_DIR/0trace_adl_photo_local_ws2
OPTIONS="-l_photo"
[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_PHOTO 2>&1
rc=$?
cat "$_TRACE_PHOTO"
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"

# ----------------------------------------------------------------------
# On compare l'arborescence de fichier de l'espace local et de l'espace distant
# ----------------------------------------------------------------------
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Comparing remote and local filetree"

# On cree la lsout de l'espace local
# - - - - - - - - - - - - - - - - - -
echo "\n>>> Creating local filelist..."
$ShellDir/adl_create_lsout.sh -f $_LSOUT_LOCAL1 -s "$_FIELD_SEP" > $_ADL_TRACE_DIR/0trace_create_local_lsout.txt 2>&1
rc=$?
if [ $rc -ne 0 ] 
then
	cat $_ADL_TRACE_DIR/0trace_create_local_lsout.txt
	Out 3 "adl_create_lsout.sh to generate local lsout is KO"
fi

# On filtre avec les frameworks passes eventuellement en argument
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ ! -z "$_FW_FILTER_CURRENT" -a -f "$_FW_FILTER_CURRENT" ]
then
	# Filtre
	echo "\n>>> Filtering local filelist..."
	fgrep -f $_FW_FILTER_CURRENT $_LSOUT_LOCAL1 >$_LSOUT_LOCAL2
else
	# Pas de filtre mais l'espace de destination peut contenir plus de frameworks que l'espace source
	# alors on filtre sur la liste des frameworks source
	export _FW_LOCAL_FILTER=$_ADL_WORKING_DIR/0FwList.local.filtered
	$_AWK -F "$_FIELD_SEP" '\
		($2 == "FRAMEWORK") \
		{
			print FS $1 FS;
			print FS $1 "/";
		}' $_COMP_LIST_CURRENT2 > $_FW_LOCAL_FILTER
	
	echo "\n>>> Filtering local filelist..."
	fgrep -f $_FW_LOCAL_FILTER $_LSOUT_LOCAL1 >$_LSOUT_LOCAL2
	\rm -f $_FW_LOCAL_FILTER
fi

# On calcule les differences
# - - - - - - - - - - - - - -
echo "\n>>> Calculating differences between remote and local filelist..."
_LSOUT_ONLY_CURRENT=0DiffLsout.OnlyInCurrent
_LSOUT_ONLY_LOCAL=0DiffLsout.OnlyInLocal
_LSOUT_DIFF_FILES=0DiffLsout.SameFilesWithDiffAttributes
_LSOUT_COMMON_FILES=0DiffLsout.CommonFileList
\rm -f $_LSOUT_ONLY_CURRENT $_LSOUT_ONLY_LOCAL $_LSOUT_DIFF_FILES $_LSOUT_COMMON_FILES

StartADLDiffImageContents -reference_outlist $_LSOUT_CURRENT2 -current_outlist $_LSOUT_LOCAL2 -sep "$_FIELD_SEP" \
	-only_ref $_LSOUT_ONLY_CURRENT -only_current $_LSOUT_ONLY_LOCAL \
	-diff_files $_LSOUT_DIFF_FILES -files_list_file_name $_LSOUT_COMMON_FILES
rc=$?
[ $rc -ne 0 ] && Out 3 "ADLDiffImageContents to compare $_LSOUT_CURRENT2 and $_LSOUT_LOCAL2 files is KO"

# On affiche le resultats 
# - - - - - - - - - - - - - -
if [ -f $_LSOUT_ONLY_CURRENT -o -f $_LSOUT_ONLY_LOCAL -o -f $_LSOUT_DIFF_FILES ] 
then
	_ADL_DIFF_RESULT=$_L_TMP/_ADL_DIFF_RESULT_$$
	\rm -f $_ADL_DIFF_RESULT
	if [ -f $_LSOUT_ONLY_CURRENT ] 
	then
		echo "\n!!!!!!! Beginning of the list of files which only exist in the workspace: $_R_WS" >> $_ADL_DIFF_RESULT
		cat $_LSOUT_ONLY_CURRENT >> $_ADL_DIFF_RESULT
		echo "!!!!!!! End of the list of files which only exist in the workspace: $_R_WS" >> $_ADL_DIFF_RESULT
	fi
	if [ -f $_LSOUT_ONLY_LOCAL ] 
	then
		echo "\n!!!!!!! Beginning of the list of files which only exist in the workspace: $_L_WS" >> $_ADL_DIFF_RESULT
		cat $_LSOUT_ONLY_LOCAL >> $_ADL_DIFF_RESULT
		echo "!!!!!!! End of the list of files which only exist in the workspace: $_L_WS" >> $_ADL_DIFF_RESULT
	fi
	if [ -f $_LSOUT_DIFF_FILES ] 
	then
		echo "\n!!!!!!! Beginning of the list of files which have same path in both workspaces but have different attributes:" >> $_ADL_DIFF_RESULT
		cat $_LSOUT_DIFF_FILES >> $_ADL_DIFF_RESULT
		echo "!!!!!!! End of the list of files which have same path in both workspaces but have different attributes:" >> $_ADL_DIFF_RESULT
	fi
	cat $_ADL_DIFF_RESULT 
else
	echo "\nNo difference has been found between remote and local filetrees."
fi

[ -f $_LSOUT_ONLY_CURRENT ] && mv $_LSOUT_ONLY_CURRENT $_ADL_TRACE_DIR
[ -f $_LSOUT_ONLY_LOCAL ]   && mv $_LSOUT_ONLY_LOCAL $_ADL_TRACE_DIR
[ -f $_LSOUT_DIFF_FILES ]   && mv $_LSOUT_DIFF_FILES $_ADL_TRACE_DIR
[ -f $_LSOUT_COMMON_FILES ] && mv $_LSOUT_COMMON_FILES $_ADL_TRACE_DIR

# ----------------------------------------------------------------------
# On execute le report de RIs
# ----------------------------------------------------------------------
if [ -z "$_NO_UPDATE_CR" ]
then
	if [ -z "$_FW_LIST_FILENAME" ]
	then
		# Pas de filtre
		_LSOUT_LOCAL_RI2=$_LSOUT_LOCAL_RI1
		_LSOUT_LOCAL_RI_REF2=$_LSOUT_LOCAL_RI_REF1

		_LSOUT_CURRENT_RI2=$_LSOUT_CURRENT_RI1
		_LSOUT_CURRENT_RI_REF2=$_LSOUT_CURRENT_RI_REF1
	fi

	# On prend une copie de la lsout Locale pour etant la lsout d'entree de la gestion des RIs
	# Dans le cas ou la lsout locale de reference pour RI n'existe pas alors on la cree comme etant la meme que celle qui existe actuellement
	# Dans le cas ou la lsout remote de reference pour RI n'existe pas alors on la cree comme etant la meme que celle qui existe actuellement
	cp -pf $_LSOUT_LOCAL1 $_LSOUT_LOCAL_RI1
	[ ! -f $_LSOUT_LOCAL_RI_REF1 ] && cp -pf $_LSOUT_LOCAL_RI1 $_LSOUT_LOCAL_RI_REF1
	[ ! -f $_LSOUT_CURRENT_RI_REF1 ] && cp -pf $_LSOUT_CURRENT1 $_LSOUT_CURRENT_RI_REF1

	if [ "$_LSOUT_LOCAL_RI2" != "$_LSOUT_LOCAL_RI1" ]
	then
		cp -pf $_LSOUT_LOCAL2 $_LSOUT_LOCAL_RI2
		[ ! -f $_LSOUT_LOCAL_RI_REF2 ] && cp -pf $_LSOUT_LOCAL_RI2 $_LSOUT_LOCAL_RI_REF2
		[ ! -f $_LSOUT_CURRENT_RI_REF2 ] && cp -pf $_LSOUT_CURRENT2 $_LSOUT_CURRENT_RI_REF2
	fi

	[ -z "$ADL_FR_CATIA" ] && Out 3 "Cannot start the RI updater process because no ADL_FR_CATIA variable exist"
	[ -z "$ADL_PROJ_IDENT" -a $_L_ADL_VERSION = 5 ] && export ADL_PROJ_IDENT="-"
	_r_base=$_R_BASE
	[ ! -z "$_R_PROJECT" ] && _r_base=$_R_PROJECT
	[ "$_R_TREE" != "-" ] && _r_base=$_R_TREE
	_l_base=$_L_BASE
	[ ! -z "$_L_PROJECT" ] && _l_base=$_L_PROJECT
	[ ! -z "$_L_WS_TREE" ] && _l_base=$_L_WS_TREE

	# On calcule les ID des sites remote et local et leur version
	NbLine=0
	_R_SITE_ID=""
	_R_SITE_VERSION=""
	while read line
	do
		let "NbLine = NbLine + 1"
		[ $NbLine -eq 1 ] && _R_SITE_ID=$(echo $line | awk -F"$_FIELD_SEP" '{print $1}')
		[ $NbLine -eq 2 ] && _R_SITE_VERSION=$(echo $line | awk -F"$_FIELD_SEP" '{print $1}')

	done < $_ADL_WORKING_DIR/$_RSITE_ATTR

	[ "$_R_ADL_VERSION" = 5 -a -z "$_R_SITE_ID" ] && Out 3 "No site identifier has been found for the remote site"
	[ -z "$_R_SITE_ID" ] && _R_SITE_ID=NULL_SITE_V3

	[ "$_R_ADL_VERSION" = 5 -a -z "$_R_SITE_VERSION" ] && Out 3 "No site version has been found for the remote site"
	[ -z "$_R_SITE_VERSION" ] && _R_SITE_VERSION=NULL_SITE_VERSION

	if [ "$_L_ADL_VERSION" = 5 ]
	then
		$ADL_USER_PATH/admin/adl_ls_site -program -sep "$_FIELD_SEP" -out $_ADL_WORKING_DIR/0Local.SiteAttributes.txt
		rc=$?
		[ $rc -ne 0 ] && Out 3 "No site identifier has been found for the local site"
		_L_SITE_ID=$(awk -F"$_FIELD_SEP" '{print $1}' $_ADL_WORKING_DIR/0Local.SiteAttributes.txt)
		[ "$_L_ADL_VERSION" = 5 -a -z "$_L_SITE_ID" ] && Out 3 "No site identifier has been found for the local site"

		$ADL_USER_PATH/adl_version -program -sep "$_FIELD_SEP" > $_ADL_WORKING_DIR/0Local.SiteVersionAttributes.txt
		rc=$?
		[ $rc -ne 0 ] && Out 3 "No site version has been found for the local site"
		_L_SITE_VERSION=$(awk -F"$_FIELD_SEP" '{print $1}' $_ADL_WORKING_DIR/0Local.SiteVersionAttributes.txt)
		[ "$_L_ADL_VERSION" = 5 -a -z "$_L_SITE_VERSION" ] && Out 3 "No site version has been found for the local site"
	fi
	[ -z "$_L_SITE_ID" ] && _L_SITE_ID=NULL_SITE_V3
	[ -z "$_L_SITE_VERSION" ] && _L_SITE_VERSION=NULL_SITE_VERSION

	_TRACE_UPDATE_RI=$_ADL_TRACE_DIR/0trace_adl_update_DB_RI
	$ShellDir/adl_update_DB_RI.sh $ADL_FR_CATIA $_R_SITE_ID $_R_SITE_VERSION $_R_WS $_r_base $_L_SITE_ID $_L_SITE_VERSION $_L_WS $_l_base $ADL_PROJ_IDENT $_ADL_WORKING_DIR $_LSOUT_CURRENT1 $_LSOUT_CURRENT2 $_LSOUT_CURRENT_RI_REF1 $_LSOUT_CURRENT_RI_REF2 $_LSOUT_LOCAL_RI2 $_LSOUT_LOCAL_RI_REF2 "$_FIELD_SEP" > $_TRACE_UPDATE_RI 2>&1
	rc_adl_update_DB_RI=$?
	cat $_TRACE_UPDATE_RI

	if [ $rc_adl_update_DB_RI -ne 0 ] 
	then
		# Pour l'instant on ignore l'erreur car parfois elle provient d'un probleme de disponibilite de DB2.
		echo "adl_update_DB_RI.sh is KO"
	else
		# L'update s'est fait correctement alors on valide les lsout pour la gestion des RIs
		ValidateLSOUTforRI
	fi
fi

# ----------------------------------------------------------------------
# On promeut les modifications realisees dans l espace local
# ----------------------------------------------------------------------
_PROMOTED_OBJECTS_FILE=$_ADL_TRACE_DIR/0PromotedObjects
OPTIONS=" -f $_PROMOTED_OBJECTS_FILE"
[ ! -z "$_L_PUBLISH" ]	&& OPTIONS="$OPTIONS -l_publish"
[ ! -z "$_L_PROMOTE" ]	&& OPTIONS="$OPTIONS -l_promote"
[ ! -z "$_L_PROMOTE_LIST" ] && OPTIONS="$OPTIONS $_L_PROMOTE_LIST"
if [ ! -z "$_L_CR_LIST" ] 
then
	OPTIONS="$OPTIONS -cr $_L_CR_LIST"
else
	OPTIONS="$OPTIONS -cr_transfer"
fi
[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"

_TRACE_PROMOTE=$_ADL_TRACE_DIR/0trace_adl_promote_local_ws
$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_PROMOTE
rc=$?
cat $_TRACE_PROMOTE
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh is KO"

# ----------------------------------------------------------------------
# On sort avec un code retour a 0 sauf dans le cas ou adl_update_DB_RI s'etait plante
# ----------------------------------------------------------------------
if [ $rc_adl_update_DB_RI -ne 0 ]
then
	Out 5 "IR transfer FAILED but promotion has been done. Restart at least one data transfer to transfer IR."
fi

Out 0
