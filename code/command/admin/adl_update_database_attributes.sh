#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

[ ! -z "$ADL_DEBUG" ] && set -x

# =====================================================================
Usage="$ShellName -a CurrentDbAttributes -p PreviousDbAttributes

-a CurrentDbAttributes : Current database attribute file path
-p PreviousDbAttributes: Reference database attribute file path

This script permit to update the current local database attributes
ATTENTION: an adl_ch_ws should have been made before call this script"
# =====================================================================


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

[ -z "$ADL_LEVEL" ] && Out 3 "No ADL_LEVEL variable set"

unset _DB_ATTR
unset _DB_ATTR_REF

while [ $# -ge 1 ]
do
	case "$1" in
	-h ) #-------------------> HELP NEEDED
		echo "$Usage"
		exit 0
		;;
	-a ) #-------------------> CURRENT DATABASE ATTRIBUTE FILE PATH
		CheckOptArg "$1" "$2"
		_DB_ATTR="$2"
		shift 2
		;;
	-p ) #-------------------> REFERENCE DATABASE ATTRIBUTE FILE PATH
		CheckOptArg "$1" "$2"
		_DB_ATTR_REF="$2"
		shift 2
		;;
	* ) echo "Unknown option $1"
		echo "$Usage"
		exit 1
		;;
	esac
done

if [ -z "$_DB_ATTR" -o -z "$_DB_ATTR_REF" ]
then
	echo "$ShellName: Missing mandatory parameter." 1>&2
	Out 3 "$Usage"
fi

if [ ! -f "$_DB_ATTR" ]
then
	echo "$ShellName: Database attribute file not found : $_DB_ATTR" 1>&2
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
	echo "____________________________________________________________"
	echo "$CurrentDate : Adele V3 update database attributes of $ADL_PROJET"
	[ -z "$ADL_W_ID" ] && Out 3 "No current workspace has been found"
	[ -z "$ADL_W_IDENT" ] && Out 3 "No ADL_W_IDENT variable set"

	# s'il y a une qq difference avec la precedente version
	# on essaye de recreer tous les attributs...

	if [ ! -f $_DB_ATTR_REF ]
	then
		/bin/touch $_DB_ATTR_REF
	fi

	/bin/cmp $_DB_ATTR $_DB_ATTR_REF >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		while read attr op value
		do
			if [ "$attr" = "fw_subdir_list" ]
			then
				echo "mka trash>trash -a fw_subdir_list $value" 
				mka "trash>trash" -a fw_subdir_list $value
			fi
		done < $_DB_ATTR
	fi

elif [ $ADL_LEVEL = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	echo "____________________________________________________________"
	echo "$CurrentDate : Adele V5 update database attributes of $TCK_ID"
	[ -z "$ADL_WS" ] && Out 3 "No current workspace has been found"

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown ADL_LEVEL in $ShellName: $ADL_LEVEL"
fi

Out 0
