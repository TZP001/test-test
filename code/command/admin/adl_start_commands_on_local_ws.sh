#!/bin/ksh

OS=$(uname -s)
case $OS in
	AIX)
		_AWK=/bin/awk
		;;
	HP-UX)
		_AWK=/bin/awk
		;;
	IRIX | IRIX64)
		_AWK=/bin/nawk
		;;
	SunOS)
		_AWK=/bin/nawk
		;;
	Windows_NT)
		_AWK=awk
		;;
esac

if [ $OS = Windows_NT ]
then
	FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	ShellName="${FullShellName##*/}"
	cd "${FullShellName%/*}"
	ShellDir="$(pwd)"
	cd -

	TMP=$(printf "%s" "$TEMP" | sed 's+\\+/+g')
	NULL=nul

else
	FullShellName=$(whence "$0" | sed 's+\\+/+g')
	ShellName=${FullShellName##*/}
	ShellDir=${FullShellName%/*}

	TMP=/tmp
	NULL=/dev/null
fi

# =====================================================================
Usage="$ShellName [-l_photo] [-l_refresh] [-l_collect WS1 WS2 ... WSn] [-l_sync] [-l_merge] [-l_att_mod] [-l_publish] [-l_promote WS1 WS2 ... WSn] [-ltree ws_tree] [-cr CR1 CR2 ... CRn | -cr_transfer] [-f PromotedFiles]

-l_photo               : To freeze local workspace
-l_refresh             : To refresh local workspace image
-l_collect WS1 ... WSn : To collect all child workspace's promotions or only specified child workspace's promotions
-l_sync                : To synchronize local workspace
-l_merge               : To solve merges in local workspace
-l_att_mod             : To attach all the modules of the attached frameworks (Adele V5 only)
-l_publish             : To publish local workspace
-l_promote WS1 ... WSn : To publish and promote local workspace to parent workspace in Adele V3 or to specified workspaces in Adele V5
-ltree ws_tree         : Name of the tree impacted by the Adele flow commands
-cr CR1 ... CRn        : Change request number list
-cr_transfer           : Change request is managed by adl_promote using -cr_transfer option
-f PromotedFiles       : Filename of the promoted files
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
	rm -fr $TMP/*_$$
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM
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

unset _L_PHOTO
unset _L_REFRESH
unset _L_COLLECT
unset _L_COLLECT_LIST
unset _L_SYNC
unset _L_LIST_MERGE
unset _L_SOLVE_MERGE
unset _L_ATT_MOD
unset _L_PUBLISH
unset _L_WS_TREE
unset _L_PROMOTE
unset _L_PROMOTE_LIST
unset _PROMOTED_FILE
unset _CR_LIST
unset _CR_TRANSFER

typeset -L1 OneChar
[ $# -eq 0 ] && Out 1 "$Usage"
while [ $# -ne 0 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
				;;
		-l_photo ) #-------------> OPTIONAL: LOCAL PHOTO
			_L_PHOTO="TRUE"
			shift
				;;
		-l_refresh ) #-----------> OPTIONAL: LOCAL REFRESH
			_L_REFRESH="TRUE"
			shift
				;;
		-l_collect ) #-----------> OPTIONAL: LOCAL COLLECT
			_L_COLLECT="TRUE"
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_L_COLLECT_LIST="$_L_COLLECT_LIST $1"
					shift
				else
					break
				fi
			done
				;;
		-l_sync ) #--------------> OPTIONAL: LOCAL SYNCHRONISATION
			_L_SYNC="TRUE"
			shift
				;;
		-l_solve_merge ) #--------------> OPTIONAL: LOCAL MERGING
			_L_SOLVE_MERGE="TRUE"
			shift
				;;
		-l_ls_merge ) #--------------> OPTIONAL: LIST LOCAL MERGING
			_L_LIST_MERGE="TRUE"
			shift
				;;
		-l_att_mod ) #--------------> OPTIONAL: ATTACHER LES MODULES
			_L_ATT_MOD="TRUE"
			shift
				;;
		-l_publish ) #-----------> OPTIONAL: LOCAL PUBLISH
			_L_PUBLISH="TRUE"
			shift
				;;
		-l_promote ) #-----------> OPTIONAL: LOCAL PROMOTE
			_L_PROMOTE="TRUE"
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_L_PROMOTE_LIST="$_L_PROMOTE_LIST $1"
					shift
				else
					break
				fi
			done
			;;
		-cr ) #------------------> OPTIONAL: CHANGE REQUEST NUMBER LIST
			shift
			while [ $# -ne 0 ]
			do
				OneChar=$1
				if [ "$OneChar" != "-" ]
				then
					_CR_LIST="$_CR_LIST $1"
					shift
				else
					break
				fi
			done
			if [ -z "$_CR_LIST" ] 
			then
				echo 1>&2 "-cr option has been requested without parameters"
				Out 3 "$Usage"
			fi
			if [ ! -z "$_CR_TRANSFER" ]
			then 
				echo 1>&2 "-cr and -cr_transfer options have been specified together"
				Out 3 "$Usage"
			fi
			;;
		-cr_transfer ) #-----------> OPTIONAL: LOCAL cr_transfer OPTION
			_CR_TRANSFER="TRUE"
			if [ ! -z "$_CR_LIST" ]
			then 
				echo 1>&2 "-cr and -cr_transfer options have been specified together"
				Out 3 "$Usage"
			fi
			shift
			;;
		-ltree ) #---------------> OPTIONAL: NAME OF THE IMPACTED TREE
			CheckOptArg "$1" "$2"
			_L_WS_TREE=$2
			shift 2
			;;
		-f ) #-------------------> OPTIONAL: FILENAME OF PROMOTED OBJECTS
			CheckOptArg "$1" "$2"
			_PROMOTED_FILE=$2
			shift 2
			;;
		 * ) echo "Unknown option: $1" 1>&2
		Out 3 "$Usage"
		;;
	esac
done

# =====================================================================
# Begin treatment
# =====================================================================
CurrentDate=$($ShellDir/adl_get_current_date.sh)

[ -z "$ADL_LEVEL" ] && Out 3 "No ADL_LEVEL variable set"
if [ $ADL_LEVEL = 2 ]
then
	# ----------------------------------------------------------------------
	# Adele version 3
	# ----------------------------------------------------------------------
	[ -z "$ADL_W_ID" ] && Out 3 "No current workspace exist"
	echo "____________________________________________________________"
	echo "$CurrentDate : Adele V3 flow commands on workspace $ADL_W_ID"

	type_de_ws=$(lsa "WS>$ADL_W_IDENT" -a !realtype -n)
	rc=$?
	[ $rc -ne 0 ] && Out 3 "Cannot get workspace type - $rc"
	
	if [ ! -z "$_L_PHOTO" ] || [ ! -z "$_L_REFRESH" ] || [ ! -z "$_L_COLLECT" ] || [ ! -z "$_L_SYNC" ] || [ ! -z "$_L_PUBLISH" ] || [ ! -z "$_L_PROMOTE" ]
	then
		Cmd=adl_photo
		echo "\n>>> $Cmd"
		compteur=0
		rc=207
		while [ $rc -eq 207 -a $compteur -lt 10 ]
		do
			$Cmd <$NULL
			rc=$?
			compteur=`expr $compteur + 1`
		done
		[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_photo KO - $rc"
	fi

	if [ ! -z "$_L_REFRESH" ] || [ ! -z "$_L_COLLECT" ] || [ ! -z "$_L_SYNC" ] || [ ! -z "$_L_PUBLISH" ] || [ ! -z "$_L_PROMOTE" ]
	then
		Cmd="adl_refresh"
		echo "\n>>> $Cmd"
		compteur=0
		rc=207
		while [ $rc -eq 207 -a $compteur -lt 10 ]
		do
			$Cmd <$NULL
			rc=$?
			compteur=`expr $compteur + 1`
		done
		[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_refresh KO - $rc"
	fi

	if [ ! -z "$_L_COLLECT" ]
	then
        if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "bsf" ]
        then
			Cmd="adl_collect $_L_COLLECT_LIST $_R_MAINTENANCE"
			echo "\n>>> $Cmd"
			compteur=0
			rc=207
			while [ $rc -eq 207 -a $compteur -lt 10 ]
			do
					$Cmd <$NULL
					rc=$?
					compteur=`expr $compteur + 1`
			done
			[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_collect KO - $rc"
		fi
	fi

	if [ ! -z "$_L_SYNC" ]
	then
        if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "dev" ]
        then
			Cmd="adl_sync"
			echo "\n>>> $Cmd"
			export ADL_BATCH=true
			compteur=0
			rc=207
			while [ $rc -eq 207 -a $compteur -lt 10 ]
			do
				$Cmd <$NULL
				rc=$?
				compteur=`expr $compteur + 1`
			done
			[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_sync KO - $rc"
		fi
	fi

	if [ ! -z "$_L_LIST_MERGE" ]
	then
		Cmd="adl_ls_merge"
		echo "\n>>> $Cmd"
		compteur=0
		rc=207
		while [ $rc -eq 207 -a $compteur -lt 10 ]
		do
			$Cmd <$NULL 
			rc=$?
			compteur=`expr $compteur + 1`
		done
		[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_ls_merge KO - $rc"
	fi

	if [ ! -z "$_L_SOLVE_MERGE" ]
	then
		Cmd="adl_solve_merge"
		echo "\n>>> $Cmd"
		unset ADL_BATCH
		compteur=0
		rc=207
		while [ $rc -eq 207 -a $compteur -lt 10 ]
		do
			$Cmd <$NULL
			rc=$?
			compteur=`expr $compteur + 1`
		done
		[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_merge KO - $rc"
	fi

	if [ ! -z "$_L_PUBLISH" ] || [ ! -z "$_L_PROMOTE" ]
	then
        if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "bsf" ]
        then
			Cmd="adl_publish"
			echo "\n>>> $Cmd"
			compteur=0
			rc=207
			while [ $rc -eq 207 -a $compteur -lt 10 ]
			do
				$Cmd <$NULL
				rc=$?
				compteur=`expr $compteur + 1`
			done
			[ $rc -ne 0 -a $rc -ne 2 ] && Out 3 "adl_publish KO - $rc"
		fi
	fi

	if [ ! -z "$_L_PROMOTE" ]
	then
        if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "dev" ]
        then
			# on recherche le niveau CATIA de la base et son mode de travail
			lsa "WS_REQ" > $TMP/WS_REQ.out_$$
			_CATIA_LEVEL=$(grep niveau_catia $TMP/WS_REQ.out_$$ | $_AWK '{print $3}')
			_DATABASE_MODE=$(grep promo_flag $TMP/WS_REQ.out_$$ | $_AWK '{print $3}')
			[ -z "$_CATIA_LEVEL" ] && Out 3 "Cannot determine catia level in Adele database"
			[ -z "$_DATABASE_MODE" ] && Out 3 "Cannot determine development database mode in Adele database"

			_MAINTENANCE_OPTION=""
			if [ "$_CATIA_LEVEL" -eq 4 ]
			then
				if [ "$_DATABASE_MODE" = "dev" ] 
				then
					[ ! -z "$_CR_LIST" ] && Out 3 "The database $ADL_PROJET is in '$_DATABASE_MODE' mode. You cannot precise change request number ($_CR_LIST)."
				elif [ "$_DATABASE_MODE" = "maintenance" ]
				then
					[ -z "$_CR_LIST" ] && Out 3 "The database $ADL_PROJET is in '$_DATABASE_MODE' mode. You have to precise one change request number."
					NbCr=$(echo $_CR_LIST | $_AWK '{print NF}')
					[ "$NbCr" -ne 1 ] && Out 3 "The database $ADL_PROJET is in '$_DATABASE_MODE' mode. You have to precise ONLY one change request number."
					_MAINTENANCE_OPTION="-ri $_CR_LIST"
				else
					Out 3 "Unknown database mode $_DATABASE_MODE in Adele database $ADL_PROJET"
				fi
			elif [ "$_CATIA_LEVEL" -eq 5 ]
			then
				if [ "$_DATABASE_MODE" = "dev" ] 
				then
					A=A
					# On ne peut rien verifier
				elif [ "$_DATABASE_MODE" = "maintenance" ]
				then
					_MAINTENANCE_OPTION="-pu -down"
				elif [ "$_DATABASE_MODE" = "mixte" ]
				then
					A=A
					# On ne peut rien verifier
				else
					Out 3 "Unknown database mode $_DATABASE_MODE in Adele database $ADL_PROJET"
				fi
			else
				Out 3 "Unkonwn catia level in Adele database: $_CATIA_LEVEL"
			fi

			# Creation des options de la commande de promotion
			OPTIONS="$_MONOBASE $_MAINTENANCE_OPTION"
			Cmd="adl_promote $OPTIONS"
			echo "\n>>> $Cmd"
			#
			# attention aux conflits d'acces
			#
			compteur=0
			rc=207
			while [ $rc -eq 207 -a $compteur -lt 10 ]
			do
				#export I_ADL_OX_DEBUG=TRUE
				if [ ! -z "$_PROMOTED_FILE" ] 
				then 
					$Cmd <$NULL  > $_PROMOTED_FILE 2>&1
					rc=$?
					cat $_PROMOTED_FILE
				else
					$Cmd <$NULL
					rc=$?
				fi
				compteur=`expr $compteur + 1`
			done
		
			if [ $rc -ne 0 -a $rc -ne 2 ]
			then
				Out 3 "$Cmd KO"
			fi
		fi 
	fi 

	if [ ! -z "$_L_PROMOTE" ]
	then
        if [ "$type_de_ws" = "prj" -o "$type_de_ws" = "dev" ]
        then
			# Si on arrive ici et que rc = 0, on passe a la partie db2
			# si on est en maintenance, sinon, on fait rien de plus
			if [ "$_CATIA_LEVEL" -eq 5 -a ! -z "$_MAINTENANCE_OPTION" -a $rc -eq 0 ]
			then
				echo "    promote in Osirix"
				BaseMVS=MVSDB2
				DATABASE="osirix"
				PASS=adele
				USER_CON=adl
				. /u/db2client/sqllib/db2profile
				if [ $? -ne 0 ]
				then
					echo "problem with db2profile"
				fi
				#
				# Suivant les machines, qqfois des problemes de connexion DB2
				# apres des commandes ADELE, en refaisant les chlev et adl_ch_ws
				# ca remarche...
				#
				db2 "connect to $DATABASE user $USER_CON using $PASS"
				if [ $? -ne 0 ]
				then
					echo
					echo "---------------------------------------------------------------"
					echo "problem with db2 connect - Resetting path and trying again..."
					echo "Before:"
					echo "PATH = $PATH"
					echo "LIBPATH = $LIBPATH"
					echo "---------------------------------------------------------------"
					if [ -f ~adl/adl_profile ]
					then
						. ~adl/adl_profile <$NULL
					else
						. ~/.profile.save <$NULL
					fi
		
					chlev "$_L_PROJECT" $_LBASE <$NULL  || Out 3 "chlev $_RBASE KO"
					adl_ch_ws $_WS <$NULL || Out 3 "adl_ch_ws $_WS KO"
					unset ADL_W_BASE
		
					# Modif DST
					# Important car dans le cas par exemple de l'ADL_FR_CATIA=CGACXR1
					# le mkmk_profile plante et genere un probleme de PATH d'ou un pb a la conexion db2
					# ce qui suit regle le pb
					unset ADL_BLD_LEVEL
					. /u/users/bsfr/usr/tools/bin/mkmk_profile
		
					BaseMVS=MVSDB2
					DATABASE="osirix"
					PASS=adele
					USER_CON=adl
					. /u/db2client/sqllib/db2profile
		
					echo "After:"
					echo "PATH = $PATH"
					echo "LIBPATH = $LIBPATH"
					echo "---------------------------------------------------------------"
		
					# modif api le 24.11.99 correction du pb
					# file db2: symbol clp_api: referenced symbol not found
					# on fait unset LIBPATH , c'est le LIBPATH qui met la pagaille
					unset LIBPATH
		
					db2 "connect to $DATABASE user $USER_CON using $PASS"
					if [ $? -ne 0 ]
					then
						echo "problem with db2 connect"
					fi
				fi
		
				db2 "UPDATE $BaseMVS.GATBHIST SET BASE = '$_LBASE' , WORKSPACE = '$ADL_W_IDENT' WHERE BASE = '$_RBASE' AND WORKSPACE ^= 'BSF' AND ROLE_WORKSPACE = 'CERTIFIED'"
		
				rc=$?
		
				db2 "connect reset"
		
				if [ -f ~adl/adl_profile ]
				then
					. ~adl/adl_profile <$NULL
				else
					. ~/.profile.save <$NULL
				fi
		
				chlev "$_L_PROJECT" $_LBASE <$NULL  || Out 3 "chlev $_RBASE KO"
				adl_ch_ws $_WS <$NULL || Out 3 "adl_ch_ws $_WS KO"
		
				if [ $rc -eq 0 ]
				then
					echo "DB2 update OK"
					Out 0 "Promotion OK"
				else
					echo "DB2 update KO"
					Out 3 "Promotion OK but DB2 update KO"
				fi
				unset ADL_W_BASE
			else
				if [ $rc -eq 0 ]
				then
					Out 0 "Promotion OK"
				else
					Out 0 "OK: Nothing to promote"
				fi
			fi
		fi
	fi
	
elif [ $ADL_LEVEL = 5 ]
then
	# ----------------------------------------------------------------------
	# Adele version 5
	# ----------------------------------------------------------------------
	[ -z "$ADL_WS" ] && Out 3 "No current workspace has been found"

	if [ ! -z "$_L_WS_TREE" ]
	then
		OPTION_WS_TREE=" -tree $_L_WS_TREE"
	else
		OPTION_WS_TREE=""
	fi

	echo "____________________________________________________________"
	echo "$CurrentDate : Adele V5 flow commands on workspace $ADL_WS"

	if [ ! -z "$_L_PHOTO" ] || [ ! -z "$_L_COLLECT" ] || [ ! -z "$_L_SYNC" ] || [ ! -z "$_L_PUBLISH" ] || [ ! -z "$_L_PROMOTE" ]
	then
		Cmd="adl_photo $OPTION_WS_TREE"
		echo "\n>>> $Cmd"
		$Cmd <$NULL
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_photo KO - $rc"
	fi

	if [ ! -z "$_L_REFRESH" ]
	then
		Cmd="adl_refresh"
		echo "\n>>> $Cmd"
		$Cmd <$NULL
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_refresh KO - $rc"
	fi

	if [ ! -z "$_L_COLLECT" ]
	then
		Cmd="adl_collect $OPTION_WS_TREE"
		echo "\n>>> $Cmd"
		$Cmd <$NULL
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_collect KO - $rc"
	fi

	if [ ! -z "$_L_SYNC" ]
	then
		export ADL_BATCH=true
		OPTIONS="-no_manual_merge $OPTION_WS_TREE"
		Cmd="adl_sync $OPTIONS"
		echo "\n>>> $Cmd"
		$Cmd <$NULL
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_sync KO - $rc"
	fi

	if [ ! -z "$_L_LIST_MERGE" ]
	then
		Cmd="adl_ls_merge -program"
		echo "\n>>> $Cmd"
		$Cmd <$NULL >$TMP/LS_MERGE.out_$$ 2>&1
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_ls_merge KO - $rc"
		# on affiche le meme message qu'en adl3.2 -> c'est pour le programme appelant
		cat $TMP/LS_MERGE.out_$$ 2>&1
		[ $(wc -l $TMP/LS_MERGE.out_$$ | $_AWK '{print $1}') -eq 0 ] && echo "No manual merge to solve"
	fi

	if [ ! -z "$_L_SOLVE_MERGE" ]
	then
		Cmd="adl_solve_merge"
		echo "\n>>> $Cmd"
		# adl_solve_merge est une commande interactive
		$Cmd 
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_solve_merge KO - $rc"
	fi

	if [ ! -z "$_L_ATT_MOD" ]
	then
		Cmd="adl_attach -attached_fw_mod $OPTION_WS_TREE"
		echo "\n>>> $Cmd"
		$Cmd <$NULL
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_attach KO - $rc"
	fi

	if [ ! -z "$_L_PUBLISH" ] || [ ! -z "$_L_PROMOTE" ]
	then
		Cmd="adl_publish $OPTION_WS_TREE"
		echo "\n>>> $Cmd"
		$Cmd <$NULL
		rc=$?
		[ $rc -ne 0 ] && Out 3 "adl_publish KO - $rc"
	fi

	if [ ! -z "$_L_PROMOTE" ]
	then
		OPTIONS="$OPTION_WS_TREE"
		[ ! -z "$_CR_TRANSFER" ]    && OPTIONS="$OPTIONS -cr_transfer"
		[ ! -z "$_CR_LIST" ]        && OPTIONS="$OPTIONS -cr $_CR_LIST"
		[ ! -z "$_L_PROMOTE_LIST" ] && OPTIONS="$OPTIONS -to $_L_PROMOTE_LIST"
		Cmd="adl_promote -adm_no_check_caa_rules $OPTIONS"
		echo "\n>>> $Cmd"

		if [ -z "$_PROMOTED_FILE" ]
		then
			$Cmd <$NULL
			rc=$?
			[ $rc -ne 0 ] && Out 3 "adl_promote KO - $rc"
		else
			$Cmd <$NULL > $_PROMOTED_FILE 2>&1
			rc=$?
			cat $_PROMOTED_FILE
			[ $rc -ne 0 ] && Out 3 "adl_promote KO - $rc"
		fi
	fi

else
	# ----------------------------------------------------------------------
	# unknown Adele version
	# ----------------------------------------------------------------------
	Out 3 "Unknown ADL_LEVEL in $ShellName: $ADL_LEVEL"
fi

Out 0
