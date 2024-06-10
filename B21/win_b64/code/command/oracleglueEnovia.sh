#!/bin/ksh
# Copyright Dassault-systemes 2003
# 
# AUTHOR: DAR
# DATE:   08/2003
# Last Update: 22/01/2004
#              mise a jour CXR13
#
if [[ $DEBUG = "YES" ]] ; then
set -x
fi

#

rc=0 ; export rc
UseShell()
{
 printf "\n\n"
 printf "\t==========       oracleglueEnovia   UTILITY        ==========\n"
 printf "\tusage :  oracleglueEnovia.sh EnoviaInstallDirectory \n"
 printf "\t  ie: ./oracleglueEnovia.sh /usr/EnoviaCode/aix_a \n"
 printf "\t      ./oracleglueEnovia.sh /usr/EnoviaCode/solaris_a   \n"
 printf "\t=============================================================\n"
 exit 1
}
CheckPath ()
{
[[ $DEBUG = YES ]] && set -x
# $1 command to check in PATH
PathCmd=`whence $1`
if [[ -z $PathCmd ]] ; then
  printf "\n\n"
  printf "\tCheck Your PATH. The command $1 is  not found!\n"
  printf "\n\n"
  exit 4
fi
DirPathCmd=`dirname $PathCmd`
case $TypeHost in
   AIXv5) # vacpp
          if [[ `echo $DirPathCmd | grep -c vacpp` = "0" ]] ; then
               printf "\n\n"
               printf "\tVisual Age compilor not found!\n"
               printf "\tCheck your PATH.              \n"
               printf "\n"
               exit 4
          fi
          ;;
esac
#
} # end of CheckPath
#

CheckCompilator ()
{
[[ $DEBUG = YES ]] && set -x 
# $1 cc command
CompilCmd=`whence $1`
if [[ -z $CompilCmd ]] ; then
  printf "\n\n"
  printf "\tCheck Your PATH. Compilator command not found!\n"
  printf "\n\n"
  exit 4
fi
#
# show informations about compilator used
case $TypeHost in 
  SunOS) # compilator level
        CC -V ;;
  AIXv4|AIXv5) # compilator level
         echo Compilator $CompilCmd Used.  ;;
  HP-UX) aCC -V ;;
  *) 
        unset CompilCmd 
        ;;
esac
} # end of CheckCompilator
#
SetLibs ()
{
[[ $DEBUG = YES ]] && set -x 
case $OsType in
  SunOS)
     for line in `find $ORACLE_HOME/lib* -name libclntsh.so`
      do
        if [[ `file $line | grep -c '32-bit'` -eq 1 ]] ; then
          # lib 32 bit trouvee dans
            LibclntshDir=`dirname $line`
            export LibclntshDir=$LibclntshDir
            export LibclntshShortDir=`basename $LibclntshDir`
            return 0
        fi
      done
     #
     # no 32 bit version found
           export LibclntshDir=UNKNOWN
           return 1
           ;;
   AIX)
     for line in `find $ORACLE_HOME/lib* -name libclntsh.a`
      do
        A=`dirname $line`
        NbObjFound=`file $A/*.o | grep -c 'executable (RISC System/6000)' `
        echo NbObjFound=$NbObjFound
        if [[ $NbObjFound -gt 0 ]] ; then
          # lib 32 bit trouvee dans
            LibclntshDir=`dirname $line`
            export LibclntshDir=$LibclntshDir
            export LibclntshShortDir=`basename $LibclntshDir`
            return 0
        fi
      done
     #
     # no 32 bit version found
           export LibclntshDir=UNKNOWN
           return 1
           ;;
   HP-UX)
     for line in `find $ORACLE_HOME/lib* -name libclntsh.sl`
      do
#        NbObjFound=`file $line | grep -c 'PA-RISC1.1 shared library' `
        NbObjFound=`file $line |grep PA-RISC |  grep -c 'shared library' `
        echo NbObjFound=$NbObjFound
        if [[ $NbObjFound -gt 0 ]] ; then
          # lib 32 bit trouvee dans
            LibclntshDir=`dirname $line`
            export LibclntshDir=$LibclntshDir
            export LibclntshShortDir=`basename $LibclntshDir`
            return 0
        fi
      done
 
     #
     # no 32 bit version found
           export LibclntshDir=UNKNOWN
           return 1
           ;;
  IRIX|IRIX64)
     for line in `find $ORACLE_HOME/lib* -name libclntsh.so`
      do
        if [[ `file $line | grep -c 'ELF 32-bit'`  -eq 1 ]] ; then
          # lib 32 bit trouvee dans
            LibclntshDir=`dirname $line`
            export LibclntshDir=$LibclntshDir
            export LibclntshShortDir=`basename $LibclntshDir`
            return 0
        fi
      done
     #
     # no 32 bit version found
           export LibclntshDir=UNKNOWN
           return 1
           ;;

    *)   echo Operating system not supported. ;;
