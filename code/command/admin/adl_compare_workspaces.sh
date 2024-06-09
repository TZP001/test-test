#!/bin/ksh
[ ! -z "$ADL_DEBUG" ] && set -x

FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

CmdLine="$@"
# =====================================================================
Usage="$ShellName -tid TransferId | -fw Fw... | -rtree WsTree
	-rl AdeleLevel -rp AdeleProfile -rb Base [-rproj Project] -rw Ws [-rimage Image]
	-ll AdeleLevel -lp AdeleProfile -lb Base [-lproj Project] -lw Ws [-limage Image]

Global parameters:
-tid TransferId  : If Transfer identifier is given, local aand remote filtered lsout won't be recalculated.
                   Else their will be created.
-fw Fw...        : Frameworks to consider (all are considered if the option is not defined)
-rtree WsTree    : Origin workspace tree whose frameworks are to consider; Adele V5 only

REMOTE parameters of the comparison procedure:
-rl AdeleLevel   : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp AdeleProfile : Path of the Adele profile to find adele installation
-rb Base         : Base in Adele V3, tck in Adele V5
-rw Ws           : Workspace name
-rproj Project   : Project in base (For Adele V3 test purpose only)
-rimage image    : Image name (For Adele V5 purpose only)

LOCAL parameters of the comparison procedure:
-ll AdeleLevel   : Level of local Adele tool ('3' for Adele V3 and '5' for Adele V5)
-lp AdeleProfile : Path of the Adele profile to find adele installation
-lb Base         : Base in Adele V3, tck in Adele V5
-lw Ws           : Workspace name
-lproj Project   : Project in base (For Adele V3 test purpose only)
-limage image    : Image name (For Adele V5 purpose only)
"
# =====================================================================
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

