#!/bin/ksh
# Recherche de toutes les informations pour le transfert,
# pour Adele 3.2.
# A appeler en . pour la construction locale, ou a bidouiller
# pour la construction a distance avec rsh.
# En entree, la fonction Out doit etre definie, ainsi que les variables
#  _ADL_WORKING_DIR
#  _FIELD_SEP
# En sortie, les fichiers resultat sont
#  $_ADL_WORKING_DIR/0Lsout_conf.txt
#  $_ADL_WORKING_DIR/0DatabaseAttributes
#  $_ADL_WORKING_DIR/0SiteAttributes.txt
# Il faudra appeler CleanWorkingDir pour nettoyer les fichiers de travail.

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

# ====================================================================================
# Calcul de lsout
# ====================================================================================

# Set Adl V3 global options
mdopt -necho -nbf >/dev/null 2>&1

# Frameworks
echo "\n>>> List of frameworks ..."
\rm -f $_ADL_WORKING_DIR/0Res_ls_fw.txt
touch $_ADL_WORKING_DIR/0Res_ls_fw.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot touch framework list: $rc"

lsa "~((~(WS>$ADL_W_IDENT.main)!revname)|wr_has_fr|(*>**))!D" -a "##=!name" -n >$_ADL_WORKING_DIR/0Res_ls_fw.1.txt
rc=$?
[ $rc -ne 0 -a $rc -ne 152 ] && Out 3 "Cannot get framework list: $rc"
grep "^##=" $_ADL_WORKING_DIR/0Res_ls_fw.1.txt | sed 's/^##=//' >$_ADL_WORKING_DIR/0Res_ls_fw.2.txt
mv $_ADL_WORKING_DIR/0Res_ls_fw.2.txt $_ADL_WORKING_DIR/0Res_ls_fw.1.txt

