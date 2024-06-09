#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName -tid TransferId -rhost RemoteHost -rl RemoteAdeleLevel -rp RemoteAdeleProfile -rw RemoteWs -rb RemoteBase [-rimage RemoteWsImage] [-rproj RemoteProject] [-rtree tree] -rtmp RemoteTmp [-ru username] -c ComponentList -f FileList [-s separator] -a DbAttr -rsiteattr SiteAttr -ltd TraceDir

-tid TransferId       : Id of the transfer (example: ENO, DSA, DSP, ...)
-rhost RemoteHost     : Remote host name (example: centaur.deneb.com)
-rl RemoteAdeleLevel  : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp RemoteAdeleProfile: Path of the remote Adele profile to find adele installation
-rw RemoteWs          : Remote workspace name
-rb RemoteBase        : Remote base for Adele V3 or tck for Adele V5
-rimage RemoteWsImage : Remote workspace image name (For Adele V5 purpose only)
-rproj RemoteProject  : Project in Remote base (For Adele V3 test purpose only)
-rtree tree           : To filter lsout on a particular tree (For Adele V5 purpose only)
-rtmp RemoteTmp       : The remote temporary directory to store data
-ru username          : The remote user name
-c Componentlist      : Component list path on local site
-f Filelist           : File list path on local site
-s Separator          : Field separator; space is the default one
-a DbAttr             : File path on local site containing remote database attributes
-rsiteattr SiteAttr   : File path on local site containing remote site attributes
-ltd TraceDir         : The local trace directory
"
# =====================================================================
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
	rm -fr /tmp/*_$$
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM

# =====================================================================
# try_rcp function
# =====================================================================
try_rcp()
{
#set -x
	nbtry=1
	rtcode=1
	while [ $nbtry -lt 10 -a $rtcode -ne 0 ]
	do
		rcp $1 $2
		rtcode=$?
		[ $rtcode -eq 0 ] && break
		nbtry=$(expr $nbtry + 1)
		echo "try rcp for the $nbtry time(s)..."
	done
	return $rtcode
}

# =====================================================================
# GetFreeSpace function
# result in Kbytes
# =====================================================================
GetFreeSpace()
{
#set -x
if [ ! -d "$1" ]
then
    if [ ! -f "$1" ]
    then
        FreeTemporarySize=-1
        echo $FreeTemporarySize
        return
    else
        DirToCheck=$(dirname $1)
    fi
else
    DirToCheck=$1
fi

old_pwd=$(pwd)
cd $DirToCheck >/dev/null 2>&1
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
    esac
    echo $FreeTemporarySize
else
    echo -1
fi
cd $old_pwd >/dev/null 2>&1
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

#set -x
unset _TID
unset _FILE_LIST
export _FIELD_SEP=" " # Espace par defaut
unset _COMP_LIST
unset _DB_ATTR

_R_USER=$($WHOAMI)

unset _R_HOST
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_WS
unset _R_BASE
unset _R_IMAGE
unset _R_PROJECT
unset _WS_TREE
unset _R_TMP
unset _ADL_TRACE_DIR

while [ $# -ge 1 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			Out 0
			;;
		-tid ) #-------------------> TRANSFER ID
			CheckOptArg "$1" "$2"
			_TID=$2
			shift 2
			;;
		-rhost ) #-------------------> REMOTE HOST
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
		-rb ) #-------------------> REMOTE BASE
			CheckOptArg "$1" "$2"
			_R_BASE=$2
			shift 2
			;;
		-rimage ) #-------------------> REMOTE WORKSPACE IMAGE
			CheckOptArg "$1" "$2"
			_R_IMAGE=$2
			shift 2
			;;
		-rproj ) #-------------------> PROJECT IN REMOTE BASE
			CheckOptArg "$1" "$2"
			_R_PROJECT=$2
			shift 2
			;;
		-rtree ) #-------------------> TREE IN REMOTE BASE
			CheckOptArg "$1" "$2"
			_WS_TREE=$2
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
		-c ) #-------------------> COMPONENTLIST PATH IN LOCAL SITE
			CheckOptArg "$1" "$2"
			_COMP_LIST=$2
			shift 2
			;;
		-f ) #-------------------> FILELIST PATH IN LOCAL SITE
			CheckOptArg "$1" "$2"
			_FILE_LIST=$2
			shift 2
			;;
		-s ) #-------------------> FILELIST FIELD SEPARATOR
			CheckOptArg "$1" "$2"
			_FIELD_SEP="$2"
			shift 2
			;;
		-a ) #-------------------> OPTIONAL: Database attributes file path
			CheckOptArg "$1" "$2"
			_DB_ATTR=$2
			shift 2
				;;
		-rsiteattr ) #-------------------> MANDATORY: remote site attributes file path
			CheckOptArg "$1" "$2"
			_RSITE_ATTR=$2
			shift 2
				;;
		-ltd ) #-------------------> LOCAL TRACE DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_TRACE_DIR=$2
			shift 2
				;;
		 * )
			echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

if [ -z "$_R_HOST" -o -z "$_R_WS" -o -z "$_R_ADL_VERSION" -o -z "$_R_ADL_PROFILE" ] 
then
	echo "$ShellName: Missing mandatory parameter." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base (or tck) is a mandatory parameter on an Adele V3 (or V5) site." 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_R_PROJECT" ] && [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter when you require Project in Adele V3 site." 1>&2
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

if [ -z "$_COMP_LIST" ]
then
	echo "$ShellName: path of the component list is required."
	Out 3 "$Usage"
fi

if [ -z "$_FILE_LIST" ]
then
	echo "$ShellName: path of the filelist is required."
	Out 3 "$Usage"
fi

if [ -z "$_DB_ATTR" ]
then
	echo "$ShellName: path of the database attribute file is required."
	Out 3 "$Usage"
fi

if [ -z "$_R_TMP" ]
then
	echo "$ShellName: Remote temporary directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_TRACE_DIR" ]
then
	echo "$ShellName: Local trace directory is required."
	Out 3 "$Usage"
fi
# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)

if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	_GET_LISTS_SHELL=adl_internal_get_lists_v3.sh
	_GET_COMPLISTS_SHELL=adl_internal_get_complists_v3.sh

elif [ $_R_ADL_VERSION = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	_GET_LISTS_SHELL=adl_internal_get_lists_v5.sh
	_GET_COMPLISTS_SHELL=adl_internal_get_complists_v5.sh

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown _R_ADL_VERSION in $ShellName: $_R_ADL_VERSION"
fi

echo "____________________________________________________________"
echo "$CurrentDate : Calculate Lsout on remote workspace $_R_HOST:$base:$_R_WS"

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

if [ ! -f $ShellDir/$_GET_LISTS_SHELL ]
then
	Out 3 "Cannot find $_GET_LISTS_SHELL"
fi

if [ ! -f $ShellDir/$_GET_COMPLISTS_SHELL ]
then
	Out 3 "Cannot find $_GET_COMPLISTS_SHELL"
fi

fgrep "\\'" $ShellDir/$_GET_LISTS_SHELL >/dev/null
if [ $? -eq 0 ]
then
	Out 3 "Unable to treat \\' into $ShellDir/$_GET_LISTS_SHELL"
fi

fgrep "\\'" $ShellDir/$_GET_COMPLISTS_SHELL >/dev/null
if [ $? -eq 0 ]
then
	Out 3 "Unable to treat \\' into $ShellDir/$_GET_COMPLISTS_SHELL"
fi

# Construction du fichier a executer en .
echo '
	Out()
	{
		trap " " HUP INT QUIT TERM
		ExitCode=$1
		if [ $# -ge 2 ]
		then
			shift
			echo "!!! KO : $*"
		fi
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
			;;
		HP-UX)
			PING="/usr/sbin/ping -n 1"
			WHOAMI="/usr/bin/whoami"
			MAIL="/usr/bin/mail"
			_AWK=/bin/awk
			DU=/bin/du
			RSH="/bin/remsh"
			COMPRESS=/bin/compress
			;;
		IRIX | IRIX64)
			PING="/usr/etc/ping -c 1"
			WHOAMI="/usr/bin/whoami"
			MAIL="/usr/bin/mail"
			_AWK=/bin/nawk
			DU=/bin/du
			RSH="/usr/bsd/rsh"
			COMPRESS=/usr/bsd/compress
			;;
		SunOS)
			PING="/usr/sbin/ping"
			WHOAMI="/usr/ucb/whoami"
			MAIL="/bin/mailx"
			_AWK=/bin/nawk
			DU=/bin/du
			RSH="/bin/rsh"
			COMPRESS=/usr/bin/compress
			;;
	esac

	_ADL_WORKING_DIR="'$_R_TMP/adl_transfer_${_TID}'"
	_FIELD_SEP="'$_FIELD_SEP'"
	_ADL_FILTER_TREE="'$_WS_TREE'"

	echo "\n>>> adl_ch_ws '$_R_WS'"

	. '$_R_ADL_PROFILE' </dev/null
' > /tmp/rsh_$$

if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	echo '
        Try_adl()
        {
            WriteDotFrequently 1 1>&2 &
            PID=$!
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
            kill $PID
            return $rc
        }

		CHLEV_OPT='$_R_BASE'
		[ ! -z "'$_R_PROJECT'" ] && CHLEV_OPT="'$_R_PROJECT' -r '$_R_BASE'"
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
	' >> /tmp/rsh_$$
else
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	echo '
        RunCmd()
        {
            WriteDotFrequently 1 1>&2 &
            PID=$!
            "$@" </dev/null
            rc=$?
            kill $PID
            return $rc
        }

		OPTIONS='$_R_BASE'
		RunCmd tck_profile $OPTIONS
		rc_tck=$?
		if [ $rc_tck -ne 0 ]
		then
			Out 3 "tck_profile $OPTIONS $rc_tck"
		fi

		OPTIONS='$_R_WS'
		[ ! -z "'$_R_IMAGE'" ] && OPTIONS="${OPTIONS} -image "'$_R_IMAGE'
		RunCmd adl_ch_ws $OPTIONS </dev/null
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "adl_ch_ws $OPTIONS $rc"
		fi
	' >> /tmp/rsh_$$
fi

cat $ShellDir/$_GET_LISTS_SHELL $ShellDir/$_GET_COMPLISTS_SHELL >>/tmp/rsh_$$

echo '
	# On detruit si besoin le repertoire des fichiers a envoyer
	_TO_SEND_DIR=$_ADL_WORKING_DIR/ToSend
	if [ -d $_TO_SEND_DIR ] 
	then
		rm -rf $_TO_SEND_DIR
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot remove existing directory $_TO_SEND_DIR to write files to send to local site - $rc"
		fi
	fi

	# On cree le repertoire des fichiers a envoyer
	mkdir -p $_TO_SEND_DIR
	if [ $? -ne 0 ]
	then
		Out 3 "Cannot create directory $_TO_SEND_DIR to write files to send to local site - $rc"
	fi

	# On stocke les fichiers a envoyer dans le repertoire 
	/bin/mv -f $_ADL_WORKING_DIR/0Lsout_conf.txt $_TO_SEND_DIR/0Lsout.current
	/bin/mv -f $_ADL_WORKING_DIR/0CompList.txt $_TO_SEND_DIR/0CompList.current
	if [ -f $_ADL_WORKING_DIR/0DatabaseAttributes ]
	then
		/bin/mv -f $_ADL_WORKING_DIR/0DatabaseAttributes $_TO_SEND_DIR
	fi
	if [ -f $_ADL_WORKING_DIR/0SiteAttributes.txt ]
	then
		/bin/mv -f $_ADL_WORKING_DIR/0SiteAttributes.txt $_TO_SEND_DIR
	fi
	SizeDirectory=$($DU -s $_TO_SEND_DIR)
	[ -z "$SizeDirectory" ] && Out 3 "Cannot calculate size of filelist"

	echo "\nDirectory path containing files :\n<> $_TO_SEND_DIR $SizeDirectory <>" 

	$COMPRESS -cvf $_TO_SEND_DIR/0Lsout.current > $_TO_SEND_DIR/0Lsout.current.Z
	rc=$?
	if [ $rc -ne 0 ] && [ $rc -ne 2 ]
	then
		Out 3 "Cannot compress file list $rc"
	fi

	$COMPRESS -cvf $_TO_SEND_DIR/0CompList.current > $_TO_SEND_DIR/0CompList.current.Z
	rc=$?
	if [ $rc -ne 0 ] && [ $rc -ne 2 ]
	then
		Out 3 "Cannot compress component list $rc"
	fi

	# Menage
	CleanWorkingDir
	CleanWorkingDirComp
' >> /tmp/rsh_$$

if [ ! -f /tmp/rsh_$$ ]
then
	Out 3 "Unable to build the file /tmp/rsh_$$ to execute at $_R_HOST"
fi

# Copie sur le site distant
rcsh=1
nbtry=0
while [ $rcsh -ne 0 -a $nbtry -lt 10 ]
do
	$RSH $_R_HOST -l $_R_USER "mkdir -p $_R_TMP"
	rcsh=$?
	if [ $rcsh -ne 0 ]
	then
		echo "Test $RSH  $_R_HOST for the  $nbtry times"	
		nbtry=$(expr $nbtry + 1)	
	fi
done
_R_GET_LISTS=$_R_TMP/adl_get_lists_${_TID}
try_rcp /tmp/rsh_$$ ${_R_USER}@$_R_HOST:$_R_GET_LISTS
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot transfer remote shell"

#set -x
$RSH $_R_HOST -l $_R_USER "
	if [ ! -f $_R_GET_LISTS ]
	then
		echo \"KO !!! $_R_GET_LISTS not found\"
	else
		. $_R_GET_LISTS
		rm -f $_R_GET_LISTS
	fi
	" < /dev/null  2>&1 | tee $TraceFile 

grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
[ $rc -eq 0 ] && Out 3 "Consult traces in: $TraceFile"

# On va chercher la liste des fichiers de l'espace distant
TraceRequested=$(grep '^<> ' $TraceFile)
[ $? -ne 0 ] && Out 3 "Cannot calculate remote directory path containing files to get on local site"
#set +x

RemoteDirectoryPath=$(echo $TraceRequested | $_AWK '{print $2}')
[ -z "$RemoteDirectoryPath" ] && Out 3 "Cannot calculate remote directory path containing files to get on local site(2)"

SizeRemoteDirectory=$(echo $TraceRequested | $_AWK '{print $3}')
[ -z "$SizeRemoteDirectory" ] && Out 3 "Cannot calculate size of remote directory containing files to get on local site(2)"
let "SizeRemoteDirectory = (SizeRemoteDirectory / 2)"

# On rapatrie tous les fichiers calcules sur le site remote
LocalDirectoryPath=/tmp/LocalFileToSend_$$
if [ -d $LocalDirectoryPath ]
then
	rm -rf $LocalDirectoryPath
	rc=$?
	[ $rc -ne 0 ] && Out 3 "Cannot remove existing temporary directory $LocalDirectoryPath - $rc "
fi
mkdir -p $LocalDirectoryPath
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot create temporary directory $LocalDirectoryPath - $rc "

# on verifie qu'on a la place pour recopier les outlist
FreeSpace=$(GetFreeSpace $(dirname $LocalDirectoryPath))
[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on file system: $LocalDirectoryPath"
[ $FreeSpace -lt $SizeRemoteDirectory ] && Out 3 "Not enough space in file system: $LocalDirectoryPath to store temporary file lists"

# on fait la copie proprement dite
try_rcp "${_R_USER}@$_R_HOST:$RemoteDirectoryPath/*" $LocalDirectoryPath
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot transfer remote file list"

# On s'occupe de la lsout
#-------------------------
# on verifie qu'on a la place pour recopier les outlist
FreeSpace=$(GetFreeSpace $(dirname $_FILE_LIST.Z))
[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on file system: $_FILE_LIST.Z"
[ $FreeSpace -lt $SizeRemoteDirectory ] && Out 3 "Not enough space in file system: $_FILE_LIST.Z to store temporary file lists"

mv $LocalDirectoryPath/0Lsout.current.Z $_FILE_LIST.Z
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot move remote file list from $LocalDirectoryPath/0Lsout.current.Z to $_FILE_LIST.Z"
# Decompression du fichier ramene
$UNCOMPRESS -f $_FILE_LIST.Z
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot uncompress remote file list $_FILE_LIST.Z - $rc"

# On s'occupe de la component list
#----------------------------------
# on verifie qu'on a la place pour recopier la component list
FreeSpace=$(GetFreeSpace $(dirname $_COMP_LIST.Z))
[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on file system: $_COMP_LIST.Z"
[ $FreeSpace -lt $SizeRemoteDirectory ] && Out 3 "Not enough space in file system: $_COMP_LIST.Z to store temporary component lists"

mv $LocalDirectoryPath/0CompList.current.Z $_COMP_LIST.Z
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot move remote component list from $LocalDirectoryPath/0CompList.current.Z to $_COMP_LIST.Z"
# Decompression du fichier ramene
$UNCOMPRESS -f $_COMP_LIST.Z
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot uncompress remote component list $_COMP_LIST.Z - $rc"

# On s'occupe de la trash
#-------------------------
mv $LocalDirectoryPath/0DatabaseAttributes $_DB_ATTR
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot move database attributes file from $LocalDirectoryPath/0DatabaseAttributes to $_DB_ATTR"

# On s'occupe des attributs du site
#-----------------------------------
mv $LocalDirectoryPath/0SiteAttributes.txt $_RSITE_ATTR
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot move site attributes file from $LocalDirectoryPath/0SiteAttributes.txt to $_RSITE_ATTR"

rm -rf $LocalDirectoryPath

Out 0