# Global variable initialization
typeset -x _ADL_WORKING_DIR

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

	rm -fr /tmp/*_$$

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

unset _TID
unset _FW_LIST

unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_BASE
unset _R_PROJECT
unset _R_WS
unset _R_IMAGE
unset _R_WS_TREE

unset _L_ADL_VERSION
unset _L_ADL_PROFILE
unset _L_BASE
unset _L_PROJECT
unset _L_WS
unset _L_IMAGE

while [ $# -ge 1 ]
do
	case "$1" in
	-h ) #-------------------> HELP NEEDED
		echo "$Usage"
		exit 0
		;;
	-tid ) #-----------------> TRANSFER IDENTIFIER
		CheckOptArg "$1" "$2"
		_TID=$2
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
	-rtree ) #-------------------> REMOTE WORKSPACE TREE
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
	-fw ) #----------------> OPTIONAL: Framework list
		shift
		while [ $# -ne 0 ]
		do
			OneChar=$1
			if [ "$OneChar" != "-" ]
			then
				_FW_LIST="$_FW_LIST $1"
				shift
			else
				break
			fi
		done
		if [ -z "$_FW_LIST" ] 
		then
			echo 1>&2 "-fw option has been requested without parameters"
			Out 3 "$Usage"
		fi
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
	-limage ) #-------------------> LOCAL IMAGE (OPTIONAL)
		CheckOptArg "$1" "$2"
		_L_IMAGE=$2
		shift 2
		;;
	* ) echo "Unknown option: $1" 1>&2
		Out 3 "$Usage"
		;;
	esac
done

if [ -z "$_R_WS" -o -z "$_R_ADL_VERSION" -o -z "$_R_ADL_PROFILE" ]
then
	echo "$ShellName: Missing mandatory remote parameter." 1>&2
	Out 3 "$Usage"
fi
if [ "$_R_ADL_VERSION" != 5 -a ! -z "$_R_WS_TREE" ]
then
	echo "$ShellName: -rtree can be used only with Adele V5." >&2
	Out 3 "$Usage"
fi

unset OPT1
unset OPT2
if [ ! -z "$_TID" ]
then
	OPT1="-tid"
fi
if [ ! -z "$_FW_LIST" ]
then
	if [ -z "$OPT1" ]
	then
		OPT1="-fw"
	else
		OPT2="-fw"
	fi
fi
if [ ! -z "$_R_WS_TREE" -a -z "$OPT2" ]
then
	if [ -z "$OPT1" ]
	then
		OPT1="-rtree"
	else
		OPT2="-rtree"
	fi
fi
if [ ! -z "$OPT2" ]
then
	echo "$ShellName: $OPT1 and $OPT2 can't be defined together." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_L_WS" -o -z "$_L_ADL_VERSION" -o -z "$_L_ADL_PROFILE" ]
then
	echo "$ShellName: Missing mandatory local parameter." 1>&2
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
		export LIBPATH=$_MULTISITE_TOOLS/code/bin:$LIBPATH
		export SHLIB_PATH=$_MULTISITE_TOOLS/code/bin:$SHLIB_PATH
		export LD_LIBRARY_PATH=:$_MULTISITE_TOOLS/code/bin:$LD_LIBRARY_PATH
	else
		echo "### DEBUG 2 - Tools have been found in Development workspace"

		export _MULTISITE_TOOLS=/u/users/ygd/Adele/ygdreportv5/$OS_INST
		export _MULTISITE_PREQ_TOOLS=/u/users/ygd/Adele/ADLV5_preq/$OS_INST
		export LIBPATH=$_MULTISITE_TOOLS/code/bin:$_MULTISITE_PREQ_TOOLS/code/bin:$LIBPATH
		export SHLIB_PATH=$_MULTISITE_TOOLS/code/bin:$_MULTISITE_PREQ_TOOLS/code/bin:$SHLIB_PATH
		export LD_LIBRARY_PATH=$_MULTISITE_TOOLS/code/bin:$_MULTISITE_PREQ_TOOLS/code/bin:$LD_LIBRARY_PATH
	fi

	export PATH=$_MULTISITE_TOOLS/code/bin:$PATH
	export CATDictionaryPath=$_MULTISITE_TOOLS/code/dictionary
	export CATMsgCatalogPath=$_MULTISITE_TOOLS/resources/msgcatalog

	ADLDiffImageContents "$@"
    )
	return $?
}

# =====================================================================
# Positionning into the REMOTE workspace
# =====================================================================
if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "____________________________________________________________" 
	echo "$CurrentDate - Positioning in remote base $_R_BASE and ws $_R_WS ...\n"
	unset ADL_FR_CATIA
	if [ ! -x "$_R_ADL_PROFILE" ]
	then
		Out 3 "Local Adele profile not found: $_R_ADL_PROFILE"
	fi
	. $_R_ADL_PROFILE < /dev/null 

	CHLEV_OPT=$_R_BASE
	[ ! -z "$_R_PROJECT" ] && CHLEV_OPT="$_R_PROJECT -r $CHLEV_OPT"
	Try_adl chlev $CHLEV_OPT </dev/null	|| Out 3 "chlev $CHLEV_OPT KO"
	Try_adl adl_ch_ws $_R_WS </dev/null || Out 3 "adl_ch_ws $_R_WS KO"

	unset ADL_W_BASE
	_R_ADL_WS=$ADL_W_ID
	
	_R_WS_DIR=$(pwd)
	_R_COMMANDS_VERSION=3

elif [ $_R_ADL_VERSION = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	CurrentDate=$($ShellDir/adl_get_current_date.sh)
	echo "____________________________________________________________" 
	echo "$CurrentDate - Positioning in remote base $_R_BASE and ws $_R_WS ...\n"
	unset ADL_FR_CATIA
	if [ ! -x "$_R_ADL_PROFILE" ]
	then
		Out 3 "Local Adele profile not found: $_R_ADL_PROFILE"
	fi
	. $_R_ADL_PROFILE < /dev/null 

	tck_profile $_R_BASE </dev/null	|| Out 3 "tck_profile $_R_BASE KO"
	OPTIONS=$_R_WS
	[ ! -z "$_R_IMAGE" ] && OPTIONS="${OPTIONS} -image $_R_IMAGE"
	adl_ch_ws $OPTIONS </dev/null || Out 3 "adl_ch_ws $OPTIONS KO"

	_R_WS_DIR=$(pwd)
	_R_COMMANDS_VERSION=5

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown _R_ADL_VERSION in $ShellName: $_R_ADL_VERSION"
fi

# =====================================================================
# Creation du filtre des frameworks si demande
# =====================================================================
_FW_FILTER=/tmp/FwFilter_$$

_FIELD_SEP="|" # Separateur des champs
# ATTENTION :
# ou un TID a ete precise et on deduira des outlists existantes le separateur
# ou on utilisera le | pour supporter les espaces dans les chemins.

if [ ! -z "$_FW_LIST" ]
then
    # Filtre a partir des frameworks passes en argument
    for fw in $_FW_LIST
    do
        echo "${_FIELD_SEP}${fw}${_FIELD_SEP}"
        echo "${_FIELD_SEP}${fw}/"
    done >$_FW_FILTER
elif [ ! -z "$_R_WS_TREE" ]
then
	# Filtre a partir de l'arborescence
	adl_ls_fw -tree "$_R_WS_TREE" -program -sep "$_FIELD_SEP" -out /tmp/ls_fw_$$
	$_AWK -F "$_FIELD_SEP" '\
		{
			print FS $1 FS;
			print FS $1 "/";
		}' /tmp/ls_fw_$$ >$_FW_FILTER
else
	_FW_FILTER=""
fi

# ----------------------------------------------------------------------
# If _TID is not valuated, we have to generate lsout
# ----------------------------------------------------------------------
_R_LSOUT=/tmp/RemoteLsout_$$
_R_FILTERED_LSOUT=/tmp/RemoteFilteredLsout_$$

if [ -z "$_TID" ]
then
	$ShellDir/adl_create_lsout.sh -f $_R_LSOUT -s "$_FIELD_SEP"
	if [ ! -z "$_FW_FILTER" ]
	then
		fgrep -f $_FW_FILTER $_R_LSOUT >$_R_FILTERED_LSOUT
	else
		cp $_R_LSOUT $_R_FILTERED_LSOUT
	fi
fi

# =====================================================================
# Positionning into the LOCAL workspace
# =====================================================================
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
	
	_L_WS_DIR=$(pwd)

	_COMMANDS_VERSION=3

	# On value le repertoire de travail des transferts
	export _ADL_WORKING_DIR=$ADL_W_DIR/.Adele/MultiSite/$_TID

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

	_L_WS_DIR=$(pwd)

	_COMMANDS_VERSION=5

	# On value le repertoire de travail des transferts
	export _ADL_WORKING_DIR=$ADL_IMAGE_DIR/ToolsData/MultiSite/$_TID

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown _L_ADL_VERSION in $ShellName: $_L_ADL_VERSION"
fi

# ----------------------------------------------------------------------
# If _TID is not valuated, we have to generate lsout
# ----------------------------------------------------------------------
_L_LSOUT=/tmp/LocalLsout_$$
_L_FILTERED_LSOUT=/tmp/LocalFilteredLsout_$$
if [ -z "$_TID" ]
then
	$ShellDir/adl_create_lsout.sh -f $_L_LSOUT -s "$_FIELD_SEP"
	if [ ! -z "$_FW_FILTER" ]
	then
		fgrep -f $_FW_FILTER $_L_LSOUT >$_L_FILTERED_LSOUT
	else
		cp $_L_LSOUT $_L_FILTERED_LSOUT
	fi
fi

# =====================================================================
# Comparing the two workspaces
# =====================================================================

# If _TID is valuated, we have already generated lsout
if [ ! -z "$_TID" ]
then
	# * Outlist origine
	_R_FILTERED_LSOUT=$_ADL_WORKING_DIR/0Lsout.current.filtered
	if [ ! -f "$_R_FILTERED_LSOUT" ]
	then
		_R_FILTERED_LSOUT=$_ADL_WORKING_DIR/0Lsout.current
		if [ ! -f "$_R_FILTERED_LSOUT" ]
		then
			Out 3 "Cannot found Remote filtered lsout: $_R_FILTERED_LSOUT"
		fi
		_R_LSOUT=$_R_FILTERED_LSOUT
	else
		_R_LSOUT=$_ADL_WORKING_DIR/0Lsout.current
		if [ ! -f "$_R_LSOUT" ]
		then
			Out 3 "Cannot found Remote lsout: $_R_LSOUT"
		fi
	fi
	
	# * Separateur des champs
	head -1 $_R_FILTERED_LSOUT >/tmp/head_lsout_$$
	fgrep "|" /tmp/head_lsout_$$ >/dev/null
	if [ $? -eq 0 ]
	then
		_FIELD_SEP="|"
	else
		_FIELD_SEP=" "
	fi

	# * Outlist destination
	_L_FILTERED_LSOUT=$_ADL_WORKING_DIR/0Lsout.local.filtered
	if [ ! -f "$_L_FILTERED_LSOUT" ]
	then
		_L_FILTERED_LSOUT=$_ADL_WORKING_DIR/0Lsout.local
		if [ ! -f "$_L_FILTERED_LSOUT" ]
		then
			Out 3 "Cannot found Local filtered lsout: $_L_FILTERED_LSOUT"
		fi
		_L_LSOUT=$_L_FILTERED_LSOUT
	else
		_L_LSOUT=$_ADL_WORKING_DIR/0Lsout.local
		if [ ! -f "$_L_LSOUT" ]
		then
			Out 3 "Cannot found Local lsout: $_L_LSOUT"
		fi
	fi

	# * Separateur des champs
	head -1 $_L_FILTERED_LSOUT >/tmp/head_lsout_$$
	fgrep "|" /tmp/head_lsout_$$ >/dev/null
	if [ $? -eq 0 ]
	then
		_FIELD_SEP2="|"
	else
		_FIELD_SEP2=" "
	fi
	if [ "$_FIELD_SEP" != "$_FIELD_SEP2" ]
	then
		Out 3 "Remote outlist's field separator = $_FIELD_SEP and local's one = $_FIELD_SEP2"
	fi
fi

OnlyInLocal=/tmp/OnlyInLocal_$$
OnlyInRef=/tmp/OnlyInRef_$$
DifferentFiles=/tmp/DifferentFiles_$$
\rm -f $OnlyInLocal $OnlyInRef $DifferentFiles

StartADLDiffImageContents -reference_outlist $_R_FILTERED_LSOUT -current_outlist $_L_FILTERED_LSOUT -sep "$_FIELD_SEP" \
	-only_ref $OnlyInRef -only_current $OnlyInLocal -diff_files $DifferentFiles \
	-ref_dir $_R_WS_DIR -current_dir $_L_WS_DIR
rc=$?

[ $rc -ne 0 ] && Out 3 "ADLDiffImageContents is KO"

if [ ! -f $OnlyInRef -a ! -f $OnlyInLocal -a ! -f $DifferentFiles ]
then
	echo "\nNo differences have been found between workspace: $_R_WS in base $_R_BASE and workspace: $_L_WS in base $_L_BASE."
fi 

if [ -f $OnlyInRef ]
then
	echo "\n!!!!!!! Here is the list of files which only exist in base $_R_BASE and workspace $_R_WS:"
	$_AWK -F "$_FIELD_SEP" -v WS_DIR="$_R_WS_DIR" '{printf "%s/%s\n",WS_DIR,$3 }' $OnlyInRef
fi

if [ -f $OnlyInLocal ]
then
	echo "\n!!!!!!! Here is the list of files which only exist in base $_L_BASE and workspace $_L_WS:"
	$_AWK -F "$_FIELD_SEP" -v WS_DIR="$_L_WS_DIR" '{printf "%s/%s\n",WS_DIR,$3 }' $OnlyInLocal
fi

if [ -f $DifferentFiles ]
then
	echo "\n!!!!!!! Here is the list of files which existing into both workspaces but have different contents:"
	$_AWK -v L_WS_DIR="$_L_WS_DIR" -v R_WS_DIR="$_R_WS_DIR" '{printf "%s/%s %s/%s\n",R_WS_DIR,$1,L_WS_DIR,$1 }' $DifferentFiles
fi

Out 0

