#!/bin/ksh

[ ! -z "$ADL_DEBUG" ] && set -x
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

CmdLine=$*
# =====================================================================
Usage="$ShellName -h

-h : to have this help


This script permit to install AdeleMultiSite product.
To run it, Adele product should be installed before.
Each question ask by this installer requires answer.
To abort this script, press CTL-C key.
"
# =====================================================================

# =====================================================================
# Out function
# =====================================================================
Out()
{
  #set -x
  trap ' ' HUP INT QUIT TERM
  ExitCode=$1
  shift
  if [ $# -ge 1 ]
  then
    echo "$*"
  fi

  exit $ExitCode
}

trap 'Out 9999 "Installation interrupted" ' HUP INT QUIT TERM
# =====================================================================
# Options treatment
# =====================================================================
unset _DOWNLOAD_DIR
unset _INSTALL_DIR
unset _LOG_DIR

while [ $# -ne 0 ]
do
  case "$1" in
    -h ) #-------------------> HELP NEEDED
      echo "$Usage"
      exit 0
      ;;
    -- ) shift $# #----------> On supprime le reste des arguments
      ;;
    * ) echo "Unknown option: $1" 1>&2
      Out 3 "$Usage"
      ;;
  esac
done


# ======================================================================
# Get OS version to install function
# ======================================================================
IsOSToInstall()
{
OS=$1
typeset -l1 rep
while [ -z "$rep" ]
do
  printf "Do you require an $OS version of AdeleMultiSite product : [y/n]"
  read rep
  if [ "$rep" = "y" ]
  then
    ReturnCode=1
  elif [ "$rep" = "n" ]
  then
    ReturnCode=0
  else
    echo "Unknown answer"
    unset rep
  fi
done
return $ReturnCode
}  
# ======================================================================
# Get all pathes
# ======================================================================

# Get Adele profile path
# ----------------------
while [ -z "$ADL_PROFILE_PATH" ]
do
  printf "Give the Adele V3 profile path of your Adele installation: "
  read ADL_PROFILE_PATH
  if [ ! -z "$ADL_PROFILE_PATH" ]
  then
    old_pwd=$(pwd)
    dir_profile=$(dirname $ADL_PROFILE_PATH)
    name_profile=$(basename $ADL_PROFILE_PATH)
    if [ -z "$dir_profile" ]
    then
      dir_profile="."
    fi
    eval cd $dir_profile
    if [ $? -eq 0 ]
    then
      dir_profile=$(pwd)
      ADL_PROFILE_PATH=$dir_profile/$name_profile
      if [ ! -x "$ADL_PROFILE_PATH" ]
      then
        printf "Cannot find executable file: $ADL_PROFILE_PATH\n\n"
        unset ADL_PROFILE_PATH
      fi
    else
      echo "Cannot change to directory containing : $ADL_PROFILE_PATH"
      unset ADL_PROFILE_PATH
    fi
    cd $old_pwd
  else
    echo "No data has been given"
    unset ADL_PROFILE_PATH
  fi
done

# Get download directory
# ----------------------
while [ -z "$_DOWNLOAD_DIR" ]
do
  printf "Give the directory where you have downloaded AdeleMultiSite product: "
  read _DOWNLOAD_DIR
  if [ ! -d "$_DOWNLOAD_DIR" ]
  then
    printf "Unknown directory: $_DOWNLOAD_DIR\n\n"
    unset _DOWNLOAD_DIR
  fi
  if [ ! -z "$_DOWNLOAD_DIR" ]
  then
    old_pwd=$(pwd)
    cd $_DOWNLOAD_DIR
    if [ $? -eq 0 ]
    then
      _DOWNLOAD_DIR=$(pwd)
    else
      echo "Cannot change to download directory: $_DOWNLOAD_DIR"
      unset _DOWNLOAD_DIR
    fi
    cd $old_pwd
  fi
done

# Get installation directory
# ----------------------
unset _EXISTING_PREVIOUS_INSTALL
while [ -z "$_INSTALL_DIR" ]
do
  printf "Give the directory where you want to install AdeleMultiSite product: "
  read _INSTALL_DIR
  if [ ! -d "$_INSTALL_DIR" ]
  then
    mkdir -p $_INSTALL_DIR
    if [ $? -ne 0 ]
    then
      printf "Cannot create directory: $_INSTALL_DIR\n\n"
      unset _INSTALL_DIR
    fi
  else
    _EXISTING_PREVIOUS_INSTALL=TRUE
    printf "A previous installation of AdeleMultiSite product has been detected. Only runtime objects will be copied. Your last AdeleMultiSite_profile won't be modified. A new virgin one will be copied in the same directory.\n"
  fi
  if [ ! -z "$_INSTALL_DIR" ]
  then
    old_pwd=$(pwd)
    cd $_INSTALL_DIR
    if [ $? -eq 0 ]
    then
      _INSTALL_DIR=$(pwd)
    else
      echo "Cannot change to installation directory: $_INSTALL_DIR"
      unset _INSTALL_DIR
    fi
    cd $old_pwd
  fi
