#!/bin/ksh
[ ! -z "$ADL_DEBUG" ] && set -x

OS=$(uname -s)
case $OS in
	AIX)
		OS_INST=aix_a
		_AWK=/bin/awk
		RSH="/usr/bin/rsh"
		WHOAMI="/bin/whoami"
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
		_AWK=/bin/awk
		RSH="/bin/remsh"
		WHOAMI="/usr/bin/whoami"
		;;
	IRIX | IRIX64)
		OS_INST=irix_a
		_AWK=/bin/nawk
		RSH="/usr/bsd/rsh"
		WHOAMI="/usr/bin/whoami"
		;;
	SunOS)
		OS_INST=solaris_a
		_AWK=/bin/nawk
		RSH="/bin/rsh"
		WHOAMI="/usr/ucb/whoami"
		PATH=$PATH:/usr/ucb
		;;
	Windows_NT)
		OS_INST=intel_a
		_AWK=awk
		RSH="" # Pas de rsh sur NT
		WHOAMI="echo $USERNAME"
		;;
esac

if [ $OS = Windows_NT ]
then
	FullShellName="$(whence "$0" | \sed 's+\\+/+g')"
	ShellName="${FullShellName##*/}"
	\cd "${FullShellName%/*}"
	ShellDir="$(pwd)"
	\cd -

	TMP=$(printf "%s\n" "$ADL_TMP" | \sed 's+\\+/+g')
	NULL=nul
	ShellVersion=${shellName}"("$(\ls -l $FullShellName | $_AWK '{print $6" "$7" "$8}')")"
	PathSeparator=";"

