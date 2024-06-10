#! /bin/ksh
# COPYRIGHT DASSAULT SYSTEMES 2003

# ============
# Functions...
# ============

# ============
# Batch End...
# ============
BatchEnd()
{
    # Reset variables
    unset SHELLNAME
    unset SYSTEMOS

    if [ $# -ne 0 ] && [ $1 -ne 0 ]
    then
        exit $1
    else
        exit 0
    fi
}

# =======
# Help...
# =======
Help()
{
    echo ' '
    echo ' BATCH GENERATION OF V5 Resolved Parts from V5 Parametric Parts'
    echo '    This batch program generates resolved V5 CATParts from'
    echo '    parametric V5 CATParts with a design table containing'
    echo '    part numbers and other parametric parameters.'
    echo '    Linked CATShapes, when applicable, are also generated.'
    echo ' '
    echo ' Usage:'
    echo ' '
    echo '    '$SHELLNAME' -h'
    echo '    '$SHELLNAME' [-env file -direnv dir] [-installdir dir] DirectoryPathIn [DirectoryPathOut -appl applname -replace -strip]'
    echo ' '
    echo '    -h                : Print this help.'
    echo '    -env              : CATIAV5 Environment name.'
    echo '    -direnv           : Directory where the CATIAV5 environment file is stored.'
    echo '    -installdir dir   : CATIA installation directory.'
    echo '    DirectoryPathIn   : Part Directory Path Name, full path name'
    echo '                        to the directory containing the'
    echo '                        parametric CATParts/CATShapes.'
    echo '    DirectoryPathOut  : Part Directory Path Name, full path name'
    echo '      (optional)        to the directory containing the generated'
    echo '                        resolved CATParts/CATShapes.'
    echo '    -appl applname    : Application name (e.g., -appl Structure,'
    echo '      (optional)        because structure parts have special handling).'
    echo '    -replace          : Replace option (existing parts in outpath'
    echo '      (optional)        will be replaced/overwritten).'
    echo '    -strip            : Strip option (generated resolved parts'
    echo '      (optional)        will be stripped of sketch constraints).'
    echo ' '
    echo '    If the CATIA installation directory is not specified, the batch'
    echo '    assumes the directory is where the batch is located.'
    echo '    It should be in installdir\intel_a\code\command.'

    if [ $# -ne 0 ] && [ $1 -ne 0 ]
    then
        BatchEnd $1
    else
        BatchEnd
    fi
}


# ===========
# Check OS...
# ===========
# Save program name
export SHELLNAME=$0
export SYSTEMOS=`uname`

case $SYSTEMOS in
    AIX) 
        OS=aix_a
        ;;
    SunOS)
        OS=solaris_a
        ;;
    HP-UX) 
        OS=hpux_b
        ;;
    IRIX64) 
        OS=irix_a
        ;;
    *)
        echo 'ERROR!! Unknown operating system!'
        Help 1
        ;;
esac


# ============================================
# Set environment variables used by program...
# ============================================
export CNEXTOUTPUT=CONSOLE

