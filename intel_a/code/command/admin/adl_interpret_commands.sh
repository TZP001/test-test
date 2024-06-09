#!/bin/ksh
#set -x
[ ! -z "$ADL_DEBUG" ] && set -x

FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="Usage : $ShellName -c CommandsFileName -v CommandsVersion -r RecoveryFileName -t TracesFileName [-simul] [-verbose]

-c : Filename of the macro commands to execute
-v : Version of Adele commands to generate
-r : Name of the recovery file where the last successful command number is stored
-t : Name of the trace file
-verbose : Execution traces will be also displayed on standard output.
-simul : Commands are just displayed and won't be run

This script permits to interpret in the current local workspace the macro commands of CommandsFileName while return code of them is equal to 0.
BEWARE: an adl_ch_ws should have been made before call this script.
To get traces : export TRACES_DEBUG=true"
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
	[ ! -z "$ADL_DEBUG" ] && set -x
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	if [ $# -ge 2 ]
	then
		shift
		echo "$*"
	fi
	\m -rf /tmp/*_$$ /tmp/*_$$.txt
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM

# =====================================================================
# MakeFw function
# =====================================================================
MakeFw()
{
# MK fw DestRelPath [-tree WsTree] -resp Resp

	DestRelPath="$1"
	shift
	# On commence par verifier s'il ne faut pas tout simplement attacher le fw
	Cmd="adl_attach \"$DestRelPath\"" 
	echo "$Cmd" > /tmp/TempoCmd_$$
	eval "$Cmd" 2>&1 >> /tmp/TempoCmd_$$
	rc=$?
	if [ $rc -eq 0 ]
	then
		cat /tmp/TempoCmd_$$
	else
		Cmd="adl_mk_fw \"$DestRelPath\" $*"
		echo "$Cmd"
		eval "$Cmd"
		rc=$?
	fi
	return $rc
}

# =====================================================================
# MakeMod function
# =====================================================================
MakeMod()
{
# MK mod DestRelPath -resp Resp

	DestRelPath="$1"
	shift
	# On commence par verifier s'il ne faut pas tout simplement attacher le module
	Cmd="adl_attach \"$DestRelPath\"" 
	echo "$Cmd" > /tmp/TempoCmd_$$
	eval "$Cmd" 2>&1 >> /tmp/TempoCmd_$$
	rc=$?
	if [ $rc -eq 0 ]
	then
		cat /tmp/TempoCmd_$$
	else
		Cmd="adl_mk_mod \"$DestRelPath\" $*"
		echo "$Cmd"
		eval "$Cmd"
		rc=$?
	fi
	return $rc
}

# =====================================================================
# MakeData function
# =====================================================================
MakeData()
{
# MK data DestRelPath -resp Resp

	DestRelPath="$1"
	shift
	# On commence par verifier s'il ne faut pas tout simplement attacher le data
	Cmd="adl_attach \"$DestRelPath\"" 
	echo "$Cmd" > /tmp/TempoCmd_$$
	eval "$Cmd" 2>&1 >> /tmp/TempoCmd_$$
	rc=$?
	if [ $rc -eq 0 ]
	then
		cat /tmp/TempoCmd_$$
	else
		Cmd="adl_mk_data \"$DestRelPath\" $*"
		echo "$Cmd"
		eval "$Cmd"
		rc=$?
	fi
	return $rc
}

# =====================================================================
# IsDirectoryExistInAdele function
# =====================================================================
IsDirectoryExistInAdele()
{
	Cmd="UnknownCommand"
	if [ $CommandVersion -eq 5 ]
	then
		Cmd="adl_ls_out"
	fi

	eval "$Cmd \"$1\"" 2>&1 >/dev/null
	if [ $? -ne 0 ]
	then
		Bool=0
	else
		Bool=1
	fi
	return $Bool
}
# =====================================================================
# MakeDir function
# =====================================================================
MakeDir()
{
# MK dir DestRelPath

	IsDirToCreate=Y
	Cmd="UnknownCommand"

	DestRelPath="$1"
	shift

	if [ $CommandVersion -eq 3 ]
	then
		Cmd="mkdir -p \"$DestRelPath\""
	elif [ $CommandVersion -eq 5 ]
	then
		if [ -d "$DestRelPath" ]
		then
			# Le repertoire destination existe deja, On verifie qu'il existe bien dans Adele
			IsDirectoryExistInAdele "$DestRelPath"
			if [ $? -ne 0 ]
			then
				# Oui, le repertoire existe. On n'aura pas besoin de le creer
				IsDirToCreate=N
				echo "Directory $DestRelPath already exist. Nothing to do."
				rc=0
			fi
		fi
		Cmd="adl_mk_dir \"$DestRelPath\" $*"
	fi

	if [ $IsDirToCreate = "Y" ]
	then
		echo "$Cmd"
		eval "$Cmd"
		rc=$?
	fi
	return $rc
}

# =====================================================================
# IsFileExistInAdele function
# =====================================================================
IsFileExistInAdele()
{
	Cmd="UnknownCommand"
	if [ $CommandVersion -eq 3 ]
	then
		Cmd="lsout"
	elif [ $CommandVersion -eq 5 ]
	then
		Cmd="adl_ls_out"
	fi

	eval "$Cmd \"$1\"" 2>&1 >/dev/null
	if [ $? -ne 0 ]
	then
		Bool=0
	else
		Bool=1
	fi
	return $Bool
}

# =====================================================================
# MakeElem function
# =====================================================================
MakeElem()
{
#set -x
# MK elem DestRelPath -origin OriginFullPath -type ContentType

	DestRelPath="$1"
	shift
	OptOrigin="$1"
	shift
	OriginFullPath="$1"
	shift
	RestOfCmd="$*"

	IsToCreate=Y
	if [ -f "$DestRelPath" ]
	then
		# Le fichier destination existe deja, On verifie qu'il existe bien dans Adele
		IsFileExistInAdele "$DestRelPath"
		if [ $? -ne 0 ]
		then
			# Oui, le fichier existe. On n'aura pas besoin de le creer
			IsToCreate=N
			# A-t'il le meme contenu ?
			cmp -s "$DestRelPath" "$OriginFullPath"
			if [ $? -ne 0 ]
			then
				# Non. On le modifie
				Cmd="adl_co \"$DestRelPath\""
				echo "$Cmd"
				eval "$Cmd"
				rc=$?
				if [ $rc -eq 0 ] 
				then
					Cmd="cp -p \"$OriginFullPath\" \"$DestRelPath\""
					echo "$Cmd"
					eval "$Cmd"
					rc=$?
				fi
			else
				# Oui. On ne fait rien
				echo "File $DestRelPath already exist and its contents does not evolved."
				rc=0
			fi
		fi
	fi

	if [ $IsToCreate = "Y" ] 
	then
		rc=0
		# Le fichier est a creer
		DestDir="$(dirname $DestRelPath)"
		if [ ! -d "$DestDir" ]
		then
			Cmd="mkdir -p \"$DestDir\""
			echo "$Cmd"
			eval "$Cmd"
			rc=$?
		fi
		if [ $rc -eq 0 ]
		then
			Cmd="cp -pf \"$OriginFullPath\" \"$DestRelPath\""
			echo "$Cmd"
			eval "$Cmd"
			rc=$?
			if [ $rc -eq 0 ] 
			then
				Cmd="adl_mk_elem \"$DestRelPath\" $RestOfCmd"
				echo "$Cmd"
				eval "$Cmd"
				rc=$?
			fi
		fi
	fi

	return $rc
}
# =====================================================================
# IsRespNotExistCreateIt function
# =====================================================================
IsRespNotExistCreateIt()
{
	Resp="$1"
	if [ ! -z "$Resp" ]
	then
		# check if the user exists, if not, create it by any method that works...
		lso "USER>$Resp" >/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			adl_mk_user $Resp
			if [ $? -ne 0 ]
			then
				mko "USER>$Resp" -t DSuser -s "USER>USER"
				if [ $? -eq 0 ]
				then
					echo "New User $Resp has been created."
				else
					echo "Failed to create new user $Resp. User $($WHOAMI) will be used instead."
					Resp=$($WHOAMI)
				fi
			else
				echo "New User $Resp has been created."
			fi
		fi
	else
		echo "No user have been specified. User $($WHOAMI) will be used."
		Resp=$($WHOAMI)
	fi
}
# =====================================================================
# Make function
# =====================================================================
Make()
{
#set -x
# MK fw DestRelPath [-tree WsTree] -resp Resp
# MK mod DestRelPath -resp Resp
# MK data DestRelPath -resp Resp
# MK dir DestRelPath
# MK elem DestRelPath -origin OriginFullPath -type ContentType

AdlCmd="$1"
shift
DestRelPath="$1"
shift
RestOfArg=""
OptResp=N

if [ "$AdlCmd" != "elem" ]
then
	Resp=""
	while [ $# -ne 0 ]
	do
		if [ "$1" = "-resp" ] 
		then 
			OptResp=Y
			shift 
			Resp="$1"
			shift
		else
			RestOfArg="$RestOfArg \"$1\""
			shift
		fi
	done
fi

FORCE=""
if [ $CommandVersion -eq 3 ]
then
	case $AdlCmd in
		fw|mod|data)
			IsRespNotExistCreateIt $Resp
			RESP=" -user $Resp"
			;;
		elem) FORCE=" -er" ;;
	esac
elif [ $CommandVersion -eq 5 ]
then
	case $AdlCmd in
		fw|mod|data)
			RESP=" -resp $Resp"
			;;
	esac
	FORCE=" -force"
fi

case $AdlCmd in
	fw)	MakeFw "$DestRelPath" $RestOfArg "$RESP" "$FORCE"
		rc=$?
		;;
	mod) MakeMod "$DestRelPath" $RestOfArg "$RESP" "$FORCE"
		rc=$?
		;;
	data) MakeData "$DestRelPath" $RestOfArg "$RESP" "$FORCE"
		rc=$?
		;;
	dir) MakeDir "$DestRelPath" $RestOfArg "$FORCE"
		rc=$?
		;;
	elem)
		MakeElem "$DestRelPath" "$@" "$FORCE"
		rc=$?
		;;
	*) Out 6 "Cannot interpret macro command: $AdlCmd $DestRelPath $RestOfArg" 
		;;
esac

return $rc
}
# =====================================================================
# MoveDir function
# =====================================================================
MoveDir()
{
	TypeDir="$1"
	shift
	AdlCmd="$1"
	shift
	DestRelPath1="$1"
	shift
	DestRelPath2="$1"
	shift
	FORCE=""
	if [ $# -ne 0 ]
	then
		FORCE="$1"
	fi

	TO=""
	if [ $CommandVersion -eq 3 ]
	then
		TO="-to"
	fi

	Cmd="$AdlCmd \"$DestRelPath1\" $TO \"$DestRelPath2\" $FORCE"
	echo "$Cmd"
	eval "$Cmd"
	rc=$?
	if [ $rc -ne 0 -a -d $DestRelPath2 ]
	then
		echo "Directory $DestRelPath2 already exist. Error is ignored."
		rc=0
	fi

	return $rc
}
# =====================================================================
# MoveFile function
# =====================================================================
MoveFile()
{
	AdlCmd="$1"
	shift
	DestRelPath1="$1"
	shift
	DestRelPath2="$1"
	shift
	FORCE=""
	if [ $# -ne 0 ]
	then
		FORCE="$1"
	fi

	TO=""
	if [ $CommandVersion -eq 3 ]
	then
		TO="-to"
	fi

	DestRelDir2="$(dirname $DestRelPath2)"
	if [ ! -d "$DestRelDir2" ]
	then
		if [ $CommandVersion -eq 3 ]
		then
			mkdir -p "$DestRelDir2"
		else
			adl_mk_dir "$DestRelDir2" -force
		fi
	fi

	Cmd="$AdlCmd \"$DestRelPath1\" $TO \"$DestRelPath2\" $FORCE"
	echo "$Cmd"
	eval "$Cmd"
	rc=$?
	if [ $rc -ne 0 -a -f "$DestRelPath2" ]
	then
		echo "File $DestRelPath2 already exist. Error is ignored."
		rc=0
	fi

	return $rc
}
# =====================================================================
# Move function
# =====================================================================
Move()
{
# MV fw DestRelPath1 DestRelPath2
# MV mod DestRelPath1 DestRelPath2
# MV data DestRelPath1 DestRelPath2
# MV dir DestRelPath1 DestRelPath2
# MV elem DestRelPath1 DestRelPath2

Cmd="$1"
shift
DestRelPath1="$1"
shift
DestRelPath2="$1"

FORCE=""
# Commandes V3
if [ $CommandVersion -eq 3 ]
then
	case $Cmd in
		fw) AdlCmd="adl_mv_fw";;
		mod) AdlCmd="adl_mv_mod";;
		data) AdlCmd="adl_mv_data";;
		dir) AdlCmd="mv";;
		elem) AdlCmd="adl_mv_elem";;
	esac
elif [ $CommandVersion -eq 5 ]
then
	AdlCmd="adl_mv"
	FORCE=" -force"
fi

case $Cmd in
	fw|mod|data|dir)MoveDir "$Cmd" "$AdlCmd" "$DestRelPath1" "$DestRelPath2" "$FORCE"
		rc=$?
		;;
	elem) MoveFile "$AdlCmd" "$DestRelPath1" "$DestRelPath2" "$FORCE"
		rc=$?
		;;
	*) Out 6 "Cannot interpret macro command: $Cmd $DestRelPath1 $DestRelPath2" 
		;;
esac

return $rc
}
# =====================================================================
# RemoveDir function
# =====================================================================
RemoveDir()
{
	AdlCmd="$1"
	shift
	DestRelPath="$1"

	case $AdlCmd in
		adl_rm_fw|adl_rm_mod|adl_rm_data|adl_rm_dir) # seulement pour adele V3, on ne supprime pas les composants mais suelement les fichiers qui sont dessous
			echo "In Adele V3, we don't want to remove Framework, Module or Data component, so we remove only included files of component: $DestRelPath"
			mdopt -necho -nbf
			nbtry=0
			while [ $nbtry -lt 5 ]
			do
				lsout "*>**" -f "$ADL_W_DIR/$DestRelPath/**/**" -fast -l /tmp/IncludedFileToRemove_$$
				rc=$?
				[ $rc -eq 0 -o $rc -eq 12 ] && break
				nbtry=$(expr $nbtry + 1)
			done

			if [ $rc -eq 0 ]
			then
				while read cobj file remainder
				do
					if [ ! -z "$remainder" ]
					then
						echo "Remainder of lsout result not empty: $cobj $file $remainder"
						rc=-1
						break
					fi
					if [ -f "$file" ]
					then
						Cmd="adl_rm_elem $file"
						echo "$Cmd"
						eval "$Cmd"
						rc=$?
					else
						rc=-1
					fi
					if [ $rc -ne 0 -a ! -f "$file" ]
					then
						echo "File $file no more exist. Error is ignored."
						rc=0
					fi
					[ $rc -ne 0 ] && break
				done < /tmp/IncludedFileToRemove_$$
				if [ $rc -eq 0 -a $AdlCmd = "adl_rm_dir" ]
				then
					Cmd="rm -rf $DestRelPath"
					echo "$Cmd"
					eval "$Cmd"
					rc=$?
				fi
			elif [ $rc -eq 12 ]
			then
				echo "No files have been removed."
				rc=0
			else
				echo "Cannot get list of files contained by $DestRelPath component"
			fi
			;;
		*)	Cmd="$AdlCmd \"$DestRelPath\""
			echo "$Cmd"
			eval "$Cmd"
			rc=$?
			if [ $rc -ne 0 -a ! -d $DestRelPath ]
			then
				echo "Directory $DestRelPath no more exist. Error is ignored."
				rc=0
			fi
			;;
	esac

	return $rc
}
# =====================================================================
# RemoveFile function
# =====================================================================
RemoveFile()
{
	AdlCmd="$1"
	shift
	DestRelPath="$1"

	Cmd="$AdlCmd \"$DestRelPath\""
	echo "$Cmd"
	eval "$Cmd"
	rc=$?
	if [ $rc -ne 0 -a ! -f "$DestRelPath" ]
	then
		echo "File $DestRelPath no more exist. Error is ignored."
		rc=0
	fi

	return $rc
}
# =====================================================================
# Remove function
# =====================================================================
Remove()
{
# RM fw DestRelPath
# RM mod DestRelPath
# RM data DestRelPath
# RM dir DestRelPath
# RM elem DestRelPath

	Cmd="$1"
	shift
	DestRelPath="$1"

	# Commandes V3
	if [ $CommandVersion -eq 3 ]
	then
		case $Cmd in
			fw) AdlCmd="adl_rm_fw";;
			mod) AdlCmd="adl_rm_mod";;
			data) AdlCmd="adl_rm_data";;
			dir) AdlCmd="adl_rm_dir";;
			elem) AdlCmd="adl_rm_elem";;
		esac
	elif [ $CommandVersion -eq 5 ]
	then
		AdlCmd="adl_rm"
	fi

	case $Cmd in
		fw|mod|data|dir)RemoveDir "$AdlCmd" "$DestRelPath"
			rc=$?
			;;
		elem) RemoveFile "$AdlCmd" "$DestRelPath"
			rc=$?
			;;
		*) Out 6 "Cannot interpret macro command: $Cmd $DestRelPath" 
			;;
	esac

	return $rc
}
# =====================================================================
# CheckOut function
# =====================================================================
CheckOut()
{
# CO DestRelPath -origin OriginFullPath
#set -x
	DestRelPath="$1"
	shift 2
	OriginFullPath="$1"

	if [ -f "$DestRelPath" ]
	then
		# Le fichier destination existe
		cmp -s "$OriginFullPath" "$DestRelPath"
		rc=$?
		if [ $rc -eq 0 ]
		then
			echo "File $DestRelPath has not evolved. Nothing to do.";
		else
			# Un check out est a faire
			CmdOptions=""
			[ $CommandVersion -eq 5 ] && CmdOptions="-force_excl"
			Cmd="adl_co \"$DestRelPath\" $CmdOptions"
			echo "$Cmd"
			eval "$Cmd"
			rc=$?
			if [ $rc -eq 0 ]
			then
				cp -p "$OriginFullPath" "$DestRelPath"
				rc=$?
				if [ $rc -ne 0 ] 
				then
					echo "Cannot copy $OriginFullPath file to $DestRelPath"
				fi
			else
				echo "Cannot checked-out file $DestRelPath"
			fi
		fi
	else
		# Le fichier destination n'existe pas. On tente sa creation
		Make elem "$@"
		rc=$?
	fi

#set +x
	return $rc
}
# =====================================================================
# ChgResp function
# =====================================================================
ChgResp()
{
# CH_RESP DestRelPath -resp Resp

	DestRelPath="$1"
	shift 2
	Resp="$1"

	if [ $CommandVersion -eq 3 ]
	then
		IsRespNotExistCreateIt $Resp
		Cmd="adl_ch_resp \"$DestRelPath\" -user $Resp"
	else
		Cmd="adl_ch_resp \"$DestRelPath\" -resp $Resp"
	fi

	echo "$Cmd"
	eval "$Cmd"
	rc=$?

	return $rc
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

unset CommandsFileName
unset CommandVersion
unset RecoveryFileName
unset TracesFileName
unset Verbose
unset Simulation

while [ $# -ge 1 ]
do
	case "$1" in
	-h ) #-------------------> HELP NEEDED
		echo "$Usage"
		exit 0
		;;

	-c ) #-------------------> MANDATORY: COMMANDS FILE NAME
		CheckOptArg "$1" "$2"
		CommandsFileName=$2
		shift 2
		;;
	-v ) #-------------------> MANDATORY: COMMAND VERSION
		CheckOptArg "$1" "$2"
		CommandVersion=$2
		shift 2
		;;

	-r ) #-------------------> MANDATORY: RECOVERY FILE NAME
		CheckOptArg "$1" "$2"
		RecoveryFileName=$2
		shift 2
		;;

	-t ) #-------------------> MANDATORY: TRACES FILE NAME
		CheckOptArg "$1" "$2"
		TracesFileName=$2
		shift 2
		;;

	-verbose ) #-------------> OPTIONAL : TRACE ACTIVATION
		Verbose=true
		shift
		;;

	-simul ) #---------------> OPTIONNAL : SIMULATION MODE
		Simulation=true
		shift
		;;

	* )
		echo "Unknown option $1"
		echo "$Usage"
		exit 1
		;;

	esac
