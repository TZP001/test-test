#! /usr/bin/ksh

#18.03.2009 WIB => in process init

if [ "$DISABLE_BOOTSTRAPFILE" != "" ];then
	echo "## WARNING: DISABLE_BOOTSTRAPFILE is set"
fi

################################
# Create EnoviaIniDir in ADL_ODT_TMP
################################
export EnoviaIniDir=$ADL_ODT_TMP/ENOEnv
mkdir -p $EnoviaIniDir

################################
# Check Bootstrap file existence
################################
#Set BOOTFILE
export BOOTFILE=MATRIX-R
BootstrapDir=$VaultClient_PropertiesFilePath
BootstrapFile=$BootstrapDir/$BOOTFILE
if [ ! -e "$BootstrapFile" ];then
	echo "## ERROR: $VaultClient_PropertiesFilePath/$BOOTFILE not found"
	exit 45
fi

################################
#Set RDBMS environment
################################
if [ ! -e "$MkmkROOT_PATH/code/command/mkSetRDBMSEnv.sh" ];then
	echo "## ERROR: mkSetRDBMSEnv.sh not found in concatenation"
	exit 1
fi
. $MkmkROOT_PATH/code/command/mkSetRDBMSEnv.sh
if [ $? != 0 ];then
	echo "## ERROR during mkSetRDBMSEnv.sh"
	exit 1
fi

################################
# Generate MATRIX.ini
################################
#if [ ! -e "$MkmkROOT_PATH/resources/TestAuto/GenMatrixEnv.sh" ];then
#	echo "## ERROR: GenMatrixEnv.sh not found in concatenation"
#	exit 1
#fi
#. $MkmkROOT_PATH/resources/TestAuto/GenMatrixEnv.sh $EnoviaIniDir $BootstrapDir $JAVA_HOME

which ENOSetMatrixEnv > $ADL_ODT_NULL
if [ $? != 0 ];then
	echo "## ERROR: ENOSetMatrixEnv not found in concatenation"
	exit 45
fi

#echo "ENOSetMatrixEnv -matrix_home $BootstrapDir -java_home "$JavaROOT_PATH" -path $MKMK_LST_RTV -output_dir $EnoviaIniDir"
ENOSetMatrixEnv -matrix_home $BootstrapDir -java_home "$JavaROOT_PATH" -path $MKMK_LST_RTV -output_dir $EnoviaIniDir
if [ $? != 0 ];then
	echo "## ERROR during ENOSetMatrixEnv"
	exit 45
fi

################################
# Source mxSetEnv.sh
################################
if [ "$MkmkOS_Type" != "Windows" ];then
	if [ ! -e "$EnoviaIniDir/mxSetEnv.sh" ];then
		echo "## ERROR: mxSetEnv.sh not found in $EnoviaIniDir directory"
		exit 45
	fi
	. $EnoviaIniDir/mxSetEnv.sh

else
	if [ ! -e "$EnoviaIniDir/mxSetEnv.bat" ];then
		echo "## WARNING: mxSetEnv.bat not found in $EnoviaIniDir directory"
	else
		sed -e 's/^set /export /g' $EnoviaIniDir/mxSetEnv.bat | sed -e 's/^SET /export /g' | sed -e 's/\\/\\\\/g' > $EnoviaIniDir/_InternalMkodt_mxSetEnv.sh
		. $EnoviaIniDir/_InternalMkodt_mxSetEnv.sh
	fi
fi

################################
# Update Env (jvm.dll, etc...)
################################

# Verification que MkmkOS_Type n'est pas vide : 
if [ -z "$MkmkOS_Type" ];then
  echo "## ERROR : MkmkOS_Type is not set"
  exit 45    
fi
# Verification que MkmkOS_NAME n'est pas vide : 
if [ -z "$MkmkOS_NAME" ];then
  echo "## ERROR : MkmkOS_NAME is not set"
  exit 45    
fi