done

# Get data transfer log directory
# --------------------------------
while [ -z "$_LOG_DIR" ]
do
  printf "Give the directory where you want to archive all AdeleMultiSite data transfers\nNote that all user run a data transfer will write a record in this file: "
  read _LOG_DIR
  if [ ! -d "$_LOG_DIR" ]
  then
    mkdir -p $_LOG_DIR
    if [ $? -ne 0 ]
    then
      printf "Cannot create directory: $_LOG_DIR\n\n"
      unset _LOG_DIR
    fi
  fi
  if [ ! -z "$_LOG_DIR" ]
  then
	chmod 777 $_LOG_DIR
    if [ $? -ne 0 ]
    then
      printf "Cannot change rights of directory: $_LOG_DIR  to authorize any user to write in it.\n\n"
      unset _LOG_DIR
    fi
  fi
done

# Get operating system list to install
# --------------------------------
unset _AIX_INSTALL
unset _SOLARIS_INSTALL
unset _HPUX_INSTALL
unset _IRIX_INSTALL

echo 
IsOSToInstall AIX
[ $? -eq 1 ] && _AIX_INSTALL=TRUE

IsOSToInstall SOLARIS
[ $? -eq 1 ] && _SOLARIS_INSTALL=TRUE

IsOSToInstall HPUX
[ $? -eq 1 ] && _HPUX_INSTALL=TRUE

IsOSToInstall IRIX
[ $? -eq 1 ] && _IRIX_INSTALL=TRUE

if [ -z "$_AIX_INSTALL" -a -z "$_SOLARIS_INSTALL" -a -z "$_HPUX_INSTAL" -a -z "$_IRIX_INSTALL" ]
then
  Out 3 "You have to choose at least one operating system to install.\nInstallation is aborted."
fi

# =====================================================================================
# CopyFile procedure
# =====================================================================================
CopyFile()
{
[ ! -z "$ADL_DEBUG" ] && set -x
	SourceFile=$1
	TargetFile=$2
	if [ ! -f $TargetFile ]
	then
		if [ ! -f $SourceFile ]
		then
			Out 5 "Cannot find $SourceFile"
		fi
		# Copy of $SourceFile
		cp -pf $SourceFile $TargetFile
		if [ $? -ne 0 ]
		then
			Out 5 "Cannot copy $SourceFile to $TargetFile"
		fi
	else
		Nb=$(find ${SourceFile%/*} -name ${SourceFile##*/} -newer $TargetFile | wc -l)
		if [ $Nb -ne 0 ]
		then
			cp -pf $SourceFile $TargetFile
			if [ $? -ne 0 ]
			then
				Out 5 "Cannot copy $SourceFile to $TargetFile"
			fi
		fi
	fi
}
# =====================================================================================
# CopyExtraFiles procedure
# =====================================================================================
CopyExtraFiles()
{
[ ! -z "$ADL_DEBUG" ] && set -x
	_LOCAL_DIR=$_INSTALL_DIR/local
	_ADL_TAR=$_LOCAL_DIR/adl_tar


	# Copy of adl_tar
	# -----------------
	if [ ! -d $_LOCAL_DIR ]
	then
		mkdir $_LOCAL_DIR
		if [ $? -ne 0 ]
		then
			Out 5 "Cannot create directory $_LOCAL_DIR"
		fi
	fi

	CopyFile $_INSTALL_DIR/$OS_INST/code/command/admin/adl_tar $_ADL_TAR
	
	# Copy of GNUtar
	# -----------------
	if [ ! -d $_LOCAL_DIR/$OS_VERSION ]
	then
		mkdir $_LOCAL_DIR/$OS_VERSION
		if [ $? -ne 0 ]
		then
			Out 5 "Cannot create directory $_LOCAL_DIR/$OS_VERSION"
		fi
	fi

	CopyFile $_INSTALL_DIR/$OS_INST/code/bin/GNUtar $_LOCAL_DIR/$OS_VERSION/GNUtar
}

# =====================================================================================
# Installation procedure
# =====================================================================================
echo "\nStart the installation phase."
echo "Adele V3 profile path                : $ADL_PROFILE_PATH"
echo "AdeleMultiSite downloaded directory  : $_DOWNLOAD_DIR"
echo "AdeleMultiSite installation directory: $_INSTALL_DIR"
echo "AdeleMultiSite log directory         : $_LOG_DIR"
unset FirstOS_INST