# ====================
# Analyse arguments...
# ====================
if [ $# -eq 0 ]
then
  echo 'ERROR!! Not enough arguments!'
  Help 1
fi

# Reset input to CNEXT
unset V5ENV 
unset V5ENVFILE 
unset V5DIRENV 
unset V5DIRENVPATH 

# Reset install directory variables
unset INSTALLDIR
unset INSTALLDIRFOUND

# Reset argument variables
unset PARTDIR
unset PARTDIRFOUND
unset PARTDIR2
unset APPL
unset APPLICATION
unset REPLACE
unset STRIP

# Loop on arguments
NUMARGS=$#
let COUNTARGS=1

let INSTALLDIRFOUND=0
let PARTDIRFOUND=0
APPL=
APPLICATION=
REPLACE=
STRIP=

while [ $COUNTARGS -le $NUMARGS ]
do
  # Help wanted
  if [ $1 = "-h" ] 
  then
      Help 0
  fi
  
  # CATIAV5 environment file 
  if [ $1 = "-env" ]
  then
    V5ENV=-env
    shift
    let COUNTARGS=$COUNTARGS+1
    if [ $COUNTARGS -gt $NUMARGS ]
    then
        echo 'ERROR!! -env option requires an argument!'
        Help 1
    fi
    V5ENVFILE=$1
    
  # Directory where the CATIAV5 environment file is stored
  else
    if [ $1 = "-direnv" ] 
    then
      V5DIRENV=-direnv
      shift
      let COUNTARGS=$COUNTARGS+1
      if [ $COUNTARGS -gt $NUMARGS ]
      then
          echo 'ERROR!! -direnv option requires an argument!'
          Help 1
      fi
      if [ ! -d $1 ]
      then
          echo 'ERROR!! CATIAV5 Environment directory was not found!'
          Help 1
      fi
      V5DIRENVPATH=$1
      
    else   
      # Install directory option detected
      if [ $1 = "-installdir" ]
      then

        # option already detected
        if [ $INSTALLDIRFOUND -eq 1 ]
        then
            echo 'ERROR!! -installdir option was specified more than once!'
            Help 1
        fi

        # get and check install dir
        shift
        let COUNTARGS=$COUNTARGS+1

        if [ $COUNTARGS -gt $NUMARGS ]
        then
            echo 'ERROR!! -installdir option requires a directory argument!'
            Help 1
        fi

        if [ ! -d $1 ]
        then
            echo 'ERROR!! Installation directory was not found!'
            Help 1
        fi
    
        INSTALLDIR=$1
        let INSTALLDIRFOUND=1
            
      # Argument may be the application name
      else
        if [ $1 = "-appl" ]
        then
           APPL=-appl
           shift
           let COUNTARGS=$COUNTARGS+1
           if [ $COUNTARGS -gt $NUMARGS ]
           then
               echo 'ERROR!! -appl option requires an argument!'
               Help 1
           fi
           APPLICATION=$1

        # Argument may be the replace option
        else
          if [ $1 = "-replace" ]
          then
             REPLACE=-replace
           
          # Argument may be the strip option
          else
            if [ $1 = "-strip" ]
            then
               STRIP=-strip

            # Argument is the part definition file
            else
              # option already detected
              if [ $PARTDIRFOUND -eq 1 ]
              then
                PARTDIR2=$1
              fi

              if [ ! -d $1 ]
              then
                echo 'ERROR!! The Part Directory was not found! '$1
                Help 1
              fi

              if [ $PARTDIRFOUND -eq 0 ]
              then
               PARTDIR=$1
               let PARTDIRFOUND=1
               PARTDIR2=
              fi
            fi
          fi
        fi
      fi
    fi
  fi

  # Analyse Next argument
  shift
  let COUNTARGS=$COUNTARGS+1

done # End while

if [ $PARTDIRFOUND -ne 1 ]
then
    echo 'ERROR!! The Part Directory was not specified!'
    Help 1
fi


# =========================
# Installation directory...
# =========================

if [ $INSTALLDIRFOUND -ne 1 ]
then
    # No installation directory given as argument.
    # We assume we are in the directory where the batch is.
    # (i.e. %INSTALLDIR%/$OS/code/command)

    # get install dir
    CURRENTDIR=`pwd`
    INSTALLDIR=${CURRENTDIR=%$OS/code/command}
fi

WSOSCODEBIN=$INSTALLDIR/$OS/code/bin
WSOSCODECMD=$INSTALLDIR/$OS/code/command


# ===================
# Set library path...
# ===================
export LIBPATH=$WSOSCODEBIN:$LIBPATH
export LD_LIBRARY_PATH=$WSOSCODEBIN:$LD_LIBRARY_PATH
export SHLIB_PATH=$WSOSCODEBIN:$SHLIB_PATH


# =============
# Generation...
# =============

# Check all programs are available.
if [ ! -f $WSOSCODEBIN/setcatenv ]
then
    echo 'ERROR!! An executable, setcatenv, cannot be found!'
    Help 1
fi

if [ ! -f $WSOSCODEBIN/delcatenv ]
then
    echo 'ERROR!! An executable, delcatenv, cannot be found!'
    Help 1
fi

if [ ! -f $WSOSCODEBIN/CNEXT ]
then
    echo 'ERROR!! An executable, CNEXT, cannot be found!'
    Help 1
fi

# Set CATIA environment
$WSOSCODEBIN/setcatenv
RC=$?

if [ $RC -ne 0 ]
then
    echo 'ERROR!! Cannot set CATIA environment!'
    BatchEnd $RC
fi

# Launch part generation
$WSOSCODEBIN/CNEXT $V5ENV $V5ENVFILE $V5DIRENV $V5DIRENVPATH -batch -e CATCloGenerateResolvedParts $PARTDIR $PARTDIR2 $APPL $APPLICATION $REPLACE $STRIP 2>&1

# Delete CATIA environment
$WSOSCODEBIN/delcatenv


# ============
# Batch End...
# ============
BatchEnd $RC