done

if [ -z "$CommandsFileName" -o -z "$CommandVersion" -o -z "$RecoveryFileName" -o -z "$TracesFileName" ]
then
	echo "$Shellname: Missing mandatory parameter."
	Out 1 "$Usage"
fi

if [ ! -f "$CommandsFileName" ]
then
	Out 1 "File $CommandsFileName does not exist"
fi

if [ ! -z "$TRACES_DEBUG" ]
then
	echo "\n********************"
	echo "Fichiers d'entree : "
	echo $CommandsFileName
	echo $CommandVersion
	echo $RecoveryFileName
	echo $TracesFileName
	echo "********************\n"
fi

# =====================================================================
# Begin treatment
# =====================================================================

# ----------------------------------------------------------------------
# Adele version 3
# ----------------------------------------------------------------------
CurrentDate=$($ShellDir/adl_get_current_date.sh)
if [ $CommandVersion = 3 ]
then
	[ -z "$ADL_W_ID" ] && Out 3 "No current workspace has been found"
	[ -z "$ADL_W_DOS_DIR" ] && Out 3 "No current workspace path has been found"

	echo "____________________________________________________________"
	echo "$CurrentDate : Executing Adele V3 commands in $ADL_W_ID workspace"

	adlwdir=$ADL_W_DOS_DIR

	cd $adlwdir