# Installation on AIX
# ------------------------
if [ ! -z "$_AIX_INSTALL" ]
then
  OS_VERSION=AIX
  OS_INST=aix_a
  [ -z "$FirstOS_INST" ] && FirstOS_INST=$OS_INST
  echo "\n>>> Installing $OS_VERSION version of AdeleMultiSite product"
  if [ ! -d $_DOWNLOAD_DIR/$OS_INST ] 
  then
    Out 3 "Cannot install $OS_VERSION version of AdeleMultiSite product. No directory found: $_DOWNLOAD_DIR/$OS_INST"
  fi 

  if [ -d "$_INSTALL_DIR/$OS_INST" ]
  then
    echo "Removing previous $OS_VERSION installation: $_INSTALL_DIR/$OS_INST"
    rm -rf $_INSTALL_DIR/$OS_INST
  fi

  cp -rp $_DOWNLOAD_DIR/$OS_INST $_INSTALL_DIR/$OS_INST
  rc=$?
  if [ $rc -ne 0 ]
  then
    Out 3 "Cannot copy $OS_VERSION version from $_DOWNLOAD_DIR/$OS_INST to $_INSTALL_DIR/$OS_INST.\nInstallation is not completed."
  fi

  # Copy of adl_tar and GNUtar
  CopyExtraFiles 

  echo "Installation of $OS_VERSION version of AdeleMultiSite product successfully completed"
fi

# Installation on SOLARIS
# ------------------------
if [ ! -z "$_SOLARIS_INSTALL" ]
then
  OS_VERSION=SunOS
  OS_INST=solaris_a
  [ -z "$FirstOS_INST" ] && FirstOS_INST=$OS_INST
  echo "\n>>> Installing $OS_VERSION version of AdeleMultiSite product"
  if [ ! -d $_DOWNLOAD_DIR/$OS_INST ] 
  then
    Out 3 "Cannot install $OS_VERSION version of AdeleMultiSite product. No directory found: $_DOWNLOAD_DIR/$OS_INST"
  fi 

  if [ -d "$_INSTALL_DIR/$OS_INST" ]
  then
    echo "Removing previous $OS_VERSION installation: $_INSTALL_DIR/$OS_INST"
    rm -rf $_INSTALL_DIR/$OS_INST
  fi

  cp -rp $_DOWNLOAD_DIR/$OS_INST $_INSTALL_DIR/$OS_INST
  rc=$?
  if [ $rc -ne 0 ]
  then
    Out 3 "Cannot copy $OS_VERSION version from $_DOWNLOAD_DIR/$OS_INST to $_INSTALL_DIR/$OS_INST.\nInstallation is not completed."
  fi

  # Copy of adl_tar and GNUtar
  CopyExtraFiles 

  echo "Installation of $OS_VERSION version of AdeleMultiSite product successfully completed"
fi

# Installation on HPUX
# ------------------------
if [ ! -z "$_HPUX_INSTALL" ]
then
  OS_VERSION=HP-UX
  case `uname -r|cut -c3-` in
  10.*)
      OS_INST=hpux_a
      ;;
  11.*)
      OS_INST=hpux_b
      ;;
  esac
  [ -z "$FirstOS_INST" ] && FirstOS_INST=$OS_INST
  echo "\n>>> Installing $OS_VERSION version of AdeleMultiSite product"
  if [ ! -d $_DOWNLOAD_DIR/$OS_INST ] 
  then
    Out 3 "Cannot install $OS_VERSION version of AdeleMultiSite product. No directory found: $_DOWNLOAD_DIR/$OS_INST"
  fi 

  if [ -d "$_INSTALL_DIR/$OS_INST" ]
  then
    echo "Removing previous $OS_VERSION installation: $_INSTALL_DIR/$OS_INST"
    rm -rf $_INSTALL_DIR/$OS_INST
  fi

  cp -rp $_DOWNLOAD_DIR/$OS_INST $_INSTALL_DIR/$OS_INST
  rc=$?
  if [ $rc -ne 0 ]
  then
    Out 3 "Cannot copy $OS_VERSION version from $_DOWNLOAD_DIR/$OS_INST to $_INSTALL_DIR/$OS_INST.\nInstallation is not completed."
  fi

  # Copy of adl_tar and GNUtar
  CopyExtraFiles 

  echo "Installation of $OS_VERSION version of AdeleMultiSite product successfully completed"
fi

