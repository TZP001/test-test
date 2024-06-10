#! /bin/ksh
# COPYRIGHT DASSAULT SYSTEMES 2001

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
    echo ' AEC BATCH MIGRATION of V4 Design Models'
    echo '    This batch program migrates V4 AEC design models.'
    echo ' '
    echo ' Usage:'
    echo ' '
    echo '    '$SHELLNAME' -h'
    echo '    '$SHELLNAME' [-env file -direnv dir] [-installdir dir]'
    echo ' '
    echo '    -h                : Print this help.'
    echo '    -env              : CATIAV5 Environment name.'
    echo '    -direnv           : Directory where the CATIAV5 environment file is stored.'
    echo '    -installdir dir   : CATIA installation directory.'
    echo ' '
    echo '    If the CATIA installation directory is not specified, the batch'
    echo '    assumes the directory is this where the batch is located.'
    echo '    It should be in CATIAInstallDir\intel_a\code\command.'
    echo ' '
    echo '    To migrate pipes and parametric piping parts, you must use a'
    echo '    customized Project file (e.g. Project.xml) in the directory '
    echo '    defined by the CATIA environment variable CATDisciplinePath.'
    echo '    A separate Project file with only the CATAecV4V5Migration'
    echo '    discipline (including its applications) is most common. The '
    echo '    project name should be specified in the AECMIGR_PROJECT '
    echo '    environment variable within this batch file.'
    echo ' '

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
# === Set the AECMIGR_PROJECT to your customized migration project name
set AECMIGR_PROJECT=Project
export CNEXTOUTPUT=CONSOLE

# ====================
# Analyse arguments...
# ====================

# Reset input to CNEXT
unset V5ENV 
unset V5ENVFILE 
unset V5DIRENV 
unset V5DIRENVPATH 

# Reset install directory variables
unset INSTALLDIR
unset INSTALLDIRFOUND

# Loop on arguments
NUMARGS=$#
let COUNTARGS=1

let INSTALLDIRFOUND=0

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
		    
				# Unexpected argument
				else

						# unexpected argument
						echo 'ERROR!! Unexpected argument '$1
						Help 1

				fi
			fi
		fi

    # Analyse Next argument
    shift
    let COUNTARGS=$COUNTARGS+1

done # End while


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


# ============
# Migration...
# ============

# Check all programs are available.
if [ ! -f $WSOSCODEBIN/setcatenv ]
then
    echo 'ERROR!! An executable for migration cannot be found!'
    Help 1
fi

if [ ! -f $WSOSCODEBIN/delcatenv ]
then
    echo 'ERROR!! An executable for migration cannot be found!'
    Help 1
fi

if [ ! -f $WSOSCODEBIN/CNEXT ]
then
    echo 'ERROR!! An executable for migration cannot be found!'
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

# Launch migration
# === The environment variable MIGRATION_MASTER_APPLI is set to AEC_MDLR
# === to cause the AEC style of migration to be executed.
export MIGRATION_MASTER_APPLI=AEC_MDLR
$WSOSCODEBIN/CNEXT $V5ENV $V5ENVFILE $V5DIRENV $V5DIRENVPATH -batch -e CATV4ToV5Migration 2>&1

# Delete CATIA environment
$WSOSCODEBIN/delcatenv


# ============
# Batch End...
# ============
BatchEnd $RC