# ----------------------------------------------------------------------
# Adele version 5
# ----------------------------------------------------------------------
elif [ $CommandVersion = 5 ]
then
	[ -z "$ADL_WS" ] && Out 3 "No current workspace has been found"

	echo "____________________________________________________________"
	echo "$CurrentDate : Executing Adele V5 commands in $ADL_WS workspace"

	# * Sous UNIX
	adlwdir=$ADL_IMAGE_DIR

	cd $adlwdir

# ----------------------------------------------------------------------
# unknown Adele version
# ----------------------------------------------------------------------
else
	Out 3 "Unknown CommandVersion in $ShellName: $CommandVersion"
fi

if [ ! -z "$TRACES_DEBUG" ]
then
	echo "\n********************"
	echo "Repertoire courant : "
	pwd
	echo "********************\n"
fi

# ----------------------------------------------------------------------
# Declaration des variables
# ----------------------------------------------------------------------
typeset -i RecoveryLine
typeset -i BeginLine
typeset -i MaxLines
typeset -i CurrentLine
typeset -i ReturnCode

# ----------------------------------------------------------------------
# Suppression du fichier de traces s il existait
# ----------------------------------------------------------------------
\rm -f $TracesFileName >/dev/null 2>&1
\rm -f $TracesFileName.rm_conf >/dev/null 2>&1