esac
} # end of SetLibs
#
#############
#############
rc=0 ; unset CompilCmd
# lib and lib32 definitions + PROC_MK setting
OsType=`uname`
LibclntshDir="" ; export LibclntshDir
LibclntshShortDir="lib" ; export LibclntshShortDir
#############
# check input
#############
if [ $# -ne 1 ] ; then
  UseShell 
fi
case $1 in 
  -*) UseShell ;;
esac
#############
TypeHost=$(uname -s)
if [[ $TypeHost = AIX ]] ;then
    VERSIONAIX=`uname -v`
    if [[ $VERSIONAIX = 4 ]] ;  then
        TypeHost=$TypeHost'v4'
    fi
    if [[ $VERSIONAIX = 5 ]] ;  then
        TypeHost=$TypeHost'v5'
    fi
fi
#CATEnvironment
if [[ -z $ORACLE_HOME ]] ; then
   echo "\n"UNIX variable \$ORACLE_HOME is not set.
   echo SET properly  ORACLE_HOME and rerun."\n"
   exit 4
fi
if [[ ! -d $ORACLE_HOME ]] ; then
   echo "\n"Directory \$ORACLE_HOME not found.
   echo SET properly  ORACLE_HOME and rerun."\n"
   exit 4
fi
if [[ -f $ORACLE_HOME/rdbms/demo/oratypes.h ]] ; then
   echo "\n"$ORACLE_HOME/rdbms/demo/oratypes.h FOUND "\n"
else
   echo "\n"\$ORACLE_HOME/rdbms/demo/oratypes.h Not FOUND
   echo SET ORACLE_HOME and rerun "\n"
   exit 4
fi
Vdate=`date +"%Y_%m_%d_%H_%M_%S"` 
# # # #
SetLibs
if [[ $? -ne 0 ]] ; then
  echo Problem while getting Oracle library definition
  exit 1
fi
# # # #
#
if [[ $OsType = AIX ]] ;  then
  export LIBPATH=$LibclntshDir:$LIBPATH
elif [[ $OsType = HP-UX ]] ; then
  export SHLIB_PATH=$LibclntshDir:$SHLIB_PATH
elif [[ $OsType = IRIX ]] ; then
  export LD_LIBRARY_PATH=$LibclntshDir:$LD_LIBRARY_PATH
elif [[ $OsType = IRIX64 ]] ; then
  export LD_LIBRARY_PATH=$LibclntshDir:$LD_LIBRARY_PATH
elif [[ $OsType = SunOS ]] ; then
  export LD_LIBRARY_PATH=$LibclntshDir:$LD_LIBRARY_PATH