else
	FullShellName=$(whence "$0" | \sed 's+\\+/+g')
	ShellName=${FullShellName##*/}
	ShellDir=${FullShellName%/*}

	TMP="$ADL_TMP"
	NULL=/dev/null
	ShellVersion=${shellName}"("$(\ls -lL $FullShellName | $_AWK '{print $6" "$7" "$8}')")"
	PathSeparator=":"
fi

CmdLine="$@"
# =====================================================================
Usage="$ShellName -tid TransferId [-keep_trace n] [-wd working_directory]
        [-p TCKProfile -tck TCK] [-simul_import] [-no_cr]
        -rw Ws -rtree tree [-r_image image|-r_no_image]
        -all_fw|-fw Fw... |-lfw Filename
        -lw Ws -ltree tree [-l_image image|-l_no_image]
        [-r_refresh] [-r_collect [Wsi...]] [-r_sync] [-r_att_mod] [-r_publish] [-r_promote [Wsi...]]
        [-l_collect [Wsi...]] [-l_sync] [-l_att_mod] [-l_publish] [-l_promote [Wsi...]]

Global parameters:
-tid TransferId  : TransferId (example: ENO, DSA, DSP, ...
-wd              : Working directory. Default is <ws_dir>/ToolsData/MultiSite. The directory TransferId is created and it contains persistent data (traces...).
-keep_trace n    : Number of trace directories to keep ; the trace directories are created into the local workspace directory ws_dir
   <ws_dir>/ToolsData/MultiSite/<TransferId>/Tracexxx
                   or into the working dir if the option -wd is used
-p TCKProfile    : Profile to run in order to access the tools
-tck TCK         : TCK to run
-simul_import    : Simulation of the import. NOTICE that all the other commands (adl_photo, adl_collect...) will be executed anyway.
-no_cr           : The change requests are not transferred

REMOTE parameters of the data transfer:
-rw Ws           : Workspace name
-rtree tree      : Workspace tree
-r_image image   : Image
-r_no_image      : No current image

-all_fw          : All the attached frameworks are to consider
-fw Fw...        : Frameworks to consider
-lfw Filename    : Filename containing a list of Frameworks to consider (one framework name or Id per line)

-r_refresh       : To refresh the remote workspace
-r_collect [Wsi...]: To collect remote workspace
-r_sync          : To synchronize remote workspace
-r_att_mod       : To attach all the modules included into the attached frameworks
-r_publish       : To publish remote workspace
-r_promote [Wsi...]: To publish and promote remote workspace

LOCAL parameters of the data transfer:
-lw Ws           : Workspace name
-ltree tree      : Workspace tree
-l_image image   : Image
-l_no_image      : No current image. NOTICE: the working directory must be specified with the option -wd

-l_collect [Wsi...]: To run adl_collect into the local workspace BEFORE the transfer for all promoted workspace or only for the specified ones
-l_sync          : To synchronize the local workspace BEFORE the transfer
-l_att_mod       : To attach all the modules included into the attached frameworks AFTER the transfer
-l_publish       : To publish local workspace AFTER the transfer
-l_promote [Wsi...]: To publish and promote local workspace to the parent workspace or to the specified workspace(s) in Adele V5
"
# =====================================================================
export _L_HOST=$(uname -n)

export DISPLAY=""

# Global variable initialization
typeset -x _ADL_WORKING_DIR
typeset -x _ADL_TRACE_DIR
typeset -xi SyncExitCode
SyncExitCode=0

# =====================================================================
# Out function
# =====================================================================
Out()
{
	[ ! -z "$ADL_DEBUG" ] && set -x
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	if [ "$ExitCode" -ge 1 ]
	then
		$SCM_ODT_RUN_IF_KO # Utile pour le debug
	fi
	
	shift
	if [ $# -ge 1 ]
	then
		echo "KO: $*"
	fi

	EndTransferDate=$($ShellDir/adl_get_current_date.sh)
	echo "
____________________________________________________________
End of the transfer: $EndTransferDate"

	if [ -z "$_TCK_PROFILE" ]
	then
		echo "END_${_L_WS_TREE}"
	else
		echo "END_${_TCK}_${_L_WS_TREE}"
	fi

	if [ ! -z "$_ADL_WORKING_DIR" ] && [ -d "$_ADL_WORKING_DIR" ]
	then
		# On recopie les fichiers de _ADL_WORKING_DIR dans _ADL_TRACE_DIR
		\ls -l $_ADL_WORKING_DIR | \grep -v '^total' | \grep -v '^d' | $_AWK '{print $NF}' > $TMP/TraceFilelist_$$
		while read fic
		do
			\cp -p $_ADL_WORKING_DIR/$fic $_ADL_TRACE_DIR/$fic 2>$NULL
		done < $TMP/TraceFilelist_$$
	fi

	if [ ! -z "$_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE" -a -f "$_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE" ]
	then
		\rm -f $_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE
	fi

	if [ ! -z "$ADL_MULTISITE_LOG_DIR" ]
	then
		echo "$EndTransferDate E $($WHOAMI) $_TID $_L_HOST $$ $ExitCode" >> $ADL_MULTISITE_LOG_DIR/_log_transfer.txt
	fi

	\rm -fr $TMP/*_$$ $TMP/*_$$.*

	exit $ExitCode
}

trap 'Out 9999 "Command interrupted" ' HUP INT QUIT TERM

# Pour trouver les differents outils du report
unset _MULTISITE_TOOLS_PREQ

if [ ! -z "$ADL_MULTISITE_INSTALL" ]
then
	export _MULTISITE_TOOLS=$ADL_MULTISITE_INSTALL/$OS_INST
	if [ ! -z "$ADL_MULTISITE_INSTALL_PREQ" ]
	then
		export _MULTISITE_TOOLS_PREQ=$ADL_MULTISITE_INSTALL_PREQ/$OS_INST
	fi
else
	export _MULTISITE_TOOLS=$ShellDir/../../.. # Au cas où le shell se trouve dans une RuntimeView
	if [ ! -d $_MULTISITE_TOOLS/code/bin ]
	then
		echo "### DEBUG 2 - Tools have been found in Development workspace"
		if [ "$OS" = "Windows_NT" ]
		then
			export _MULTISITE_TOOLS=//bibesco/home/users/ygd/Adele/ygdreportv5/$OS_INST
		else
			export _MULTISITE_TOOLS=/u/users/ygd/Adele/ygdreportv5/$OS_INST
		fi
		echo "### DEBUG 2 - _MULTISITE_TOOLS=$_MULTISITE_TOOLS"
	fi
fi

# =====================================================================
# RunNTProfile function
# =====================================================================
RunNTProfile()
{
	if [ $# -eq 0 ]
	then
		Out 50 "Fatal internal error: usage: RunNTProfile commande"
	fi

	init_env=$TMP/init_env_$$.bat
	env_file1=$TMP/env1_$$.txt
	env_file2=$TMP/env2_$$.txt
	echo "\
@set >$env_file1
@CALL $@
@set PROFILE_RC=%ERRORLEVEL%
@set >$env_file2" >$init_env

	\cd $TMP
	cmd /c $init_env
	\cd -
	\rm -f $init_env

	[ ! -s $env_file1 -o ! -s $env_file2 ] && Out 3 "$@ failed"

	# * Nouvelles valeurs
	sort -o $env_file1 $env_file1
	sort -o $env_file2 $env_file2
	env_file=$TMP/env_$$.txt
	
	adl_comm $env_file1 $env_file2 -only2 $env_file # Delta
	rc=$?
	[ $rc -ne 0 ] && Out 3 "adl_comm failed"
#	notepad $env_file2
#	notepad $env_file1
#	notepad $env_file
#	start -w cmd

	init_env=$TMP/init_env_$$.sh
	$_AWK '\
	{
		var = $0;
		value = $0;
		sub("=.*", "", var);
		sub(".*=", "", value);
		if (var == "Path")
			var = "PATH"; # Le remplacement est apparu avec une version de Mks...
		print "export " var "='"'"'" value "'"'"'"; # On suppose qu on n aura pas de problème avec les apostrophes...
	}' $env_file >$init_env
	#notepad $init_env

	# * Variables qui ne sont plus valuées
	env_file11=$TMP/env11_$$.txt
	\sed 's/=.*//' $env_file1 >$env_file11
	env_file22=$TMP/env22_$$.txt
	\sed 's/=.*//' $env_file2 >$env_file22
	adl_comm $env_file11 $env_file22 -only1 $env_file
	rc=$?
	[ $rc -ne 0 ] && Out 3 "adl_comm failed"
	$_AWK '{ print "unset " $1 }' $env_file >>$init_env

	# * Initialisation de l'environnement
	. $init_env
	[ $PROFILE_RC -ne 0 ] && Out 3 "$@ failed"

	return 0
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
unset _SPECIFIED_WORKING_DIR
unset _NB_TRACE_DIR
unset _TCK_PROFILE
unset _TCK

unset _R_WS
typeset -u _R_WS_TREE
unset _R_WS_TREE
unset _R_IMAGE
unset _R_NO_IMAGE
unset _R_REFRESH
unset _R_COLLECT
unset _R_COLLECT_LIST
unset _R_SYNC
unset _R_ATT_MOD
unset _R_PUBLISH
unset _R_PROMOTE
unset _R_PROMOTE_LIST

unset _L_WS
typeset -u _L_WS_TREE
unset _L_WS_TREE
unset _L_IMAGE
unset _L_NO_IMAGE
unset _L_COLLECT
unset _L_COLLECT_LIST
unset _L_SYNC
unset _L_ATT_MOD
unset _L_PUBLISH
unset _L_PROMOTE
unset _L_PROMOTE_LIST

unset _ALL_FW
unset _FW_OPT_DEFINED
unset _LFW_OPT_DEFINED
unset _FW_LIST
unset _TRACE_ADL_CMD
unset _SIMUL_IMPORT
unset _NO_CR
unset _NO_CHECK_CAA_RULES

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
		-wd ) #-------------------> WORKING DIRECTORY
			CheckOptArg "$1" "$2"
			_SPECIFIED_WORKING_DIR=$(printf "%s\n" "$2" | \sed 's+\\+/+g')
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
		-p ) #-------------------> OPTIONAL: TCK_PROFILE
			CheckOptArg "$1" "$2"
			_TCK_PROFILE=$2
			shift 2
			;;
		-tck ) #-------------------> OPTIONAL: TCK
			CheckOptArg "$1" "$2"
			_TCK=$2
			shift 2
			;;
		-simul_import ) #-------------------> OPTIONAL: SIMULATION
			_SIMUL_IMPORT=true
			shift
			;;
		-no_cr ) #-------------------> OPTIONAL: NO CHANGE REQUEST
			_NO_CR=true
			shift
			;;
		-adm_no_check_caa_rules ) #-------------------> OPTIONAL: NO CHECK CAA RULES
			_NO_CHECK_CAA_RULES=true
			shift
			;;
		-all_fw ) #-------------------> OPTIONAL: ALL FW
			_ALL_FW=true
			shift
			;;
		-fw ) #----------------> OPTIONAL: Framework list
			_FW_OPT_DEFINED=true
			shift
			_FW_LIST_FILENAME=$TMP/FW_LIST_$$
			\rm -f $_FW_LIST_FILENAME
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
			_LFW_OPT_DEFINED=true
			CheckOptArg "$1" "$2"
			Input_FW_LIST_FILENAME=$2
			shift 2
			[ ! -f "$Input_FW_LIST_FILENAME" ] && Out 3 "Cannot find file containing framework list: $Input_FW_LIST_FILENAME"
			_FW_LIST_FILENAME=$TMP/FW_LIST_$$
			\rm -f $_FW_LIST_FILENAME
			touch $_FW_LIST_FILENAME
			\sed 's/#.*$//g' $Input_FW_LIST_FILENAME > $_FW_LIST_FILENAME
			[ $? -ne 0 ] && Out 3 "Cannot remove comments from file: $Input_FW_LIST_FILENAME"
			;;
		-lw ) #-------------------> LOCAL WORKSPACE
			CheckOptArg "$1" "$2"
			_L_WS=$2
			shift 2
			;;
		-ltree ) #-------------------> LOCAL WORKSPACE TREE
			CheckOptArg "$1" "$2"
			_L_WS_TREE=$2
			shift 2
			;;
		-l_image ) #-------------------> LOCAL IMAGE
			CheckOptArg "$1" "$2"
			_L_IMAGE=$2
			shift 2
			;;
		-l_no_image ) #-------------------> NO LOCAL IMAGE
			_L_NO_IMAGE=true
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
		-l_att_mod ) #--------------> OPTIONAL: LOCAL ATTACH MODULES
			_L_ATT_MOD="TRUE"
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
		-r_image ) #-------------------> REMOTE IMAGE
			CheckOptArg "$1" "$2"
			_R_IMAGE=$2
			shift 2
			;;
		-r_no_image ) #-------------------> NO REMOTE IMAGE
			_R_NO_IMAGE=true
			shift
			;;
		-r_refresh ) #--------------> OPTIONAL: REMOTE REFRESH
			_R_REFRESH="TRUE"
			shift
			;;
		-r_collect ) #-----------> OPTIONAL: REMOTE COLLECT
			_R_COLLECT="TRUE"
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_R_COLLECT_LIST="$_R_COLLECT_LIST $1"
					shift
				else
					break
				fi
			done
			shift
			;;
		-r_sync ) #--------------> OPTIONAL: REMOTE SYNC
			_R_SYNC="TRUE"
			shift
			;;
		-r_att_mod ) #--------------> OPTIONAL: REMOTE ATTACH MODULES
			_R_ATT_MOD="TRUE"
			shift
			;;
		-r_publish ) #-----------> OPTIONAL: REMOTE PUBLISH
			_R_PUBLISH="TRUE"
			shift
			;;
		-r_promote ) #-----------> OPTIONAL: REMOTE PROMOTE
			_R_PROMOTE="TRUE"
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_R_PROMOTE_LIST="$_R_PROMOTE_LIST $1"
					shift
				else
					break
				fi
			done
			;;
		* ) echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