# ----------------------------------------------------------------------
# Determination de la premiere ligne du fichier de comandes a executer
# ----------------------------------------------------------------------
RecoveryLine=0
BeginLine=1
if [ ! -f $RecoveryFileName ]
then
	echo 0 > $RecoveryFileName
fi
if [ -f $RecoveryFileName ]
then
	if [ -s $RecoveryFileName ]
	then
		RecoveryLine=$(cat $RecoveryFileName </dev/null)
		let "BeginLine = RecoveryLine + 1"
	fi
fi

if [ ! -z "$TRACES_DEBUG" ]
then
	echo "\n********************"
	echo "RecoveryLine : $RecoveryLine"
	echo "BeginLine : $BeginLine"
	echo "********************\n"
fi

# ----------------------------------------------------------------------
# Calcul du nombre de lignes dans CommandsFileName
# ----------------------------------------------------------------------
MaxLines=0
if [ ! -s $CommandsFileName ]
then
	Out 1 "File $CommandsFileName is empty"
else
	MaxLines=$(cat $CommandsFileName </dev/null | wc -l)
fi

if [ ! -z "$TRACES_DEBUG" ]
then
	echo "\n********************"
	echo "MaxLines : $MaxLines"
	echo "********************\n"
fi

if [ $MaxLines -eq 0 ]
then
	Out 1 "The number of lines in $CommandsFileName is 0"
