#!/bin/ksh

FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName -tid TransferId -rhost RemoteHost -rl RemoteAdeleLevel -rp RemoteAdeleProfile -rw RemoteWs -rwd RemoteWorkingDir -rimage RemoteWsImage -rb RemoteBase [-rproj RemoteProject] -f FileList -rtmp RemoteTmp [-ru username] -ltmp LocalTmpWs -lwd WorkingDir -ltd TraceDir

-tid TransferId       : Id of the transfer (example: ENO, DSA, DSP, ...)
-rhost RemoteHost     : Remote host name (example: centaur.deneb.com)
-rl RemoteAdeleLevel  : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp RemoteAdeleProfile: Path of the Adele profile to find adele installation
-rw RemoteWs          : Remote workspace name
-rb RemoteBase        : Remote base (for chlev in Adele V3, for tck_profile in Adele V5)
-rimage RemoteWsImage : Remote workspace image name (For Adele V5 purpose only)
-rproj RemoteProject  : Project in Remote base (For Adele V3 test purpose only)
-rtmp RemoteTmpWs     : The remote temporary directory to store transfered data
-ru username          : The remote user name
-f Filelist           : File list path on local site
-ltmp LocalTmp        : The local temporary directory to store compressed data to transfer
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
            FreeTemporarySize=$(df -k . | _AWK '(FNR == 2) {print $1}')
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
unset _R_HOST
unset _R_ADL_VERSION
unset _R_ADL_PROFILE
unset _R_WS
unset _R_BASE
unset _R_IMAGE
unset _R_PROJECT
unset _R_TMP
unset _L_TMP
unset _ADL_REMOTE_WORKING_DIR
unset _ADL_LOCAL_WORKING_DIR
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
		-rimage ) #-------------------> REMOTE WORKSPACE IMAGE
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
		-rwd ) #-------------------> REMOTE WORKING DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_REMOTE_WORKING_DIR=$2
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
			_L_TMP=$2
			[ ! -d "$2" ] && mkdir -p "$2"
			shift 2
				;;
		-lwd ) #-------------------> LOCAL WORKING DIRECTORY
			CheckOptArg "$1" "$2"
			_ADL_LOCAL_WORKING_DIR=$2
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

if [ -z "$_R_TMP" ]
then
	echo "$ShellName: Remote temporary directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_L_TMP" ]
then
	echo "$ShellName: Local temporary directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_LOCAL_WORKING_DIR" ]
then
	echo "$ShellName: Local working directory is required."
	Out 3 "$Usage"
fi

if [ -z "$_ADL_TRACE_DIR" ]
then
	echo "$ShellName: Local trace directory is required."
	Out 3 "$Usage"
fi

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

# partie de shell pour les rsh regroupant les fonctions communes
rsh_functions='

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
	            FreeTemporarySize=$(df -k . | tail -1 | $_AWK '"'"'{print $3}'"'"')
	            ;;
	        HP-UX)
	            FreeTemporarySize=$(df -k . | _AWK '"'"'(FNR == 2) {print $1}'"'"')
	            ;;
 	       IRIX | IRIX64)
 	           FreeTemporarySize=$(df -k . | tail -1 | $_AWK '"'"'{print $5}'"'"')
 	           ;;
 	       SunOS)
	            FreeTemporarySize=$(df -k . | tail -1 | $_AWK '"'"'{print $4}'"'"')
	            ;;
	    esac
	    echo $FreeTemporarySize
	else
		echo -1
	fi
	cd $old_pwd >/dev/null 2>&1
	}

	'

# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate : File transfer from local site to remote site"
	
# S'il n'y a rien a faire, on va pas plus loin
if [ ! -f $_FILE_LIST -o ! -s $_FILE_LIST ]
then
	Out 0 "Nothing has evolved locally, thus there is nothing to transfer to remote site."
fi

# =====================================================================
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

#
# On a besoin de calculer le repertoire courant de travail sur le site distant
#

if [ $_R_ADL_VERSION = 3 ]
then
	# ----------------------------------------------------------------------
	# Remote Adele version 3
	# ----------------------------------------------------------------------
	rsh_adl_environment='
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
		print "\n_ADL_REMOTE_WORKING_DIR=$ADL_W_DIR/.Adele/MultiSite/'$_TID'"
		'