CheckParamIsDefined()
{
	if [ -z "$1" ]
	then
		echo "$ShellName: the $2 parameter is required; use the option $3."
		Out 3 "$Usage"
	fi
}

CheckParamIsDefined "$_TID"         "transfer id"           "-tid"
CheckParamIsDefined "$_R_WS"        "remote workspace"      "-rw"
CheckParamIsDefined "$_R_WS_TREE"   "remote workspace tree" "-rtree"

unset _OPT1
unset _OPT2
if [ "$_ALL_FW" = true ]
then
	_OPT1="-all_fw"
fi
if [ "$_FW_OPT_DEFINED" = true ]
then
	if [ "$_OPT1" = "" ]
	then
		_OPT1="-fw"
	else
		_OPT2="-fw"
	fi
fi
if [ -z "$_OPT2" -a "$_LFW_OPT_DEFINED" = true ]
then
	if [ "$_OPT1" = "" ]
	then
		_OPT1="-lfw"
	else
		_OPT2="-lfw"
	fi
fi
if [ -z "$_OPT1" ]
then
	echo "$ShellName: you have to use one of the options -all_fw, -fw or -lfw" 1>&2
	Out 3 "$Usage"
fi
if [ ! -z "$_OPT2" ]
then
	echo "$ShellName: $_OPT1 and $_OPT2 can't be used together." 1>&2
	Out 3 "$Usage"