fi

if [ "$BeginLine" -gt "$MaxLines" ]
then
	Out 1 "The number of lines in $CommandsFileName is less than the line of $RecoveryFileName"
fi

# Exemple de fichier de macro commandes en entree
# ------------------------------------------------
# MK fw DestRelPath [-tree WsTree] -resp Resp
# MK mod DestRelPath -resp Resp
# MK data DestRelPath -resp Resp
# MK dir DestRelPath
# MK elem DestRelPath -origin OriginFullPath -type ContentType
# 
# MV fw DestRelPath1 DestRelPath2
# MV mod DestRelPath1 DestRelPath2
# MV data DestRelPath1 DestRelPath2
# MV dir DestRelPath1 DestRelPath2
# MV elem DestRelPath1 DestRelPath2
# 
# RM fw DestRelPath
# RM mod DestRelPath
# RM data DestRelPath
# RM dir DestRelPath
# RM elem DestRelPath
# 
# CO DestRelPath -origin OriginFullPath
# 
# CH_RESP DestRelPath -resp Resp

# ----------------------------------------------------------------------
# Lancement des commandes 
# a partir de BeginLine + 1
# tant que le code retour est egal a 0
# ----------------------------------------------------------------------
echo "\n$MaxLines commands to perform. To follow their execution, run command: tail -f $TracesFileName"

