#!/bin/ksh

# 
# Copyright © 2001, Dassault-Systemes.
#
# Internal shell for adl_site_transfer
#
[ ! -z "$ADL_DEBUG" ] && set -x

CmdLine="$@"

OS=$(uname -s)
if [ "$OS" = "Windows_NT" ]
then
	export _CALL_SH="sh +C -K "
	FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	ShellName="${FullShellName##*/}"
	cd "${FullShellName%/*}"
	ShellDir="$(pwd)"
	cd -

	DefaultTmpDir="$(printf "%s" "$TEMP" | sed 's+\\+/+g')"
	[ -z "$DefaultTmpDir" ] && DefaultTmpDir=C:/TEMP
	NULL=nul

else
	unset _CALL_SH
	FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	FullShellName2=${FullShellName%\'}
	FullShellName=${FullShellName2##\'}
	ShellName="${FullShellName##*/}"
	ShellDir="${FullShellName%/*}"

	DefaultTmpDir=/tmp
	NULL=/dev/null
fi
export DefaultTmpDir
export NULL

# Global variable initialization
case $OS in
	AIX)					
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
        _FIND=find
		;;
	HP-UX)
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
        _FIND=find
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
        _FIND=find
		;;
	SunOS)
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
        _FIND=find
		;;
	Windows_NT)
		PING="$SystemRoot/system32/ping.exe"
		WHOAMI="$SystemDrive/ntreskit/whoami.exe"
		MAIL="mail_not_found"
		_AWK="awk"
		_FIND="$(dirname "$SHELL")/find.exe"
		;;
esac

Usage="$ShellName -tmp tmp_directory [ -x -f tar_file ] | [ -c -l file_list -f tar_file] [ -tmp directory] [-v] [-z | -Z]

-x          : to extract data from the tar file
-c          : to copy data in the tar file
-l file_list: list of file to copy in the tar file (see -c option)
-f tar_file : name of the tar file
-tmp        : temporary directory 
-v          : to display traces
-tmp        : directory for temporary file
-d directory: if -c copy files from this directory in the tar file
              if -x change to this directory prior extracting data from the tar file
-z          : compress/uncompress data using gzip/gunzip
-Z          : compress/uncompress data using compress/uncompress

