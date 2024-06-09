#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName ADL_FR_CATIA SourceSiteId SourceSiteVersion SourceWs SourceBase TargetSiteId TargetSiteVersion TargetWs TargetBase ADL_PROJ_IDENT ADL_WORKING_DIR _LSOUT_CURRENT1 _LSOUT_CURRENT2 _LSOUT_CURRENT_REF1 _LSOUT_CURRENT_REF2 _LSOUT_RI2 _LSOUT_RI_REF2 _FIELD_SEP

ADL_FR_CATIA        : CATIA level of Target base
SourceSiteId        : source site identifier (In case of ADLV3, give NULL value)
SourceSiteVersion   : source site version (In case of ADLV3, give NULL value)
SourceWs            : workspace name in the source database (In case of ADLV3, give ADL_W_IDENT value of the workspace)
SourceBase          : Name of the Adele source database
TargetSiteId        : target site identifier (In case of ADLV3, give NULL value)
TargetSiteVersion   : target site version (In case of ADLV3, give NULL value)
TargetWs            : workspace name in the target database (In case of ADLV3, give ADL_W_IDENT value of the workspace)
TargetBase          : Name of the Adele target database
ADL_PROJ_IDENT      : Name of the Adele target project (In case of ADLV3 only)
ADL_WORKING_DIR     : Path of the data transfer working directory
_LSOUT_CURRENT1     : Name of the file containing the COMPLETED list of files in the CURRENT  version of source workspace
_LSOUT_CURRENT2     : Name of the file containing the FILTERED  list of files in the CURRENT  version of source workspace
_LSOUT_CURRENT_REF1 : Name of the file containing the COMPLETED list of files in the PREVIOUS  version of source workspace
_LSOUT_CURRENT_REF2 : Name of the file containing the FILTERED  list of files in the PREVIOUS  version of source workspace
_LSOUT_RI2          : Name of the file containing the FILTERED  list of files in the CURRENT version of target workspace
_LSOUT_RI_REF2      : Name of the file containing the FILTERED  list of files in the PREVIOUS version of target workspace
_FIELD_SEP          : Field separator in lsout file
"
# =====================================================================

# Shell de report des RI ( equivaut a un changement de espace de travail proprietaire des fichiers attaches a un RI)
# 
# Usage : Report_RI_V5V3.sh ADL_FR_CATIA ws_depart base_depart ws_arrivee base_arrivee ADL_PROJ_IDENT rep_trace_report
# ws_depart , ws_arrivee , base_arrivee et ADL_PROJ_IDENT de la base d'arrivee doivent etre donnes en argument -> faire attention , en ADLV3 on veut ADL_W_IDENT a priori 
# ex : rep_trace_report ou se trouve les fichiers OLsout ...

[ ! -z "$ADL_DEBUG" ] && set -x

