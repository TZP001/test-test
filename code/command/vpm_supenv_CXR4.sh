#! /bin/ksh
#
if [[ $TRACE_VPM -ge 1 ]]
   then  set -x
fi ;
# ------------------------------------------------
# initialization or retrieval of general variables
# ------------------------------------------------
# following environment variables can be set prior to mkodt execution
# (May 26th 1999 list)
#
#  ODT_ROOT    : root directory of VPM4 RunTimeView
#  ORACLE_HOME : Oracle environment
#  TNS_ADMIN   : Oracle environment
#  DATABASE_NAME : connection string
#  RDBMS       : DB2 (default) or ORACLE
#  ODT_DB_SETTINGS : for CATDbServer.CATSettings
#  ODT_VPM4Settings  (temporary) : for tacr user settings environment
#  
# ------------------------------------------------
# 28-oct-99: dmh: creation "officielle" en cxr4 
# ------------------------------------------------
#
# modif dmh 10/01/00####################################
#grep "SetOdtParam TYPE=RECORD" $SUBODT_PROGNAME >$MK_DEVNULL
#   if [  $? != 0 ]; then
#	if [ ! -z "$CATRECORDCAPTURE" -o ! -z "$CATRECORDREPLAY" ]; then
#     CATUserSettingPath="$ADL_ODT_TMP$MK_SEPARATOR$ADL_ODT_REC"
#	fi
#   else
#     CATUserSettingPath=""
#   fi
export FILE_ENV=YES
#verue rwn - centralisation input vault
if [ -z  "$CATDefaultVaultName" ]
then 
   export CATDefaultVaultName=VPM4DefaultVault

   case $OS in
   aix_a) export CATDefaultVaultHost=lemond ;;
   hpux_a) export CATDefaultVaultHost=alipacha ;;
   irix_a) export CATDefaultVaultHost=ndola ;;
   solaris_a) export CATDefaultVaultHost=poseidon ;;
   esac
   export CATVaultSecuredPath=/home/data/TestAutoCNext/VPM4Vault
   export CATVaultTmpPath=/u/lego/CXR4odt/VPM4Vault
fi

export WS=QWksMetierUser

#export VPM=$WSROOT/${MkmkOS_VAR}
export VPM=$(echo $WSROOT | sed 's/VPMJ/VPM/')/${MkmkOS_VAR}
##LIC_ROOT=$(dirname $WSROOT | sed 's/VPMJ/VPM/')
LIC_ROOT=/u/lego/CXR4rel

#ODT_VPM4Settings=${ODT_VPM4Settings:-/u/users/tacr/VPM4Settings}
#
if [ -z "$RDBMS" ]
then export RDBMS=DB2
fi
#
# modif dmh le 10/01/00 ########################
IFS=":" 
      for  s in $MKMK_LST_RTV
      do
	if [ -d  $s/${MkmkOS_VAR}/reffiles ]; then 
 	  if [ "$ODT_VPM4Settings" != "" ]; then 
		ODT_VPM4Settings=${ODT_VPM4Settings}:$s/${MkmkOS_VAR}/reffiles
	  else
		ODT_VPM4Settings=$s/${MkmkOS_VAR}/reffiles
	  fi
	  if [ -d  $s/${MkmkOS_VAR}/reffiles/ODT/${RDBMS}/${MkmkOS_VAR} ]; then
	    if [ "$ODT_VPM4SettingsRDBMS" != "" ]; then
		 ODT_VPM4SettingsRDBMS=${ODT_VPM4SettingsRDBMS}:$s/${MkmkOS_VAR}/reffiles/ODT/$RDBMS/${MkmkOS_VAR}
	    else
         ODT_VPM4SettingsRDBMS=$s/${MkmkOS_VAR}/reffiles/ODT/$RDBMS/${MkmkOS_VAR}
	    fi
      fi
	fi
      done
      unset IFS

# fin modif dmh le 10/01/00 #####################
#################################################
#DATABASE_NAME unified name db2/oracle for connection string 
#
if [ -z "$DATABASE_NAME" ] ; then
	case $MkmkOS_NAME in
 		"AIX" ) DATABASE_NAME=AIXVPM4 
  		;;
 		"SunOS" ) DATABASE_NAME=SUNVPM4
  		;;
 		"HP-UX" ) DATABASE_NAME=HPVPM4
  		;;
 		"IRIX" ) DATABASE_NAME=IRIXVPM4
  		;;
	esac
fi
export DATABASE_NAME

