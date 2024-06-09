#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName -tid TransferId -rhost RemoteHost -rl RemoteAdeleLevel -rp RemoteAdeleProfile -rw RemoteWs [-rimage image] -rb RemoteBase [-rproj RemoteProject] -f FileList -rtmp RemoteTmp [-ru username] -ltmp LocalTmpWs -lwd WorkingDir -ltd TraceDir

-tid TransferId       : Id of the transfer (example: ENO, DSA, DSP, ...)
-rhost RemoteHost     : Remote host name (example: centaur.deneb.com)
-rl RemoteAdeleLevel  : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp RemoreAdeleProfile: Path of the Adele profile to find adele installation
-rw RemoteWs          : Remote workspace name
-rimage image         : Image name of remote workspace
-rb RemoteBase        : Remote base (for chlev in Adele V3, for tck_profile in Adele V5)
-rproj RemoteProject  : Project in Remote base (For Adele V3 test purpose only)
-f Filelist           : File list path on local site
-rtmp RemoteTmp       : The remote temporary directory to store compressed data to transfer
-ru username          : The remote user name
-ltmp LocalTmpWs      : The local temporary directory to store transfered data
-lwd WorkingDir       : The local working directory
-ltd TraceDir         : The local trace directory

ATTENTION: You must be in a workspace before invoke this script
"
# =====================================================================

