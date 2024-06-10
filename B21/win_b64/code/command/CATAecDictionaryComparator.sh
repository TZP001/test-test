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
    echo ' BATCH COMPARISON OF V4 TO V5 DATA DICTIONARIES'
    echo '    This batch program compares XML files containing data definitions'
    echo '    of V4 AEC objects and attributes and V5 AEC objects and attributes.'
    echo '    The comparison is used to build a mapping table from V4 data to V5'
    echo '    data, and the mapping table is considered when comparing the data'
    echo '    in order to find V4 data that does not correspond to V5 data and that'
    echo '    has not been explicitly excluded from the mapping. For non-mapped'
    echo '    objects or attributes, proposed mappings and V5 data definitions '
    echo '    are listed.'
    echo ' '
    echo ' Usage:'
    echo ' '
    echo '    '$SHELLNAME' -h'
    echo '    '$SHELLNAME' [-env file -direnv dir] [-installdir dir] -i V4Dict V5Dict -m MappingTable -o OutputFile'
    echo ' '
    echo '    -h                : Print this help.'
    echo '    -env              : CATIAV5 Environment name.'
    echo '    -direnv           : Directory where the CATIAV5 environment file is stored.'
    echo '    -installdir dir   : CATIA installation directory.'
    echo '    -i V4Dict V5Dict  : V4Dict is an XML file defining the V4 data.'
    echo '                        V5Dict is an XML file defining the V5 data.'
    echo '    -m MappingTable   : MappingTable is a csv (comma separated value)'
    echo '                        file defining the V4 to V5 data mappings.'
    echo '    -o OutputFile     : OutputFile defines the names of the files output'
    echo '                        by this program: the report (OutputFile.html),'
    echo '                        the proposed V5 Data additions (OutputFile.xml) and'
    echo '                        the proposed mapping table additions (OutputFile.csv).'
    echo ' '
    echo '    If the CATIA installation directory is not specified, the batch'
    echo '    assumes the directory is this where the batch is located.'
    echo '    It should be in CATIAInstallDir\intel_a\code\command.'
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

# Reset input to CNEXT
unset V5ENV 
unset V5ENVFILE 
unset V5DIRENV 
unset V5DIRENVPATH 

# Reset install directory variables
unset INSTALLDIR
unset INSTALLDIRFOUND

# Reset argument variables
unset V4DICTXML
unset V5DICTXML
unset DICTIONARIESFOUND
unset MAPPINGTABLE
unset MAPPINGTABLEFOUND
unset OUTFILE
unset OUTFILEFOUND

# Loop on arguments
NUMARGS=$#
let COUNTARGS=1

let INSTALLDIRFOUND=0
let DICTIONARIESFOUND=0
let MAPPINGTABLEFOUND=0
let OUTFILEFOUND=0

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
		    

				# Dictionary files option detected
				elif [ $1 = "-i" ]
				then

						# option already detected
						if [ $DICTIONARIESFOUND -eq 1 ]
						then
								echo 'ERROR!! -i option was specified more than once!'
								Help 1
						fi

						# get and check traces file
						shift
						let COUNTARGS=$COUNTARGS+1

						if [ $COUNTARGS+1 -gt $NUMARGS ]
						then
								echo 'ERROR!! -i option requires two file name arguments!'
								Help 1
						fi

						if [ -d $1 ]
						then
								echo 'ERROR!! -i option requires two file name arguments, not a directory!'
								Help 1
						fi

						if [ -d $2 ]
						then
								echo 'ERROR!! -i option requires two file name arguments, not a directory!'
								Help 1
						fi

						# Get traces file directory
						V4DICTXML=$1
						V5DICTXML=$2

						shift
						let COUNTARGS=$COUNTARGS+1

						let DICTIONARIESFOUND=1
		    
				# Mapping Table option detected
				elif [ $1 = "-m" ]
				then

						# option already detected
						if [ $MAPPINGTABLEFOUND -eq 1 ]
						then
								echo 'ERROR!! -m option was specified more than once!'
								Help 1
						fi

						# get and check mapping table file
						shift
						let COUNTARGS=$COUNTARGS+1

						if [ $COUNTARGS -gt $NUMARGS ]
						then
								echo 'ERROR!! -m option requires a file argument!'
								Help 1
						fi

						MAPPINGTABLE=$1
						let MAPPINGTABLEFOUND=1

				# Output file option detected
				elif [ $1 = "-o" ]
				then
						# option already detected
						if [ $OUTFILEFOUND -eq 1 ]
						then
								echo 'ERROR!! -o option was specified more than once!'
								Help 1
						fi

						# get and check mapping table file
						shift
						let COUNTARGS=$COUNTARGS+1

						if [ $COUNTARGS -gt $NUMARGS ]
						then
								echo 'ERROR!! -o option requires an output name argument!'
								Help 1
						fi

						OUTFILE=$1
						let OUTFILEFOUND=1

				# Argument should be a Product
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

if [ $DICTIONARIESFOUND -ne 1 ]
then
    echo 'ERROR!! Dictionary XML files were not specified!'
    Help 1
fi

if [ $MAPPINGTABLEFOUND -ne 1 ]
then
    echo 'ERROR!! Mapping Table file was not specified!'
    Help 1
fi

if [ $OUTFILEFOUND -ne 1 ]
then
    echo 'ERROR!! Output file name was not specified!'
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
# Comparator...
# =============

if [ ! -d $AECMIGR_DIRECTORYPATH ]
then
    export AECMIGR_DIRECTORYPATH=$INSTALLDIR/$OS/startup/EquipmentAndSystems/MigrationDirectory
fi

# Check all programs are available.
if [ ! -f $WSOSCODEBIN/setcatenv ]
then
    echo 'ERROR!! An executable for the comparator cannot be found!'
    Help 1
fi

if [ ! -f $WSOSCODEBIN/delcatenv ]
then
    echo 'ERROR!! An executable for the comparator cannot be found!'
    Help 1
fi

if [ ! -f $WSOSCODEBIN/CATAecDictionaryComparator ]
then
    echo 'ERROR!! An executable for the comparator cannot be found!'
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

# Launch the comparator
$WSOSCODEBIN/CATAecDictionaryComparator $V5ENV $V5ENVFILE $V5DIRENV $V5DIRENVPATH -i $V4DICTXML $V5DICTXML -m $MAPPINGTABLE -o $OUTFILE 2>&1

# Delete CATIA environment
$WSOSCODEBIN/delcatenv


# ============
# Batch End...
# ============
BatchEnd $RC
