
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
	[ -z ""$DefaultTmpDir"" ] && DefaultTmpDir="$(printf "%s" "$TEMP" | sed 's+\\+/+g')"
	[ -z ""$DefaultTmpDir"" ] && DefaultTmpDir=C:/TEMP
	export NULL=nul

	export ADL_USER_PATH="$(printf "%s" "$ADL_USER_PATH" | sed 's+\\+/+g')"
else
	unset _CALL_SH
	export FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	export FullShellName2=${FullShellName%\'}
	export FullShellName=${FullShellName2##\'}
	export ShellName="${FullShellName##*/}"
	export ShellDir="${FullShellName%/*}"

	export DefaultTmpDir=${ADL_TMP:-/tmp}
	export NULL=/dev/null
fi

# Global variable controling the removing of transfer lock
_lock_code=5

# Global variable initialization
case $OS in
	AIX)
		export WHOAMI="/bin/whoami"
		export _AWK=/bin/awk
		export _FIND=find
		export _SORT=sort
		;;
	HP-UX)
		export WHOAMI="/usr/bin/whoami"
		export MAIL="/usr/bin/mail"
		export _AWK=/bin/awk
		export _FIND=find
		export _SORT=sort
		;;
	IRIX | IRIX64)
		export WHOAMI="/usr/bin/whoami"
		export _AWK=/bin/nawk
		export _FIND=find
		export _SORT=sort
		;;
	SunOS)
		export WHOAMI="/usr/ucb/whoami"
		export _AWK=/bin/nawk
		export _FIND=find
		export _SORT=sort
		;;
	Windows_NT)
		export WHOAMI="$SystemDrive/ntreskit/whoami.exe"
		export _AWK="awk"
		export _FIND="$(dirname "$SHELL")/find.exe"
		export _SORT="$(dirname "$SHELL")/sort.exe"
		;;
esac