while read conf remainder
do
	#echo "conf = $conf, remainder = $remainder"
	[ ! -z "$remainder" ] && Out 3 "remainder not empty for conf $conf: $remainder"
	
	lsa "$conf" -a !cobjname01 "**" %c_dir "**" !realtype "**" %deleted "**" -l $_ADL_WORKING_DIR/0Res_ls_fw.2.txt
	rc=$?
	[ $rc -ne 0 ] && Out 3 "Cannot get framework attributes: $rc"

	while read col1 col2 col3 remainder
	do
		#echo "col1="$col1 "col2="$col2 "col3="col3 "remainder="$remainder
		[ ! -z "$remainder" -o "$col2" != "=" -o -z "$col3" ] && Out 3 "Invalid information for conf $conf: col1=$col1 col2=$col2 col3=$col3 remainder=$remainder"
	
		case "$col1" in
			"!cobjname01") # Nom Adele de la conf
				Id1=$col3
				Id2=${Id1#*$ADL_PROJ_IDENT}
				Id=${Id2#\>}
				[ -z "$Id" ] && Out 3 "Cannot get Adele name for conf $conf"
				;;
			"%c_dir")		# Nom du repertoire
				FwName=$col3
				[ -z "$FwName" ] && Out 3 "Cannot get directory name for conf $conf"
				;;
			"!realtype")	# Type de conf
				Type=$col3
				[ "$Type" != "FW_rev" ] && Out 3 "Unknown framework type for conf $conf - $Type"
				;;
			"%deleted")		# Conf supprime ou non
				Deleted=$col3
				[ "$Deleted" != "true" -a "$Deleted" != "false" ] && Out 3 "Unknown deleted flag for conf $conf - $Deleted"
				;;
			*) 	echo "col1="$col1 "col2="$col2 "col3="col3 "remainder="$remainder
				Out 3 "Unknown field for conf $conf" 
				;;
		esac
	done < $_ADL_WORKING_DIR/0Res_ls_fw.2.txt

	Folder="<NULL>"

	Content1=${conf#*$ADL_PROJ_IDENT}
	Content=${Content1#\>}

	# Recherche du responsable du framework
	nbtry=0
	while [ $nbtry -lt 5 ]
	do
		lsa "~((*>**)|u_has_c|(~($conf)!sprojname))!O" -a "##=!name" -n > $_ADL_WORKING_DIR/0Res_get_resp.txt
		rc=$?
		[ $rc -ne 152 -a $rc -ne 242 -a $rc -ne 207 ] && break
		nbtry=$(expr $nbtry + 1)
	done

	grep "^##=" $_ADL_WORKING_DIR/0Res_get_resp.txt | sed 's/^##=//' >$_ADL_WORKING_DIR/0Res_get_resp.2.txt
	mv $_ADL_WORKING_DIR/0Res_get_resp.2.txt $_ADL_WORKING_DIR/0Res_get_resp.txt

	NbResp=$(cat $_ADL_WORKING_DIR/0Res_get_resp.txt | wc -w)
	if [ $NbResp -gt 1 ]
	then
		cat $_ADL_WORKING_DIR/0Res_get_resp.txt
		Out 3 "Cannot get only one responsible for conf $conf"
	fi
	[ $rc -ne 0 -a $rc -ne 152 ] && Out 3 "Cannot get framework responsible: $rc"
	Resp1=$(cat $_ADL_WORKING_DIR/0Res_get_resp.txt)
	Resp=${Resp1##*\>}
	[ -z "$Resp" ] && Resp=$ADL_W_RESP

	Base=${ADL_PROJ_IDENT}

	if [ "$Deleted" = "false" ]
	then
		echo "${Id}${_FIELD_SEP}${Folder}${_FIELD_SEP}${FwName}${_FIELD_SEP}${FwName}${_FIELD_SEP}FRAMEWORK${_FIELD_SEP}${Resp}${_FIELD_SEP}${Base}${_FIELD_SEP}1" >>$_ADL_WORKING_DIR/0Res_ls_fw.txt
	fi
done < $_ADL_WORKING_DIR/0Res_ls_fw.1.txt 

# Modules et datas
echo "\n>>> List of modules and data folders ..."
\rm -f $_ADL_WORKING_DIR/0Res_ls_mod.txt
touch $_ADL_WORKING_DIR/0Res_ls_mod.txt

lsa "~((~(WS>$ADL_W_IDENT.main)!revname)|wr_has_mr|(*>**))!D" -a "##=!name" -n >$_ADL_WORKING_DIR/0Res_ls_mod.1.txt
rc=$?
if [ $rc -ne 0 ] && [ $rc -ne 12 ] 
then
	Out 3 "Cannot get module and data list: $rc"
elif [ $rc -eq 0 ]
then
	grep "^##=" $_ADL_WORKING_DIR/0Res_ls_mod.1.txt | sed 's/^##=//' >$_ADL_WORKING_DIR/0Res_ls_mod.2.txt
	mv $_ADL_WORKING_DIR/0Res_ls_mod.2.txt $_ADL_WORKING_DIR/0Res_ls_mod.1.txt
	
	while read conf remainder
	do
		#echo "conf = $conf, remainder = $remainder"
		[ ! -z "$remainder" ] && Out 3 "remainder not empty for conf $conf: $remainder"

		lsa "$conf" -a !cobjname01 "**" %owner_f "**" %c_dir "**" %dir "**" !realtype "**" %deleted "**" -l $_ADL_WORKING_DIR/0Res_ls_mod.2.txt
		rc=$?
		[ $rc -ne 0 ] && Out 3 "Cannot get module or data attributes: $rc"

		while read col1 col2 col3 remainder
		do
			#echo "col1="$col1 "col2="$col2 "col3="col3 "remainder="$remainder
			[ ! -z "$remainder" -o "$col2" != "=" -o -z "$col3" ] && Out 3 "Invalid information for conf $conf: col1=$col1 col2=$col2 col3=$col3 remainder=$remainder"

		    case "$col1" in
				"!cobjname01") # Nom Adele de la conf
						Id1=$col3
						Id2=${Id1#*$ADL_PROJ_IDENT}
						Id=${Id2#\>}
						[ -z "$Id" ] && Out 3 "Cannot get Adele name for conf $conf"
						;;
				"%owner_f")		# Nom Adele du folder
						Folder1=$col3
						Folder2=${Folder1#*$ADL_PROJ_IDENT}
						Folder=${Folder2#\>}
						;;
				"%c_dir")       # Nom du repertoire
						ModDataName=$col3
						[ -z "$ModDataName" ] && Out 3 "Cannot get directory name for conf $conf"
						;;
				"%dir")         # Fullpath du repertoire
						ModDataFullPath=$col3
						[ -z "$ModDataFullPath" ] && Out 3 "Cannot get directory name for conf $conf"
						;;
				"!realtype")    # Type de conf
						case $col3 in
							"MOD_rev") Type=MODULE;;
							"DATA_rev")Type=DATA;;
							*) Out 3 "Unknown module or data type for conf $conf - $col3";;
						esac
						;;
				"%deleted")     # Conf supprime ou non
						Deleted=$col3
						[ "$Deleted" != "true" -a "$Deleted" != "false" ] && Out 3 "Unknown deleted flag for conf $conf - $Deleted"
						;;
				*)      echo "col1="$col1 "col2="$col2 "col3="col3 "remainder="$remainder
						Out 3 "Unknown field for conf $conf" 
						;;
			esac
		done < $_ADL_WORKING_DIR/0Res_ls_mod.2.txt

		Content1=${conf#*$ADL_PROJ_IDENT}
		Content=${Content1#\>}

		# Recherche du responsable du module ou data
		nbtry=0
		while [ $nbtry -lt 5 ]
		do
            lsa "~((*>**)|u_has_c|(~($conf)!sprojname))!O" -a "##=!name" -n > $_ADL_WORKING_DIR/0Res_get_resp.txt
			rc=$?
			[ $rc -ne 152 -a $rc -ne 242 -a $rc -ne 207 ] && break
			nbtry=$(expr $nbtry + 1)
		done

		grep "^##=" $_ADL_WORKING_DIR/0Res_get_resp.txt | sed 's/^##=//' >$_ADL_WORKING_DIR/0Res_get_resp.2.txt
		mv $_ADL_WORKING_DIR/0Res_get_resp.2.txt $_ADL_WORKING_DIR/0Res_get_resp.txt

		NbResp=$(cat $_ADL_WORKING_DIR/0Res_get_resp.txt | wc -w)
        if [ $NbResp -gt 1 ]
        then
                cat $_ADL_WORKING_DIR/0Res_get_resp.txt
                Out 3 "Cannot get only one responsible for conf $conf"
        fi
 
		[ $rc -ne 0 -a $rc -ne 152 ] && Out 3 "Cannot get module or data responsible: $rc"
        Resp1=$(cat $_ADL_WORKING_DIR/0Res_get_resp.txt)
		Resp=${Resp1##*\>}
		[ -z "$Resp" ] && Resp=$ADL_W_RESP

		Base=${ADL_PROJ_IDENT}

		if [ "$Deleted" = "false" ]
		then
			echo "${Id}${_FIELD_SEP}${Folder}${_FIELD_SEP}${ModDataName}${_FIELD_SEP}${ModDataFullPath}${_FIELD_SEP}${Type}${_FIELD_SEP}${Resp}${_FIELD_SEP}${Base}${_FIELD_SEP}1" >> $_ADL_WORKING_DIR/0Res_ls_mod.txt
		fi
	done < $_ADL_WORKING_DIR/0Res_ls_mod.1.txt 
fi

# Fichiers
echo "\n>>> List of files ..." 
\rm -f $_ADL_WORKING_DIR/0Res_lsout.txt
touch $_ADL_WORKING_DIR/0Res_lsout.txt

lsout "*>**" -f "${ADL_W_DIR}/**/**" -fast -u $ADL_W_RESP -list !cobjname01 !sctype "~(!projname)!ident" "%{extn.sc}" "~(~(!name)%xmove)%owner_c" %delta %executable %dir -l $_ADL_WORKING_DIR/0Res_lsout.1.txt > $_ADL_WORKING_DIR/0Res_lsout_traces.txt 2>&1
rc=$?
if [ $rc -ne 0 ] && [ $rc -ne 12 ] 
then
	echo "Content of lsout execution:"
	cat $_ADL_WORKING_DIR/0Res_lsout_traces.txt
	Out 3 "Cannot get file list: $rc"
elif [ $rc -eq 0 ]
then
	\rm -f $_ADL_WORKING_DIR/0Res_lsout_traces.txt
	while read cont ficname cobj sctype projname NomFic Folder1 IsText UnixExec CheminFic remainder
	do
		#echo "$cont - $ficname - $cobj - $sctype - $projname - $NomFic - $Folder1 - $IsText - $UnixExec - $CheminFic"
		[ -z "$cont" -o -z "$ficname" -o -z "$cobj" -o -z "$sctype" -o -z "$projname" -o -z "$NomFic" -o -z "$Folder1" -o -z "$IsText" -o -z "$UnixExec" -o ! -z "$remainder" ] && Out 3 "Invalid file information: $cont - $ficname - $cobj - $sctype - $projname - $NomFic - $Folder1 - $IsText - $UnixExec - $CheminFic"
		[ "$IsText" != "true" -a "$IsText" != "false" ] && Out 3 "Unknown IsText flag for file $ficname - $IsText"
		[ "$UnixExec" != "true" -a "$UnixExec" != "false" ] && Out 3 "Unknown UnixExec flag for file $ficname - $UnixExec"

		Id1=${cobj#*$projname}
		Id=${Id1#\>}
		Folder2=${Folder1#*$projname}
		Folder=${Folder2#\>}
		FullPathFic=${ficname#*$ADL_W_DIR/}

		if [ "$CheminFic" != "" ]
		then
			# Un ou plusieurs repertoires entre le composant et le fichier
			# "Fw1/PublicInterfaces/fic1.h" -> CheminFic = "PublicInterfaces"
			FullPathDir=${FullPathFic%/$CheminFic/$NomFic} # -> "Fw1"
			if [ "$FullPathDir" = "" -o "$FullPathDir" = "$FullPathFic" ]
			then
				Out 3 "Unable to treat the outlist line of $FullPathFic"
			fi

			while [ "$CheminFic" != "" ]
			do
				NomDir=${CheminFic%%/*} # "d1/d2" -> "d1"
				CheminFic2=${CheminFic#*/} # -> "d2"
				if [ "$CheminFic2" = "$CheminFic" ]
				then
					# Plus de /
					CheminFic=""
				else
					CheminFic=$CheminFic2
				fi
				DirId="$Folder/$NomDir" # Id construit...
				FullPathDir="$FullPathDir/$NomDir"
				echo "${DirId}${_FIELD_SEP}${Folder}${_FIELD_SEP}${NomDir}${_FIELD_SEP}${FullPathDir}${_FIELD_SEP}DIR_ELEM${_FIELD_SEP}1" >> $_ADL_WORKING_DIR/0Res_lsout.txt
				Folder=$DirId
			done
		fi

		if [ $IsText = "true" ]
		then
			IsText=1
		else
			IsText=0
		fi
		if [ $UnixExec = "true" ]
		then
			UnixExec=1
		else
			UnixExec=0
		fi
		Content1=${cont#*$projname}
		Content=${Content1#\>}
		Type=$sctype
		Taille="-"
		Date="-"

		echo "${Id}${_FIELD_SEP}${Folder}${_FIELD_SEP}${NomFic}${_FIELD_SEP}${FullPathFic}${_FIELD_SEP}FILE_ELEM${_FIELD_SEP}0${_FIELD_SEP}${IsText}${_FIELD_SEP}0${_FIELD_SEP}0${_FIELD_SEP}${UnixExec}${_FIELD_SEP}${Content}${_FIELD_SEP}${Taille}${_FIELD_SEP}${Date}${_FIELD_SEP}${Type}" >> $_ADL_WORKING_DIR/0Res_lsout.txt
	done < $_ADL_WORKING_DIR/0Res_lsout.1.txt 
fi

sort -T $_ADL_WORKING_DIR -o $_ADL_WORKING_DIR/0Res_lsout.txt -k 4 -t "$_FIELD_SEP" -u $_ADL_WORKING_DIR/0Res_lsout.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot sort outlist into $_ADL_WORKING_DIR/0Res_lsout.txt: $rc"

# Construction de la lsout finale
echo "\n>>> Assembly of all lists ..."

cat $_ADL_WORKING_DIR/0Res_ls_fw.txt $_ADL_WORKING_DIR/0Res_ls_mod.txt $_ADL_WORKING_DIR/0Res_lsout.txt >$_ADL_WORKING_DIR/0Lsout_conf.txt
rc=$?
[ $rc -ne 0 ] && Out 3 "Cannot concatenate lists in $_ADL_WORKING_DIR/0Lsout_conf.txt: $rc"

# cat $_ADL_WORKING_DIR/0Lsout_conf.txt

# ====================================================================================
# On genere la trash cote remote
# ====================================================================================
echo "\n>>> Database attributes"
lsa "trash>trash" -l $_ADL_WORKING_DIR/0DatabaseAttributes
rc=$?
if [ $rc -ne 0 ] && [ $rc -ne 2 ]
then
	echo "!!! KO : Cannot calculate database attributes - $rc"
	return
fi
# ====================================================================================
# On recupere les attributs du site
# ====================================================================================
echo "\n>>> List of site attributes..."
echo  "$_FIELD_SEP" > $_ADL_WORKING_DIR/0SiteAttributes.txt


# ====================================================================================
# Menage A APPELER !!!
# ====================================================================================
CleanWorkingDir()
{
	\rm -f $_ADL_WORKING_DIR/0Res_ls_fw.1.txt
	\rm -f $_ADL_WORKING_DIR/0Res_ls_fw.2.txt
	\rm -f $_ADL_WORKING_DIR/0Res_ls_mod.1.txt
	\rm -f $_ADL_WORKING_DIR/0Res_ls_mod.2.txt
	\rm -f $_ADL_WORKING_DIR/0Res_lsout.1.txt
	\rm -f $_ADL_WORKING_DIR/0Res_ls_fw.txt
	\rm -f $_ADL_WORKING_DIR/0Res_ls_mod.txt
	\rm -f $_ADL_WORKING_DIR/0Res_lsout.txt 
	\rm -f $_ADL_WORKING_DIR/0DatabaseAttributes
	\rm -f $_ADL_WORKING_DIR/0Res_lsout_traces.txt
	\rm -f $_ADL_WORKING_DIR/0Res_get_resp.txt
}