_JVMPathToExport=""
if [ "$MkmkOS_Buildtime" = "intel_a" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}bin${ADL_ODT_SLASH}client
fi				
if [ "$MkmkOS_Buildtime" = "win_b64" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}bin${ADL_ODT_SLASH}server
fi				
if [ "$MkmkOS_Buildtime" = "aix_a" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}jre${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}ppc${ADL_ODT_SLASH}j9vm
fi				
if [ "$MkmkOS_Buildtime" = "aix_a64" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}jre${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}ppc64${ADL_ODT_SLASH}j9vm
fi				
if [ "$MkmkOS_Buildtime" = "linux_a" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}i386${ADL_ODT_SLASH}server
fi	
if [ "$MkmkOS_Buildtime" = "linux_a64" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}amd64${ADL_ODT_SLASH}server
fi
if [ "$MkmkOS_Buildtime" = "linux_b" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}i386${ADL_ODT_SLASH}server
fi	
if [ "$MkmkOS_Buildtime" = "linux_b64" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}amd64${ADL_ODT_SLASH}server
fi
if [ "$MkmkOS_Buildtime" = "solaris_a" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}sparc${ADL_ODT_SLASH}server
fi	
if [ "$MkmkOS_Buildtime" = "solaris_b" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}i386${ADL_ODT_SLASH}server
fi
if [ "$MkmkOS_Buildtime" = "solaris_a64" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}sparcv9${ADL_ODT_SLASH}server
fi	
if [ "$MkmkOS_Buildtime" = "solaris_b64" ];then
	_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}amd64${ADL_ODT_SLASH}server
fi

##UNKNOWN OS
if [ "$_JVMPathToExport" = "" ];then
	echo "## WARNING: Can't set JVM Path ($MkmkOS_Buildtime OS not supported): please contact Tools support"

# Verification que MkmkOS_BitMode n'est pas vide : 
#	if [ -z "$MkmkOS_BitMode" ];then
#		echo "## ERROR : MkmkOS_BitMode is not set"
#		exit 45    
#	fi
#	if [ "$MkmkOS_Type" = "Windows" ];then
#		if [ "$MkmkOS_BitMode" = "32" ];then
#			_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}bin${ADL_ODT_SLASH}client
#		else
#			_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}bin${ADL_ODT_SLASH}server
#		fi
#	else
#		if [ "$MkmkOS_NAME" = "AIX" ];then
#			if [ "$MkmkOS_BitMode" = "32" ];then
#				_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}jre${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}ppc${ADL_ODT_SLASH}j9vm
#			else
#				_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}jre${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}ppc64${ADL_ODT_SLASH}j9vm
#			fi
#		elif [ "$MkmkOS_NAME" = "Linux" ];then
#			if [ "$MkmkOS_BitMode" = "32" ];then
#				_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}i386${ADL_ODT_SLASH}server
#			else
#				_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}amd64${ADL_ODT_SLASH}server
#			fi
#		elif [ "$MkmkOS_NAME" = "SunOS" ];then
#			proc_name=`uname -p`
#			_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}$(proc_name)${ADL_ODT_SLASH}server
#		else
#			if [ "$MkmkOS_BitMode" = "32" ];then
#				_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}i386${ADL_ODT_SLASH}server
#			else
#				_JVMPathToExport=${JAVA_HOME}${ADL_ODT_SLASH}lib${ADL_ODT_SLASH}amd64${ADL_ODT_SLASH}server
#			fi
#		fi
#	fi
fi

##CHECK JMV DIR EXISTENCE AND EXPORT
if [ -d "${_JVMPathToExport}" ];then
	if [ "$MkmkOS_Type" = "Windows" ];then
		\export PATH="${_JVMPathToExport}${ADL_ODT_SEPARATOR}${PATH}"
	else
		if [ "$MkmkOS_NAME" = "AIX" ];then
			\export LIBPATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${LIBPATH}
		elif [ "$MkmkOS_NAME" = "Linux" ];then
			\export LD_LIBRARY_PATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${LD_LIBRARY_PATH}
		elif [ "$MkmkOS_NAME" = "SunOS" ];then
			\export LD_LIBRARY_PATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${LD_LIBRARY_PATH}
		else
			\export LIBPATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${LIBPATH}		
			\export LD_LIBRARY_PATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${LD_LIBRARY_PATH}
			\export SHLIB_PATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${SHLIB_PATH}
			\export DYLD_LIBRARY_PATH=${_JVMPathToExport}${ADL_ODT_SEPARATOR}${DYLD_LIBRARY_PATH}
		fi
	fi
else
	echo "## WARNING: JVM directory $_JVMPathToExport directory not found: please check JRE existence in concatenation"
fi

return 0
