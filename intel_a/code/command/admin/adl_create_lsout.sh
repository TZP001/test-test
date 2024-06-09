#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName [-tree tree] -f Filelist [-s separator] [-Z]

-tree        : Filter the lsout to a tree (For Adele V5 purpose only)
-f Filelist  : File list name to create
-s separator : Field separator; the space is the default one
-Z           : To create also a compressed file list (same name as filelist name + suffix '.Z'

ATTENTION: You must be in a valid workspace before call this procedure
"
# =====================================================================

[ ! -z "$ADL_DEBUG" ] && set -x

OS=$(uname -s)
case $OS in
	AIX)					
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		DU=/bin/du
		RSH="/usr/bin/rsh"
		COMPRESS=/usr/bin/compress
		UNCOMPRESS=/usr/bin/uncompress
		;;
	HP-UX)
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		DU=/bin/du
		RSH="/bin/remsh"
		COMPRESS=/bin/compress
		UNCOMPRESS=/bin/uncompress
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		DU=/bin/du
		RSH="/usr/bsd/rsh"
		COMPRESS=/usr/bsd/compress
		UNCOMPRESS=/usr/bsd/uncompress
		;;
	SunOS)
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
		DU=/bin/du
		RSH="/bin/rsh"
		COMPRESS=/usr/bin/compress
		UNCOMPRESS=/usr/bin/uncompress
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
	rm -fr *_$$
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

unset _ADL_FILTER_TREE
unset _FILELIST
unset _FILELIST_TO_COMPRESS
export _FIELD_SEP=" " # Espace par defaut

while [ $# -ge 1 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
			;;
		-Z ) #-------------------> OPTIONAL: compress mode
			_FILELIST_TO_COMPRESS=TRUE
			shift
			;;
		-tree ) #----------------> TREE NAME
			CheckOptArg "$1" "$2"
			_ADL_FILTER_TREE=$2
			shift 2
			;;
		-f ) #-------------------> FILELIST NAME
			CheckOptArg "$1" "$2"
			_FILELIST=$2
			shift 2
			;;
		-s ) #-------------------> SEPARATOR
			CheckOptArg "$1" "$2"
			_FIELD_SEP="$2"
			shift 2
			;;
		 * )
			echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

if [ -z "$_FILELIST" ]
then
	echo "$ShellName: name of the filelist is required."
	Out 3 "$Usage"
fi

# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)

if [ $ADL_LEVEL = 2 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	[ -z "$ADL_W_ID" ] && Out 3 "Variable $ADL_W_ID not defined"
	[ -z "$ADL_W_DIR" ] && Out 3 "Variable $ADL_W_DIR not defined"

	_GET_LISTS_TOOL=adl_internal_get_lists_v3.sh

elif [ $ADL_LEVEL = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	[ -z "$ADL_WS" ] && Out 3 "Variable $ADL_WS not defined"
	[ -z "$ADL_IMAGE_DIR" ] && Out 3 "Variable $ADL_IMAGE_DIR not defined"

	_GET_LISTS_TOOL=adl_internal_get_lists_v5.sh

else
	Out 3 "Unknown level $ADL_LEVEL"
fi

echo "____________________________________________________________"
echo "${CurrentDate} : Calculate Lsout on workspace $ADL_W_ID"

#set -x

if [ ! -f $ShellDir/$_GET_LISTS_TOOL ]
then
	Out 3 "Cannot find $_GET_LISTS_TOOL"
fi

_ADL_WORKING_DIR=/tmp/adl_lsout_$$

. $ShellDir/$_GET_LISTS_TOOL # Execution dans le meme environnement

\mv -f $_ADL_WORKING_DIR/0Lsout_conf.txt $_FILELIST

\rm -fr $_ADL_WORKING_DIR

if [ ! -z "$_FILELIST_TO_COMPRESS" ]
then
	$COMPRESS -cvf $_FILELIST > $_FILELIST.Z
	rc=$?
	if [ $rc -ne 0 ] && [ $rc -ne 2 ]
	then
		Out 3 "Cannot get compress file list: $rc"
	else
		echo "\nCompressed file list path:\n<> $_FILELIST.Z <>" 
	fi
fi

Out 0