fi

CheckParamIsDefined "$_L_WS"      "local workspace"      "-lw"
CheckParamIsDefined "$_L_WS_TREE" "local workspace tree" "-ltree"

if [ ! -z "$_L_NO_IMAGE" ]
then
	if [ ! -z "$_L_IMAGE" ]
	then
		echo "$ShellName: you have to choose between -l_image or -l_no_image" 1>&2
		Out 3 "$Usage"
	fi
	CheckParamIsDefined "$_SPECIFIED_WORKING_DIR" "working directory" "-wd"
fi

if [ ! -z "$_R_IMAGE" -a ! -z "$_R_NO_IMAGE" ]
then
	echo "$ShellName: you have to choose between -r_image or -r_no_image" 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_TCK_PROFILE" -a -z "$_TCK" ]
then
	echo "$ShellName: -p TCKProfile and -tck TCK must be defined together" 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_TCK" -a -z "$_TCK_PROFILE" ]
then
	echo "$ShellName: -p TCKProfile and -tck TCK must be defined together" 1>&2
	Out 3 "$Usage"
fi

# ======================================================================
# ChWs function
# Usage: ChWs Ws image no_image
# ======================================================================
ChWs()
{
	cmd_options="$1 -no_ds"
	if [ "$3" = "true" ]
	then
		cmd_options="$cmd_options -no_image"
	elif [ ! -z "$2" ]
	then
		cmd_options="$cmd_options -image $2"
	fi

	if [ "$OS" = "Windows_NT" ]
	then
		RunNTProfile adl_ch_ws "$cmd_options"
	else
		cmd="adl_ch_ws_i $cmd_options -env_file $ADL_TMP/chws_$$"
		eval $cmd
		rc=$?
		[ $rc -ne 0 ] && Out 3 "$cmd failed"
		. $ADL_TMP/chws_$$
	fi
}

# ======================================================================
# Global process
# ======================================================================
BeginTransferDate=$($ShellDir/adl_get_current_date.sh)
TraceDirName=trace_$(date +"%Y_%m_%d_%H_%M")

Username=$($WHOAMI)
echo "
_____________________________________________________________
Begining of the transfer: $BeginTransferDate"
echo "Command: $FullShellName - Version: $ShellVersion\n"
echo "____________________________________________________________
Command args: '$CmdLine'
Local host  : $_L_HOST
User        : $Username
____________________________________________________________
Transfer is to be done from (1) to (2)
  (1) id    : $_TID
      ws    : $_R_WS
      tree  : $_R_WS_TREE

  (2) ws    : $_L_WS
      tree  : $_L_WS_TREE
