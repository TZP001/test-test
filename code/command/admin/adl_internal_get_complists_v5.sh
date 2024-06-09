#!/bin/ksh
# Recherche de toutes les informations pour le transfert,
# pour Adele V5.
# ATTENTION : le format est inadapte pour du transfert V5->V5
# (pas de gestion de repertoire).
# A appeler en . pour la construction locale, ou a bidouiller
# pour la construction a distance avec rsh.
# En entree, la fonction Out doit etre definie, ainsi que les variables
#  _ADL_WORKING_DIR
#  _ADL_FILTER_TREE si on ne veut la liste des frameworks que pour un tree donne
#  _FIELD_SEP
# En sortie, les fichiers resultat sont
#  $_ADL_WORKING_DIR/0CompList.txt
# Il faudra appeler CleanWorkingDirComp pour nettoyer les fichiers de travail.

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

unset OPTIONS
[ ! -z "$_ADL_FILTER_TREE" ] && OPTIONS="-tree $_ADL_FILTER_TREE"

# Lancement de la commande
echo "\n>>> List of all frameworks and modules..."
adl_ls_fw -mod -all $OPTIONS -program -sep "$_FIELD_SEP" -out $_ADL_WORKING_DIR/0CompList.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot get the list of all frameworks and modules: $rc"

# Menage
CleanWorkingDirComp()
{
	true # Rien a faire
}
