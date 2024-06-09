#!/bin/ksh
# Recherche de toutes les informations pour le transfert,
# pour Adele 3.2.
# A appeler en . pour la construction locale, ou a bidouiller
# pour la construction a distance avec rsh.
# En entree, la fonction Out doit etre definie, ainsi que les variables
#  _ADL_WORKING_DIR
#  _FIELD_SEP
# En sortie, les fichiers resultat sont
#  $_ADL_WORKING_DIR/0CompList.txt
# Il faudra appeler CleanWorkingDirComp pour nettoyer les fichiers de travail.

[ ! -z "$ADL_DEBUG" ] && set -x

whence Out >/dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "!!! KO : The Out function is not defined"
	return 3
fi

OS=$(uname -s)
case $OS in
	AIX)					
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		;;
	HP-UX)
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		;;
	SunOS)
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
		;;
esac

# Determination du repertoire de travail
if [ -z "$_ADL_WORKING_DIR" ]
then
	Out 3 "The variable _ADL_WORKING_DIR is not set"
fi

if [ ! -d $_ADL_WORKING_DIR ]
then
	mkdir -p $_ADL_WORKING_DIR
	rc=$?
	[ $rc -ne 0 ] && Out 3 "Cannot create directory: $_ADL_WORKING_DIR : $rc"
fi

# Set Adl V3 global options
mdopt -necho -nbf >/dev/null 2>&1

# Frameworks
echo "\n>>> List of frameworks and modules  ..."
rm -f $_ADL_WORKING_DIR/0CompList.txt
touch $_ADL_WORKING_DIR/0CompList.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot touch framework list: $rc"

adl_ls_fw -mod -all >$_ADL_WORKING_DIR/0Res_ls_fw_mod.1.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot get detached framework list: $rc"

$_AWK -v projet=$ADL_PROJET -v field_sep="$_FIELD_SEP" '\
	BEGIN \
	{
		cur_fw = "";
	}
	{
		attach = -1
		if ($1 == "Fw:")
		{
			cur_fw = $2
			component = cur_fw
			type_comp = "FRAMEWORK"
			resp = $4
			attach = 1
			if (NF == 6 && $(NF-1) == "(not" && $NF == "attached)")
				attach = 0;
		}
		else if ($1 == "+")
		{
			component = cur_fw"/"$3
			resp = $5
			attach = 1
			if (NF == 7 && $(NF-1)=="(not" && $NF == "attached)")
				attach = 0;
			if ($2 == "Mod:")
				type_comp = "MODULE";
			else if ( $2 == "Data:")
				type_comp = "DATA";
		}
		if (attach != -1 )
			print component field_sep type_comp field_sep attach field_sep resp field_sep projet;
	}' $_ADL_WORKING_DIR/0Res_ls_fw_mod.1.txt >$_ADL_WORKING_DIR/0CompList.txt

# Menage A APPELER !!!
CleanWorkingDirComp()
{
	\rm -f $_ADL_WORKING_DIR/0Res_ls_fw_mod.1.txt
}