OS=$(uname -s)
case $OS in
	AIX)					
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		RSH="/usr/bin/rsh"
		;;
	HP-UX)
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		RSH="/bin/remsh"
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		RSH="/usr/bsd/rsh"
		;;
	SunOS)
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
		RSH="/bin/rsh"
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

	rm -fr /tmp/*_$$ /tmp/*_$$.Z
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM

# =====================================================================
# try_rcp function
# =====================================================================
try_rcp()
{
	nbtry=1
	while [ $nbtry -lt 3 ]
	do
		rcp $1 $2
		rtcode=$?
		[ $rtcode -eq 0 ] && break
		nbtry=$(expr $nbtry + 1)
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

_R_USER=$($WHOAMI)

unset _TID
unset _FILE_LIST
unset _L_TEMP_WS
unset _R_HOST
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_WS
unset _R_IMAGE
unset _R_BASE
unset _R_PROJECT
unset _R_TMP
unset _ADL_WORKING_DIR
unset _ADL_TRACE_DIR

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
		-f ) #-------------------> FILELIST PATH IN LOCAL SITE
			CheckOptArg "$1" "$2"
			_FILE_LIST=$2
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
		-ltmp ) #-------------------> LOCAL TEMPORARY DIRECTORY
			CheckOptArg "$1" "$2"
			_L_TEMP_WS=$2
			shift 2
				;;
		-lwd ) #-------------------> LOCAL WORKING DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_WORKING_DIR=$2
			shift 2
				;;

		-ltd ) #-------------------> LOCAL TRACE DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_TRACE_DIR=$2
			shift 2
				;;
		 * ) echo "Unknown option: $1" 1>&2
		Out 3 "$Usage"
		;;
	esac
done

if [ -z "$_R_HOST" -o -z "$_R_WS" -o -z "$_R_ADL_VERSION" -o -z "$_R_ADL_PROFILE" ] 
then
	echo "$ShellName: Missing mandatory parameter." 1>&2
	Out 3 "$Usage"
fi

if [ ! -z "$_R_PROJECT" ] && [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter when you require Project in Adele V3 site." 1>&2
	Out 3 "$Usage"
fi

if [ -z "$_R_BASE" ] 
then
	echo "$ShellName: Remote Adele base is a mandatory parameter." 1>&2
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

if [ -z "$_FILE_LIST" ]
then
	echo "$ShellName: path of the filelist is required."
	Out 3 "$Usage"
fi

if [ -z "$_L_TEMP_WS" ]
then
	echo "$ShellName: Local temporary directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_R_TMP" ]
then
	echo "$ShellName: Remote temporary directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_WORKING_DIR" ]
then
	echo "$ShellName: Local working directory is required."
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
echo "____________________________________________________________"
echo "$CurrentDate : File transfer from remote site to local site"
	
_R_FILE_LIST=$_R_TMP/$(basename $_FILE_LIST)_$$

# On affiche la liste des fichiers a transferer
#cat $_FILE_LIST

# Determination du repertoire de travail
if [ ! -d $_ADL_WORKING_DIR ]
then
	mkdir -p $_ADL_WORKING_DIR
	rc=$?
	if [ $rc -ne 0 ]
	then
		Out 3 "mkdir $_ADL_WORKING_DIR $rc"
	fi
fi

# * Recherche de l'outil adl_tar
# Comme cet outil s'appuie sur GNUtar qui ne peut pas etre livre comme
# les outils maison, on suppose qu'il est sujet d'une installation
# particuliere, aussi bien en local que sur le site distant :
# ou on le trouve dans $CAA_INSTALL_DIR/AdeleMultiSite/local,
# ou dans /u/lego/adele/util/AdeleMultiSite/local.

if [ ! -z "$CAA_INSTALL_DIR" ]
then 
	if [ ! -d "$CAA_INSTALL_DIR/AdeleMultiSite/local" ]
	then
		Out 3 "Cannot find $CAA_INSTALL_DIR/AdeleMultiSite/local directory"
	fi
	ADL_TAR=$CAA_INSTALL_DIR/AdeleMultiSite/local/adl_tar
else
	if [ ! -d /u/lego/adele/util/AdeleMultiSite/local ]
	then
		Out 3 "Cannot find /u/lego/adele/util/AdeleMultiSite/local directory"
	fi
	ADL_TAR=/u/lego/adele/util/AdeleMultiSite/local/adl_tar
fi

if [ ! -f $ADL_TAR ]
then
	Out 3 "Cannot find adl_tar tool"
fi

# =====================================================================
# Preparation de la compression des fichiers a transferer sur le site distant
# =====================================================================
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

LocalCompressedFile=$_ADL_WORKING_DIR/0LocalCompressedFiles_$$.Z
RemoteCompressedFile=$_R_TMP/0RemoteCompressedFilesToTransfer_${_TID}_$$.Z
LocalTarTraces=$_ADL_TRACE_DIR/0adl_tar_traces
RemoteTarTraces=$_R_TMP/0adl_tar_traces_${_TID}_$$

# On envoie la liste des fichiers a transferer
echo "\n> Sending list of files to transfer on $_R_HOST:$_R_FILE_LIST"
try_rcp $_FILE_LIST ${_R_USER}@$_R_HOST:$_R_FILE_LIST
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot send the list of files to transfer on $_R_HOST:_R_TMP/$_R_FILE_LIST : $rc"

echo "\n> Calculating necessary temporary storage on $_R_HOST, taring and compressing files to transfer"

rsh_program='
	Out()
	{
		trap " " HUP INT QUIT TERM
		ExitCode=$1
		if [ $# -ge 2 ]
		then
			shift
			echo "!!! KO : $*"
		fi

		rm -fr /tmp/*_$$ /tmp/*_$$.Z
		exit $ExitCode
	}

	OS=$(uname -s)
	case $OS in
		AIX)					
			PING="/usr/sbin/ping -c 1"
			WHOAMI="/bin/whoami"
			MAIL="/bin/mail"
			_AWK=/bin/awk
			RSH="/usr/bin/rsh"
			;;
		HP-UX)
			PING="/usr/sbin/ping -n 1"
			WHOAMI="/usr/bin/whoami"
			MAIL="/usr/bin/mail"
			_AWK=/bin/awk
			RSH="/usr/bin/rsh"
			;;
		IRIX | IRIX64)
			PING="/usr/etc/ping -c 1"
			WHOAMI="/usr/bin/whoami"
			MAIL="/usr/bin/mail"
			_AWK=/bin/nawk
			RSH="/usr/bsd/rsh"
			;;
		SunOS)
			PING="/usr/sbin/ping"
			WHOAMI="/usr/ucb/whoami"
			MAIL="/bin/mailx"
			_AWK=/bin/nawk
			RSH="/bin/rsh"
			;;
	esac
	'
if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Remote Adele version 3
	# ----------------------------------------------------------------------
	rsh_program="$rsh_program"'
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

		echo "\n>>> adl_ch_ws $_R_WS"

		. '$_R_ADL_PROFILE' </dev/null

		CHLEV_OPT='$_R_BASE'
		[ ! -z "'$_R_PROJECT'" ] && CHLEV_OPT='$_R_PROJECT'" -r "'$_R_BASE'
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
		'
else
	# ----------------------------------------------------------------------
	# Remote Adele version 5
	# ----------------------------------------------------------------------
	rsh_program="$rsh_program"'
		echo "\n>>> adl_ch_ws"

		. '$_R_ADL_PROFILE' </dev/null
		
		tck_profile '$_R_BASE' </dev/null
		rc_chlev=$?
		if [ $rc_chlev -ne 0 ]
		then
			Out 3 "tck_profile $rc_chlev"
		fi

		OPTIONS='$_R_WS'
		[ ! -z "'$_R_IMAGE'" ] && OPTIONS="$OPTIONS -image '$_R_IMAGE'"
		adl_ch_ws $OPTIONS </dev/null
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "adl_ch_ws $rc"
		fi
		'
fi

rsh_program="$rsh_program"'
	# * Recherche de adl_tar
	if [ ! -z "$CAA_INSTALL_DIR" ]
	then 
		if [ ! -d "$CAA_INSTALL_DIR/AdeleMultiSite/local" ]
		then
			Out 3 "Cannot find $CAA_INSTALL_DIR/AdeleMultiSite/local directory"
		fi
		ADL_TAR=$CAA_INSTALL_DIR/AdeleMultiSite/local/adl_tar
	else
		DirAdlProfile=$(dirname '$_R_ADL_PROFILE')
		if [ -d $DirAdlProfile/AdeleMultiSite/local ]
		then
			ADL_TAR=$DirAdlProfile/AdeleMultiSite/local/adl_tar

		elif [ -d /u/lego/adele/util/AdeleMultiSite/local ]
		then
			ADL_TAR=/u/lego/adele/util/AdeleMultiSite/local/adl_tar
		else
			Out 3 "Cannot find /u/lego/adele/util/AdeleMultiSite/local directory"
		fi
	fi

	if [ ! -f $ADL_TAR ]
	then
		Out 3 "Cannot find adl_tar tool"
	fi

	# calcul de la taille necessaire
	TotalSize=0
	NbFiles=0
	while read fic
	do
		if [ ! -f "$fic" ]
		then
			Out 3 "Unknown file $fic"
		fi
		SizeFile=$(ls -l "$fic" | $_AWK '"'"'{print $5}'"'"')
		let "TotalSize = TotalSize + SizeFile"
		let "NbFiles = NbFiles + 1"
	done < '$_R_FILE_LIST'

	let "TotalSize = (TotalSize / 1024) + 1"
	OS=$(uname -s)
	case $OS in
		AIX)					
			FreeTemporarySize=$(df -k '$_R_TMP' | tail -1 | $_AWK '"'"'{print $3}'"'"')
			;;
		HP-UX)
			FreeTemporarySize=$(df -k '$_R_TMP' | $_AWK '"'"'(FNR == 2) {print $1}'"'"')
			;;
		IRIX | IRIX64)
			FreeTemporarySize=$(df -k '$_R_TMP' | tail -1 | $_AWK '"'"'{print $5}'"'"')
			;;
		SunOS)
			FreeTemporarySize=$(df -k '$_R_TMP' | tail -1 | $_AWK '"'"'{print $4}'"'"')
			;;
	esac

	if [ $TotalSize -gt $FreeTemporarySize ]
	then
		Out 3 "Not enough space in '$_R_TMP'. Space required in Kb: $TotalSize - Space available: $FreeTemporarySize"
	fi
	echo "\nSpace required in Kb: $TotalSize - Space available in '$_R_TMP': $FreeTemporarySize"

	# On cree le fichier tare et compresse
	if [ -f "'$RemoteCompressedFile'" ]
	then
		\rm -f '$RemoteCompressedFile'
		if [ $? -ne 0 ]
		then
			Out 3 "Cannot delete existing compressed file:'$RemoteCompressedFile'"
		fi
	fi
	$ADL_TAR -cvf '$RemoteCompressedFile' -T '$_R_FILE_LIST' -Z 2>&1 >'$RemoteTarTraces'
	rc=$?
	if [ $rc -ne 0 ] && [ $rc -ne 2 ]
	then
		Out 3 "Cannot create compressed file:'$RemoteCompressedFile' - Error code: $rc - Consult trace file on host '$_R_HOST':'$RemoteTarTraces'"
	fi
	\rm -f '$RemoteTarTraces'
	
	# Calcul de la taille du fichier a transferer
	FileSize=$(ls -l '$RemoteCompressedFile' | $_AWK '"'"'{print $5}'"'"')
	let "FileSize = (FileSize / 1024) + 1" 
	# On informe de la taille du fichier total et du nombre de fichiers
	printf "\n>>> Transfer Statistics:\n"
	printf "Number of files to transfer                           : %5d\n" $NbFiles
	printf "File size of compressed file to transfer (in Kbytes) <> %5d\n" $FileSize

	\rm -f '$_R_FILE_LIST'
	'


$RSH $_R_HOST -l $_R_USER "$rsh_program" </dev/null 2>&1 >$TraceFile

# =====================================================================
# Transfert des fichiers compresses sur le site local et decompression
# =====================================================================

# On verifie que la compression c'est bien passe
grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
cat $TraceFile
if [ $rc -eq 0 ]
then
	Out 3 "\nTraces on local site in: $TraceFile"
fi

# on verifie qu'on a la place pour recopier les fichiers a recevoir dans le file systeme de destination 
RequestedSize=$(grep '<>' $TraceFile | $_AWK '{print $NF}')
FreeSpace=$(GetFreeSpace $(dirname $LocalCompressedFile))
[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on file system: $LocalCompressedFile"
[ $FreeSpace -lt $RequestedSize ] && Out 3 "Not enough space in file system: $LocalCompressedFile to store file to receive.\nRequested size: $RequestedSize - Free space: $FreeSpace in Kbytes"

echo "\n> Transferring compressed file from $_R_HOST"
BeginDate=$(date +"%H:%M:%S")
echo "Begin of compressed file transfer at:" $BeginDate 

# On transfere le fichier compresse
try_rcp ${_R_USER}@$_R_HOST:$RemoteCompressedFile $LocalCompressedFile
rc=$?
EndDate=$(date +"%H:%M:%S")
echo "End of compressed file transfer at:" $EndDate 
if [ $rc -ne 0 -o ! -f $LocalCompressedFile ]
then
	Out 3 "Cannot transfer the compressed file with command: rcp ${_R_USER}@$_R_HOST:$RemoteCompressedFile $LocalCompressedFile"
fi

# On detruit le fichier compresse sur le site distant
$RSH $_R_HOST -l $_R_USER "rm -f $RemoteCompressedFile"

# On cree un repertoire bidon et on s'y place pour detarer le fichier
if [ -d $_L_TEMP_WS ] 
then
	\rm -rf $_L_TEMP_WS
fi

mkdir -p $_L_TEMP_WS
if [ $? -ne 0 -o ! -d $_L_TEMP_WS ]
then
	\rm -f $LocalCompressedFile
	Out 3 "Cannot create temporary Workspace directory: $_L_TEMP_WS"
fi

old_pwd=$(pwd)
cd $_L_TEMP_WS

# on verifie qu'on a la place pour detarer les fichiers
FreeSpace=$(GetFreeSpace $_L_TEMP_WS)
[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on file system: $_L_TEMP_WS"
[ $FreeSpace -lt $RequestedSize ] && Out 3 "Not enough space in file system: $_L_TEMP_WS to store file to receive.\nRequested size: $RequestedSize - Free space: $FreeSpace in Kbytes"

# On decompresse le fichier 
echo "\n> Uncompressing and untaring gotten file on local site"
$ADL_TAR -xvf $LocalCompressedFile -Z 2>&1 > $LocalTarTraces
if [ $? -ne 0 ]
then
	\rm -f $LocalCompressedFile
	cd $old_pwd
	Out 3 "Cannot uncompress or untar the transfered files into temporary Workspace directory: $_L_TEMP_WS - Consult trace file in $LocalTarTraces"
fi

# On detruit le fichier compresse.
\rm -f $LocalCompressedFile

cd $old_pwd

Out 0
