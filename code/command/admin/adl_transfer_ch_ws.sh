#!/bin/ksh
#
# Remplacement de la fonction "built-in" adl_ch_ws
# pour pouvoir l'appeler depuis un programme 
# et recuperer les variables d'environnement
#

# Les appels possibles sont 
#   ws -no_ds tmpfile
#   ws tmpfile
#   ws -no_image -no_ds tmpfile
#   ws -no_image tmpfile
#   ws -image image -no_ds tmpfile
#   ws -image image tmpfile

# $1 = forcement le nom du ws
wsname=$1
shift
lineoptions=""

# Specific replay ODT
if [ ! -z "$ADL_ODT_TMP" ]
then
	export ADL_ODT_TMP="$(env|sed 's:\\:/:g'| $AWK -F= '$1 == "ADL_ODT_TMP" {print $2}')"
	export SystemRoot="$(env|sed 's:\\:/:g'| $AWK -F= '$1 == "SystemRoot" {print $2}')"
	export ADL_TMP="$ADL_ODT_TMP"
fi

while [ $# -gt 1 ]
do
	if [ "$1" = "-image" ]
	then
		lineoptions="$lineoptions $1 $2"
		shift; shift
	elif [ "$1" = "-no_image" ]
	then
		lineoptions="$lineoptions $1"
		shift
	elif [ "$1" = "-no_ds" ]
	then
		lineoptions="$lineoptions $1"
		shift
	fi
done

# dernier parametre = fichier temporaire
if [ -z "$1" ] 
then
	echo "Wrong command line: $wsname $lineoptions"
	echo "Command line must end with a temporary file name"
	exit 1
fi

# On precise le type de fichier profile a generer car ce programme s'execute dans un environnement ODT
# donc aussi sur Windows-NT
# La TCK associé à l'espace de travail n'est pas exécutée
adl_ch_ws_i $wsname $lineoptions -no_tck -env_file "${ADL_TMP}/ADLTransferChWsTmp1.$$" -env_file_type ksh >"${ADL_TMP}/ADLTransferChWsTmp2.$$" 2>&1
rtcode=$?
if [ $rtcode -ne 0 ]
then
	cat "${ADL_TMP}"/ADLTransferChWsTmp2.$$
	\rm -f "${ADL_TMP}"/ADLTransferChWsTmp*.$$
	exit $rtcode
fi

. "${ADL_TMP}/ADLTransferChWsTmp1.$$" >>"${ADL_TMP}/ADLTransferChWsTmp2.$$" 2>&1
rtcode=$?

pwd > "$1"
env >> "$1"

cat "${ADL_TMP}/ADLTransferChWsTmp2.$$"
\rm -f "${ADL_TMP}"/ADLTransferChWsTmp*.$$ >/dev/null 2>&1

exit $rtcode

