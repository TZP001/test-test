#!/bin/ksh
# Recherche de toutes les informations pour le transfert,
# pour Adele V5.
# ATTENTION : le format est inadapte pour du transfert V5->V5
# (pas de gestion de repertoire).
# A appeler en . pour la construction locale, ou a bidouiller
# pour la construction a distance avec rsh.
# En entree, la fonction Out doit etre definie, ainsi que les variables
#  _ADL_WORKING_DIR
#  _FIELD_SEP
#  _ADL_FILTER_TREE si on ne veut la liste des frameworks que pour un tree donne

# En sortie, les fichiers resultat sont
#  $_ADL_WORKING_DIR/0Lsout_conf.txt
#  $_ADL_WORKING_DIR/0DatabaseAttributes
#  $_ADL_WORKING_DIR/0SiteAttributes.txt
# Il faudra appeler CleanWorkingDir pour nettoyer les fichiers de travail.

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

# ====================================================================================
# Lancement de la commande calculant la liste des objets
# ====================================================================================
echo "\n>>> List of all objects..."
adl_ls_out -soft_obj_info -rel_to_folder -all -program -sep "$_FIELD_SEP" -out $_ADL_WORKING_DIR/0Res_lsout.txt 
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot get the outlist: $rc"

# Correction d'un bug Adele V5... ### A VIRER que <NULL> ne sera plus suivi par des espaces
sed 's/<NULL> */<NULL>/g' $_ADL_WORKING_DIR/0Res_lsout.txt >$_ADL_WORKING_DIR/0Lsout_conf.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot treat the outlist: $rc"

# ====================================================================================
# Lancement de la commande calculant la liste des attributs de la base (pour compatibilite V3)
# ====================================================================================
$_AWK -F "$_FIELD_SEP" '\
($5 == "DIR_ELEM") \
{
	path = $4;
	sub("^[^/]*/", "", path); # On enleve le framework
	if (subdir_list_array[path] == 0)
	{
		# Le chemin restant n est pas deja traite
		path2 = path;
		nb = sub("/[^/]*$", "", path2); # On enleve le dernier nom de repertoire
		if (nb == 0 || subdir_list_array[path2] != 0)
		{
			# Il s agit du repertoire suivant le framework, ou
			# le chemin entre le framework et le repertoire traite apparait dans
 l ensemble
			# -> il s agit d un nouveau repertoire a sortir
			subdir_list_array[path] = 1;
			print "	  fw_subdir_list = " path;
		}
	}
}' $_ADL_WORKING_DIR/0Lsout_conf.txt >$_ADL_WORKING_DIR/0DatabaseAttributes

# ====================================================================================
# On filtre la liste des objets avec le TREE s'il existe
# ====================================================================================
if [ ! -z "$_ADL_FILTER_TREE" ]
then
	# on calcule la liste de frameworks de ce tree
	$_AWK -F "$_FIELD_SEP" -v tree=$_ADL_FILTER_TREE -v sep="$_FIELD_SEP" '\
	{ 
		if ($5 == "FRAMEWORK" && $7 == tree) 
		{
			print sep $4 sep
			print sep $4 "/"
		}
	}' $_ADL_WORKING_DIR/0Lsout_conf.txt > $_ADL_WORKING_DIR/0FwFilter$$.txt

	# on filtre la lsout
	fgrep -f $_ADL_WORKING_DIR/0FwFilter$$.txt $_ADL_WORKING_DIR/0Lsout_conf.txt > $_ADL_WORKING_DIR/0Lsout_conf2.txt
	\mv $_ADL_WORKING_DIR/0Lsout_conf2.txt $_ADL_WORKING_DIR/0Lsout_conf.txt
	\rm -f $_ADL_WORKING_DIR/0FwFilter$$.txt
fi

# ====================================================================================
# On recupere les attributs du site
# ====================================================================================
echo "\n>>> List of site attributes..."
CMD=$ADL_USER_PATH/admin/adl_ls_site
whence $CMD 2>&1 >/dev/null
[ $? -ne 0 ] && Out 3 "Cannot find command: $CMD"
 
$CMD -program -sep "$_FIELD_SEP" -out $_ADL_WORKING_DIR/0SiteAttributes.txt 
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot get the site attributes: $rc"

CMD=$ADL_USER_PATH/adl_version
whence $CMD 2>&1 >/dev/null
[ $? -ne 0 ] && Out 3 "Cannot find command: $CMD"
 
$CMD -program -sep "$_FIELD_SEP" >> $_ADL_WORKING_DIR/0SiteAttributes.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot get the site version attributes: $rc"

# ====================================================================================
# Menage
# ====================================================================================
CleanWorkingDir()
{
	\rm -f $_ADL_WORKING_DIR/0Res_lsout.txt 
}