fi
# # # #
obj=OracleGLUE
#oracle_lib_path=-L$ORACLE_HOME/lib
oracle_lib_path=-L$ORACLE_HOME/$LibclntshShortDir
oracle_lib=-lclntsh
oracle_include=" -I$ORACLE_HOME/rdbms/demo "
for i in `echo $ORACLE_HOME/*/public`
do
oracle_include=$oracle_include" -I"$i
done
#
# test input parameter
#
if [[ $# -ne 1 ]] ; then
   UseShell
fi
if [[ ! -d $1 ]] ; then
   printf "\n\n\tDirectory $1 NOT FOUND.\n"
   exit 4
else
  if [[ ! -d $1/code/command ]] ; then
    printf "\n\n\tDirectory $1/code/command NOT FOUND.\n"
    printf "\tCheck $1 value.\n"
    exit 4
  else
    CATEnvironment=$1
  fi
fi
racine=$CATEnvironment
sample=$CATEnvironment/code/command
cnext_lib=$racine/code/bin
# check cnext_lib write permission
touch $cnext_lib/.dardar 1>/dev/null 2>/dev/null
if [[ $? -ne 0 ]] ; then
   printf "\n\n\tYou do not have write permission in $cnext_lib directory.\n" 
   printf "\tChange directory ownership or be super user.\n" 
   printf "\tPress Enter to continue \c " 
   read AA
fi
rm -f $cnext_lib/.dardar
TEMPO=/tmp/$LOGNAME
if [[ ! -d $TEMPO ]] ;  then
   mkdir $TEMPO
else
   rm -f $TEMPO"/*"
fi

#=================== COMPIL AIX ========================
rm -f $TEMPO/"$obj".o

echo TypeHost=$TypeHost
if [[ $TypeHost = AIXv5 ]] ;        then
   CheckCompilator xlC
   $CompilCmd         -c $oracle_include -I$sample \
   -qnotempinc -O2 -D_LANGUAGE_CPLUSPLUS -D_oracle_XA -w -qnoeh -Q \
   -qtbtable=full -qhalt=e -D_AIX41  \
   $sample/"$obj".cpp  -o $TEMPO/"$obj".o
       rc=$?
   if [[ ! -f $TEMPO/"$obj".o ]] ; then
      printf "/n/n/tError while Compiling: lib"$obj".so Not created\n"
      exit 5
   fi
   lib_glue=lib"$obj".a

elif [ $TypeHost = AIX -o $TypeHost = AIXv4 ] ; then
   CheckCompilator xlC
   $CompilCmd -c -qnoeh -g -w -qnotempinc -qnoansialias -qtbtable=full -qhalt=e \
   -qlanglvl=noansifor  -qlanglvl=implicitint -qlanglvl=oldmath -qlanglvl=typedefclass \
   -qnamemangling=compat -qnokeyword=export -qnokeyword=_Thread \
   -D_oracle_XA -D_LANGUAGE_CPLUSPLUS -D_AIX_SOURCE -D_AIX41 -D_ENDIAN_BIG \
   $oracle_include -I$sample $sample/"$obj".cpp  -o $TEMPO/"$obj".o
   rc=$?
   if [ ! -f $TEMPO/"$obj".o ] ; then
      printf "/n/n/tError while Compiling: lib"$obj".so Not created\n"
      exit 5
   fi
   lib_glue=lib"$obj".a
#  $CompilCmd -c $oracle_include -I$sample \
#-qnotempinc -O2 -D_LANGUAGE_CPLUSPLUS -w -qnoeh -Q \
#  -qtbtable=full -qhalt=e -D_AIX41  \
#  $sample/"$obj".cpp  -o $TEMPO/"$obj".o
#=================== COMPIL HP ========================
elif [[ $TypeHost = HP-UX ]] ;        then
   aCC -c $oracle_include -I$sample  \
   -I/usr/include +inst_none   +O2 -D_oracle_XA -D_LANGUAGE_CPLUSPLUS \
   +p +DA1.1d +DS2.0a +Z -w  -D_hpux_a_SOURCE -D_HPUX_SOURCE \
   $sample/"$obj".cpp  -o $TEMPO/"$obj".o
   lib_glue=lib"$obj".sl
#=================== COMPIL IRIX ========================
elif [ $TypeHost = IRIX   -o  $TypeHost = IRIX64 ] ;       then
   CC -c   $oracle_include -I$sample  \
   -I/usr/include/CC -I/usr/include -ptnone -no_prelink  \
  -O3 -r10000 -D__INLINE_INTRINSICS -D_oracle_XA -D_LANGUAGE_CPLUSPLUS \
  -w -LANG:exceptions=OFF -OPT:got_call_conversion=OFF \
  -no_auto_include -mips3 -n32 -xansi -KPIC -D_IRIX_SOURCE -DIRIX_5_3 \
   $sample/"$obj".cpp -o $TEMPO/"$obj".o
   lib_glue=lib"$obj".so
#=================== COMPIL SUN ========================
elif [[ $TypeHost = SunOS ]] ;        then
   CheckCompilator CC
   $CompilCmd -c  -D_oracle_XA -D_LANGUAGE_CPLUSPLUS -D_SUNOS_SOURCE  \
   -D_LANGUAGE_CPLUSPLUS -D_SUNOS_SOURCE  \
   -features=%none,anachronisms,except,namespace,rtti -noex -g -w -mt\
   -xarch=v8plusa -xchip=ultra3 -KPIC -compat=4 -library=iostream -instances=global \
   $oracle_include -I$sample  \
   $sample/"$obj".cpp  -o $TEMPO/"$obj".o 
   rc=$?
   lib_glue=lib"$obj".so
fi
#=================== result tests ===================
if [[ $rc -ne 0 ]] ;  then
   if [[ ! -s $TEMPO/"$obj".o ]] ; then
     echo "\n\n\tLink Ko\n"
     printf "\tThe object file "$obj".o has not been created.!\n"
     exit 4
   else
     echo "\n\n\tWarnings while compiling.\n"
     printf "\tThe object file "$obj".o has been created.!\n"
   fi
else
   echo "Compilation Ok\n"
fi

#=================== LINK-EDIT AIX ========================
rc=0
if [[ $TypeHost = AIXv5 ]] ; then
   CheckPath makeC++SharedLib
   makeC++SharedLib -p10 -blibpath:/lib:/usr/lib \
   $TEMPO/"$obj".o -o $TEMPO/$lib_glue  \
   $oracle_lib_path $oracle_lib -bloadmap:$TEMPO/build
   rc=$?
elif [ $TypeHost = AIX -o $TypeHost = AIXv4 ] ; then
   CheckPath makeC++SharedLib
   makeC++SharedLib -p10 -blibpath:/lib:/usr/lib \
   $TEMPO/"$obj".o -o $TEMPO/$lib_glue  \
   $oracle_lib_path $oracle_lib -bloadmap:$TEMPO/build
   rc=$?
#=================== LINK-EDIT HP ========================
elif [[ $TypeHost = HP-UX ]] ; then
   aCC  -b -Wl,+h,libOracleGLUE.sl -Wl,+s +inst_none \
   -Wl,+vnocompatwarnings   +O2  -D_LANGUAGE_CPLUSPLUS \
   +p +DA1.1d +DS2.0a +Z -w  -D_hpux_a_SOURCE -D_HPUX_SOURCE \
   -L/usr/lib/Motif1.2_R6  \
  $TEMPO/"$obj".o $oracle_lib_path $oracle_lib \
			 -ldld -lc -o  $TEMPO/lib"$obj".sl 
     rc=$?
#=================== LINK-EDIT IRIX ========================
elif [ $TypeHost = IRIX -o $TypeHost = IRIX64 ] ; then
     CC  -default_delay_load -shared -no_unresolved -soname libOracleGLUE.so \
     -OPT:got_call_conversion=OFF -default_delay_load -multigot -ptnone \
     -Wf,-no_auto_instantiation -mips3 -Wl,-wall -Wl,-woff,47 \
     -Wl,-woff,133 -Wl,-woff,138 -Wl,-woff,15 -Wl,-woff,85 \
     -LANG:exceptions=OFF -Wl,-no_transitive_link   \
     $TEMPO/"$obj".o \
     $oracle_lib_path $oracle_lib \
    -lc -lm -Wl,-LD_MSG:error=157  \
	-o $TEMPO/$lib_glue
     rc=$?
#=================== LINK-EDIT SUN ========================
elif [[ $TypeHost = SunOS ]] ; then
#cxr13
        $CompilCmd -mt -Qoption CClink -Bsymbolic,-Bdirect,-zlazyload  -G -hlibOracleGLUE.so \
        -Qoption CClink -zmuldefs  -features=%none,anachronisms,except,namespace,rtti \
        -noex -g -w -mt -xarch=v8plusa -xchip=ultra3 -KPIC -compat=4  -library=iostream \
        -instances=global  \
         -D_LANGUAGE_CPLUSPLUS -D_SUNOS_SOURCE -D_ENDIAN_BIG -DOS_SunOS  \
        -norunpath  -R /usr/lib -Qoption CClink -znodefs \
        $TEMPO/"$obj".o \
        -L/usr/dt/lib -L/usr/openwin/lib -L/lib -L/usr/lib \
        $oracle_lib_path \
        -lM77 -lF77 -lclntsh -lsunmath -lm -lC  \
        -o $TEMPO/$lib_glue 
        rc=$?
fi

if [[ $rc -ne 0 ]] ;  then
   if [[ ! -s $TEMPO/$lib_glue ]] ; then
      echo "\n\n\tLink Ko\n"
     printf "\tThe library $lib_glue has not been created.!\n"
     exit 4
   else
     echo "\n\n\tWarnings while linking.\n"
     printf "\tThe library $lib_glue has been created.!\n"
   fi
else
   echo "Link Ok\n"
fi

if [[   -d $cnext_lib           ]] ; then
  if [[ -f $cnext_lib/$lib_glue ]] ; then
    if [[ ! -w $cnext_lib/$lib_glue ]] ; then
     printf "\n\n\tYou do not have write permission on Library $cnext_lib/$lib_glue !\n"
     printf "\tChange LIBRARY ownership or be super user.\n" 
     exit 1
    fi
  else
    touch $cnext_lib/$lib_glue
  fi
else
     printf "\n\n\tDirectory $cnext_lib does not exist! \n"
     exit 1
fi
mv_lib=$TEMPO/mv_oracleGLUE
mv $cnext_lib/$lib_glue $cnext_lib/"$lib_glue".$Vdate
if [ "$?" -eq 0 ] ; then
cp $TEMPO/$lib_glue $cnext_lib/$lib_glue 
rm $TEMPO/$lib_glue
rm $TEMPO/"$obj".o
else
   printf "\n\n\tYou do not have write permission to rename  $cnext_lib/$lib_glue !\n"
   printf "\tChange Directory LIBRARY ownership or be super user.\n"
   exit 1

fi
exit 0