OS=$(uname -s)
case $OS in
    AIX)   
        PING="/usr/sbin/ping -c 1"
        WHOAMI="/bin/whoami"
        MAIL="/bin/mail"
        _AWK=/bin/awk
        DU=/bin/du
        RSH="/usr/bin/rsh"
        ;;
    HP-UX)
        PING="/usr/sbin/ping -n 1"
        WHOAMI="/usr/bin/whoami"
        MAIL="/usr/bin/mail"
        _AWK=/bin/awk
        DU=/bin/du
        RSH="/bin/remsh"
        ;;
    IRIX | IRIX64)
        PING="/usr/etc/ping -c 1"
        WHOAMI="/usr/bin/whoami"
        MAIL="/usr/bin/mail"
        _AWK=/bin/nawk
        DU=/bin/du
        RSH="/usr/bsd/rsh"
        ;;
    SunOS)
        PING="/usr/sbin/ping"
        WHOAMI="/usr/ucb/whoami"
        MAIL="/bin/mailx"
        _AWK=/bin/nawk
        DU=/bin/du
        RSH="/bin/rsh"
		export PATH=$PATH:/usr/ucb
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
    \rm -fr /tmp/*_$$
    exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM

# =====================================================================
# Options treatment
# =====================================================================
if [ $# -ne 18 ] 
then
	echo "You don't have specified the right number of arguments"
	Out 1 "$Usage"
fi

niveau_report=$1
site_depart=$2
site_version_depart=$3
workspace_depart=$4
base_depart=$5
site_arrivee=$6
site_version_arrivee=$7
workspace_arrivee=$8
base_arrivee=$9
ADL_PROJ_IDENT=${10}
rep_trace_report=${11}
_LSOUT_CURRENT1=${12}
_LSOUT_CURRENT2=${13}
_LSOUT_CURRENT_REF1=${14}
_LSOUT_CURRENT_REF2=${15}
_LSOUT_RI2=${16}
_LSOUT_RI_REF2=${17}
_FIELD_SEP=${18}

for fic in $_LSOUT_CURRENT1 $_LSOUT_CURRENT2 $_LSOUT_CURRENT_REF1 $_LSOUT_CURRENT_REF2 $_LSOUT_RI2 $_LSOUT_RI_REF2
do
	if [ ! -f $rep_trace_report/$fic ]
	then
		Out 5 "File does not exist: $rep_trace_report/$fic"
	fi
done
# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)

echo "____________________________________________________________"
echo "$CurrentDate : Update RI informations from source workspace $workspace_depart to target workspace $workspace_arrivee"
echo "Procedure parameters:"
echo "$@"

# =====================================================================
# DB2 - OSIRIX parameters
# =====================================================================

if [ ! -z "$ADL_OX_PROFILE" ] 
then
	# Cas Adele V5 et TCK
	# Export des variables necessaires a l'execution de requete DB2 et des Osirix
	. $ADL_OX_PROFILE

	# Lancement de la profile db2
	. $DB2_PROFILE

	# Lancement d'un serveur Osirix
	. adl_ox_start_server.sh
	[ $? -ne 0 ] && Out 5 "Cannot start an Osirix server"

elif [ -x /u/db2client/sqllib/db2profile ]
then
  # Cas Adele V3
  ADL_OX_SCHEMA_NAME=MVSDB2
  ADL_OX_DATABASE="osirix"
  ADL_OX_PASSWORD=adele
  ADL_OX_USERNAME=adl
  export ADL_CUST=/u/env/adlbin/off/custserver
  export ADL_OX_LEVEL=2
  
  unset LIBPATH
  unset LD_LIBRARY_PATH
  unset SHLIB_PATH

  # On lance la profile db2
  . /u/db2client/sqllib/db2profile

  # on lance un serveur Osirix
  . $ADL_CUST/bin/profile_ox.sh
else
  Out 5 "Cannot find Osirix profile. Please Valuate ADL_OX_PROFILE variable."
fi

# On se connecte a la base Osirix
# -------------------------------------
_TRACE_CONNECT=/tmp/Trace_DB2_Connect_$$
db2 "connect to $ADL_OX_DATABASE user $ADL_OX_USERNAME using $ADL_OX_PASSWORD" 1>$_TRACE_CONNECT 2>&1
if [ $? -ne 0 ] 
then
	cat $_TRACE_CONNECT
	Out 5 "Cannot connect to Osirix"
fi
\rm -f $_TRACE_CONNECT



# =====================================================================
# On recherche la liste des RIs associes au workspace de la base source
# =====================================================================
typeset -u workspace_depart_upper=$workspace_depart
typeset -u base_depart_upper=$base_depart
_ws_source=$workspace_depart
_base_source=$base_depart
if [ $site_version_depart != "NULL_SITE_VERSION" -a $site_version_depart != "adlv5703" -a $site_version_depart != "adlv5800" ]
then
	_ws_source=$workspace_depart_upper
	_base_source=$base_depart_upper
fi

typeset -u workspace_arrivee_upper=$workspace_arrivee
typeset -u base_arrivee_upper=$base_arrivee
_ws_target=$workspace_arrivee
_base_target=$base_arrivee
if [ $site_version_arrivee != "NULL_SITE_VERSION" -a $site_version_arrivee != "adlv5703" -a $site_version_arrivee != "adlv5800" ]
then
	_ws_target=$workspace_arrivee_upper
	_base_target=$base_arrivee_upper
fi

REQUETE="SELECT DISTINCT '##BEGIN##' , CODRI||NUMRI FROM $ADL_OX_SCHEMA_NAME.GATBHIST WHERE WORKSPACE = '$_ws_source' AND BASE = '$_base_source' AND (SITE = '$site_depart' OR SITE IS NULL)"

db2 "$REQUETE" 2>&1 > /tmp/resu_temp1_requete_$$
[ ! -z "$ADL_DEBUG" ] && cat /tmp/resu_temp1_requete_$$

vide1=$(cat /tmp/resu_temp1_requete_$$ | $_AWK '{ if ( $0 == "  0 record(s) selected.") { print $0; } }' | wc -l)
vide=$(echo $vide1)

if [ $vide = 1 ]
then
	echo "NO RIs to update from workspace $workspace_depart in source database $base_depart on site $site_depart to workspace $workspace_arrivee in target database $base_arrivee on site $site_arrivee"
	\rm -f /tmp/resu_temp1_requete_$$
	Out 0
fi

grep '^##BEGIN##' /tmp/resu_temp1_requete_$$ | $_AWK '{print $2}' > /tmp/fichier_ri_in_$$
cp -pf /tmp/fichier_ri_in_$$ /tmp/fichier_ri_out_$$

# =====================================================================
# Step supprime par YGD et NLE le 30/11/2001 car on veut supporter le MULTILEVEL
# =====================================================================
# Si la variable ADL_OX_NO_CHECK_FR=ON (ce qui est le cas des workspaces CGM), on va reporter tous les RIs
# Sinon on filtre la liste des RIs associes au workspace de la base source par le niveau ADL_FR_CATIA 
# de l'espace d'arrivee concerne. La plupart du temps, le resultat contient tous les RIs. Le seul interet est
# le cas ou l'espace d'origine n'a pas la meme valeur de ADL_FR_CATIA que l'espace de destination et qu'on ne
# veut pas reporter ces RIs qui n'arriveraient jamais dans le BSF du bon ADL_FR_CATIA.
# =====================================================================
#if [ "$ADL_OX_NO_CHECK_FR" != "ON" ]
#then
	# On positionne le fichier des RIs a traiter dans le $HOME du user pour que ox_chkri le trouve
	# ---------------------------------------------------------------------------------------------
#	cp -pf /tmp/fichier_ri_in_$$ $HOME/fichier_ri_in_$$
#	[ ! -z "$ADL_DEBUG" ] && cat $HOME/fichier_ri_in_$$
  
	# On boucle sur tous les RIs a filtrer
	# -------------------------------------
#	touch     $HOME/fichier_ri_out_$$
#	chmod 777 $HOME/fichier_ri_out_$$
#	NbMaxTry=2
#	NbTried=0
#	rc_chkri=-1
#	while [ $rc_chkri != 0 -a $rc_chkri != 1 -a $NbTried -lt $NbMaxTry ]
#	do
#		ox_chkri -report -RIin $HOME/fichier_ri_in_$$ -RIout $HOME/fichier_ri_out_$$ -nivadl $niveau_report 1>/tmp/pb_$$ 2>&1
#		rc_chkri=$?
#		[ ! -z "$ADL_DEBUG" ] && cat $HOME/fichier_ri_out_$$
#		cp $HOME/fichier_ri_out_$$ /tmp/fichier_ri_out_$$
#	    let "NbTried=NbTried+1"
#	done
#
#	\rm -f $HOME/fichier_ri_in_$$
#	\rm -f $HOME/fichier_ri_out_$$
#
#	if [ $rc_chkri = 1 ]
#	then
#		\rm -f /tmp/pb_$$ 2>&1
#		Out 0 "No RI have to be transfered from workspace $workspace_depart in source database $base_depart on site $site_depart to workspace $workspace_arrivee in target database $base_arrivee on site $site_arrivee"
#	fi
#
#	if  [ $rc_chkri != 0 ] 
#	then
#		echo "ox_chkri return code is $rc_chkri"
#		cat /tmp/pb_$$
#		\rm /tmp/pb_$$
#		Out $rc_chkri "Command ox_chkri failed, please CONTACT your ADELE Administrator !"
#	fi # fin si le retour renvoie KO
#
#	\rm -f /tmp/pb_$$ 2>&1
#fi

# ==========================
# On agence la liste des RIs au format VARIABLE
# ==========================
passage=0
while read codrinumri
do
	if [ $passage = 0 ]
	then
		ListeRI=$codrinumri
		passage=1
	else
		ListeRI=$codrinumri\',\'$ListeRI
	fi # passage = 0
done </tmp/fichier_ri_out_$$

if [ -z "$ListeRI" ]
then
	Out 0 "No RI have to be transfered from workspace $workspace_depart in source database $base_depart on site $site_depart to workspace $workspace_arrivee in target database $base_arrivee on site $site_arrivee"
fi

# =====================================================================
# On recherche le nom reel des fichiers et leur type de mofication
# =====================================================================
REQUETE="SELECT '##BEGIN##', TYPE_MODIFICATION, CODRI||NUMRI, NOM_REEL_FICHIER FROM $ADL_OX_SCHEMA_NAME.GATBHIST WHERE WORKSPACE = '$_ws_source' AND BASE = '$_base_source' AND (SITE = '$site_depart' OR SITE IS NULL) AND CODRI||NUMRI IN ('$ListeRI')"
db2 "$REQUETE" | grep '^##BEGIN##' > /tmp/liste_fic_report_$$
[ ! -z "$ADL_DEBUG" ] && cat /tmp/liste_fic_report_$$

# =====================================================================
# On update le nom du workspace et de sa base destination pour chaque fichier concerne
# =====================================================================
while read begin type_modification RI nom_reel_fichier
do
	# REMARQUE : comme nom_reel_fichier est le dernier champ lu,
	# il peut contenir des espaces.

	if [ $type_modification = "MF" ]
	then
		# la recherche se fera dans la lsout du ws d'origine car c'est une creation
		first_file_to_study=$rep_trace_report/$_LSOUT_CURRENT2
		second_file_to_study=$rep_trace_report/$_LSOUT_CURRENT1
		result_file=$rep_trace_report/$_LSOUT_RI2
	elif [ $type_modification = "DF" ]
	then
		# la recherche se fera dans la lsout du ws d'arrivee car c'est une destruction
		first_file_to_study=$rep_trace_report/$_LSOUT_CURRENT_REF2
		second_file_to_study=$rep_trace_report/$_LSOUT_CURRENT_REF1
		result_file=$rep_trace_report/$_LSOUT_RI_REF2
	else # Type de modification inconnue
		Out 5 "Unknown modification type $type_modification for file $nom_reel_fichier"
	fi			

	# On recherche dans la lsout filtree du ws la ligne du fichier traite 
	fgrep "${_FIELD_SEP}${nom_reel_fichier}${_FIELD_SEP}" $first_file_to_study > /tmp/traitement_first_file_$$
	[ ! -z "$ADL_DEBUG" ] && cat /tmp/traitement_first_file_$$
	vide1=$(cat /tmp/traitement_first_file_$$ | wc -l)
	vide=$(echo $vide1)
	if [ $vide = 0 ]
	then
		# Comme on n'a rien trouve, on recherche dans la lsout non filtree du ws la ligne du fichier traite 
		fgrep "${_FIELD_SEP}${nom_reel_fichier}${_FIELD_SEP}" $second_file_to_study > /tmp/traitement_second_file_$$
		vide2=$(cat /tmp/traitement_second_file_$$ | wc -l)
		vide3=$(echo $vide2)
		if [ $vide3 = 0 ]
		then
			# On n'a trouve aucune ligne dans les lsout disponible concernant ce fichier, on suppose donc qu'il y a eu une merde un jour, on essaie de se ratrapper comme on peut aux branches en updatant tout ce qui concerne ce fichier en donnant le workspace et la base d'arrivee
			
			REQUETE="UPDATE $ADL_OX_SCHEMA_NAME.GATBHIST SET WORKSPACE = '$_ws_target', BASE = '$_base_target', SITE = '$site_arrivee', DATE_MODIFICATION = CURRENT TIMESTAMP, ROLE_WORKSPACE = 'COLLECTED' WHERE NOM_REEL_FICHIER = '$nom_reel_fichier' AND WORKSPACE = '$_ws_source' AND BASE = '$_base_source' AND (SITE = '$site_depart' OR SITE IS NULL) AND TYPE_MODIFICATION = '$type_modification' AND CODRI||NUMRI ='$RI'"
			echo "-> $REQUETE"
			db2 "$REQUETE" 
			db2 "COMMIT"
		# else
			# Cas ou le fw n'est pas reporte ...
		fi # vide3 = 0
		\rm /tmp/traitement_second_file_$$
	else
		fgrep "${_FIELD_SEP}${nom_reel_fichier}${_FIELD_SEP}" $result_file > /tmp/traitement_result_file_$$
		[ ! -z "$ADL_DEBUG" ] && cat /tmp/traitement_result_file_$$
		if [ "$ADL_PROJ_IDENT" != "-" ] 
		then
			nom_adele_fichier=\>$ADL_PROJ_IDENT\>$(cat /tmp/traitement_result_file_$$ |  $_AWK -F "$_FIELD_SEP" '{ print $1; }')
		else
			nom_adele_fichier=$(cat /tmp/traitement_result_file_$$ |  $_AWK -F "$_FIELD_SEP" '{ print $1; }')
			# on ne veut que le soft_obj_id soit les 20 derniers cararcteres des 43 de lsout
			nom_adele_fichier=$(echo $nom_adele_fichier |  $_AWK -F "_"  '{ print $NF; }')
		fi

		REQUETE_UPDATE="UPDATE $ADL_OX_SCHEMA_NAME.GATBHIST SET NOM_ADELE_FICHIER = '$nom_adele_fichier', WORKSPACE = '$_ws_target', BASE = '$_base_target', SITE = '$site_arrivee', DATE_MODIFICATION = CURRENT TIMESTAMP, ROLE_WORKSPACE = 'COLLECTED'  WHERE NOM_REEL_FICHIER = '$nom_reel_fichier' AND WORKSPACE = '$_ws_source' AND BASE = '$_base_source' AND (SITE = '$site_depart' OR SITE IS NULL) AND TYPE_MODIFICATION = '$type_modification' AND CODRI||NUMRI = '$RI'"
		echo "-> $REQUETE_UPDATE"
		db2 "$REQUETE_UPDATE" 2>&1 > /tmp/db2_result_$$
		rc_update=$?
		[ ! -z "$ADL_DEBUG" -o $rc_update -ne 0 ] && cat /tmp/db2_result_$$
		db2 "COMMIT"
		\rm /tmp/traitement_result_file_$$
	fi # vide = 0
	\rm /tmp/traitement_first_file_$$		

done </tmp/liste_fic_report_$$

\rm /tmp/liste_fic_report_$$
\rm /tmp/fichier_ri_out_$$

Out 0 