____________________________________________________________
"
if [ ! -z "$_TCK_PROFILE" ]
then
	# ----------------------------------------------------------------------
	# Nettoyage de l'environnement Adele 3.2, V5, Tck (pas mkmk, quand meme...)
	# ----------------------------------------------------------------------
	[ ! -f "$ShellDir/adl_transfer_clean_env.sh" ] && Out 3 "adl_transfer_clean_env.sh not found"
	. "$ShellDir/adl_transfer_clean_env.sh"

	# * Environnement pour les outils
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "____________________________________________________________"
	echo "$CurrentDate - Positioning in local TCK $_TCK and ws $_L_WS ...\n"

	if [ "$OS" = "Windows_NT" ]
	then
		RunNTProfile "CALL $_TCK_PROFILE & CALL tck_profile $_TCK"
	else
		. $_TCK_PROFILE < $NULL

		tck_profile $_TCK <$NULL || Out 3 "tck_profile $_TCK failed"

	fi
fi

ChWs "$_L_WS" "$_L_IMAGE" "$_L_NO_IMAGE"

# On value le repertoire de travail des transferts
if [ -z "$_SPECIFIED_WORKING_DIR" ]
then
	export _ADL_WORKING_DIR=$(printf "%s\n" $ADL_IMAGE_DIR/ToolsData/MultiSite/$_TID | \sed 's+\\+/+g')
else
	export _ADL_WORKING_DIR=$_SPECIFIED_WORKING_DIR/$_TID
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
else
	# Nettoyage des fichiers des versions précédentes
	for f1 in "$_ADL_WORKING_DIR/so_chg_id.Delta.txt" "$_ADL_WORKING_DIR/so_chg_id.New.txt" "$_ADL_WORKING_DIR/so_chg_id.Ref.txt" "$_ADL_WORKING_DIR/already_imported_so_chg_id.txt"
	do
		if [ -f "$f1" ]
		then
			rm -f "$f1"
		fi
	done
fi

# On se positionne dans le repertoire de travail des transferts
\cd $_ADL_WORKING_DIR || Out 3 "\cd $_ADL_WORKING_DIR failed"

if [ ! -z "$ADL_DEBUG_ENV" ]
then
	echo "---------------- Begin of environment -----------------"
	echo "$FullShellName $LINENO : Environment variables"
	env | sort
	echo "---------------- End of environment -----------------"
fi
# ------------------------------------------------------------
# Avant de commencer un report on verifie qu'il n'y en aurait pas
# deja un qui tournerait deja
# ------------------------------------------------------------
_ADL_CURRENT_DATA_TRANSFER="0LockCurrentDataTransfer"
if [ -f "$_ADL_CURRENT_DATA_TRANSFER" ]
then
	# Il en existe peut deja un. On verifie qu'il existe toujours
	read CurHost CurPid CurDate < $_ADL_CURRENT_DATA_TRANSFER
    if [ ! -z "$CurHost" -a ! -z "$CurPid" ]
	then
		RC=-1
		if [ "$_L_HOST" = "$CurHost" ]
		then
			ps -p $CurPid -f | \grep "$ShellName" > $NULL 2>&1
			RC=$?
		elif [ ! -z "$RSH" ]
		then
			$RSH $CurHost ps -p $CurPid -f | \grep "$ShellName" > $NULL 2>&1
			RC=$?
		fi

		if [ $RC -eq -1 ]
		then
			# Pas moyen de vérifier sur une machine distante
			Out 3 "A running data transfer may already exist now on host: $CurHost with pid: $CurPid. It was launch at $CurDate.\nPlease verify. If no transfer runs, please remove the file $_ADL_WORKING_DIR/$_ADL_CURRENT_DATA_TRANSFER."
		elif [ $RC -eq 0 ]
		then
			Out 3 "A running data transfer already exists now on host: $CurHost with pid: $CurPid. It was launch at $CurDate.\nYou have to wait for its finishing before start a new data transfer."
		else
			# Il n'existe plus, on supprime le verrou
			\rm -f $_ADL_CURRENT_DATA_TRANSFER
		fi
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

_ADL_CURRENT_DATA_TRANSFER_LOCK_FILE=$PWD/$_ADL_CURRENT_DATA_TRANSFER # Pour pouvoir le supprimer à la fin...

# ------------------------------------------------------------
# Avant de commencer un report on ecrit dans la log des reports qu'on demarre
# ------------------------------------------------------------
if [ ! -z "$ADL_MULTISITE_LOG_DIR" ]
then
	if [ ! -f $ADL_MULTISITE_LOG_DIR/_log_transfer.txt ]
	then
		touch $ADL_MULTISITE_LOG_DIR/_log_transfer.txt
		chmod 777 $ADL_MULTISITE_LOG_DIR/_log_transfer.txt
	fi
	if [ ! -w $ADL_MULTISITE_LOG_DIR/_log_transfer.txt ]
	then
		chmod 777 $ADL_MULTISITE_LOG_DIR/_log_transfer.txt
	fi
	echo "$BeginTransferDate B $($WHOAMI) $_TID $_L_HOST $$ -" >> $ADL_MULTISITE_LOG_DIR/_log_transfer.txt