This command either creates a tar file from a list of files or extract files from a tar
"

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
		[ $ExitCode -eq 0 ] && echo "$*"
		[ $ExitCode -ne 0 ] && echo "#ERR# $*"
	fi

	rm -fr "$DefaultTmpDir"/*_$$ 
	# Effacement fichier tar seulement si code different de zero
	[ $ExitCode -ne 0 ] && rm -f "$DefaultTmpDir"/*_$$.Z
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM


# =====================================================================
# GetFreeSpace function
# result in Kbytes
# =====================================================================
GetFreeSpace()
{
	if [ ! -d "$1" ]
	then
		if [ ! -f "$1" ]
		then
			FreeTemporarySize=-1
			echo $FreeTemporarySize
			return
		else
			DirToCheck="$(dirname "$1")"
		fi
	else
		DirToCheck="$1"
	fi

	old_pwd="$(pwd)"
	cd "$DirToCheck" >$NULL 2>&1
	if [ $? -eq 0 ]
	then
		case $OS in
	        AIX)
        		FreeTemporarySize=$(df -k . | tail -1 | $_AWK '{print $3}')
			;;
		HP-UX)
			FreeTemporarySize=$(df -k . | $_AWK '(FNR == 2) {print $1}')
			;;
        	IRIX | IRIX64)
			FreeTemporarySize=$(df -k . | tail -1 | $_AWK '{print $5}')
			;;
		SunOS)
			FreeTemporarySize=$(df -k . | tail -1 | $_AWK '{print $4}')
			;;
		Windows_NT)
			FreeTemporarySize=$(df -k . | $_AWK '{print $3}' | $_AWK -F/ '{print $1}')
			;;
		esac
		echo $FreeTemporarySize
	else
		echo -1
	fi

	cd "$old_pwd" >$NULL 2>&1
}

# =====================================================================
# Options treatment
# =====================================================================
typeset -L1 OneChar
CheckOptArg()
{
	# Usage: CheckOptArg opt arg
	OneChar="$2"
	if [ "$2" = "" -o "$OneChar" = "-" ]
	then
		Out 3 "Option $1: one argument is required"
	fi
}

unset _FILE_LIST
unset _DIR_TO_TAR
unset _X_OPT
unset _C_OPT
unset _V_OPT
unset _z_OPT
unset _Z_OPT
_TMP_DIR="$DefaultTmpDir"

while [ $# -ge 1 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
				;;
		-l ) #-------------------> FILE LIST PATH 
			CheckOptArg "$1" "$2"
			_FILE_LIST="$2"
			shift 2
				;;
		-d ) #-------------------> DIRECTORY 
			CheckOptArg "$1" "$2"
			_DIR_TO_TAR="$2"
			shift 2
				;;
		-f ) #-------------------> TAR FILE PATH 
			CheckOptArg "$1" "$2"
			_TAR_FILE="$2"
			shift 2
				;;
		-tmp ) #-------------------> TEMPORARY DIRECTORY
			CheckOptArg "$1" "$2"
			_TMP_DIR="$2"
			shift 2
				;;
		-x ) #-------------------> EXTRACT DATA FROM TAR
			_X_OPT=true
			shift
				;;
		-c ) #-------------------> COPY DATA IN TAR
			_C_OPT=true
			shift
				;;
		-v ) #-------------------> VERBOSE
			_V_OPT=true
			shift
				;;
		-z ) #-------------------> GZIP
			_z_OPT="-z"
			shift
				;;
		-Z ) #-------------------> COMPRESS
			_Z_OPT="-Z"
			shift
				;;
		 * ) echo "$Usage"
			Out 5 "Unknown option: $1"
				;;
	esac
done

if [ ! -z "$_C_OPT" ]
then
	[ ! -z "$_X_OPT" ] && Out 5 "Only one option can be specified: -c -x"
	[ -z "$_FILE_LIST" -a -z "$_DIR_TO_TAR" ] && Out 5 "Missing list of files to tar"
	[ ! -z "$_FILE_LIST" -a ! -s "$_FILE_LIST" ] && Out 5 "List of files is empty or not accessible"
elif [ ! -z "$_X_OPT" ]
then
	[ ! -z "$_C_OPT" ] && Out 5 "Only one option can be specified: -c -x"
	if [ ! -f "$_TAR_FILE" ]
	then
		Out 5 "Could not stat tar file: $_TAR_FILE"
	elif [ ! -s "$_TAR_FILE" ]
	then
		Out 5 "tar file is empty: $_TAR_FILE"
	fi
else
	echo "$Usage"
	Out 5 "$ShellName: one of these options must be set: -x -c"
fi

[ ! -z "$_z_OPT" -a ! -z "$_Z_OPT" ] &&  Out 5 "Only one option can be specified: -z -Z"

if [ ! -z "$_DIR_TO_TAR" ]
then
	if [ ! -z "$_FILE_LIST" ]
	then
		Out 5 "Only one of these options can be set: -d -l"
	elif [ ! -d "$_DIR_TO_TAR" ]
	then
		Out 5 "directory does not exist: $_DIR_TO_TAR"
	fi

	_oldpwd="$(pwd)"
	cd "$_DIR_TO_TAR"
	
	if [ ! -z "$_C_OPT" ]
	then
		"$_FIND" . -type f -print > $_TMP_DIR/${ShellName}_flist_$$
		[ $? -ne 0 ] && Out 5 "Failed to list content of directory $_DIR_TO_TAR"
		_FILE_LIST="$_TMP_DIR/${ShellName}_flist_$$"

		cd "$_oldpwd"
	fi

	# on reste dans ce repertoire si l'option -x est positionnee
fi


# Recherche de l'outil adl_tar
# Comme cet outil s'appuie sur GNUtar qui ne peut pas etre livre comme
# les outils maison, on suppose qu'il est sujet d'une installation
# particuliere, aussi bien en local que sur le site distant :
# ou on le trouve dans $ADL_TAR_DIR,

unset ADL_TAR
if [ ! -z "$ADL_TAR_DIR" ]
then 
	if [ ! -d "$ADL_TAR_DIR" ]
	then
		Out 3 "Cannot find $ADL_TAR_DIR directory"
	fi
	ADL_TAR="$ADL_TAR_DIR/adl_tar"
fi

if [ -z "$ADL_TAR" -o ! -f "$ADL_TAR" ]
then
	Out 3 "Cannot find adl_tar tool. Check variable ADL_TAR_DIR"
fi


# =====================================================================
# Preparation de la compression des fichiers a transferer sur le site distant
# =====================================================================

#
# Creation fichier tar
#
if [ ! -z "$_C_OPT" ]
then

	# on verifie qu'on a la place pour faire le tar
	# calcul de la taille necessaire
	_oldpwd="$(pwd)"
	[ ! -z "$_DIR_TO_TAR" ] && cd "$_DIR_TO_TAR"
	TotalSize=0
	NbFiles=0
	while read fic
	do
		if [ ! -f "$fic" ]
		then
			Out 3 "Unknown file $fic"
		fi
		SizeFile=$(ls -l "$fic" | $_AWK '{print $5}')
		let "TotalSize = TotalSize + SizeFile"
		let "NbFiles = NbFiles + 1"
	done < "$_FILE_LIST"
	let "TotalSize = (TotalSize / 1024) + 1"

	FreeTemporarySize=$(GetFreeSpace "$(dirname "$_TAR_FILE")")

	if [ $TotalSize -gt $FreeTemporarySize ]
	then
		Out 3 "Not enough space for creating $(hostname):$_TAR_FILE. Space required in Kb: $TotalSize - Space available: $FreeTemporarySize"
	fi
	[ ! -z "$_V_OPT" ] && echo "\nSpace required in Kb: $TotalSize - Space available in "$(dirname "$_TAR_FILE")": $FreeTemporarySize"


	if [ -f "$CompressedFile" ]
	then
		rm -f "$CompressedFile"
		[ $? -ne 0 ] && Out 3 "Cannot delete existing compressed file: $CompressedFile"
	fi

	[ ! -z "$_V_OPT" ] && echo "Creating tar file $CompressedFile..."
	$_CALL_SH "$ADL_TAR" -c -v -f "$_TAR_FILE" -T "$_FILE_LIST" $_z_OPT $_Z_OPT > "$_TMP_DIR/0traces_$$" 2>&1
	rc=$?
	if [ $rc -ne 0 ] && [ $rc -ne 2 ]
	then
		cat "$_TMP_DIR/0traces_$$"
		Out 3 "Cannot create compressed file: $(hostname):$_TAR_FILE"
	elif [ ! -z "$_V_OPT" ]
	then
		cat "$_TMP_DIR/0traces_$$"
	fi

	cd "$_oldpwd"
fi	

#
# Extraction fichier tar : on extrait dans le repertoire courant
#
if [ ! -z "$_X_OPT" ]
then

	# on verifie qu'on a la place pour detarer les fichiers
	FreeSpace=$(GetFreeSpace "$(pwd)")
	[ $FreeSpace -eq -1 ] && Out 5 "Cannot get free space on current directory $(pwd) on host $(hostname)."

	# c'est pipeau car on teste pour l'instant une taille de donnees compressees !!!!
	FileSize=$(ls -l "$_TAR_FILE" | $_AWK '{print $5}')
	let "FileSize = (FileSize / 1024) + 1" 

	[ $FreeSpace -lt $FileSize ] && Out 5 "Not enough space in file system $(pwd) on host $(hostname) to store files being extracted.\nRequested size: $FileSize - Free space: $FreeSpace in Kbytes"

	# On decompresse le fichier 
	[ ! -z "$_V_OPT" ] && echo "Extracting data from $_TAR_FILE..."
	$_CALL_SH "$ADL_TAR" -x -v -f "$_TAR_FILE" $_z_OPT $_Z_OPT >"$_TMP_DIR/0traces_$$" 2>&1
	if [ $? -ne 0 ]
	then
		cat "$_TMP_DIR/0traces_$$"
		Out 5 "Cannot uncompress or untar data from tar file: $(hostname):$_TAR_FILE"
	elif [ ! -z "$_V_OPT" ]
	then
		cat "$_TMP_DIR/0traces_$$"
	fi

fi

Out 0
