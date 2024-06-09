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
#  ODT_ROOT    : root directory of VPM2 RunTimeView
#  ORACLE_HOME : Oracle environment
#  TNS_ADMIN   : Oracle environment
#  DATABASE_NAME : connection string
#  RDBMS       : DB2 (default) or ORACLE
#  ODT_DB_SETTINGS : for CATDbServer.CATSettings
#  ODT_VPM2Settings  (temporary) : for tacr user settings environment
#  
# ------------------------------------------------
#
export VPM=${WSROOT}/${MkmkOS_VAR}
export WS=QWksMetierUser
#
ODT_ROOT=${ODT_ROOT:-/u/lego/VPM2rel}
ODT_VPM2Settings=${ODT_VPM2Settings:-/u/users/tacr/VPM2Settings}
#
if [ -z "$RDBMS" ]
then export RDBMS=DB2
fi
#
#DATABASE_NAME unified name db2/oracle for connection string 
#
if [ -z "$DATABASE_NAME" ] ; then
	case $MkmkOS_NAME in
 		"AIX" ) DATABASE_NAME=AIXVPM2 
  		;;
 		"SunOS" ) DATABASE_NAME=SUNVPM2
  		;;
 		"HP-UX" ) DATABASE_NAME=HPVPM2
  		;;
 		"IRIX" ) DATABASE_NAME=IRIXVPM2
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

# abe
# ----- access to packaging/licensing -----
if [ -z "$CATICPath" ]
then
  export CATICPath=${ODT_ROOT}/${MkmkOS_VAR}/code/productIC:${ODT_ROOT}/PACKAGINGBSF/${MkmkOS_VAR}/code/productIC:${ODT_ROOT}/INFRACXR2/${MkmkOS_VAR}/code/productIC
else
  CATICPath=$CATICPath:${ODT_ROOT}/PACKAGINGBSF/${MkmkOS_VAR}/code/productIC
fi

# ------------------------------------------------- Settings ++++++++
# for access to officially delivered ODT settings (SLD May 21st 1999)
#  (1) general purpose settings
for dir in `echo $CATReffilesPath | tr ':' '  ' | awk '{ for (i=NF; i>0;i--) print $i"/ODT";} '` 
do
	if [ -d $dir ]; then
		CATUserSettingPath=$dir:${CATUserSettingPath}
	fi
done 
#  (2) database connection settings = CATDbServers.CATSettings
#      please remind : those settings are database and system dependant 
#       for Suresnes implementation and thus delivered in different directories
#
if [ -z "$ODT_DB_SETTINGS" ]; then
	for dir in `echo $CATReffilesPath | tr ':' '  ' | awk '{ for (i=NF; i>0;i--) print $i"/ODT/";} '` 
	do
		if [ -d $dir${RDBMS}"/"${DATABASE_NAME} ]; then
			CATUserSettingPath=$dir${RDBMS}"/"${DATABASE_NAME}:${CATUserSettingPath}
		fi
	done 
else
	CATUserSettingPath=$ODT_DB_SETTINGS:${CATUserSettingPath}
fi
#
# references to tacr user environment to be removed after delivery of all Setting files
#  expected : week 99.21
export CATUserSettingPath=$CATUserSettingPath:$ODT_VPM2Settings/${RDBMS}/${DATABASE_NAME}:$ODT_VPM2Settings
#
# old version follows :
#export CATUserSettingPath=~tacr/VPM2Settings/${RDBMS}/${DATABASE_NAME}:~tacr/VPM2Settings:$CATUserSettingPath
#
export CATReferenceSettingPath=$CATUserSettingPath
# ------------------------------------------------- Settings --------
#jpa+
# pour le single sign on (a decommenter quand READY!)
## export CATDictionaryPath=$CATDictionaryPath:~tacr/VPM2Env/dictionary
#jpa-

if [ "$ODT_LOG_NAME" != "" ]; then
	export CATErrorLog=$ADL_ODT_OUT/${ODT_LOG_NAME}.CATErrorLog	
fi
#

if [ -z "$IT_CONFIG_PATH" ]; then
export IT_CONFIG_PATH=/u/users/tacr/VPM2Env/Orbix/${MkmkOS_VAR}
fi
