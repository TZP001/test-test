#!/bin/ksh
#
ShellName=$(basename $0)
# =====================================================================
Usage="$ShellName -l current_remote_lsout -r reference_lsout

-l current_remote_lsout: path of the current lsout of the remote workspace
-r reference_lsout     : path of the reference lsout to generate
"
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
[ -z "$ADL_LEVEL" ] && Out 3 "No ADL_LEVEL variable set"

unset _LSOUT_REF
unset _LSOUT_CURRENT

set -- $(getopt hr:l: "$@") || Out 1 "$Usage"
while [ -n "$1" -a "$1" != "--" ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
			;;
		-r ) #-------------------> REFERENCE LSOUT
			_LSOUT_REF=$2
			shift 2
			;;
		-l ) #-------------------> CURRENT REMOTE LSOUT
			_LSOUT_CURRENT=$2
			shift 2
			;;
		* ) echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

if [ -z "$_LSOUT_REF" -o -z "$_LSOUT_CURRENT" ]
then
	echo "$ShellName: Missing mandatory remote parameter." 1>&2
	Out 3 "$Usage"
fi

if [ ! -f $_LSOUT_CURRENT ] 
then
	echo "$ShellName: Current lsout not found: $_LSOUT_CURRENT" 1>&2
	Out 3 "$Usage"
fi
# =====================================================================
# Begin treatment
# =====================================================================

if [ $ADL_LEVEL = 2 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	[ -z "$ADL_W_DIR" ] && Out 3 "No current workspace has been found"
	ADL_WS=$ADL_W_ID

	# Determination du repertoire des traces
	[ -z "$_ADL_TRACE_DIR" ] && Out 3 "No current trace directory variable: _ADL_TRACE_DIR"
	
elif [ $ADL_LEVEL = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	echo "____________________________________________________________"
	echo "${CurrentDate} : Adele V5 STEP"

	[ -z "$ADL_WS" ] && Out 3 "No current workspace has been found"

	Out 3 "A FAIRE le cas d'Adele V5 dans $ShellName"

# ----------------------------------------------------------------------
# unknown Adele version
# ----------------------------------------------------------------------
else
	Out 3 "Unknown ADL_LEVEL in $ShellName: $ADL_LEVEL"
fi

# =====================================================================
# Traitement principal
# =====================================================================
CurrentDate=$(adl_get_current_date.sh)
echo "____________________________________________________________"
echo "${CurrentDate} : Calculate the reference lsout of the local workspace: $ADL_WS"

_LOCAL_LSOUT=${_ADL_TRACE_DIR}/0CurrentLocalLsout
adl_create_lsout.sh -f ${_LOCAL_LSOUT}
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot generate lsout in current workspace $ADL_WS"  

#echo "$Id $Folder $FwName      $Type $Resp $Base"
#echo "$Id $Folder $ModDataName $Type $Resp $Base"
#echo "$Id $Folder $FicName     $Type $Txtbin $Unixexec $Content $Date $Taille"

# On decompose la lsout courante cible en liste de Fw, de modules et de fichiers
_FW_LIST=$Working/0FwList
_MOD_LIST=$Working/0ModList
_FILE_LIST=$Working/0FileList
\rm -f ${_FW_LIST} ${_MOD_LIST} ${_FILE_LIST}
touch ${_FW_LIST} ${_MOD_LIST} ${_FILE_LIST}
while read Id FolderId Name Type Path Remainder
do
	case $Type in
		FW)       echo $Id $FolderId $Name $Type $Path $Remainder >> ${_FW_LIST};;
		MOD|DATA) echo $Id $FolderId $Name $Type $Path $Remainder >> ${_MOD_LIST};;
		* )       echo $Id $FolderId $Name $Type $Path $Remainder >> ${_FILE_LIST};;
	esac
done < $_LSOUT_CURRENT 
sort -k 5 ${_FW_LIST}   -o ${_FW_LIST}
sort -k 5 ${_MOD_LIST}  -o ${_MOD_LIST}
sort -k 5 ${_FILE_LIST} -o ${_FILE_LIST}

# On decompose la lsout courante LOCALE en liste de Fw, de modules et de fichiers
_L_FW_LIST=$Working/0LocalFwList
_L_MOD_LIST=$Working/0LocalModList
_L_FILE_LIST=$Working/0LocalFileList
\rm -f ${_L_FW_LIST} ${_L_MOD_LIST} ${_L_FILE_LIST}
touch ${_L_FW_LIST} ${_L_MOD_LIST} ${_L_FILE_LIST}
while read Id FolderId Name Type Path Remainder
do
	case $Type in
		FW)       echo $Id $FolderId $Name $Type $Path $Remainder >> ${_L_FW_LIST};;
		MOD|DATA) echo $Id $FolderId $Name $Type $Path $Remainder >> ${_L_MOD_LIST};;
		* )       echo $Id $FolderId $Name $Type $Path $Remainder >> ${_L_FILE_LIST};;
	esac
done < $_LSOUT_CURRENT 
sort -k 5 ${_L_FW_LIST}   -o ${_L_FW_LIST}
sort -k 5 ${_L_MOD_LIST}  -o ${_L_MOD_LIST}
sort -k 5 ${_L_FILE_LIST} -o ${_L_FILE_LIST}

while read 

Pour tous les FW et le modules presents dans les deux lsout
	mettre dans la lsout de ref ces fw et ces modules en prenant les lignes dans la lsout remote
	pour tous les fichiers et repertoires de la liste remote inclus dans les fw et modules en question, les mettre dans la lsout remote
	pour tous les fichiers et repertoires de la liste locale inclus dans les fw et modules en question, les mettre dans la lsout remote

Ne rien faire pour les autres fws et autres modules

Out 0