case $RDBMS in
 "DB2" ) # DB2 Environnement 

	DB2INSTANCE_HOME_DIR=~admclien/
	. $DB2INSTANCE_HOME_DIR/sqllib/db2profile
	export DB2DBDFT=$DATABASE_NAME
	export LIBPATH=$DB2INSTANCE_HOME_DIR/sqllib/lib:$LIBPATH
	export LD_LIBRARY_PATH=$DB2INSTANCE_HOME_DIR/sqllib/lib:$LD_LIBRARY_PATH
	export LD_LIBRARYN32_PATH=$LD_LIBRARYN32_PATH:$LD_LIBRARY_PATH:/opt/IBMdb2/V5.0/lib:/u/env/oracle/IRIX/lib
	export SHLIB_PATH=$DB2INSTANCE_HOME_DIR/sqllib/lib:$SHLIB_PATH
	;;

 "ORACLE" ) # Environnement Oracle

	export ORACLE_HOME=${ORACLE_HOME:-/u/env/oracle/${MkmkOS_NAME}}
	export TNS_ADMIN=${TNS_ADMIN:-${ORACLE_HOME}/network/admin}
	export PATH=$PATH:$ORACLE_HOME/bin
#	export LIBPATH=$ORACLE_HOME/lib:$LIBPATH
	export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
#	export SHLIB_PATH=$ORACLE_HOME/lib:$SHLIB_PATH
	;;
esac
export VpmLicense=InternalDS.prd

# abe
# ----- access to packaging/licensing -----
if [ -z "$CATICPath" ]
then
  export CATICPath=${WSROOT}/${MkmkOS_VAR}/code/productIC:${LIC_ROOT}/PACKAGINGBSF/${MkmkOS_VAR}/code/productIC:${LIC_ROOT}/CXR3/${MkmkOS_VAR}/code/productIC
else
  export CATICPath=$CATICPath:${LIC_ROOT}/PACKAGINGBSF/${MkmkOS_VAR}/code/productIC
fi

# ------------------------------------------------- Settings ++++++++
# for access to officially delivered ODT settings (SLD May 21st 1999)
#  (1) general purpose settings
#for dir in `echo $CATReffilesPath | tr ':' '  ' | awk '{ for (i=NF; i>0;i--) print $i"/ODT";} '` 
#do
#	if [ -d $dir ]; then
#		CATUserSettingPath=$dir:${CATUserSettingPath}
#	fi
#done 
#  (2) database connection settings = CATDbServers.CATSettings
#      please remind : those settings are database and system dependant 
#       for Suresnes implementation and thus delivered in different directories
#
#if [ -z "$ODT_DB_SETTINGS" ]; then
#	for dir in `echo $CATReffilesPath | tr ':' '  ' | awk '{ for (i=NF; i>0;i--) print $i"/ODT/";} '` 
#	do
#		if [ -d $dir${RDBMS}"/"${DATABASE_NAME} ]; then
#			CATUserSettingPath=$dir${RDBMS}"/"${DATABASE_NAME}:${CATUserSettingPath}
#		fi
#	done 
#else
#	CATUserSettingPath=$ODT_DB_SETTINGS:${CATUserSettingPath}
#fi
#
# jpa: pour que cela MARCHE ENFIN !
# jpa: Mais si je choppe celui qui change les settings ...
tmprep1=$(echo ${CATDictionaryPath}|sed "s:code/dictionary:reffiles/ODT/${RDBMS}/${DATABASE_NAME}:g")
tmprep2=$(echo ${CATDictionaryPath}|sed "s:code/dictionary:reffiles:g")

###########dmh le 10/01/00 ####################
 if [ ! -z "$CATRECORDCAPTURE" -o ! -z "$CATRECORDREPLAY" ]; then
   CATUserSettingPath="$ADL_ODT_TMP$MK_SEPARATOR$ADL_ODT_REC"
 export CATUserSettingPath=${CATUserSettingPath}:${ODT_VPM4SettingsRDBMS}:${ODT_VPM4Settings}
 else
   CATUserSettingPath=""
 export CATUserSettingPath=${ODT_VPM4SettingsRDBMS}:${ODT_VPM4Settings}
 fi
#fin ######dmh le 10/01/00 ####################

##export CATUserSettingPath=${tmprep1}:${tmprep2}
unset CATReferenceSettingPath
# ------------------------------------------------- Settings --------
#jpa+
# pour le single sign on (a decommenter quand READY!)
export CATDictionaryPath=$CATDictionaryPath:~tacr/VPM4Env/dictionary
#jpa-

if [ "$ODT_LOG_NAME" != "" ]; then
	export CATErrorLog=$ADL_ODT_OUT/${ODT_LOG_NAME}.CATErrorLog	
fi
#
if [ -z "$IT_CONFIG_PATH" ]; then
export IT_CONFIG_PATH=/u/users/tacr/VPM4Env/Orbix/${MkmkOS_VAR}
fi
unset FILE_ENV