fi

# ------------------------------------------------------------
# On nettoie les repertoires de trace
# ------------------------------------------------------------

if [ ! -z "$_NB_TRACE_DIR" -a "$_NB_TRACE_DIR" -ge 1 ]
then
	\ls -d1 trace_* >$TMP/ls_trace_$$ 2>$NULL
	nb=$(wc -l $TMP/ls_trace_$$ | $_AWK '{print $1}')
	let "nb = $nb - $_NB_TRACE_DIR"
	if [ $nb -gt 0 ]
	then
		head -$nb $TMP/ls_trace_$$ | while read dir
		do
			if [ -d "$dir" ]
			then
				\rm -fr "$dir"
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
# On impose une photo et un refresh de l'espace local
# ----------------------------------------------------------------------
_TRACE_PHOTO_REFRESH1=$_ADL_TRACE_DIR/0trace_adl_photo_refresh_local_ws_1.txt
OPTIONS="-l_photo -ltree $_L_WS_TREE"
[ -z "$_L_NO_IMAGE" ] && OPTIONS="$OPTIONS -l_refresh"
$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_PHOTO_REFRESH1 2>&1
rc=$?
cat "$_TRACE_PHOTO_REFRESH1"
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS with $_L_WS failed"

# ----------------------------------------------------------------------
# On lance la collecte de l'espace local
# ----------------------------------------------------------------------
if [ ! -z "$_L_COLLECT" ]
then
	_TRACE_COLLECT=$_ADL_TRACE_DIR/0trace_adl_collect_local_ws.txt
	OPTIONS="-l_collect $_L_COLLECT_LIST -ltree $_L_WS_TREE"

	$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_COLLECT 2>&1
	export CollectExitCode=$?
	cat "$_TRACE_COLLECT"
	[ $CollectExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS with $_L_WS failed"
fi

# ----------------------------------------------------------------------
# On lance la synchronisation de l'espace local
# ----------------------------------------------------------------------
if [ ! -z "$_L_SYNC" ]
then
	_TRACE_SYNCHRO=$_ADL_TRACE_DIR/0trace_adl_sync_local_ws.txt
	OPTIONS="-l_sync -ltree $_L_WS_TREE"
	$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_SYNCHRO 2>&1
	export SyncExitCode=$?
	cat "$_TRACE_SYNCHRO"
	[ $SyncExitCode -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS with $_L_WS failed"
fi

# ----------------------------------------------------------------------
# On lance la photograhie et l'éventuelle collecte de l'espace distant
# ----------------------------------------------------------------------

ChWs "$_R_WS" "$_R_IMAGE" "$_R_NO_IMAGE"

# On calcule les options de lancement pour le site remote

_TRACE_R_WS=$_ADL_TRACE_DIR/0trace_remote_ws.txt

OPTIONS="-ltree $_R_WS_TREE -l_photo"
[ ! -z "$_R_REFRESH" ] && OPTIONS="$OPTIONS -l_refresh"
[ ! -z "$_R_COLLECT" ] && OPTIONS="$OPTIONS -l_collect $_R_COLLECT_LIST"
[ ! -z "$_R_SYNC" ]    && OPTIONS="$OPTIONS -l_sync"
[ ! -z "$_R_ATT_MOD" ] && OPTIONS="$OPTIONS -l_att_mod"
[ ! -z "$_R_PUBLISH" ] && OPTIONS="$OPTIONS -l_publish"
[ ! -z "$_R_PROMOTE" ] && OPTIONS="$OPTIONS -l_promote"
[ ! -z "$_R_PROMOTE_LIST" ] && OPTIONS="$OPTIONS -to $_R_PROMOTE_LIST"

$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_R_WS 2>&1
rc=$?
cat $_TRACE_R_WS
[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh with $_R_WS failed"

# ----------------------------------------------------------------------
# Extraction des modifications dans l'espace distant
# ----------------------------------------------------------------------
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Extracting soft obj changes from ws $_R_WS ...\n"

export _SO_CHG_ID_FILE=$_ADL_WORKING_DIR/so_chg_id.txt
export _REF_DELTA_PARAM_FILE=$_ADL_WORKING_DIR/delta_param.txt
export _NEW_DELTA_PARAM_FILE=$_ADL_WORKING_DIR/new_delta_param.txt
export _MOVED_OUT_SO_FILE=$_ADL_WORKING_DIR/moved_out_soft_obj_id.txt
export _SOFT_OBJ_FILE=$_ADL_WORKING_DIR/soft_obj_id.txt

touch $_REF_DELTA_PARAM_FILE

_TRACE_DELTA_SO_CHG=$_ADL_TRACE_DIR/0trace_adl_delta_so_chg.txt

OPTIONS="-tree $_R_WS_TREE -ref $_REF_DELTA_PARAM_FILE -out $_NEW_DELTA_PARAM_FILE -so_chg_file $_SO_CHG_ID_FILE -moved_out_so_file $_MOVED_OUT_SO_FILE -so_file $_SOFT_OBJ_FILE"
if [ "$_ALL_FW" = true ]
then
	OPTIONS="$OPTIONS -all_fw"
else
	OPTIONS="$OPTIONS -fw_file $_FW_LIST_FILENAME"
fi

"$ADL_USER_PATH"/admin/adl_delta_so_chg $OPTIONS >$_TRACE_DELTA_SO_CHG 2>&1
rc=$?
cat $_TRACE_DELTA_SO_CHG
[ $rc -ne 0 ] && Out 3 "adl_delta_so_chg failed"

# ----------------------------------------------------------------------
# On récupère les modifications dans l'espace local
# ----------------------------------------------------------------------
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Importing soft obj changes into ws $_L_WS ...\n"

ChWs "$_L_WS" "$_L_IMAGE" "$_L_NO_IMAGE"

export _REF_SO_CHG_ID_FILE=$_ADL_WORKING_DIR/so_chg_id.Ref.txt
export _IMPORTED_SO_CHG_ID_FILE=$_ADL_WORKING_DIR/imported_so_chg_id.txt # Fichier de toutes les modifications importées, notamment pour accélérer les simulations

if [ ! -s $_REF_SO_CHG_ID_FILE ]
then
	# Pas de fichier référence
	touch $_REF_SO_CHG_ID_FILE
fi

count=1
ForceToDo=1
while [ $ForceToDo -eq 1 ]
do
	_TRACE_FORCE_SO_CHG=$_ADL_TRACE_DIR/0trace_adl_force_so_chg.txt

	OPTIONS="-previous $_REF_SO_CHG_ID_FILE -file $_SO_CHG_ID_FILE -tree $_L_WS_TREE -from_tree $_R_WS_TREE -complete -imported $_IMPORTED_SO_CHG_ID_FILE"
	[ ! -z "$_SIMUL_IMPORT" ] && OPTIONS="$OPTIONS -simul"
	[ ! -z "$_NO_CHECK_CAA_RULES" ] && OPTIONS="$OPTIONS -adm_no_check_caa_rules"

	"$ADL_USER_PATH"/admin/adl_force_so_chg $OPTIONS >$_TRACE_FORCE_SO_CHG 2>&1
	rc=$?
	ForceToDo=0

	# Fix for missing changes due to cleaner
	# --------------------------------------
	if [ $rc -ne 0 ]
	then
		grep '#ERR# ADLCMD \- 6326' "$_TRACE_FORCE_SO_CHG" >$NULL 2>&1
		rc1=$?
		grep '#ERR# ADLCMD \- 6330' "$_TRACE_FORCE_SO_CHG" >$NULL 2>&1
		rc2=$?
		_SO_ID_FILENAME="$TMP"/SO_ID_LIST_$$
		_SO_CHG_ID_FILENAME="$TMP"/SO_CHG_ID_LIST_$$
		while [ $rc1 -eq 0 -o $rc2 -eq 0 ]
		do
			ForceToDo=1
			\rm -f "$_SO_ID_FILENAME"
			if [ $rc1 -eq 0 ]
			then
				# -> if install in english
				grep 'Soft obj id' "$_TRACE_FORCE_SO_CHG" | $_AWK '{print $4}' | $_AWK -F: '{print $1}' >> "$_SO_ID_FILENAME"
				[ $? -ne 0 ] && Out 5 "Cannot generate IDs file"
				# -> if install in french
				grep 'Id obj' "$_TRACE_FORCE_SO_CHG" | $_AWK '{print $3}' >> "$_SO_ID_FILENAME"
				[ $? -ne 0 ] && Out 5 "Cannot generate IDs file"
			fi

			if [ $rc2 -eq 0 ]
			then
				$_AWK '{if (NF==1 && length($1)==20) print $1}' "$_TRACE_FORCE_SO_CHG" >> "$_SO_ID_FILENAME"
				[ $? -ne 0 ] && Out 5 "Cannot generate IDs file"
			fi

			# Recherche des modifications associées à ces objets dans l'espace origine
			cat "$_SO_ID_FILENAME" | while read SoftObjId
			do
				adl_ds_chg soid:${SoftObjId} -ws $_R_WS -all_chg -program -sep "|" -out "$TMP"/DsChg_$$
				[ $? -ne 0 ] && Out 5 "adl_ds_chg is KO"
				$_AWK -F\| '{if ($1=="___SO_CHG") print $2}' "$TMP"/DsChg_$$ >> "$_SO_CHG_ID_FILENAME"
				[ $? -ne 0 ] && Out 5 "Cannot extract software object change"
			done

			# Import des modifications dans l'espace destination
			count=$(expr $count + 1)
			_TRACE_FORCE_SO_CHG="$_ADL_TRACE_DIR/0trace_adl_force_so_chg_${count}.txt"
			"$ADL_USER_PATH/admin/adl_force_so_chg" -file "$_SO_CHG_ID_FILENAME" -tree $_L_WS_TREE -complete >"$_TRACE_FORCE_SO_CHG" 2>&1
			rc=$?
			if [ $rc -eq 0 ]
			then
				rc1=1
				rc2=1
			else
				grep '#ERR# ADLCMD \- 6326' "$_TRACE_FORCE_SO_CHG" >$NULL 2>&1
				rc1=$?
				grep '#ERR# ADLCMD \- 6330' "$_TRACE_FORCE_SO_CHG" >$NULL 2>&1
				rc2=$?
				[ $rc1 -ne 0 -a $rc2 -ne 0 ] && Out 5 "adl_force_so_chg is KO"
			fi
		done
	fi
done
cat $_TRACE_FORCE_SO_CHG
[ $rc -ne 0 ] && Out 3 "adl_force_so_chg failed"

# ----------------------------------------------------------------------
# Nouveaux paramètres -> paramètres de référence
# ----------------------------------------------------------------------
mv -f $_IMPORTED_SO_CHG_ID_FILE $_REF_SO_CHG_ID_FILE

if [ -z "$_SIMUL_IMPORT" ]
then
	mv -f $_NEW_DELTA_PARAM_FILE $_REF_DELTA_PARAM_FILE
	rc=$?
	[ $rc -ne 0 ] && Out 3 "mv -f $_NEW_DELTA_PARAM_FILE $_REF_DELTA_PARAM_FILE failed"

	# Il y avait quelquechose à faire
	if [ -z "$_L_NO_IMAGE" ]
	then
		# ----------------------------------------------------------------------
		# On impose un refresh de l'espace local
		# ----------------------------------------------------------------------
		_TRACE_REFRESH2=$_ADL_TRACE_DIR/0trace_adl_refresh_local_ws_2.txt
		OPTIONS="-l_refresh"
		[ ! -z "$_L_ATT_MOD" ] && OPTIONS="$OPTIONS -l_att_mod"
		$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_REFRESH2 2>&1
		rc=$?
		cat "$_TRACE_REFRESH2"
		[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh $OPTIONS with $_L_WS failed"
	fi

	# ----------------------------------------------------------------------
	# Transfert des demandes de modifications
	# ----------------------------------------------------------------------
	if [ -z "$_NO_CR" ]
	then
		_TRACE_TRANSFER_CR=$_ADL_TRACE_DIR/0trace_adl_transfer_cr.txt

		OPTIONS="-tree $_L_WS_TREE -from_ws $_R_WS -from_tree $_R_WS_TREE"
		if [ "$_ALL_FW" = true ]
		then
			OPTIONS="$OPTIONS -all_fw"
		else
			OPTIONS="$OPTIONS -fw_file $_FW_LIST_FILENAME"
		fi

		adl_transfer_cr $OPTIONS >$_TRACE_TRANSFER_CR 2>&1
		rc=$?
		cat $_TRACE_TRANSFER_CR
		[ $rc -ne 0 ] && Out 3 "adl_transfer_cr failed"
	fi

	# ----------------------------------------------------------------------
	# Fusions à résoudre ?
	# ----------------------------------------------------------------------
	_TRACE_LS_MERGE=$_ADL_TRACE_DIR/0trace_adl_ls_merge.txt
	_MERGE_TO_SOLVE_FILE=$_ADL_TRACE_DIR/0merge_to_solve.txt

	OPTIONS="-program -out $_MERGE_TO_SOLVE_FILE"

	adl_ls_merge $OPTIONS >$_TRACE_LS_MERGE 2>&1
	rc=$?
	cat $_TRACE_LS_MERGE
	[ $rc -ne 0 ] && Out 3 "adl_ls_merge failed"

	if [ -s $_MERGE_TO_SOLVE_FILE ]
	then
		echo "-------------------------------------------------------"
		echo "---      MERGES TO SOLVE : RUN adl_solve_merge      ---"
		echo "-------------------------------------------------------"
	else
		# ----------------------------------------------------------------------
		# Photo + on promeut les modifications realisees dans l espace local
		# ----------------------------------------------------------------------
		_PROMOTED_OBJECTS_FILE=$_ADL_TRACE_DIR/0PromotedObjects.txt
		OPTIONS=" -f $_PROMOTED_OBJECTS_FILE -ltree $_L_WS_TREE -l_photo"
		[ ! -z "$_L_PUBLISH" ] && OPTIONS="$OPTIONS -l_publish"
		[ ! -z "$_L_PROMOTE" ] && OPTIONS="$OPTIONS -l_promote"
		[ ! -z "$_L_PROMOTE_LIST" ] && OPTIONS="$OPTIONS -to $_L_PROMOTE_LIST"

		_TRACE_PROMOTE=$_ADL_TRACE_DIR/0trace_adl_promote_local_ws.txt
		$ShellDir/adl_start_commands_on_local_ws.sh $OPTIONS >$_TRACE_PROMOTE 2>&1
		rc=$?
		cat $_TRACE_PROMOTE
		[ $rc -ne 0 ] && Out 3 "adl_start_commands_on_local_ws.sh failed"
	fi
fi

Out 0
