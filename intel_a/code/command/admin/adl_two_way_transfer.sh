#!/bin/ksh

[ ! -z "$ADL_DEBUG" ] && set -x

FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

CmdLine="$@"
# =====================================================================
Usage="$ShellName -tid TransferId [-mail [addr...]] [-http HttpServer] [-simul] [-trace_adl_cmd]
		[-keep_trace n] -rhost RemoteHost 
		-rl AdeleLevel -rp AdeleProfile -rb Base [-rproj Project] -rw Ws [-rtree tree_mk_fw] [-rimage image] -rtmp TmpDir -rmaint
	[-ru username]
        -ll AdeleLevel -lp AdeleProfile -lb Base [-lproj Project] -lw Ws [-ltree tree_mk_fw] [-limage image] -ltmp TmpDir 
        [-r_collect] [-r_sync] [-r_publish] [-r_promote] 
        [-l_collect WSi ... ] [-l_sync] [-l_publish] [-l_promote WSi ... ] [-l_cr CRi ... ]
		[-no_update_cr]
		[-keep_trace n]
        [-r_TransferToolProfile]
        [-display display]
		[-first_transfer_by_push]

Global parameters:
-tid TransferId  : TransferId (example: ENO, DSA, DSP, ...
-mail [addr...]  : Results will be sent by mail to the specified addresses; if no address is specified, the mail will be sent to people declared in \$MAIL_ADDR_LIST list
     (example: export MAIL_ADDR_LIST=\"ygd@soleil apa@soleil\")
-http HttpServer : Address of the http server being able to display generated HTML pages
             (example: http://herrero:8016)
-simul           : To simulate the data transfer. Adele command will be displayed but won't be launched
                   Note that local or distant collect/sync/promote commands will be performed
-trace_adl_cmd   : To display Adele command traces on terminal
-keep_trace n    : Number of trace directories to keep; the trace directories are created into the local workspace directory ws_dir
    Adele V3: <ws_dir>/.Adele/MultiSite/<TransferId>/Tracexxx
    Adele V5: <ws_dir>/ToolsData/MultiSite/<TransferId>/Tracexxx

REMOTE parameters of the data transfer:
-rhost RemoteHost: Remote host name (example: centaur.deneb.com)
-rl AdeleLevel   : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp AdeleProfile : Path of the Adele profile to find Adele installation
-rb Base         : Base in Adele V3, TCK in Adele V5
-rw Ws           : Workspace name
-rimage image    : Remote workspace image name (for ADLV5 purpose only)
-rtree tree_mk_fw: Workspace tree for the new frameworks (mandatory for 2way transfers and for Adele V5 workspace)
-rproj Project   : Project in base (For Adele V3 test purpose only)
-rmaint          : Maintenance mode is activated on base
-rtmp TmpDir     : Temporary directory to store file to be copied (or received)
-ru username     : login name of remote workspace owner

-r_photo         : To check-in all files and freeze the remote workspace BEFORE the transfer
-r_collect       : To collect remote workspace
-r_sync          : To synchronize remote workspace
-r_publish       : To publish remote workspace
-r_promote       : To publish and promote remote workspace

-r_TransferToolProfile: path to the profile to execute to access transfer tools

LOCAL parameters of the data transfer:
-ll AdeleLevel   : Level of local Adele tool ('3' for Adele V3 and '5' for Adele V5)
-lp AdeleProfile : Path of the Adele profile to find Adele installation
-lb Base         : Base in Adele V3, TCK in Adele V5
-lw Ws           : Workspace name
-limage image    : Local workspace image name (for ADLV5 purpose only)
-ltree tree_mk_fw: Workspace tree for the new frameworks (mandatory for Adele V5 workspace)
-lproj Project   : Project in base (For Adele V3 test purpose only)
-C               : Maintenance mode is activated on base
-ltmp TmpDir     : Temporary directory to store file to be copied (or received)

-l_collect WSi ... : To run adl_collect into the local workspace BEFORE its synchronization and for all promoted workspace or only for the specified ones
-l_sync          : To synchronize the local workspace (MANDATORY for 2 way transfer)
-l_publish       : To publish local workspace AFTER the transfer
-l_promote WSi...: To publish and promote local workspace to the parent workspace in Adele V3 or to the specified workspace(s) in Adele V5
-l_cr CRi...     : To precise change request number list with local workspace promotion
-no_update_cr    : To disconnect update change request phase

-first_transfer_by_push: only for the first transfer if all data exist only in local site 
                         and must be sent to the remote site.

-display <display>: To specify a screen in case of merging files
"
# =====================================================================
export _L_HOST=$(uname -n)

export DISPLAY=${DISPLAY:-0:0}

OS=$(uname -s)
case $OS in
	AIX)					
		OS_INST=aix_a
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		RSH="/usr/bin/rsh"
		;;
	HP-UX)
        case `uname -r|cut -c3-` in
        10.*)
           OS_INST=hpux_a
           ;;
        11.*)
           OS_INST=hpux_b
           ;;
        esac
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		RSH="/bin/remsh"
		;;
	IRIX | IRIX64)
		OS_INST=irix_a
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		RSH="/usr/bsd/rsh"
		;;
	SunOS)
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
		# On met en rouge (si erreur) la derniere etape du transfert dans le fichier de suivi html
		[ $# -ge 1 ] && update_tracking_html $_last_transfer_step fail $_last_transfer_step_info
		[ $# -eq 9999 ] && update_tracking_html $_last_transfer_step interrupt $_last_transfer_step_info

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
		mv $TempTraceDir/* $_ADL_TRACE_DIR 2>/dev/null
		\rm -rf $TempTraceDir
	fi

	# On recopie le suivi html dans _ADL_TRACE_DIR
	[ ! -z "$ADL_MULTISITE_LOG_DIR" ] && cp -pf $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.htm $_ADL_TRACE_DIR

	if [ "$_SENDMAIL" = "TRUE" -a ! -z "$MAIL_ADDR_LIST" ] 
	then
		tmpfile=/tmp/envoi_$$
		echo "\nBeginning of the transfer (Paris time): $BeginTransferDate \n" >$tmpfile
		echo "How the source data exchange went: \n" >>$tmpfile

		if [ $ExitCode -le 2 ]
		then
			Status=SUCCESSFUL
			TITLE="Data transfer ($_TID,$_R_BASE) -> DS: successful"
			echo "Operation is: OK\n" >>$tmpfile
		elif [ $ExitCode -eq 9999 ]
		then
			Status=INTERRUPTED
			TITLE="Data transfer ($_TID,$_R_BASE) -> DS: interrupted"
			echo "Operation is: INTERRUPTED\n" >>$tmpfile
		else
			Status=FAILED
			TITLE="Data transfer ($_TID,$_R_BASE) -> DS: failed"
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

		if [ $ExitCode -le 2 ] 
		then
			# on ajoute la liste des fichiers recus du site distant
			echo "\n\nHere's what has been transfered from $_R_WS to $_L_WS:" >> $tmpfile
			if [ -f "$_FILESTOBECOPIED_FILE" -a -s "$_FILESTOBECOPIED_FILE" ]
			then
				cat "$_FILESTOBECOPIED_FILE" >> $tmpfile
			else
				echo "<nothing>" >> $tmpfile
			fi
			echo "\nHere's what has been transfered from $_L_WS to $_R_WS:" >> $tmpfile
			if [ -f "$_LOCAL_FILESTOBECOPIED_FILE" -a -s "$_LOCAL_FILESTOBECOPIED_FILE" ]
			then
				cat "$_LOCAL_FILESTOBECOPIED_FILE" >> $tmpfile
			else
				echo "<nothing>" >> $tmpfile
			fi
			if [ -f "$_PROMOTED_OBJECTS_FILE" -a -s "$_PROMOTED_OBJECTS_FILE" ]
			then
				echo "\nHere's what have been promoted to the parent workspace:" >> $tmpfile
				echo "${_HTTP_SERVER}$_PROMOTED_OBJECTS_FILE" >> $tmpfile
			fi
			echo >> $tmpfile
			echo >> $tmpfile
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

		if [ ! -z "$_HTTP_SERVER" ]
		then
			[ ! -z "$ADL_MULTISITE_LOG_DIR" ] && echo "\nUse this link to access information about transfer steps: ${_HTTP_SERVER}${_ADL_TRACE_DIR}/suivi_${_TID}.htm" >> $tmpfile

			if [ ! -z "$BilanHtml" ]
			then
				echo "\nUse this link to access all trace files related to this transfer: ${_HTTP_SERVER}${BilanHtml}" >> $tmpfile
			fi
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

SaveLocalLsout()
{
	if [ ! -z "$ADL_MULTISITE_LOG_DIR" ]
	then
		# On sauvegarde quelque part les lsout de reference, au cas ou on les perdrait
		if [ ! -d $ADL_MULTISITE_LOG_DIR/SaveLsoutReference ]
		then
			mkdir $ADL_MULTISITE_LOG_DIR/SaveLsoutReference
			chmod 777 $ADL_MULTISITE_LOG_DIR/SaveLsoutReference
		fi
		cp -p $_LSOUT_LOCAL_REF1 $ADL_MULTISITE_LOG_DIR/SaveLsoutReference/$_LSOUT_LOCAL_REF1.$_TID 2>/dev/null
	fi 
}

SaveRemoteLsout()
{
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
# ValidateLocalLSOUT function -> lsout of local workspace
# =====================================================================
ValidateLocalLSOUT()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	
	if [ -z "$_SIMUL" ]
	then
		cp -p $_LSOUT_LOCAL_CURRENT1 $_LSOUT_LOCAL_REF1
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate file list from (local) CURRENT to (local) REFERENCE: $_LSOUT_LOCAL_CURRENT1 / $_LSOUT_LOCAL_REF1"
		fi

		SaveLocalLsout
	else
		echo "Simulation mode: no validation on out lists"
	fi
}

# =====================================================================
# ValidateRemoteLSOUT function -> lsout of remote workspace
# =====================================================================
ValidateRemoteLSOUT()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	
	if [ -z "$_SIMUL" ]
	then
		cp -p $_LSOUT_CURRENT1 $_LSOUT_REF1
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate file list from CURRENT to REFERENCE: $_LSOUT_CURRENT1 / $_LSOUT_REF1"
		fi

		cp -p $_DB_ATTR $_DB_ATTR_REF
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate database attribute files from CURRENT to REFERENCE: $_DB_ATTR / $_DB_ATTR_REF"
		fi

		SaveRemoteLsout
	else
		echo "Simulation mode: no validation on out lists"
	fi
}

# =====================================================================
# ValidateLSOUTforRI function
# =====================================================================
ValidateLSOUTforRI()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	
	if [ -z "$_SIMUL" ]
	then
		cp -pf $_LSOUT_LOCAL_RI1 $_LSOUT_LOCAL_RI_REF1
		if [ $? -ne 0 ]
		then
		Out 3 "Cannot validate LOCAL file list for RI from CURRENT to REFERENCE: $_LSOUT_LOCAL_RI1 / $_LSOUT_LOCAL_RI_REF1"
		fi

		cp -pf $_LSOUT_REF1 $_LSOUT_CURRENT_RI_REF1
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot validate CURRENT file list for RI from CURRENT to REFERENCE: $_LSOUT_REF1 / $_LSOUT_CURRENT_RI_REF1"
		fi
	else
		echo "Simulation mode: no validation on out lists"
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
unset _R_BASE
unset _R_PROJECT
unset _R_WS_TREE
unset _R_WS
unset _R_IMAGE
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_MAINT
unset _R_PHOTO
unset _R_COLLECT
unset _R_SYNC
unset _R_PUBLISH
unset _R_PROMOTE
unset _R_TMP
unset _R_USER

unset _L_BASE
unset _L_PROJECT
unset _L_WS
unset _L_IMAGE
unset _L_WS_TREE
unset _L_ADL_VERSION
unset _L_ADL_PROFILE
unset _L_MAINTENANCE
unset _L_SYNC
unset _L_COLLECT
unset _L_COLLECT_LIST
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

unset _FIRST_TRANSFER_BY_PUSH

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
		-rtree ) #-------------------> REMOTE WORKSPACE TREE for adl_mk_fw
			CheckOptArg "$1" "$2"
			_R_WS_TREE=$2
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
		-ru ) #-------------------> REMOTE LOGIN NAME
			CheckOptArg "$1" "$2"
			_R_USER="$2"
			shift 2
			;;

		-fw ) #----------------> OPTIONAL: Framework list
			#########################################################
			# INTERDICTION DE FILTRER POUR UN REPORT BIDIRECTIONNEL
			Out 3 "It is not allowed to filter on frameworks when sharing frameworks between 2 sites"
			;;

		-lfw ) #----------------> OPTIONAL: filename of Framework list
			#########################################################
			# INTERDICTION DE FILTRER POUR UN REPORT BIDIRECTIONNEL
			Out 3 "It is not allowed to filter on frameworks when sharing frameworks between 2 sites"
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
		-l_sync ) #--------------> OPTIONAL: LOCAL SYNCHRONISATION
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
		-display ) #-------------------> DISPLAY OPTIONAL
			CheckOptArg "$1" "$2"
			DISPLAY=$2
			shift 2
			xset -display $DISPLAY q >/dev/null 2>&1
            rc=$?
			if [ $rc -ne 0 ]
			then
				Out 3 "The display value is not valid: $DISPLAY"
			fi
			;;
		-first_transfer_by_push) #----------> OPTIONAL: FOR FIRST TRANSFER ONLY AND FROM IF DATA ARE SENT FROM LOCAL TO REMOTE WS
			_FIRST_TRANSFER_BY_PUSH=TRUE
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

# Le report bi-directionnel ne fonctionne que si l'espace de report local
# est gere par ADELE V5
if [ $_L_ADL_VERSION != 5 ]
then
	echo "WARNING : $ShellName: two-ways transfer works only with ADELE V5 on local site." 1>&2
	#Out 3 "Transfer failed"
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
Beginning of the transfer: $BeginTransferDate"
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
Transfer is to be done from (1) to (2)
  (1) server: $_R_HOST
      id    : $_TID
      base  : $_r_base
      ws    : $_R_WS"
[ ! -z "$_R_USER" ] && echo "      user  : $_R_USER"
echo "
 
  (2) base  : $_l_base
      ws    : $_L_WS
 
And...
  SENDMAILTO  : $MAIL_ADDR_LIST
  SENDMAIL    : $_SENDMAIL
____________________________________________________________
"
}


# Copie de la trame de suivi html depuis l'installation vers le repertoire de travail
unset _last_transfer_step
if [ ! -z "$ADL_MULTISITE_LOG_DIR" ] 
then
	\rm -f $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.htm
	if [ -f $ShellDir/trame_suivi.txt ] 
	then	
		cp -p $ShellDir/trame_suivi.txt $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt
		chmod 777 $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt
	fi
fi

# ===========================================================
# Mise a jour du suivi HTML
# ===========================================================
# $1 = cle de tache
# $2 = 'start', 'end', 'fail' ou 'interrupt'
# $3 = fichier de traces (optionnel)

update_tracking_html()
{
	[ -z "$ADL_MULTISITE_LOG_DIR" ] && return 0

	_last_transfer_step=$1
 	_last_transfer_step_info=$3
	
	_current_step_info=$3
	[ -z "$3" ] && _current_step_info="-"

	if [ -f $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt ]
	then
		if [ $2 = "start" ]
		then
			$ShellDir/adl_generate_html.sh $1 o $_current_step_info $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt > $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.tmp
		elif [ $2 = "end" ]
		then
			[ ! -f $_current_step_info ] && _current_step_info="-"
			$ShellDir/adl_generate_html.sh $1 g $_current_step_info $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt > $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.tmp
		elif [ $2 = "fail" ]
		then
			$ShellDir/adl_generate_html.sh $1 r $_current_step_info $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt > $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.tmp
		elif [ $2 = "interrupt" ]
		then
			$ShellDir/adl_generate_html.sh $1 i $_current_step_info $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt > $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.tmp
		else 
			echo "##ERROR in update_tracking_html: unknown status: $2"
			$ShellDir/adl_generate_html.sh $1 r $_current_step_info $ADL_MULTISITE_LOG_DIR/trame_suivi_${_TID}.txt > $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.tmp
		fi
	fi
	mv -f $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.tmp $ADL_MULTISITE_LOG_DIR/suivi_${_TID}.htm
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
<b>Html report of data transfer from ($_R_SITE,$_R_BASE) --> <font color=$color>$Status</font></b>
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
</table>
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

update_tracking_html init start

# ----------------------------------------------------------------------
# Nettoyage de l'environnement Adele 3.2, V5, Tck (pas mkmk, quand meme...)
# ----------------------------------------------------------------------
[ ! -f "$ShellDir/adl_transfer_clean_env.sh" ] && Out 3 "adl_transfer_clean_env.sh not found"
. "$ShellDir/adl_transfer_clean_env.sh"


# =====================================================================
# Lancement des fusions dans l'espace courant
# la fonction rend la main que si plus aucune fusion reste a resoudre
# Les outlists courantes et de reference sont mises a jour 
# =====================================================================

try_solve_merge()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	echo "\n>>> Solving merges in local workspace..."
	echo ">>> DISPLAY=$DISPLAY"
	
	touch $_LOCAL_MERGE_TO_SOLVE

	# Lancement des fusions
	_TRACE_MERGE=$_ADL_TRACE_DIR/0trace_adl_solve_merge_local_ws
	$ShellDir/adl_start_commands_on_local_ws.sh -l_solve_merge 2>&1 | tee -a $_TRACE_MERGE
	[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh -l_solve_merge is KO"

	# On verifie que l'utilisateur a bien resolu toutes les fusions
	$ShellDir/adl_start_commands_on_local_ws.sh -l_ls_merge > $TempTraceDir/trace_ls_merge.$$ 2>&1
	[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh -l_ls_merge is KO"

	# affichage des traces du adl_ls_merge
	grep 'No manual merge to solve' $TempTraceDir/trace_ls_merge.$$ >/dev/null 2>&1
	ResultLsMgr=$?

	# Affichage des fusions restant a resoudre (fichier vide s'il n'y en a pas)
	grep -v 'No manual merge to solve' $TempTraceDir/trace_ls_merge.$$
	[ $ResultLsMgr -ne 0 ] && Out 3 "Cannot continue. Please, solve remaining merges and restart the tool."
	
	# On peut effacer le fichier indiquant la phase de resolution des fusions
	\rm -f $_LOCAL_MERGE_TO_SOLVE
	
	return $?
}

# =====================================================================
# Fonction effectuant les traitements concernant l'espace local
# de report
# =====================================================================
treat_local_workspace()
{

	# On indique le demarrage de la "transaction" inverse pour reprendre au bon endroit
	# en cas de bug ou d'interruption
	if [ ! -f $_REMOTE_RECOVERY_FILE ] 
	then
		touch $_REMOTE_RECOVERY_FILE
	fi
	
	update_tracking_html adelize1 end $_ADL_TRACE_DIR/0trace_adl_interpret_commands

	# ----------------------------------------------------------------------
	# On lance la collecte de l'espace local
	# -> utile si l'espace accepte des promotions depuis l'espace parent 
	#    ou simplement accepte des espaces fils
	# -> le fait d'accepter une promotion depuis l'espace parent permet
	#    d'attacher automatiquement tout nouveau framework puisque c'est une collecte
	# ----------------------------------------------------------------------
	if [ ! -z "$_L_COLLECT" ]
	then
		_TRACE_COLLECT=$_ADL_TRACE_DIR/0trace_adl_collect_local_ws
		update_tracking_html collect_local start $_TRACE_COLLECT
		OPTIONS="-l_collect $_L_COLLECT_LIST"
		[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"

		$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_COLLECT
		export CollectExitCode=$?
		cat "$_TRACE_COLLECT"
		[ $CollectExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
		update_tracking_html collect_local end $_TRACE_COLLECT
	fi

	# ----------------------------------------------------------------------
	# On lance la synchronisation de l'espace local
	# OBLIGATOIRE pour faire du bi-directionnel
	# ----------------------------------------------------------------------
	if [ ! -z "$_L_SYNC" ]
	then
		echo "\n>>> Starting synchronization in local workspace..."
		_TRACE_SYNCHRO=$_ADL_TRACE_DIR/0trace_adl_sync_local_ws
		update_tracking_html sync start $_TRACE_SYNCHRO
		OPTIONS="-l_sync"
		[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
		$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_SYNCHRO
		export SyncExitCode=$?
		cat "$_TRACE_SYNCHRO"
		[ $SyncExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
		update_tracking_html sync end $_TRACE_SYNCHRO
	fi

	# ----------------------------------------------------------------------
	# On lance la resolution des fusions 
	# ----------------------------------------------------------------------
	update_tracking_html solve_merge start
	try_solve_merge
	update_tracking_html solve_merge end
	
	update_tracking_html diff2 start
	# ----------------------------------------------------------------------
	# On attache les nouveaux modules ou data presents dans 
	# les frameworks deja attaches
	# -> doit etre fait apres 'try_solve_merge()' 
	# car si la synchro a induit des fusions, il n'est pas possible de faire 
	# des attachements tant que les fusions n'ont pas ete resolues
	# ----------------------------------------------------------------------
	echo "\n>>> Attaching new component(s) in local workspace..."
	_TRACE_ATTACH=$_ADL_TRACE_DIR/0trace_adl_attach_local_ws
	update_tracking_html attach start $_TRACE_ATTACH
	OPTIONS="-l_att_mod"
	[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
	$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_ATTACH
	export AttachExitCode=$?
	cat "$_TRACE_ATTACH"
	[ $AttachExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
	update_tracking_html attach end $_TRACE_ATTACH

	# ----------------------------------------------------------------------
	# On cree la lsout courante de l'espace local pour calculer ce qui est apparu
	# - - - - - - - - - - - - - - - - - -
	echo "\n>>> Creating local current filelist..."
	[ -z "$_FIELD_SEP" ] && export _FIELD_SEP="|"
	$ShellDir/adl_create_lsout.sh -f $_LSOUT_LOCAL_CURRENT1 -s "${_FIELD_SEP}" > $_ADL_TRACE_DIR/0trace_create_local_lsout.txt 2>&1
	rc=$?
	if [ $rc -ne 0 ] 
	then
		cat $_ADL_TRACE_DIR/0trace_create_local_lsout.txt
		Out 3 "adl_create_lsout.sh to generate local current lsout is KO"
	else
		# On filtre la lsout sur les fws du tree
		Filter_lsout_on_a_tree $_LSOUT_LOCAL_CURRENT1 $_L_WS_TREE
		[ $? -ne 0 ] && Out 3 "Filtering local lsout 2 KO"
	fi

}

# =====================================================================
# Fonction effectuant le calcul des differences entre la outlist courante et celle de reference
# pour l'espace courant et qui transfere et execute les modifications correspondantes
# sur le site distant
# =====================================================================
transfer_from_local_to_distant()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	update_tracking_html diff2 start
	
	\rm -f $_REMOTE_COMMANDS_FILE $_LOCAL_FILESTOBECOPIED_FILE $_LOCAL_FILESTOBECOPIEDSIZE_FILE
	# On calcule les differences
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# remarque : le separator est force a "|" car 
	#	1. on est sur de travailler localement en ADLV5 puisqu'on fait du bidirectionnel
	#	2. en cas de recovery, la variable _FIELD_SEP n'est pas encore positionnee
	_REMOTE_FILETOBECOPIED_DIR=$_R_TMP/adl_transfer_${_TID}/$ADL_WS

	StartADLDiffImageContents -reference_outlist $_LSOUT_LOCAL_REF1 -current_outlist $_LSOUT_LOCAL_CURRENT1 -sep "|" \
		-outlist_version $_LOCAL_LSOUT_VERSION -commands_version $_REMOTE_COMMANDS_VERSION \
		-commands_file_name $_REMOTE_COMMANDS_FILE -files_list_file_name $_LOCAL_FILESTOBECOPIED_FILE \
		-files_size_file_name $_LOCAL_FILESTOBECOPIEDSIZE_FILE -files_directory $_REMOTE_FILETOBECOPIED_DIR $_REMOTE_WS_TREE_OPT
	rc=$?
	[ $rc -ne 0 ] && Out 3 "ADLDiffImageContents Local is KO"
	update_tracking_html diff2 end

	# On transfere les nouveaux fichiers et les fichiers modifies
	# du site local vers le site distant
	if [ -s $_LOCAL_FILESTOBECOPIED_FILE ]
	then
		update_tracking_html transfer2 start $_ADL_TRACE_DIR/0trace_adl_file_transfer_to_remote.sh_${_TID}
		echo "$_LOCAL_FILESTOBECOPIED_FILE contains files to be transfered to the remote site"
		OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
		[ ! -z "$_R_BASE" ] && OPTIONS="$OPTIONS -rb $_R_BASE"
		[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
		[ ! -z "$_R_USER" ] && OPTIONS="$OPTIONS -ru $_R_USER"
		OPTIONS="$OPTIONS -f $_LOCAL_FILESTOBECOPIED_FILE -rtmp $_REMOTE_FILETOBECOPIED_DIR -ltmp $_FILETOBECOPIED_DIR"
		$ShellDir/adl_file_transfer_to_remote.sh $OPTIONS -lwd $_ADL_WORKING_DIR -ltd $_ADL_TRACE_DIR
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_file_transfer_to_remote.sh is KO"
		update_tracking_html transfer2 end $_ADL_TRACE_DIR/0trace_adl_file_transfer_to_remote.sh_${_TID}
	fi

	# On execute les commandes sur le site distant
	if [ -s $_REMOTE_COMMANDS_FILE ]
	then
		update_tracking_html adelize2 start $_ADL_TRACE_DIR/0trace_adl_interpret_commands_on_remote.sh_${_TID}
		echo "$_REMOTE_COMMANDS_FILE contains commands to execute on remote site"
		OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
		[ ! -z "$_R_BASE" ] && OPTIONS="$OPTIONS -rb $_R_BASE"
		[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
		OPTIONS="$OPTIONS -rtmp $_R_TMP -ltmp $_FILETOBECOPIED_DIR"
		OPTIONS="$OPTIONS -c $_REMOTE_COMMANDS_FILE -v $_REMOTE_COMMANDS_VERSION -r $_REMOTE_RECOVERY_FILE"
		[ ! -z "$_SIMUL" ] && OPTIONS="-simul" 
		[ ! -z "$_TRACE_ADL_CMD" ] && OPTIONS="$OPTIONS -verbose" 
		[ ! -z "$_R_USER" ] && OPTIONS="$OPTIONS -ru $_R_USER" 
		$ShellDir/adl_interpret_commands_on_remote.sh $OPTIONS -lwd $_ADL_WORKING_DIR -ltd $_ADL_TRACE_DIR
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_interpret_commands_on_remote.sh is KO"
		update_tracking_html adelize2 end $_ADL_TRACE_DIR/0trace_adl_interpret_commands_on_remote.sh_${_TID}

		if [ -f $_REMOTE_RECOVERY_FILE ]
		then
			Out 3 "FATAL INTERNAL ERROR: all commands have been executed but the recovery file $_REMOTE_RECOVERY_FILE still exists"
		fi
	fi

	# On valide les lsout de l'espace local
	ValidateLocalLSOUT

	# On supprime le fichier s'il n'y avait rien a executer (sinon deja fait lors de l'execution)
	rm -f $_REMOTE_RECOVERY_FILE

	# On sauvegarde les commandes executees (pour info)
	[ -f $_REMOTE_COMMANDS_FILE ] && cp -pf $_REMOTE_COMMANDS_FILE $_ADL_TRACE_DIR/0CommandsToExecuteOnRemoteSite

}

Get_remote_outlists_and_unlock_ws()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	# ----------------------------------------------------------------------
	# On recalcule les lsout de l'espace distant pour ne pas recuperer
	# dans le prochain report ce qu'on vient de lui envoyer
	# ----------------------------------------------------------------------

	touch $_LAST_STEP_FILE

	# Photo de l'espace distant pour que les outlists soient représentatives des fichiers 
	update_tracking_html photo3 start $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}
	# On calcule les options de lancement pour le site remote
	OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
	[ ! -z "$_R_IMAGE" ]   && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
	[ ! -z "$_R_BASE" ]    && OPTIONS="$OPTIONS -rb $_R_BASE"
	[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
	[ ! -z "$_R_MAINT" ]   && OPTIONS="$OPTIONS -rmaint $_R_MAINT"
	[ ! -z "$_R_USER" ]   && OPTIONS="$OPTIONS -ru $_R_USER"
	$ShellDir/adl_start_commands_on_remote_ws.sh $OPTIONS -r_photo -ltd $_ADL_TRACE_DIR
	rc=$?
	if [ $rc -ne 0 ] 
	then
		Out 3 "adl_start_commands_on_remote_ws.sh -r_photo is KO"
	else
		mv $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID} $_ADL_TRACE_DIR/0trace_adl_photo_on_remote_ws.sh_${_TID}.2
	fi
	update_tracking_html photo3 end $_ADL_TRACE_DIR/0trace_adl_photo_on_remote_ws.sh_${_TID}.2

	# On recupere a nouveau les outlists que si quelque chose a ete envoye vers le site distant
	if [ -s $_REMOTE_COMMANDS_FILE ]
	then

		update_tracking_html get_data2 start $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID}

		# ----------------------------------------------------------------------
		# On recalcule la liste des frameworks, modules, data et fichiers de l espace distant
		# de facon a ce qu'on vient d'envoyer ne reviennent pas au report suivant
		# ----------------------------------------------------------------------

		OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
		[ ! -z "$_R_BASE" ]    && OPTIONS="$OPTIONS -rb $_R_BASE"
		[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
		[ ! -z "$_R_MAINT" ]   && OPTIONS="$OPTIONS -rmaint $_R_MAINT"
		[ ! -z "$_R_USER" ]   && OPTIONS="$OPTIONS -ru $_R_USER"
		$ShellDir/adl_get_remote_lists.sh $OPTIONS -f $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 -a $_ADL_WORKING_DIR/$_DB_ATTR -c $_ADL_WORKING_DIR/$_COMP_LIST_CURRENT1 -rsiteattr $_ADL_WORKING_DIR/$_RSITE_ATTR -ltd $_ADL_TRACE_DIR -rtmp $_R_TMP -s "${_FIELD_SEP:-|}"
		rc=$?
		if [ $rc -ne 0 ]
 		then
			Out 3 "adl_get_remote_lists.sh is KO"
		else
			mv $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID} $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID}.2
		fi

		if [ ! -z "$_R_WS_TREE" ]
		then
			# On filtre la lsout sur les fws du tree distant
			Filter_lsout_on_a_tree $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 $_R_WS_TREE
			[ $? -ne 0 ] && Out 3 "Filtering remote lsout KO"
		fi

		# On valide les lsout du site distant
		ValidateRemoteLSOUT

		update_tracking_html get_data2 end $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID}.2
	fi

	update_tracking_html unlock_ws start $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}
	# On calcule les options de lancement pour le site remote
	OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
	[ ! -z "$_R_IMAGE" ]   && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
	[ ! -z "$_R_BASE" ]    && OPTIONS="$OPTIONS -rb $_R_BASE"
	[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
	[ ! -z "$_R_MAINT" ]   && OPTIONS="$OPTIONS -rmaint $_R_MAINT"
	[ ! -z "$_R_USER" ]   && OPTIONS="$OPTIONS -ru $_R_USER"
	$ShellDir/adl_start_commands_on_remote_ws.sh $OPTIONS -r_publish -r_unlock_req -ltd $_ADL_TRACE_DIR
	rc=$?
	if [ $rc -ne 0 ] 
	then
		Out 3 "adl_start_commands_on_remote_ws.sh -r_publish -r_unlock_req is KO"
	else
		mv $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID} $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}.2
	fi

	rm -f $_LAST_STEP_FILE

	update_tracking_html unlock_ws end $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}.2
}

# ----------------------------------------------------------------------
# On vire de la lsout recue en entree toutes informations
# qui ne concernent pas un framework de l'arborescence courante
# ----------------------------------------------------------------------

Filter_lsout_on_a_tree()
{
	[ ! -z "$ADL_DEBUG" ] && set -x

	# $1 = outlist $2 = tree_name
	_treename=$2
	_FILTERED_OUTLIST=${1}.$$

	# Filtre
	_FW_LIST_REF_FILENAME=$_L_TMP/FW_LIST_REF_$$
	rm -f $_FW_FILTER_CURRENT $_FW_LIST_REF_FILENAME
	touch $_FW_FILTER_CURRENT $_FW_LIST_REF_FILENAME

	_R_FW_LIST=$_L_TMP/FwList_$$
	$_AWK -F "$_FIELD_SEP" '{if ($5 == "FRAMEWORK" && $7 == "'$_treename'") print $3}' $1 | sort -T "$_L_TMP" -u  > $_R_FW_LIST
	$_AWK -F "$_FIELD_SEP" '{if ($5 == "FRAMEWORK" && $7 == "'$_treename'") print $4}' $1 | sort -T "$_L_TMP" -u  >> $_R_FW_LIST
	# on prend les 2 champs pour traiter le renommage de frameworks
	sort -T "$_L_TMP" -u $_R_FW_LIST > ${_R_FW_LIST}.2
	# On filtre sur la liste calculee des frameworks
	while read fw remainder
	do
		[ ! -z "$remainder" ] && Out 3 "File containing the framework list must have one framework per line (file: $_FW_LIST_FILENAME)"
		echo "${_FIELD_SEP}${fw}${_FIELD_SEP}" >>$_FW_FILTER_CURRENT
		echo "${_FIELD_SEP}${fw}/" >>$_FW_FILTER_CURRENT
				
		# On recherche ce framework dans la lsout de reference par son id au cas ou il aurait change de nom
		FwId=$($_AWK -F "$_FIELD_SEP" '($4 == "'$fw'") && ($5 == "FRAMEWORK") {print $1}' $1)
		NbFw=$(echo $FwId | wc -w)
		[ $NbFw -gt 1 ] && Out 3 "Find more than only one framework: $fw in file $1"
		if [ $NbFw -eq 1 ]
		then
			export FwIdERE=$(echo "$FwId" | sed 's/+/\\+/g') # Histoire de supporter les Id V5 dans awk : le + = 1 ou n occurences
			FwRef=$($_AWK -F "$_FIELD_SEP" '/^'$FwIdERE'/ && ($5 == "FRAMEWORK") {print $3}' $1)
			NbFw=$(echo $FwRef | wc -w)
			[ $NbFw -gt 1 ] && Out 3 "Find more than only one framework: $FwId in file $1"
			if [ $NbFw -eq 1 ]
			then
				echo "${_FIELD_SEP}${FwRef}${_FIELD_SEP}" >>$_FW_FILTER_CURRENT
				echo "${_FIELD_SEP}${FwRef}/" >>$_FW_FILTER_CURRENT
				echo $FwRef >> $_FW_LIST_REF_FILENAME
			fi
		fi
	done < ${_R_FW_LIST}.2

	fgrep -f $_FW_FILTER_CURRENT $1 >$_FILTERED_OUTLIST
	chmod 777 $1
	mv -f $_FILTERED_OUTLIST $1
	return $?
}

# ----------------------------------------------------------------------
# On demarre
# ----------------------------------------------------------------------
if [ $_L_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	export ADLTTY=$_TID
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
	export _ADL_WS_ROOT_DIR=$ADL_W_DIR

	_LOCAL_COMMANDS_VERSION=3
	_LOCAL_LSOUT_VERSION=3

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
	adl_ch_ws $OPTIONS -no_ds </dev/null || Out 3 "adl_ch_ws $OPTIONS KO"

	# On value le repertoire de travail des transferts
	export _ADL_WORKING_DIR=$ADL_IMAGE_DIR/ToolsData/MultiSite/$_TID
	export _ADL_WS_ROOT_DIR=$ADL_IMAGE_DIR

	_LOCAL_COMMANDS_VERSION=5
	_LOCAL_LSOUT_VERSION=5

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown _L_ADL_VERSION in $ShellName: $_L_ADL_VERSION"
fi

trap 'Out 9999 "Command interrupted" ' HUP INT QUIT TERM

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
	env | sort -T "$_L_TMP"
	echo "---------------- End of environment -----------------"
fi
# ------------------------------------------------------------
# Avant de commencer un report on verifie qu'il n'y en aurait pas
# deja un qui tournerait deja
# ------------------------------------------------------------
_ADL_CURRENT_DATA_TRANSFER="0LockCurrentDataTransfer"
if [ -f "$_ADL_CURRENT_DATA_TRANSFER" ]
then
	# Il en existe peut etre deja un. On verifie qu'il existe toujours
	read CurHost CurPid CurDate < $_ADL_CURRENT_DATA_TRANSFER
    if [ ! -z "$CurHost" -a ! -z "$CurPid" ]
	then
		$RSH $CurHost ps -p $CurPid -f | grep "$ShellName" > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			Out 3 "A running data transfer already exists on host: $CurHost with pid: $CurPid. It was launched at $CurDate.\nYou have to wait for its termination before starting a new data transfer."
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
	Out 3 "A running data transfer already exists now on host: $CurHost with pid: $CurPid. It was launched at $CurDate.\nYou have to wait for its termination before starting a new data transfer."
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
	_REMOTE_LSOUT_VERSION=3
	_REMOTE_COMMANDS_VERSION=3
elif [ "$_R_ADL_VERSION" = 5 ]
then
	_REMOTE_LSOUT_VERSION=5
	_REMOTE_COMMANDS_VERSION=5
else
	Out 3 "Unknown _R_ADL_VERSION in $ShellName: $_R_ADL_VERSION"
fi
_COMMANDS_FILE=$_ADL_WORKING_DIR/0CommandsToExecuteOnLocalSite
_LOCAL_RECOVERY_FILE=$_ADL_WORKING_DIR/0LocalRecoveryCommands
_LOCAL_MERGE_TO_SOLVE=$_ADL_WORKING_DIR/0MergeToSolve
_REMOTE_COMMANDS_FILE=$_ADL_WORKING_DIR/0CommandsToExecuteOnRemoteSite
_REMOTE_RECOVERY_FILE=$_ADL_WORKING_DIR/0RemoteRecoveryCommands
_LAST_STEP_FILE=$_ADL_WORKING_DIR/0GetRemoteOutlistAndPublishWs
_FILESTOBECOPIED_FILE=$_ADL_TRACE_DIR/0FileListToCopyFromRemote
_FILESTOBECOPIEDSIZE_FILE=$_ADL_TRACE_DIR/0SizeOfFilesToCopyFromRemote
_LOCAL_FILESTOBECOPIED_FILE=$_ADL_TRACE_DIR/0FileListToCopyFromLocal
_LOCAL_FILESTOBECOPIEDSIZE_FILE=$_ADL_TRACE_DIR/0SizeOfFilesToCopyFromLocal
_FILETOBECOPIED_DIR=$_L_TMP/adl_transfer_${_TID}/$ADL_WS

_COMP_LIST_CURRENT1=0CompList.current
_LSOUT_CURRENT1=0Lsout.current
_LSOUT_CURRENT2=0Lsout.current.filtered
_LSOUT_REF1=$_LSOUT_CURRENT1.Reference
_FW_FILTER_CURRENT=0FwFilterCurrent
_FW_FILTER_REF=0FwFilterReference
_LSOUT_LOCAL_CURRENT1=0Lsout.local
_LSOUT_LOCAL_CURRENT2=0Lsout.local.filtered
_LSOUT_LOCAL_REF1=0Lsout.local.Reference
_LOCAL_FW_LIST_REF=0FwList.local.Reference
_LOCAL_FW_LIST=0FwList.local

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

_LOCAL_DB_ATTR=0LocalDatabaseAttributes
_LOCAL_DB_ATTR_REF=$_LOCAL_DB_ATTR.Reference

_RSITE_ATTR=0SiteAttributes.txt

update_tracking_html init end

if [ -f $_LOCAL_RECOVERY_FILE ]
then
	_RECOVERY_RESULT_FILE=$_ADL_TRACE_DIR/0trace_adl_interpret_commands.recovery
	update_tracking_html recovery1 start $_ADL_TRACE_DIR/0trace_adl_interpret_commands.recovery

	# ---------------------------------------------------------------------------
	# Un fichier de recovery existe pour l'espace local alors on joue le recovery 
	# ---------------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "______________________________________________________________________________"
	echo "$CurrentDate - A recovery of a previous command set exist for local workspace."

	if [ ! -f $_COMMANDS_FILE ]
	then
		Out 3 "A local recovery has to be run, but the commands file $_COMMANDS_FILE doesn't exist"
	fi
	if [ ! -d $_FILETOBECOPIED_DIR ]
	then
		Out 3 "A local recovery has to be run, but the files to copy directory $_FILETOBECOPIED_DIR doesn't exist"
	fi

	unset OPTIONS
	if [ ! -z "$_SIMUL" ] 
	then
		echo "A local recovery of a previous data transfer exist, simulation mode is ignored"
		unset _SIMUL
	fi
	[ ! -z "$_TRACE_ADL_CMD" ] && OPTIONS="$OPTIONS -verbose" 
	$ShellDir/adl_interpret_commands.sh -c $_COMMANDS_FILE -v $_LOCAL_COMMANDS_VERSION -r $_LOCAL_RECOVERY_FILE -t $_RECOVERY_RESULT_FILE $OPTIONS
	rc=$?
	if [ $rc -ne 0 ] 
	then
		Out 3 "adl_interpret_commands.sh for local recovery is KO"
	fi

	if [ -f $_LOCAL_RECOVERY_FILE ]
	then
		Out 3 "FATAL INTERNAL ERROR: the recovery has been run, but the recovery file $_LOCAL_RECOVERY_FILE still exists"
	fi

	# On valide les lsout
	ValidateRemoteLSOUT

	# On deplace les commandes executees
	mv $_COMMANDS_FILE $_ADL_TRACE_DIR/0CommandsForRecovery

	update_tracking_html recovery1 end $_ADL_TRACE_DIR/0trace_adl_interpret_commands.recovery
fi

# ----------------------------------------------------------------------
# On teste la ligne du site distant
# ----------------------------------------------------------------------
_TRACE_TEST_LINE=$_ADL_TRACE_DIR/0trace_adl_test_line
update_tracking_html testline start $_TRACE_TEST_LINE

if [ -z "$_R_USER" ]
then
	$ShellDir/adl_test_line.sh -rhost $_R_HOST 2>&1 > $_TRACE_TEST_LINE
else
	$ShellDir/adl_test_line.sh -rhost $_R_HOST -u $_R_USER 2>&1 > $_TRACE_TEST_LINE
fi
export TestLineExitCode=$?
cat "$_TRACE_TEST_LINE"
[ $TestLineExitCode -ne 0 ] && Out 3 "adl_test_line.sh is KO"

update_tracking_html testline end $_TRACE_TEST_LINE

if [ -f $_LOCAL_MERGE_TO_SOLVE ]
then
	update_tracking_html recovery2 start
	# ---------------------------------------------------------------------------
	# Le precedent report etait dans la phase de resolution des fusions 
	# lorsqu'il s'est arrete -> il faut poursuivre ce report
	# ---------------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "______________________________________________________________________________"
	echo "$CurrentDate - The last transfer has stopped while solving merges. It must be finished before starting a new transfer."

	if [ ! -z "$_SIMUL" ] 
	then
		echo "A local recovery of a previous data transfer exist, simulation mode is ignored"
		unset _SIMUL
	fi

	try_solve_merge
	treat_local_workspace
	transfer_from_local_to_distant
	Get_remote_outlists_and_unlock_ws
	
	update_tracking_html recovery2 end

	Out 3 "Due to the recovery step, it is not possible to continue with the current report. You must restart the report."
fi

if [ -f $_REMOTE_RECOVERY_FILE ]
then
	update_tracking_html recovery3 start 
	# ---------------------------------------------------------------------------
	# Un fichier de recovery existe pour l'espace distant
	# -> un precedent report a ete interrompu pendant la phase
	# de report des differences vers l'espace distant, il faut le terminer
	# ---------------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "______________________________________________________________________________"
	echo "$CurrentDate - The last transfer has stopped while transfering changes to $_R_HOST. It must be finished before starting a new transfer."

	if [ ! -z "$_SIMUL" ] 
	then
		echo "A local recovery of a previous data transfer exist, simulation mode is ignored"
		unset _SIMUL
	fi

	treat_local_workspace
	transfer_from_local_to_distant
	Get_remote_outlists_and_unlock_ws
	
	update_tracking_html recovery3 end

	# On ne demarre pas un nouveau report car de toute facon l'espace distant a bloque les promotions
	# il n'y aura donc rien a ramener
	Out 3 "Due to the recovery step, it is not possible to continue with the current report. You must restart the report."
fi

if [ -f $_LAST_STEP_FILE ]
then
	update_tracking_html recovery4 start 
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "______________________________________________________________________________"
	echo "$CurrentDate - The last transfer has stopped while validating transfer from local to remote site. It must be finished before starting a new transfer."

	if [ ! -z "$_SIMUL" ] 
	then
		echo "A local recovery of a previous data transfer exist, simulation mode is ignored"
		unset _SIMUL
	fi

	Get_remote_outlists_and_unlock_ws

	update_tracking_html recovery4 end

	# On ne demarre pas un nouveau report car de toute facon l'espace distant a bloque les promotions
	# il n'y aura donc rien a ramener
	Out 3 "Due to the recovery step, it is not possible to continue with the current report. You must restart the report."
fi

# ----------------------------------------------------------------------
# On impose une photo et un refresh de l'espace local
# ----------------------------------------------------------------------
update_tracking_html photo1 start $_TRACE_PHOTO_REFRESH

_TRACE_PHOTO_REFRESH=$_ADL_TRACE_DIR/0trace_adl_photo_refresh_local_ws
OPTIONS="-l_photo -l_refresh"
[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_PHOTO_REFRESH
rc=$?
cat "$_TRACE_PHOTO_REFRESH"
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
update_tracking_html photo1 end $_TRACE_PHOTO_REFRESH

# ----------------------------------------------------------------------
# On lance la collecte de l espace distant
# ----------------------------------------------------------------------
update_tracking_html collect_ws start $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}
# On calcule les options de lancement pour le site remote
OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
[ ! -z "$_R_IMAGE" ]   && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
[ ! -z "$_R_BASE" ]    && OPTIONS="$OPTIONS -rb $_R_BASE"
[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
[ ! -z "$_R_MAINT" ]   && OPTIONS="$OPTIONS -rmaint $_R_MAINT"
[ ! -z "$_R_USER" ]   && OPTIONS="$OPTIONS -ru $_R_USER"
OPTIONS2="-r_photo -r_collect -r_lock_req"
$ShellDir/adl_start_commands_on_remote_ws.sh $OPTIONS $OPTIONS2 -ltd $_ADL_TRACE_DIR
rc=$?
if [ $rc -ne 0 ]
then
	Out 3 "adl_start_commands_on_remote_ws.sh is KO"
else
	mv $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID} $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}.1
fi
update_tracking_html collect_ws end $_ADL_TRACE_DIR/0trace_adl_start_commands_on_remote_ws.sh_${_TID}.1

# ----------------------------------------------------------------------
# Separateur des champs
# ----------------------------------------------------------------------
if [ $_R_ADL_VERSION = 5 -o $_L_ADL_VERSION = 5 ]
then
	export _FIELD_SEP="|" # Histoire de supporter les chemins avec espaces

	# * Changement eventuel du separateur des champs
	for ref_file in $_LSOUT_REF1 $_LSOUT_LOCAL_REF1 $_LSOUT_LOCAL_RI_REF1 $_LSOUT_CURRENT_RI_REF1
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
update_tracking_html get_data start $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID}

OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
[ ! -z "$_R_IMAGE" ]   && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
[ ! -z "$_R_BASE" ]    && OPTIONS="$OPTIONS -rb $_R_BASE"
[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
[ ! -z "$_R_MAINT" ]   && OPTIONS="$OPTIONS -rmaint $_R_MAINT"
[ ! -z "$_R_USER" ]   && OPTIONS="$OPTIONS -ru $_R_USER"
$ShellDir/adl_get_remote_lists.sh $OPTIONS -f $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 -a $_ADL_WORKING_DIR/$_DB_ATTR -c $_ADL_WORKING_DIR/$_COMP_LIST_CURRENT1 -rsiteattr $_ADL_WORKING_DIR/$_RSITE_ATTR -ltd $_ADL_TRACE_DIR -rtmp $_R_TMP -s "$_FIELD_SEP"
rc=$?
if [ $rc -ne 0 ]
then
	# Code d'erreur OK si option -first_transfer_by_push utilisee
	if [ ! -z "$_FIRST_TRANSFER_BY_PUSH" ]
	then
		echo "### No data is to be got from remote site since it is empty"
		touch $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 
		touch $_ADL_WORKING_DIR/$_DB_ATTR
		touch $_ADL_WORKING_DIR/$_RSITE_ATTR
 		touch $_ADL_WORKING_DIR/$_COMP_LIST_CURRENT1
	else
		Out 3 "adl_get_remote_lists.sh is KO"
	fi
elif [ ! -z "$_FIRST_TRANSFER_BY_PUSH" -a -s $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 ]
then
	Out 3 "Option -first_transfer_by_push cannot be used if something is already managed in remote workspace."
else 
	if [ ! -z "$_R_WS_TREE" ]
	then
		# On filtre la lsout sur les fws du tree distant
		Filter_lsout_on_a_tree $_ADL_WORKING_DIR/$_LSOUT_CURRENT1 $_R_WS_TREE
		[ $? -ne 0 ] && Out 3 "Filtering remote lsout KO"
	fi
fi

mv $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID} $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID}.1

update_tracking_html get_data end $_ADL_TRACE_DIR/0trace_adl_get_remote_lists.sh_${_TID}.1

echo "ENDLSOUT_${_L_BASE}_${_L_WS_TREE}" # -> Pour synchroniser des reports concurrents

update_tracking_html diff1 start
# ----------------------------------------------------------------------
# On traite la liste des fichiers
# ----------------------------------------------------------------------
if [ ! -f $_LSOUT_REF1 ]
then
	if [ ! -z "$_FIRST_TRANSFER_BY_PUSH" ]
	then
		touch $_LSOUT_REF1
	else
		Out 3 "No reference file list has been found: $_LSOUT_REF1 in directory: $_ADL_WORKING_DIR"
		# Charge a l'utilisateur ou a l'administrateur de creer le necessaire.
	fi
else
	# Craderie pour rattraper les doublons DIR_ELEM contenus dans les outlist V3
	sort -T "$_L_TMP" -o $_LSOUT_REF1 -k 4 -t "$_FIELD_SEP" -u $_LSOUT_REF1
fi

# on verifie que les frameworks appartiennent tous a la meme arborescence dans le cas Adele V5
export _R_TREE="-"
if [ "$_R_ADL_VERSION" = 5 ]
then
	_R_TREE_LIST=TreeList_$$
	$_AWK -F "$_FIELD_SEP" '{if ($5 == "FRAMEWORK") print $7;}' $_LSOUT_CURRENT1 | sort -T "$_L_TMP" -u > $_L_TMP/$_R_TREE_LIST
	if [ $(cat $_L_TMP/$_R_TREE_LIST | wc -l) -gt 1 ]
	then
		echo "Here is the list of workspace trees containing frameworks to transfer:"
		cat $_L_TMP/$_R_TREE_LIST
		\rm -f $_L_TMP/$_R_TREE_LIST
		Out 3 "You cannot specify a list of frameworks that are in more than one workspace tree."
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

unset _LOCAL_WS_TREE_OPT
if [ "$_L_WS_TREE" != "" ]
then
	_LOCAL_WS_TREE_OPT="-tree $_L_WS_TREE"
fi
unset _REMOTE_WS_TREE_OPT
if [ "$_R_WS_TREE" != "" ]
then
	_REMOTE_WS_TREE_OPT="-tree $_R_WS_TREE"
fi

StartADLDiffImageContents -reference_outlist $_LSOUT_REF1 -current_outlist $_LSOUT_CURRENT1 -sep "$_FIELD_SEP" \
	-outlist_version $_REMOTE_LSOUT_VERSION -commands_version $_LOCAL_COMMANDS_VERSION \
	-commands_file_name $_COMMANDS_FILE -files_list_file_name $_FILESTOBECOPIED_FILE \
	-files_size_file_name $_FILESTOBECOPIEDSIZE_FILE -files_directory $_FILETOBECOPIED_DIR $_LOCAL_WS_TREE_OPT
rc=$?
[ $rc -ne 0 -a -z "$_FIRST_TRANSFER_BY_PUSH" ] && Out 3 "ADLDiffImageContents is KO"

update_tracking_html diff1 end
# ----------------------------------------------------------------------
# On transfere les fichiers necessaires
# ----------------------------------------------------------------------
if [ -s $_FILESTOBECOPIED_FILE ]
then
	update_tracking_html transfer1 start $_ADL_TRACE_DIR/0trace_adl_file_transfer.sh_${_TID}

	OPTIONS="-tid $_TID -rhost $_R_HOST -rl $_R_ADL_VERSION -rp $_R_ADL_PROFILE -rw $_R_WS"
	[ ! -z "$_R_IMAGE" ] && OPTIONS="$OPTIONS -rimage $_R_IMAGE"
	[ ! -z "$_R_BASE" ] && OPTIONS="$OPTIONS -rb $_R_BASE"
	[ ! -z "$_R_PROJECT" ] && OPTIONS="$OPTIONS -rproj $_R_PROJECT"
	[ ! -z "$_R_USER" ] && OPTIONS="$OPTIONS -ru $_R_USER"
	OPTIONS="$OPTIONS -f $_FILESTOBECOPIED_FILE -rtmp $_R_TMP -ltmp $_FILETOBECOPIED_DIR"
	$ShellDir/adl_file_transfer.sh $OPTIONS -lwd $_ADL_WORKING_DIR -ltd $_ADL_TRACE_DIR
	rc=$?
	[ $rc -ne 0 ] && Out 3 "adl_file_transfer.sh is KO"

	update_tracking_html transfer1 end $_ADL_TRACE_DIR/0trace_adl_file_transfer.sh_${_TID}
fi

# ----------------------------------------------------------------------
# On s'occupe des attributs de la base
# ----------------------------------------------------------------------
if [ -s $_DB_ATTR ]
then
	_UPDATE_DB_ATTR_TRACES=$_ADL_TRACE_DIR/adl_update_database_attributes
	update_tracking_html db_attr start $_UPDATE_DB_ATTR_TRACES 
	$ShellDir/adl_update_database_attributes.sh -a $_DB_ATTR -p $_DB_ATTR_REF 2>&1 > $_UPDATE_DB_ATTR_TRACES 
	rc=$?
	if [ $rc -ne 0 ] 
	then
		cat "$_UPDATE_DB_ATTR_TRACES"
		Out 3 "adl_update_database_attributes.sh is KO"
	fi
	update_tracking_html db_attr end $_UPDATE_DB_ATTR_TRACES 
fi

# ----------------------------------------------------------------------
# On execute les commandes pour mettre a jour l'espace local
# ----------------------------------------------------------------------
if [ -f $_COMMANDS_FILE ]
then
	_COMMAND_RESULT_FILE=$_ADL_TRACE_DIR/0trace_adl_interpret_commands
	update_tracking_html adelize1 start $_ADL_TRACE_DIR/0trace_adl_interpret_commands

	unset OPTIONS
	[ ! -z "$_SIMUL" ] && OPTIONS="-simul" 
	[ ! -z "$_TRACE_ADL_CMD" ] && OPTIONS="$OPTIONS -verbose" 

	$ShellDir/adl_interpret_commands.sh -c $_COMMANDS_FILE -v $_LOCAL_COMMANDS_VERSION -r $_LOCAL_RECOVERY_FILE -t $_COMMAND_RESULT_FILE $OPTIONS
	rc=$?
	if [ $rc -ne 0 ] 
	then
		Out 3 "adl_interpret_commands.sh is KO"
	fi
	echo "All Adele commands have been successfully performed"
else
	sort -T "$_L_TMP" -o $_LSOUT_CURRENT1 $_LSOUT_CURRENT1 
	sort -T "$_L_TMP" -o $_LSOUT_REF1 $_LSOUT_REF1
	/bin/cmp -s $_LSOUT_CURRENT1 $_LSOUT_REF1
	rc=$?
	if [ $rc -eq 0 ]
	then
		CurrentDate=$($ShellDir/adl_get_current_date.sh)
		echo "____________________________________________________________"
		echo "$CurrentDate - Launch Adele commands in local workspace"
		echo "There was no difference since the last transfer. No Adele command has been run"
	else
		Out 3 "ERROR: There is some differences between the last and the current file list and no command file has been created. Contact you Adele administrator"
	fi
fi

# ----------------------------------------------------------------------
# On valide les lsout si on n'est pas en mode de simulation
# ----------------------------------------------------------------------
ValidateRemoteLSOUT

# On move le fichier des commandes dans le repertoire des traces
if [ -f $_COMMANDS_FILE ] 
then
	CommandFileName=$(basename $_COMMANDS_FILE)
	mv $_COMMANDS_FILE $_ADL_TRACE_DIR/$CommandFileName
fi

# ----------------------------------------------------------------------
# On impose une photo de l espace local
# ----------------------------------------------------------------------
update_tracking_html photo2 start $_TRACE_PHOTO
_TRACE_PHOTO=$_ADL_TRACE_DIR/0trace_adl_photo_local_ws2
OPTIONS="-l_photo"
[ "$_L_ADL_VERSION" = 5 ] && OPTIONS="$OPTIONS -ltree $_L_WS_TREE"
$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_PHOTO 2>&1
rc=$?
cat "$_TRACE_PHOTO"
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS is KO"
update_tracking_html photo2 end $_TRACE_PHOTO

# ----------------------------------------------------------------------
# On cree la lsout de l'espace local qui devient forcement la nouvelle reference
# - - - - - - - - - - - - - - - - - -
echo "\n>>> Creating local filelist..."
$ShellDir/adl_create_lsout.sh -f $_L_TMP/0Lsout_local_ref.$$ -s "$_FIELD_SEP" > $_ADL_TRACE_DIR/0trace_create_local_lsout_ref.txt 2>&1
rc=$?
if [ $rc -ne 0 ] 
then
	cat $_ADL_TRACE_DIR/0trace_create_local_lsout_ref.txt
	Out 3 "adl_create_lsout.sh to generate local reference lsout is KO"
else
	# Sauvegarde precedante lsout puis ecrasement par la nouvelle lsout de reference
	SaveLocalLsout 

	# On filtre la lsout sur les fws du tree
	Filter_lsout_on_a_tree $_L_TMP/0Lsout_local_ref.$$ $_L_WS_TREE
	[ $? -ne 0 ] && Out 3 "Filtering local lsout KO"

	# On calcule la liste des frameworks geres lors du transfert precedent
	if [ -s "$_LSOUT_LOCAL_REF1" ]
	then
		$_AWK -F "$_FIELD_SEP" '($5 == "FRAMEWORK") {print substr($1,24) FS $3}' $_LSOUT_LOCAL_REF1 > $_LOCAL_FW_LIST_REF
		sort -T "$_L_TMP" -o $_LOCAL_FW_LIST_REF $_LOCAL_FW_LIST_REF
	else
		touch $_LOCAL_FW_LIST_REF
	fi

	cp -pf $_L_TMP/0Lsout_local_ref.$$ $_LSOUT_LOCAL_REF1 
	[ $? -ne 0 ] && Out 3 "Failed to overwrite previous local reference lsout."
	\rm -f $_L_TMP/0Lsout_local_ref.$$

	# On calcule la liste des frameworks qui sont a gerer lors de ce transfert
	$_AWK -F "$_FIELD_SEP" '($5 == "FRAMEWORK") {print substr($1,24) FS $3}' $_LSOUT_LOCAL_REF1 > $_LOCAL_FW_LIST
	sort -T "$_L_TMP" -o $_LOCAL_FW_LIST $_LOCAL_FW_LIST

	# On en deduit la liste des frameworks apparus
	$_AWK -F "$_FIELD_SEP" '{print $1}' $_LOCAL_FW_LIST_REF > $_L_TMP/FwIdRef.$$
	$_AWK -F "$_FIELD_SEP" '{print $1}' $_LOCAL_FW_LIST     > $_L_TMP/FwId.$$
	comm -13 $_L_TMP/FwIdRef.$$ $_L_TMP/FwId.$$ > $_L_TMP/0DiffFrameworkList.$$
	\rm -f $_L_TMP/FwIdRef.$$ $_L_TMP/FwId.$$ 

	\rm -f $_L_TMP/FwToRemoveFromLsout.$$
	touch $_L_TMP/FwToRemoveFromLsout.$$
    while read FwId
	do
		FwName=$(grep "$FwId" $_LOCAL_FW_LIST | $_AWK -F "$_FIELD_SEP" '{print $2}')
		echo "${_FIELD_SEP}${FwName}${_FIELD_SEP}" >> $_L_TMP/FwToRemoveFromLsout.$$
		echo "${_FIELD_SEP}${FwName}/"             >> $_L_TMP/FwToRemoveFromLsout.$$
	done < $_L_TMP/0DiffFrameworkList.$$
	\rm -f $_L_TMP/0DiffFrameworkList.$$ 

	#echo "++{+{+{+{+{+{+{+{+{+{+{+{+{+{+{+"
	#cat $_L_TMP/FwToRemoveFromLsout.$$
	#echo "++{+{+{+{+{+{+{+{+{+{+{+{+{+{+{+"

	# On supprime de la Lsout que l'on vient de calculer tous les fichiers correspondant aux framework apparus
	fgrep -vf $_L_TMP/FwToRemoveFromLsout.$$ $_LSOUT_LOCAL_REF1 > $_LSOUT_LOCAL_REF1.OutFilter
	\rm -f $_L_TMP/FwToRemoveFromLsout.$$
	\mv $_LSOUT_LOCAL_REF1.OutFilter $_LSOUT_LOCAL_REF1

	#echo "++{+{+{+{+{+{+{+{+{+{+{+{+{+{+{+"
	#cat $_LSOUT_LOCAL_REF1
	#echo "++{+{+{+{+{+{+{+{+{+{+{+{+{+{+{+"
fi

# A partir de maintenant, il faut terminer le transfert sous peine
# d'oublier des donnees a transferer

# ----------------------------------------------------------------------
# On fait RAZ de la lsout locale de reference si c'est le premier transfert
# afin de forcer un transfert de toutes les donnees vers le site distant
# Pour eviter de faire des betises, on ne fait ce traitement que si on a 
# utilise la bonne option et que rien n'a ete recupere du site distant
# - - - - - - - - - - - - - - - - - -
if [ ! -z "$_FIRST_TRANSFER_BY_PUSH" -a ! -s "$_LSOUT_REF1" ]
then
	rm -f $_LSOUT_LOCAL_REF1 
	touch $_LSOUT_LOCAL_REF1
fi

# ----------------------------------------------------------------------
# On recupre les nouveautes dans l'espace local
# - collecte
# - synchronisation
# - resolution des fusions
# - attachement des modules non encore attaches
# ----------------------------------------------------------------------
treat_local_workspace

# ----------------------------------------------------------------------
# On fait maintenant un transfert des modifications locales 
# vers le site distant
# ----------------------------------------------------------------------

transfer_from_local_to_distant

# ----------------------------------------------------------------------
# Tout est termine, on peut liberer les promotions et publier l'espace distant
# ----------------------------------------------------------------------
Get_remote_outlists_and_unlock_ws

# ----------------------------------------------------------------------
# On compare l'arborescence de fichier de l'espace local et de l'espace distant
# ----------------------------------------------------------------------
_ADL_DIFF_RESULT=$_L_TMP/_ADL_DIFF_RESULT_$$
\rm -f $_ADL_DIFF_RESULT
update_tracking_html compare_ws start

CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Comparing remote and local filetree"
# On calcule les differences
# - - - - - - - - - - - - - -
echo "\n>>> Calculating differences between remote and local filelist..."
_LSOUT_ONLY_CURRENT=0DiffLsout.OnlyInCurrent
_LSOUT_ONLY_LOCAL=0DiffLsout.OnlyInLocal
_LSOUT_DIFF_FILES=0DiffLsout.SameFilesWithDiffAttributes
_LSOUT_COMMON_FILES=0DiffLsout.CommonFileList
\rm -f $_LSOUT_ONLY_CURRENT $_LSOUT_ONLY_LOCAL $_LSOUT_DIFF_FILES $_LSOUT_COMMON_FILES

StartADLDiffImageContents -reference_outlist $_LSOUT_CURRENT1 -current_outlist $_LSOUT_LOCAL_CURRENT1 -sep "$_FIELD_SEP" \
	-only_ref $_LSOUT_ONLY_CURRENT -only_current $_LSOUT_ONLY_LOCAL \
	-diff_files $_LSOUT_DIFF_FILES -files_list_file_name $_LSOUT_COMMON_FILES
rc=$?
[ $rc -ne 0 ] && Out 3 "ADLDiffImageContents to compare $_LSOUT_CURRENT1 and $_LSOUT_LOCAL_CURRENT1 files is KO"

# On affiche le resultat
# - - - - - - - - - - - - - -
if [ -f $_LSOUT_ONLY_CURRENT -o -f $_LSOUT_ONLY_LOCAL -o -f $_LSOUT_DIFF_FILES ] 
then
	if [ -f $_LSOUT_ONLY_CURRENT ] 
	then
		echo "\n!!!!!!! Beginning of the list of files which only exist in the workspace: $_R_WS" >> $_ADL_DIFF_RESULT
		cat $_LSOUT_ONLY_CURRENT >> $_ADL_DIFF_RESULT
		echo "!!!!!!! End of the list of files which only exist in the workspace: $_R_WS" >> $_ADL_DIFF_RESULT
	fi
	if [ -f $_LSOUT_ONLY_LOCAL ] 
	then
		# on n'emet pas de message si les seules lignes differentes concernent que des repertoires
		# car ADLV3 ne les gere pas dans ses outlists
		if [ "$_R_ADL_VERSION" = "3" ]
		then
			grep -v "${_FIELD_SEP:-|}DIR_ELEM${_FIELD_SEP:-|}" $_LSOUT_ONLY_LOCAL >/dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo "\n!!!!!!! Beginning of the list of files which only exist in the workspace: $_L_WS" >> $_ADL_DIFF_RESULT
				cat $_LSOUT_ONLY_LOCAL >> $_ADL_DIFF_RESULT
				echo "!!!!!!! End of the list of files which only exist in the workspace: $_L_WS" >> $_ADL_DIFF_RESULT
			fi
		else
			echo "\n!!!!!!! Beginning of the list of files which only exist in the workspace: $_L_WS" >> $_ADL_DIFF_RESULT
			cat $_LSOUT_ONLY_LOCAL >> $_ADL_DIFF_RESULT
			echo "!!!!!!! End of the list of files which only exist in the workspace: $_L_WS" >> $_ADL_DIFF_RESULT
		fi
	fi
	if [ -f $_LSOUT_DIFF_FILES ] 
	then
		echo "\n!!!!!!! Beginning of the list of files which have same path in both workspaces but have different attributes:" >> $_ADL_DIFF_RESULT
		cat $_LSOUT_DIFF_FILES >> $_ADL_DIFF_RESULT
		echo "!!!!!!! End of the list of files which have same path in both workspaces but have different attributes:" >> $_ADL_DIFF_RESULT
	fi
	if [ -f $_ADL_DIFF_RESULT ]
	then
		cat $_ADL_DIFF_RESULT 
		cp -pf $_ADL_DIFF_RESULT $_ADL_TRACE_DIR/_ADL_DIFF_RESULT_$$
		update_tracking_html compare_ws fail $_ADL_TRACE_DIR/_ADL_DIFF_RESULT_$$
	else
		echo "\nNo difference has been found between remote and local filetrees."
		update_tracking_html compare_ws end
	fi
else
	echo "\nNo difference has been found between remote and local filetrees."
	update_tracking_html compare_ws end
fi

[ -f $_LSOUT_ONLY_CURRENT ] && mv $_LSOUT_ONLY_CURRENT $_ADL_TRACE_DIR
[ -f $_LSOUT_ONLY_LOCAL ]   && mv $_LSOUT_ONLY_LOCAL $_ADL_TRACE_DIR
[ -f $_LSOUT_DIFF_FILES ]   && mv $_LSOUT_DIFF_FILES $_ADL_TRACE_DIR
[ -f $_LSOUT_COMMON_FILES ] && mv $_LSOUT_COMMON_FILES $_ADL_TRACE_DIR


# ----------------------------------------------------------------------
# On execute le report de RIs
# ----------------------------------------------------------------------

_TRACE_UPDATE_RI=$_ADL_TRACE_DIR/0trace_adl_update_DB_RI
update_tracking_html ri start $_TRACE_UPDATE_RI

if [ -z "$_NO_UPDATE_CR" ]
then
	cp -pf $_LSOUT_CURRENT1 $_LSOUT_CURRENT2
	cp -pf $_LSOUT_LOCAL_CURRENT1 $_LSOUT_LOCAL_CURRENT2
	# On prend une copie de la lsout Locale pour etant la lsout d'entree de la gestion des RIs
	cp -pf $_LSOUT_LOCAL_CURRENT1 $_LSOUT_LOCAL_RI1
	cp -pf $_LSOUT_LOCAL_CURRENT2 $_LSOUT_LOCAL_RI2
	# Dans le cas ou la lsout locale de reference pour RI n'existe pas alors on la cree comme etant la meme que celle qui existe actuellement
	[ ! -f $_LSOUT_LOCAL_RI_REF1 ] && cp -pf $_LSOUT_LOCAL_RI1 $_LSOUT_LOCAL_RI_REF1
	[ ! -f $_LSOUT_LOCAL_RI_REF2 ] && cp -pf $_LSOUT_LOCAL_RI2 $_LSOUT_LOCAL_RI_REF2
	# Dans le cas ou la lsout remote de reference pour RI n'existe pas alors on la cree comme etant la meme que celle qui existe actuellement
	[ ! -f $_LSOUT_CURRENT_RI_REF1 ] && cp -pf $_LSOUT_CURRENT1 $_LSOUT_CURRENT_RI_REF1
	[ ! -f $_LSOUT_CURRENT_RI_REF2 ] && cp -pf $_LSOUT_CURRENT2 $_LSOUT_CURRENT_RI_REF2

	[ -z "$ADL_FR_CATIA" ] && Out 3 "Cannot start the RI updater process because no ADL_FR_CATIA variable exist"
	[ -z "$ADL_PROJ_IDENT" -a $_L_ADL_VERSION = 5 ] && export ADL_PROJ_IDENT="-"
	_r_base=$_R_BASE
	[ ! -z "$_R_PROJECT" ] && _r_base=$_R_PROJECT
	[ "$_R_TREE" != "-" ] && _r_base=$_R_TREE
	_l_base=$_L_BASE
	[ ! -z "$_L_PROJECT" ] && _l_base=$_L_PROJECT
	[ ! -z "$_L_WS_TREE" ] && _l_base=$_L_WS_TREE

	# On calcule les ID des sites remote et local
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

	$ShellDir/adl_update_DB_RI.sh $ADL_FR_CATIA $_R_SITE_ID $_R_SITE_VERSION $_R_WS $_r_base $_L_SITE_ID $_L_SITE_VERSION $_L_WS $_l_base $ADL_PROJ_IDENT $_ADL_WORKING_DIR $_LSOUT_CURRENT1 $_LSOUT_CURRENT2 $_LSOUT_CURRENT_RI_REF1 $_LSOUT_CURRENT_RI_REF2 $_LSOUT_LOCAL_RI2 $_LSOUT_LOCAL_RI_REF2 "$_FIELD_SEP" 2>&1 > $_TRACE_UPDATE_RI
	rc=$?
	cat $_TRACE_UPDATE_RI

	if [ $rc -ne 0 ] 
	then
		# Pour l'instant on ignore l'erreur car parfois elle provient d'un probleme de lancement d'Osirix.
		echo "adl_update_DB_RI.sh is KO"
	else
		# L'update s'est fait correctement alors on valide les lsout pour la gestion des RIs
		ValidateLSOUTforRI
	fi
fi
update_tracking_html ri end $_TRACE_UPDATE_RI

if [ ! -z "$_L_PUBLISH" -o ! -z "$_L_PROMOTE" ]
then
	_TRACE_PROMOTE=$_ADL_TRACE_DIR/0trace_adl_promote_local_ws
	update_tracking_html promote start $_TRACE_PROMOTE
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

	$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS 2>&1 >$_TRACE_PROMOTE
	rc=$?
	cat $_TRACE_PROMOTE
	[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh is KO"

	update_tracking_html promote end $_TRACE_PROMOTE
fi

Out 0