else
	# ----------------------------------------------------------------------
	# Remote Adele version 5
	# ----------------------------------------------------------------------
	rsh_adl_environment='
		echo "\n>>> adl_ch_ws"

		. '$_R_ADL_PROFILE' </dev/null
		
		tck_profile '$_R_BASE' </dev/null
		rc_chlev=$?
		if [ $rc_chlev -ne 0 ]
		then
			Out 3 "tck_profile $rc_chlev"
		fi

        OPTIONS='$_R_WS'
		[ ! -z "'$_R_IMAGE'" ] && OPTION="${OPTIONS} -image "'$_R_IMAGE'
		adl_ch_ws $OPTIONS </dev/null
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "adl_ch_ws $OPTIONS $rc"
		fi

		print "\n_ADL_REMOTE_WORKING_DIR=$ADL_IMAGE_DIR/ToolsData/MultiSite/'$_TID'"
		'
fi

rsh_program="$rsh_functions $rsh_adl_environment"
$RSH $_R_HOST -l $_R_USER "$rsh_program" </dev/null 2>&1 >$TraceFile

# On verifie que le rsh c'est bien passe
grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
cat $TraceFile
if [ $rc -eq 0 ]
then
	Out 3 "\nChecking environment on remote site is KO. Traces on local site in: $TraceFile"
fi

export _ADL_REMOTE_WORKING_DIR=$(grep '_ADL_REMOTE_WORKING_DIR=' $TraceFile | $_AWK -F= '{print $2}')

# =====================================================================
# Preparation de la compression des fichiers a transferer sur le site distant
# =====================================================================

LocalCompressedFile=$_L_TMP/0LocalCompressedFiles_$$.Z
RemoteCompressedFile=$_ADL_REMOTE_WORKING_DIR/0RemoteCompressedFilesToTransfer_${_TID}_$$.Z
LocalTarTraces=$_ADL_TRACE_DIR/0adl_tar_traces
RemoteTarTraces=$_R_TMP/0adl_tar_traces_${_TID}_$$

# =====================================================================
# On tare et comprime les fichiers a transferer
# =====================================================================

# On verifie qu'on a assez de place dans le "tmp" local pour faire le tar

_Curr_Dir=$(\pwd)

# On se place a la racine de l'espace de travail pour faire le tar
cd $_ADL_WS_ROOT_DIR

# calcul de la taille necessaire
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
done < $_FILE_LIST

let "TotalSize = (TotalSize / 1024) + 1"
OS=$(uname -s)
case $OS in
	AIX)					
		FreeTemporarySize=$(df -k $_L_TMP | tail -1 | $_AWK '{print $3}')
		;;
	HP-UX)
		FreeTemporarySize=$(df -k $_L_TMP | $_AWK '(FNR == 2) {print $1}')
		;;
	IRIX | IRIX64)
		FreeTemporarySize=$(df -k $_L_TMP | tail -1 | $_AWK '{print $5}')
		;;
	SunOS)
		FreeTemporarySize=$(df -k $_L_TMP | tail -1 | $_AWK '{print $4}')
		;;
esac

if [ $TotalSize -gt $FreeTemporarySize ]
then
	Out 3 "Not enough space in $_L_TMP. Space required in Kb: $TotalSize - Space available: $FreeTemporarySize"
fi

echo "\nSpace required in Kb: $TotalSize - Space available in $_L_TMP: $FreeTemporarySize"

if [ -f "$LocalCompressedFile" ]
then
	\rm -f $LocalCompressedFile
	if [ $? -ne 0 ]
	then
		Out 3 "Cannot delete existing local compressed file: $LocalCompressedFile"
	fi
fi

$ADL_TAR -cvf $LocalCompressedFile -T $_FILE_LIST -Z 2>&1 >$LocalTarTraces
rc=$?
if [ $rc -ne 0 ] && [ $rc -ne 2 ]
then
	Out 3 "Cannot create local compressed file:$LocalCompressedFile - Error code: $rc - Consult trace file on host $_L_HOST:$LocalTarTraces"
fi
\rm -f $LocalTarTraces

cd $_Curr_Dir

# Calcul de la taille du fichier a transferer
FileSize=$(ls -l $LocalCompressedFile | $_AWK '{print $5}')
let "FileSize = (FileSize / 1024) + 1" 
# On informe de la taille du fichier total et du nombre de fichiers
printf "\n>>> Transfer Statistics:\n"
printf "Number of files to transfer                           : %5d\n" $NbFiles
printf "File size of compressed file to transfer (in Kbytes) <> %5d\n" $FileSize