# =====================================================================
# Print a message
# INPUT
#  message code + argument(s)
# =====================================================================
_printmsg()
{
	if [ -z "$_R_TMP" ]
	then
		if [ $# -eq 1 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1"
		elif [ $# -eq 2 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2"
		elif [ $# -eq 3 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3"
		elif [ $# -eq 4 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4"
		elif [ $# -eq 5 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5"
		elif [ $# -eq 6 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6"
		elif [ $# -eq 7 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7"
		elif [ $# -eq 8 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		elif [ $# -eq 9 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
		elif [ $# -eq 10 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" 
		else
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite $*
		fi
	else
		if [ $# -eq 1 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 2 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 3 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 4 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 5 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 6 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 7 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 8 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 9 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 10 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" |"$_CLIENT" $_RUN_COMMON -log_input -echo
		else
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite $* |"$_CLIENT" $_RUN_COMMON -log_input -echo
		fi
	fi
}

_printerr()
{
	if [ -z "$_R_TMP" ]
	then
		echo "#ERR# ADLMultiSite - $1: \c"
		if [ $# -eq 1 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1"
		elif [ $# -eq 2 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2"
		elif [ $# -eq 3 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3"
		elif [ $# -eq 4 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4"
		elif [ $# -eq 5 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5"
		elif [ $# -eq 6 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6"
		elif [ $# -eq 7 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7"
		elif [ $# -eq 8 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		elif [ $# -eq 9 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
		elif [ $# -eq 10 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" 
		else
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite $*
		fi
	else
		echo "#ERR# ADLMultiSite - $1: \c"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		if [ $# -eq 1 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 2 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 3 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 4 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 5 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 6 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 7 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 8 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 9 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"|"$_CLIENT" $_RUN_COMMON -log_input -echo
		elif [ $# -eq 10 ]
		then
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" |"$_CLIENT" $_RUN_COMMON -log_input -echo
		else
			"$ADL_USER_PATH/adl_build_nls_msg" ADLMultiSite $*|"$_CLIENT" $_RUN_COMMON -log_input -echo
		fi
	fi
}


# =====================================================================
# Check that the remote site is reachable
# INPUT
#   $1 = server(s) to connect under format host1:port1#...#hostn:portn
# OUTPUT
#   _TUUID = connection identifier
#   _RUN_COMMON = arguments for calls to the remote transfer manager
#   _CLIENT = program to communicate with the remote transfer manager
#   RemoteOS = UNIX | WINDOWS regarding the remote OS
#   _RemoteADLUserPath = full path to the SCM user commands on remote site
#   _R_TMP = remote temporary directory that is specific to the current client
# =====================================================================
init_connection_with_remote_site()
{
	[ ! -z "$ADL_DEBUG" ] && set -x

	unset _R_TMP

	if [ "$OS" = "Windows_NT" ]
	then
		if [ ! -f "$ADL_USER_PATH"/admin/adl_transfer_client.exe ]
		then
			_printmsg 0007 $1 # "Checking connexion with host /p1..."
			_printerr 0001 # "Cannot find adl_transfer_client.exe"
			_printerr 0102 # "Command aborted";
			exit 1
		else
			export _CLIENT="$(printf "%s" "$ADL_USER_PATH/admin/adl_transfer_client.exe" | sed 's+\\+/+g')"
		fi
	elif [ ! -f "$ADL_USER_PATH"/admin/adl_transfer_client ]
	then
		_printmsg 0007 $1 # "Checking connexion with host /p1..."
		_printerr 0001 # Cannot find adl_transfer_client.exe
		_printerr 0102 # "Command aborted";
		exit 1
	else
		export _CLIENT="$ADL_USER_PATH/admin/adl_transfer_client"
	fi

	# UUID to identify remote actions on server side
	"$ADL_USER_PATH"/admin/adl_get_uuid >"$DefaultTmpDir"/info_$$.txt 2>&1
	[ $? -ne 0 ] && cat "$DefaultTmpDir"/info_$$.txt && _printmsg 0007_1 $1 && Out 5 0002
	export _TUUID=$(cat "$DefaultTmpDir"/info_$$.txt)
	export _RUN_COMMON=" -id $_TUUID -server $1"

	# Ask the transfer manager for the remote temporary directory
	"$_CLIENT" $_RUN_COMMON -info -program -sep \| >"$DefaultTmpDir"/info_$$.txt 2>&1
	rc=$?
	if [ $rc -ne 0 -a ! -z "$_R_PORT" ]
	then
		# for backward compatibility we have to try again but using deprecated options "-server -port"
		"$_CLIENT" -id $_TUUID -server $_R_SERVER -port $_R_PORT -info -program -sep \| >"$DefaultTmpDir"/info_$$.txt 2>&1
		rc=$?
		if [ $rc -ne 0 ]
		then
			export _R_HOST=$(echo $_R_SERVER | $_AWK -F: '{print $1}')
			export _R_PORT=$(echo $_R_SERVER | $_AWK -F: '{print $2}')
			"$_CLIENT" -id $_TUUID -server $_R_HOST -port $_R_PORT -info -program -sep \| >"$DefaultTmpDir"/info_$$.txt 2>&1
			rc=$?
			if [ $rc -ne 0 ]
			then
				unset _R_HOST
				unset _R_PORT
			else
				export _RUN_COMMON=" -id $_TUUID -server $_R_HOST -port $_R_PORT"
			fi
		else
			export _R_HOST=$_R_SERVER
			export _RUN_COMMON=" -id $_TUUID -server $_R_SERVER -port $_R_PORT"
		fi
	fi

	if [ $rc -ne 0 ]
	then
	cat "$DefaultTmpDir"/info_$$.txt
		_printmsg 0007 $1 # "Checking connexion with host /p1..."
		_printerr 0003 $1 # "Cannot get information from remote transfer manager."
		Out 5 0004 $1 # "Check that a multisite transfer manager is running on host(s) /p1..."
	else
		export _R_TMP="$($_AWK -F\| '{if ($1=="_MNGR") print $9}' "$DefaultTmpDir"/info_$$.txt)/$_TUUID"
		"$_CLIENT" $_RUN_COMMON -cmd mkdir "$_R_TMP" || Out 5 0024 "$_R_TMP" # "Could not create remote temporary directory..."
		# Determine remote OS
		export RemoteOS=$($_AWK -F\| '{if ($1=="_MNGR") print $5}' "$DefaultTmpDir"/info_$$.txt)
		if [ "$RemoteOS" = "WINDOWS" ]
		then
			export _RemoteADLUserPath='%ADL_USER_PATH%'
			export _REM_CALL_SH="sh +C -K "
			export RemoteOS=Windows_NT # to have same value as in adl_site_transfer
		else
			export _RemoteADLUserPath='$ADL_USER_PATH'
			export _REM_CALL_SH=""
			RemoteOS=UNIX
		fi
	fi
}

# =====================================================================
# Check that the given transfer name is valid 
# and if not set then find one.
# Once the transfer is determined, check that remote workspace has not
# changed since the transfer has been set up.
#
# INPUT
#   _T_NAME = transfer name or null
#   _TREE_LIST_FILE = name of the file containing the tree names (one per line)
# OUTPUT
#   _T_NAME 
#   _L_SITE = UUID of local site
#   _R_WS_TREE_LIST = list of remote trees corresponding to the given local tree(s)
#   _R_WS = name of remote mirror workspace
#   _R_WS_ID = UUID of the remote mirror workspace
#   _R_SITE = name of remote site
#   _R_SERVER = name and port of remote transfer manager to connect with
#   If routing is enable for a given transfer, _R_SERVER contains the complete route
#   to the targer manager
#   _L_IMAGE = name of one image of the current workspace 
#              if transfer specific files are stored in it
#   _L_DIR = path to the directory where to store transfer specific files
#            It can be either the local workspace image or another directory
# =====================================================================

check_transfer()
{
	[ ! -z "$ADL_DEBUG" ] && set -x

	if [ -z "$_T_NAME" ]
	then
		"$ADL_USER_PATH"/adl_ls_transfer -ws "$ADL_WS" -program -sep "|" -out "$DefaultTmpDir"/ls_transfer_$$.txt >$NULL
		[ $? -ne 0 ] && Out 5 0014 "$ADL_WS" # "Failed to list transfers associated with workspace /p1."
		[ ! -f "$DefaultTmpDir"/ls_transfer_$$.txt -o ! -s "$DefaultTmpDir"/ls_transfer_$$.txt ] && Out 5 0220 "$ADL_WS" # "There is no transfer defined for workspace /p1."
		nbl=$($_AWK -F\| '{print $3}' "$DefaultTmpDir"/ls_transfer_$$.txt | "$_SORT" -u | wc -l)
		if [ $nbl -gt 1 ]
		then
			_printerr 0019 # "There is more than one transfer defined for the current workspace. Select one transfer in the list below:"
			$_AWK -F\| '{if ($15!="<NULL>") printf("    %s (Image %s)\n", $3, $15); else print "    "$3}' "$DefaultTmpDir"/ls_transfer_$$.txt | "$_SORT" -u
			Out 5 # "Command aborted"
		fi
	else
		# Check transfer name exists for the given workspace
		"$ADL_USER_PATH"/adl_ls_transfer $_T_NAME -ws "$ADL_WS" -program -sep "|" -out "$DefaultTmpDir"/ls_transfer_$$.txt >$NULL
		[ $? -ne 0 ] && Out 5 0014 "$ADL_WS" # "Failed to list transfers associated with workspace /p1."
		nbl=$(cat "$DefaultTmpDir"/ls_transfer_$$.txt | wc -l)
		if [ $nbl -eq 0 ]
		then
			Out 5 0020 "$_T_NAME" "$ADL_WS" # "The transfer /p1 is not defined for the workspace /p2."
		fi
	fi
	export _T_NAME=$($_AWK -F\| '{print $3}' "$DefaultTmpDir"/ls_transfer_$$.txt | "$_SORT" -u)

	# Now that we have a transfer name, check it exists and is defined for the given workspace tree(s)
	unset _R_WS_TREE_LIST
	_TREE_LIST_FILE=${_TREE_LIST_FILE:-"$DefaultTmpDir"/ls_tree_$$.txt}

	if [ ! -z "$_L_WS_TREE" ]
	then
		echo "$_L_WS_TREE" > "$_TREE_LIST_FILE" || Out 5 0221 "$_TREE_LIST_FILE"
	elif [ -z "$_TREE_OPTION" ]
	then
		$_AWK -F\| '{print $5}' "$DefaultTmpDir"/ls_transfer_$$.txt > "$_TREE_LIST_FILE"
	fi

	while read _one_tree
	do
		_R_WS_TREE=$($_AWK -F\| '{if (tolower($5)==tolower("'$_one_tree'")) print $9}' "$DefaultTmpDir"/ls_transfer_$$.txt)
		[ -z "$_R_WS_TREE" ] && Out 5 0021 "$_T_NAME" "$_one_tree" "$ADL_WS" # "The transfer /p1 is not defined in the workspace tree /p2 for the workspace /p3."
		_R_WS_TREE_LIST="${_R_WS_TREE} $_R_WS_TREE_LIST"
	done < "$_TREE_LIST_FILE"
	export _R_WS_TREE_LIST


	# Get name and UUID of remote mirror workspace + information about the remote transfer manager
	# All the transfers are supposed to have the same remote workspace and the same attributes
	# So we take the first transfer of the list
	head -1 "$DefaultTmpDir"/ls_transfer_$$.txt > "$DefaultTmpDir"/ls_transfer2_$$.txt
	[ $? -ne 0 ] && Out 5 0221 "$DefaultTmpDir"/ls_transfer2_$$.txt
	export _R_WS=$($_AWK -F\| '{print $7}' "$DefaultTmpDir"/ls_transfer2_$$.txt)
	export _R_WS_ID=$($_AWK -F\| '{print $8}' "$DefaultTmpDir"/ls_transfer2_$$.txt)
	export _R_SITE="$($_AWK -F\| '{print $11}' "$DefaultTmpDir"/ls_transfer2_$$.txt)"
	export _R_HOST=$($_AWK -F\| '{print $13}' "$DefaultTmpDir"/ls_transfer2_$$.txt)
	export _R_PORT=$($_AWK -F\| '{print $14}' "$DefaultTmpDir"/ls_transfer2_$$.txt)
	[ -z "$_R_WS" -o -z "$_R_WS_ID" ] && Out 5 0222 # "Could not get name and uuid of the remote mirror workspace..."
	[ -z "$_R_HOST" ] && Out 5 0227 # "Could not get information about the remote multisite transfer manager..."
	if [ "$_R_PORT" = "\0" ]
	then
		export _R_SERVER="$_R_HOST"
		unset _R_PORT
	else
		export _R_SERVER="$_R_HOST:$_R_PORT"
	fi
	export _R_MIRROR_WS=$($_AWK -F\| '{print $19}' "$DefaultTmpDir"/ls_transfer2_$$.txt)

	unset _L_IMAGE
	unset _L_DIR
	export _L_IMAGE=$($_AWK -F\| '{print $15}' "$DefaultTmpDir"/ls_transfer2_$$.txt)
	[ $_L_IMAGE = "<NULL>" ] && unset _L_IMAGE
	export _L_DIR=$($_AWK -F\| '{print $17}' "$DefaultTmpDir"/ls_transfer2_$$.txt)

	# Check if the current image is appropriate for current transfer
	if [ -z "$ADL_IMAGE" ]
	then
		# "The transfer /p1 is associated with the image \"/p2\" but there is no current image..."
		[ ! -z "$_L_IMAGE" ] && Out 5 0027 "$_T_NAME" "$_L_IMAGE" "$ADL_WS" 
	else
		[ ! -z "$_L_IMAGE" -a "$_L_IMAGE" != "$ADL_IMAGE" ] && Out 5 0023 "$ADL_IMAGE" "$_T_NAME" "$_L_IMAGE" "$ADL_WS" # The current image is \"/p1\" but the transfer /p2 is associated with the image \"/p3\"...
	fi
	
	# Check if a specific directory is to be used for the current transfer
	_localhost1="$($_AWK -F\| '{print toupper($18)}' "$DefaultTmpDir"/ls_transfer2_$$.txt)"
	typeset -u _localhost2=$(hostname)
	# "The transfer /p1 is declared to store files in the directory \"/p2\" on the host \"/p3\" but the current host is..."
	[ "$_localhost1" != "<NETWORK>" -a "$_localhost1" != "$_localhost2" ] && Out 5 0028 "$_T_NAME" "$_L_DIR" "$_localhost1" "$_localhost2"
	# Check the directory is reachable
	[ ! -d "$_L_DIR" ] && Out 5 0029 "$_L_DIR" # "The directory "\/p1\" does not exist..."

	# Finally retrieve the local site UUID
	"$ADL_USER_PATH"/admin/adl_ls_site -program -out "$DefaultTmpDir"/info_$$.txt 2>&1
	[ $? -ne 0 ] && \cat "$DefaultTmpDir"/info_$$.txt && Out 5 0008 # "Could not get SCM local site's identifier"
	export _L_SITE="$($_AWK '{print $1}' "$DefaultTmpDir"/info_$$.txt)"
}

# =====================================================================
# Check consistency of information stored locally and remote mirror workspace
#
# INPUT
#   _R_WS = name of remote workspace as registered locally
#   _R_WS_ID = UUID of remote workspace as registered locally
# OUTPUT
#   _MIRROR_INFO_FILE = temporary file containing the result of adl_ds_ws
#                       on the mirror workspace (to avoid to call again)
# =====================================================================

check_remote_transfer()
{
	[ ! -z "$ADL_DEBUG" ] && set -x

	# Check that the remote workspace still exists and has not been renamed
	unset _OPTIONS
	[ ! -z "$_R_WS_TREE_LIST" ] && _OPTIONS="-tree $_R_WS_TREE_LIST"
	"$_CLIENT" $_RUN_COMMON -cmd '"'$_RemoteADLUserPath/adl_ds_ws'"' wsid:"${_R_WS_ID}" "$_OPTIONS" -program '-sep "|"' -out '"'$_R_TMP/r_ds_ws_$$.txt'"' 
	if [ $? -ne 0 ]
	then
		Out 5 0223 "$_R_WS" # "Failed to retrieve information about the remote workspace /p1..."
	else
		"$_CLIENT" $_RUN_COMMON -get "$_R_TMP/r_ds_ws_$$.txt" "$DefaultTmpDir"/r_ds_ws_$$.txt || Out 5 0025 "$_R_TMP/r_ds_ws_$$.txt" "$DefaultTmpDir"/r_ds_ws_$$.txt
		_curr_r_ws_id=$($_AWK -F\| '{if ($1=="MULTI_TREE_WS") print $3}' "$DefaultTmpDir"/r_ds_ws_$$.txt)
		[ "$_curr_r_ws_id" != "$_R_WS_ID" ] && Out 5 0224 "${_R_WS}" # "The remote workspace /p1 has not the same UUID as the one created when setting up the transfer..."
		_curr_r_ws_name=$($_AWK -F\| '{if ($1=="MULTI_TREE_WS") print $2}' "$DefaultTmpDir"/r_ds_ws_$$.txt)
		[ "$_curr_r_ws_name" != "$_R_WS" ] && Out 5 0225 "${_R_WS}" "$_curr_r_ws_name" # "The remote workspace /p1 has been renamed to /p2. Call a SCM administrator in order to change local transfer information."
	fi
	export _MIRROR_INFO_FILE="$DefaultTmpDir/r_ds_ws_$$.txt"
}