# Installation on IRIX
# ------------------------
if [ ! -z "$_IRIX_INSTALL" ]
then
  OS_VERSION=IRIX
  OS_INST=irix_a
  [ -z "$FirstOS_INST" ] && FirstOS_INST=$OS_INST
  echo "\n>>> Installing $OS_VERSION version of AdeleMultiSite product"
  if [ ! -d $_DOWNLOAD_DIR/$OS_INST ] 
  then
    Out 3 "Cannot install $OS_VERSION version of AdeleMultiSite product. No directory found: $_DOWNLOAD_DIR/$OS_INST"
  fi 

  if [ -d "$_INSTALL_DIR/$OS_INST" ]
  then
    echo "Removing previous $OS_VERSION installation: $_INSTALL_DIR/$OS_INST"
    rm -rf $_INSTALL_DIR/$OS_INST
  fi

  cp -rp $_DOWNLOAD_DIR/$OS_INST $_INSTALL_DIR/$OS_INST
  rc=$?
  if [ $rc -ne 0 ]
  then
    Out 3 "Cannot copy $OS_VERSION version from $_DOWNLOAD_DIR/$OS_INST to $_INSTALL_DIR/$OS_INST.\nInstallation is not completed."
  fi

  # Copy of adl_tar and GNUtar
  CopyExtraFiles 

  echo "Installation of $OS_VERSION version of AdeleMultiSite product successfully completed"
fi

# Installation of the AdeleMultiSite_profile
# ------------------------------------------
echo "\n>>> Creation of the AdeleMultiSite_profile"
ADL_MTS_DEFAULT_PROFILE=AdeleMultiSite_profile
ADL_MTS_PROFILE=$ADL_MTS_DEFAULT_PROFILE
if [ -f "$_INSTALL_DIR/$ADL_MTS_DEFAULT_PROFILE" ]
then
  ADL_MTS_PROFILE=$ADL_MTS_DEFAULT_PROFILE.$(date +"%Y_%m_%d")
  echo "A previous AdeleMultiSite_profile has been detected.\nThe new one will be generated on file: $ADL_MTS_PROFILE.\nAfter the installation phase, please compare both profiles and modify current profile with differences." 
fi

SourceFile=$_DOWNLOAD_DIR/$FirstOS_INST/code/command/admin/$ADL_MTS_DEFAULT_PROFILE
TargetFile=$_INSTALL_DIR/$ADL_MTS_PROFILE
cp -p $SourceFile $TargetFile
rc=$?
if [ $rc -ne 0 ]
then
  Out 3 "Cannot copy $ADL_MTS_DEFAULT_PROFILE file from $SourceFile to $TargetFile.\nInstallation is not completed."
fi

# Change the rights of the profile
chmod 755 $TargetFile

# Set the Adele profile path 
sed "s:\#\&\#ADL_PROFILE_PATH\#\&\#:$ADL_PROFILE_PATH:" $TargetFile > $TargetFile.$$
if [ $? -ne 0 ]
then
  rm -f $TargetFile $TargetFile.$$
  Out 3 "Cannot customize $TargetFile file."
fi
mv $TargetFile.$$ $TargetFile

# Set AdeleMultiSite installation directory
sed "s:\#\&\#ADL_MULTISITE_INSTALL\#\&\#:$_INSTALL_DIR:" $TargetFile > $TargetFile.$$
if [ $? -ne 0 ]
then
  rm -f $TargetFile $TargetFile.$$
  Out 3 "Cannot customize $TargetFile file."
fi
mv $TargetFile.$$ $TargetFile

# Change the rights of the profile
chmod 755 $TargetFile

# Set AdeleMultiSite log directory
sed "s:\#\&\#ADL_MULTISITE_LOG_DIR\#\&\#:$_LOG_DIR:" $TargetFile > $TargetFile.$$
if [ $? -ne 0 ]
then
  rm -f $TargetFile $TargetFile.$$
  Out 3 "Cannot customize $TargetFile file."
fi
mv $TargetFile.$$ $TargetFile

echo "Installation of the $ADL_MTS_PROFILE file successfully completed."

# Installation of the AdeleMultiSite files
# ------------------------------------------
echo "\n>>> Copy of the AdeleMultiSite README files"
OLD_PWD=$(pwd)
cd $_DOWNLOAD_DIR
ls -1 README*.txt > /tmp/READMEList$$
ls -1 adl_report_* >> /tmp/READMEList$$
cd $OLD_PWD

while read fic
do
   cp -pf $_DOWNLOAD_DIR/$fic $_INSTALL_DIR/$fic
   rc=$?
   if [ $rc -ne 0 ]
   then
     Out 3 "Cannot copy $fic file from $_DOWNLOAD_DIR/$fic to $_INSTALL_DIR/$fic.\nInstallation is not completed."
   fi
done < /tmp/READMEList$$
\rm -f /tmp/READMEList$$

echo "Installation of README files of AdeleMultiSite product successfully completed"

# End of the installation
echo "\nAll installation steps have been successfully completed."
Out 0