# =====================================================================
# On verifie qu'on dispose de la place necessaire sur le site distant
echo "\n> Checking for space left on remote host $_R_HOST"

rsh_program="$rsh_functions"'
	if [ ! -d '$_ADL_REMOTE_WORKING_DIR' ]
	then
		mkdir -p '$_ADL_REMOTE_WORKING_DIR'
		rc=$?
		if [ $rc -ne 0 ]
		then
			Out 3 "mkdir '$_ADL_REMOTE_WORKING_DIR' $rc"
		fi
	fi

	# A-t-on la place dans le file system de destination ?
	FreeSpace=$(GetFreeSpace $(dirname '$RemoteCompressedFile'))
	[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on remote file system: '$RemoteCompressedFile'"
	[ $FreeSpace -lt '$FileSize' ] && Out 3 "Not enough space in remote file system: '$RemoteCompressedFile' to store file to receive.\nRequested size: '$FileSize' - Free space: $FreeSpace in Kbytes"

	'

$RSH $_R_HOST -l $_R_USER "$rsh_program" </dev/null 2>&1 >$TraceFile

# On verifie que le rsh c'est bien passe
grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
cat $TraceFile
if [ $rc -eq 0 ]
then
	Out 3 "\nChecking of space left on remote site is KO. Traces on local site in: $TraceFile"
fi

# =====================================================================
# Transfert des fichiers compresses sur le site distant 
# =====================================================================

echo "\n> Transferring compressed file to $_R_HOST"
BeginDate=$(date +"%H:%M:%S")
echo "Begin of compressed file transfer at:" $BeginDate 

# On transfere le fichier compresse
try_rcp $LocalCompressedFile ${_R_USER}@$_R_HOST:$RemoteCompressedFile 
rc=$?
EndDate=$(date +"%H:%M:%S")
echo "End of compressed file transfer at:" $EndDate 
if [ $rc -ne 0 ]
then
	Out 3 "Cannot transfer the compressed file with command: rcp $LocalCompressedFile ${_R_USER}@$_R_HOST:$RemoteCompressedFile "
fi

# On detruit le fichier compresse sur le site local
rm -f $LocalCompressedFile

# =====================================================================
# On decompresse sur le site distant 
# =====================================================================


rsh_program="$rsh_functions $rsh_adl_environment"'
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
	
	# On cree un repertoire bidon et on s y place pour detarer le fichier
	if [ -d '$_R_TMP' ] 
	then
		\rm -rf '$_R_TMP'
	fi

	mkdir -p '$_R_TMP'
	if [ $? -ne 0 -o ! -d '$_R_TMP' ]
	then
		\rm -f '$RemoteCompressedFile'
		Out 3 "Cannot create remote temporary Workspace directory: '$_R_TMP'"
	fi
	chmod 777 '$_R_TMP'

	old_pwd=$(\pwd)
	cd '$_R_TMP'

	# on verifie qu on a la place pour detarer les fichiers
	FreeSpace=$(GetFreeSpace '$_R_TMP')
	[ $FreeSpace -eq -1 ] && Out 3 "Cannot get Free space on file system: '$_R_TMP'"
	[ $FreeSpace -lt '$TotalSize' ] && Out 3 "Not enough space in file system: '$_R_TMP' to store file to receive.\nRequested size: '$TotalSize' - Free space: $FreeSpace in Kbytes"

	# On decompresse le fichier 
	echo "\n> Uncompressing and untaring tar file on remote site"
	$ADL_TAR -xvf '$RemoteCompressedFile' -Z 2>&1 > '$RemoteTarTraces'
	if [ $? -ne 0 ]
	then
		\rm -f '$RemoteCompressedFile'
		cd $old_pwd
		Out 3 "Cannot uncompress or untar the transferred files into temporary Workspace directory: '$_R_TMP' - Consult trace file in '$RemoteTarTraces'"
	fi

	# On detruit le fichier compresse
	\rm -f '$RemoteCompressedFile'

	cd $old_pwd

	'

$RSH $_R_HOST -l $_R_USER "$rsh_program" </dev/null 2>&1 >$TraceFile

# On verifie que le rsh c'est bien passe
grep "!!! KO :" $TraceFile >/dev/null 2>&1
rc=$?
cat $TraceFile
if [ $rc -eq 0 ]
then
	Out 3 "\nChecking of space left on remote site is KO. Traces on local site in: $TraceFile"
fi


Out 0
