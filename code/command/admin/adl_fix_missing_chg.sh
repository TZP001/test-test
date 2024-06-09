#!/bin/ksh
set -x
# ====================================================================
# Copyright © 2002, Dassault-Systemes.
#
# Internal shell of adl_site_transfer command.
# Not to be executed directly
# ====================================================================

OS=$(uname -s)
if [ "$OS" = "Windows_NT" ]
then
	export _CALL_SH="sh +C -K "
	export FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	export ShellName="${FullShellName##*/}"
	cd "${FullShellName%/*}"
	export ShellDir="$(pwd)"
	cd - >nul

	export DefaultTmpDir="$(printf "%s" "$ADL_TMP" | sed 's+\\+/+g')"
	[ -z ""$DefaultTmpDir"" ] && export DefaultTmpDir="$(printf "%s" "$TEMP" | sed 's+\\+/+g')"
	[ -z ""$DefaultTmpDir"" ] && export DefaultTmpDir=C:/TEMP
	export NULL=nul

	export ADL_USER_PATH="$(printf "%s" "$ADL_USER_PATH" | sed 's+\\+/+g')"

else
	unset _CALL_SH
	export FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	export FullShellName2=${FullShellName%\'}
	export FullShellName=${FullShellName2##\'}
	export ShellName="${FullShellName##*/}"
	export ShellDir="${FullShellName%/*}"

	export DefaultTmpDir="$ADL_TMP"
	[ -z ""$DefaultTmpDir"" ] && export DefaultTmpDir=/tmp
	export NULL=/dev/null
fi

#
# $1 = traces of the command that crashed and in which we can find the IDs of the objects
#      of which some changes are missing
# $2 = "local" | "remote"
# if "local" then get changes from remote site and force them locally
# if "remote" get changes locally and force them remotely
# $3 = "self" | "container" -> the way to find out from $1 the Ids to treat depends on this parameter
#

_tracefile=$1
_where=$2
_what=$3
_tmpfile="$DefaultTmpDir"/IDlist_$$.txt
_tmpfile2="$DefaultTmpDir"/IDlist2_$$.txt

if [ ! -f "$_tracefile" ]
then
	echo "Error in adl_fix_missing_chg: no file supplied or the given file \"$_tracefile\" does not exist"
	exit 1
fi

if [ -z "$2" ]
then
	echo "Error in adl_fix_missing_chg: missing type of fix (local|remote)"
	exit 1
fi

\touch "$_tmpfile"

# Note: the process of searching missing changes is a loop because forcing the missing changes can lead to have
# other ones missed

#
# Extract the IDs of objects from the trace file "$1"
# and add them at the end of file "$2"
# $3 = "self" or "container"
#
enlarge_chg_file()
{
	if [ "$3" = "self" ]
	then
		# -> if install in english
		grep 'Soft obj id' "$1" | $_AWK '{print $4}' | $_AWK -F: '{print $1}' >> "$2"
		if [ $? -ne 0 ]
		then
			echo "Error in adl_fix_missing_chg(self): could not generate IDs file $2"
			exit 1
		fi
		# -> if install in french
		grep 'Id obj' "$1" | $_AWK '{print $3}' >> "$2"
		if [ $? -ne 0 ]
		then
			echo "Error in adl_fix_missing_chg(self): could not generate IDs file $2 (french search)"
			exit 1
		fi
	elif [ "$3" = "container" ]
	then
		$_AWK '{if (NF==1 && length($1)==20) print $1}' "$1" >> "$2"
		if [ $? -ne 0 ]
		then
			echo "Error in adl_fix_missing_chg(container): could not generate IDs file $2"
			exit 1
		fi
	else
		echo "Error: unknown value for argument 3 -> $3"
		exit 1
	fi
}


grep '#ERR# ADLCMD \- 6326' "$_tracefile" >$NULL 2>&1
rc1=$?
grep '#ERR# ADLCMD \- 6330' "$_tracefile" >$NULL 2>&1
rc2=$?
count=1
while [ $rc1 -eq 0 -o $rc2 -eq 0 ]
do
	if [ $rc1 -eq 0 ]
	then
		enlarge_chg_file "$_tracefile" "$_tmpfile" "self"
	else
		enlarge_chg_file "$_tracefile" "$_tmpfile" "container"
	fi

	if [ "$_where" = "local" ]
	then
		#
		# Find out the missing changes in remote mirror workspace
		#
		\rm -f "$_tmpfile2"
		touch "$_tmpfile2"
		chmod 777 "$_tmpfile2"
		cat "$_tmpfile" | while read softobjid
		do
			"$_CLIENT" $_RUN_COMMON -cmd '"'$_RemoteADLUserPath/adl_ds_chg'"' soid:${softobjid} -all_chg  -program '-sep "|"' \
			| $_AWK -F\| '{if ($1=="___SO_CHG") print $2}' >> "$_tmpfile2"
			if [ $? -ne 0 ]
			then
				echo "Error in adl_fix_missing_chg: could not write in file $_tmpfile2"
				exit 1
			fi
		done
	
		#
		# Apply the changes in the local workspace
		#
		"$ADL_USER_PATH"/admin/adl_force_so_chg -tree $_L_WS_TREE -complete -file "$_tmpfile2" > "$_ADL_TRACE_DIR/0trace_force_ws_local_${count}.txt" 2>&1

		# 
		# look if there is a need to loop again
		#
		grep '#ERR# ADLCMD \- 6326' "$_ADL_TRACE_DIR/0trace_force_ws_local_${count}.txt" >$NULL 2>&1
		rc1=$?
		grep '#ERR# ADLCMD \- 6330' "$_ADL_TRACE_DIR/0trace_force_ws_local_${count}.txt" >$NULL 2>&1
		rc2=$?

		_tracefile="$_ADL_TRACE_DIR/0trace_force_ws_local_${count}.txt"
		count=$(expr $count + 1)

	elif [ "$_where" = "remote" ]
	then
		#
		# Find out the missing changes in local workspace and transfer them into the mirror remote workspace
		#
		\rm -f "$_tmpfile2"
		touch "$_tmpfile2"
		chmod 777 "$_tmpfile2"
		cat "$_tmpfile" | while read softobjid
		do
			"$ADL_USER_PATH"/adl_ds_chg soid:${softobjid} -all_chg -program -sep \| \
			| $_AWK -F\| '{if ($1=="___SO_CHG") print $2}' >> "$_tmpfile2"
			if [ $? -ne 0 ]
			then
				echo "Error in adl_fix_missing_chg: could not write in file $_tmpfile2"
				exit 1
			fi
		done
	
		#
		# Put the list of changes to the remote site
		#
		"$_CLIENT" $_RUN_COMMON -put "$_tmpfile2" "$_R_TMP/transfer_${_R_WS}_${_TID}/IDChg.txt"
		if [ $? -ne 0 ]
		then
			echo "Error in adl_fix_missing_chg: could not send file $_tmpfile2 into $_R_TMP/transfer_${_R_WS}_${_TID}/IDChg.txt"
			exit 1
		fi

		#
		# Apply the changes in the mirror workspace
		#
		"$_CLIENT" $_RUN_COMMON -cmd '"'$_RemoteADLUserPath/admin/adl_force_so_chg'"' -tree "$_R_WS_TREE" -complete -file '"'$_R_TMP/transfer_${_R_WS}_${_TID}/IDChg.txt'"' > "$_ADL_TRACE_DIR/0trace_force_ws_remote_${count}.txt" 2>&1

		# 
		# look if there is a need to loop again
		#
		grep '#ERR# ADLCMD \- 6326' "$_ADL_TRACE_DIR/0trace_force_ws_remote_${count}.txt" >$NULL 2>&1
		rc1=$?
		grep '#ERR# ADLCMD \- 6330' "$_ADL_TRACE_DIR/0trace_force_ws_remote_${count}.txt" >$NULL 2>&1
		rc2=$?

		_tracefile="$_ADL_TRACE_DIR/0trace_force_ws_remote_${count}.txt"
		count=$(expr $count + 1)
	fi

done

#
# Print out the traces of the last execution since it is the one
# where the changes have been imported successfully
#
\cat "$_tracefile"

\rm -f $_tmpfile $_tmpfile2

exit 0
