#! /bin/ksh
# COPYRIGHT DASSAULT SYSTEMES 2002

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
    echo ' BATCH GENERATION OF V5 Catalog parts from part definition files'
    echo '    This batch program generates resolved V5 CATParts'
    echo '    from part definition files and template CATParts'
    echo ' '
    echo ' Usage:'
    echo ' '
    echo '    '$SHELLNAME' -h'
    echo '    '$SHELLNAME' [-installdir dir] PartDefinitionFile.xml'
    echo ' '
    echo '    -h                : Print this help.'
    echo '    -installdir dir   : CATIA installation directory.'
    echo '    PartDefinitionFile: Part definition file in directory'
    echo '                        PartGeneration\PartDefinitions within the'
    echo '                        migration directory specified by the'
    echo '                        AECMIGR_DIRECTORYPATH environment variable.'
    echo ' '
    echo '    If the CATIA installation directory is not specified, the batch'
    echo '    assumes the directory is this where the batch is located.'
    echo '    It should be in CATIAInstallDir\intel_a\code\command.'

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
# Save Program name
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
# === Set the AECMIGR_DIRECTORYPATH to your copy of the MigrationDirectory 
export AECMIGR_DIRECTORYPATH=/YourPath/MigrationDirectory
export CNEXTOUTPUT=CONSOLE

# ====================
# Analyse arguments...
# ====================
if [ $# -eq 0 ]
then
  echo 'ERROR!! Not enough arguments!'
  Help 1
fi

# Reset install directory variables
unset INSTALLDIR
unset INSTALLDIRFOUND

# Reset argument variables
unset PARTDEFFILE
unset PARTDEFFILEFOUND

# Loop on arguments
NUMARGS=$#
let COUNTARGS=1

let INSTALLDIRFOUND=0
let PARTDEFFILEFOUND=0

while [ $COUNTARGS -le $NUMARGS ]
do
    # Help wanted
    if [ $1 = "-h" ] 
    then
        Help 0
    fi

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
    
    # Argument is the part definition file
    else
        # option already detected
        if [ $PARTDEFFILEFOUND -eq 1 ]
        then
            # unexpected argument
            echo 'ERROR!! Unexpected argument '$1
            Help 1
        fi

        PARTDEFFILE=$1
        let PARTDEFFILEFOUND=1

    fi

    # Analyse Next argument
    shift
    let COUNTARGS=$COUNTARGS+1

done # End while

if [ $PARTDEFFILEFOUND -ne 1 ]
then
    echo 'ERROR!! Part definition file was not specified!'
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

if [ ! -d $AECMIGR_DIRECTORYPATH ]
then
    echo 'AEC Migration Directory='$AECMIGR_DIRECTORYPATH
    echo 'ERROR!! AEC Migration Directory was not found!'
    Help 1
fi

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
$WSOSCODEBIN/CNEXT -batch -e CATAecPartGeneration $PARTDEFFILE 2>&1

# Delete CATIA environment
$WSOSCODEBIN/delcatenv


# ============
# Batch End...
# ============
BatchEnd $RC