TempoTracesFileName=/tmp/TempoTracesFile_$$
rm -f $TempoTracesFileName
touch $TempoTracesFileName

CurrentLine=0
ReturnCode=0
NbDisplayedLine=0
while read MacroCmd LineContent
do
	let "CurrentLine = $CurrentLine + 1"
	if [ "$CurrentLine" -gt "$MaxLines" ]
	then
		break
	fi
	
	if [ "$CurrentLine" -ge "$BeginLine" ]
	then
		if [ ! -z "$TRACES_DEBUG" ]
		then
			echo "\n********************"
			echo $LineContent
			echo "********************\n"
		fi
		
		printf "# %d / %d - %s %s\n" $CurrentLine $MaxLines "$MacroCmd" "$LineContent" > $TempoTracesFileName 2>&1
		ReturnCode=0

		if [ -z "$Simulation" ]
		then
			case $MacroCmd in
				MK) RunCmd="Make $LineContent"
					;;
				MV) RunCmd="Move $LineContent"
					;;
				RM) RunCmd="Remove $LineContent"
					;;
				CO) RunCmd="CheckOut $LineContent"
					;;
				CH_RESP) RunCmd="ChgResp $LineContent"
					;;
				"#"*) RunCmd="$MacroCmd $LineContent" # On ignore les lignes en commentaires
					;;
				*) Out 5 "Unknown command $MacroCmd $LineContent - Number: $CurrentLine"
					;;
			esac

			eval "$RunCmd" >> $TempoTracesFileName 2>&1
			ReturnCode=$?
		fi

		cat $TempoTracesFileName >> $TracesFileName
		[ ! -z "$Verbose" ] && cat $TempoTracesFileName

		# NbLine=$(cat $TracesFileName | wc -l)
		# let "NbLineToDisplay = NbLine - NbDisplayedLine"
        # tail -$NbLineToDisplay $TracesFileName
		# NbDisplayedLine=$NbLine

		# La commande s est bien terminee
		if [ "$ReturnCode" -eq 0 ]
		then
			# Sauvegarde de la derniere ligne OK dans RecoveryFileName
			echo $CurrentLine > $RecoveryFileName
		else
			break
		fi

	fi
done < $CommandsFileName

# Toutes les commandes ont ete passees avec succes
# On supprime donc le fichier RecoveryFileName

if [ "$ReturnCode" -eq 0 ]
then
	\rm -f $RecoveryFileName > /dev/null 2>&1
else
	if [ -z "$Verbose" ]
	then
		# Ca s'est mal passe, on affiche les traces des 100 dernieres lignes
		echo "\n............... last lines of the trace file ($TracesFileName) ................"
		tail -100 $TracesFileName
	fi
fi

Out $ReturnCode
