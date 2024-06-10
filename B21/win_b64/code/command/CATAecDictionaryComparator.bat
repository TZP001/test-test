@echo off

rem  COPYRIGHT DASSAULT SYSTEMES 2003

rem ============================================
rem Set environment variables used by program...
rem ============================================
rem === Set the AECMIGR_DIRECTORYPATH to your copy of the MigrationDirectory 
rem set AECMIGR_DIRECTORYPATH=\YourPath\MigrationDirectory
set CNEXTOUTPUT=CONSOLE

rem ====================
rem Analyse arguments...
rem ====================

rem Save Program name
set BATCHNAME=%0

rem input to CNEXT
set V5ENV=""
set V5ENVFILE=""
set V5DIRENV=""
set V5DIRENVPATH=""

rem Reset install directory variables
set INSTALLDIR=""
set INSTALLDIRFOUND=0

rem Reset argument variables
set V4DICTXML=""
set V5DICTXML=""
set DICTIONARIESFOUND=0
set MAPPINGTABLE=""
set MAPPINGTABLEFOUND=0
set OUTFILE=""
set OUTFILEFOUND=0

:ARGSLOOP
rem Help wanted
if (%1)==(-h) goto HELP

rem Check Cnext input
if (%1)==(-env) (
  set V5ENV=-env
  set V5ENVFILE=%2
  SHIFT
  goto ANALARGSNEXT
)

rem Check Cnext input
if (%1)==(-direnv) (
  set V5DIRENV=-direnv
  set V5DIRENVPATH=%2
  SHIFT
  goto ANALARGSNEXT
)

rem Install directory option detected
if NOT (%1)==(-installdir) goto NOTINSTALLDIR

  rem option already detected
  if NOT (%INSTALLDIRFOUND%)==(0) (
    echo ERROR!! -installdir option was specified more than once!
    goto HELP
  )

  rem get and check install dir
  SHIFT

  if (%1)==() (
    echo ERROR!! -installdir option requires a directory argument!
    goto HELP
  )
   
  if NOT EXIST %1\nul (
    echo ERROR!! Installation directory was not found!
    goto HELP
  )

  set INSTALLDIR=%1
  set INSTALLDIRFOUND=1

  goto ANALARGSNEXT

:NOTINSTALLDIR
rem Dictionary files option detected
if NOT (%1)==(-i) goto NOTDICTIONARIES

  rem option already detected
  if NOT (%DICTIONARIESFOUND%)==(0) (
    echo ERROR!! -i option was specified more than once!
    goto HELP
  )

  rem get and check dictionary XML file names
  SHIFT

  if (%1)==() (
    echo ERROR!! -i option requires two file name arguments!
    goto HELP
  )
   
  if EXIST %1\nul (
    echo ERROR!! -i option requires two file name arguments, not a directory!
    goto HELP
  )

  set V4DICTXML=%1

  SHIFT

  if (%1)==() (
    echo ERROR!! -i option requires two file name arguments!
    goto HELP
  )
   
  if EXIST %1\nul (
    echo ERROR!! -i option requires two file name arguments, not a directory!
    goto HELP
  )

  set V5DICTXML=%1

  set DICTIONARIESFOUND=1

  goto ANALARGSNEXT

:NOTDICTIONARIES
rem MappingTable file option detected
if NOT (%1)==(-m) goto NOTMAPPINGTABLEFILE

  rem option already detected
  if NOT (%MAPPINGTABLEFOUND%)==(0) (
    echo ERROR!! -traces option was already used!
    goto HELP
  )

  rem get and check traces file name
  SHIFT

  if (%1)==() (
    echo ERROR!! -m option requires a file name argument!
    goto HELP
  )
   
  if EXIST %1\nul (
    echo ERROR!! -m option requires a file name argument, not a directory!
    goto HELP
  )

  set MAPPINGTABLE=%1
  set MAPPINGTABLEFOUND=1

  goto ANALARGSNEXT

:NOTMAPPINGTABLEFILE
rem Output file option detected
if NOT (%1)==(-o) goto NOTOUTFILE

  rem option already detected
  if NOT (%OUTFILEFOUND%)==(0) (
    echo ERROR!! -o option was specified more than once!
    goto HELP
  )

  rem get and check mapping table file name
  SHIFT

  if (%1)==() (
    echo ERROR!! -o option requires a file name argument!
    goto HELP
  )
   
  set OUTFILE=%1
  set OUTFILEFOUND=1

  goto ANALARGSNEXT

:NOTOUTFILE
rem No other argument
if (%1)==() goto ANALARGSEND

  rem unrecognized argument
  echo ERROR!! Unexpected argument %1
  goto HELP

:ANALARGSNEXT
rem Analyse Next argument
SHIFT

goto ARGSLOOP

:ANALARGSEND

if (%DICTIONARIESFOUND%)==(0) (
  echo ERROR!! Dictionary XML files were not specified!
  goto HELP
)

if (%MAPPINGTABLEFOUND%)==(0) (
  echo ERROR!! Mapping Table file was not specified!
  goto HELP
)

if (%OUTFILEFOUND%)==(0) (
  echo ERROR!! Output file name was not specified!
  goto HELP
)

goto INSTALLATIONDIR

rem =========================
rem Installation directory...
rem =========================
:INSTALLATIONDIR

if (%INSTALLDIRFOUND%)==(1) goto MIGRATIONRUN

rem No installation directory given as argument.
rem We assume we are in the directory where the batch is.
rem (i.e. %INSTALLDIR%\intel_a\code\command)

rem get install dir
set INSTALLDIR=..\..\..

rem ============
rem Comparator...
rem ============
:MIGRATIONRUN

set WSOSCODEBIN=%INSTALLDIR%\intel_a\code\bin

if (%AECMIGR_DIRECTORYPATH%)==() (
  set AECMIGR_DIRECTORYPATH=%INSTALLDIR%\intel_a\startup\EquipmentAndSystems\MigrationDirectory
)

rem Check all programs are available.
if NOT EXIST %WSOSCODEBIN%\setcatenv.exe (
  echo ERROR!! An executable for migration cannot be found!
  goto HELP
)

if NOT EXIST %WSOSCODEBIN%\CATAecDictionaryComparator.exe (
  echo ERROR!! An executable for migration cannot be found!
  goto HELP
)

if NOT EXIST %WSOSCODEBIN%\delcatenv.exe (
  echo ERROR!! An executable for migration cannot be found!
  goto HELP
)

rem Set CATIA environment
%WSOSCODEBIN%\setcatenv.exe

rem Launch comparator
%WSOSCODEBIN%\CATAecDictionaryComparator.exe %V5ENV% %V5ENVFILE% %V5DIRENV% %V5DIRENVPATH% -i %V4DICTXML% %V5DICTXML% -m %MAPPINGTABLE% -o %OUTFILE% 2>&1

rem Delete CATIA environment
%WSOSCODEBIN%\delcatenv.exe

goto END


rem =======
rem Help...
rem =======

:HELP
echo.
echo BATCH COMPARISON OF V4 TO V5 DATA DICTIONARIES
echo    This batch program compares XML files containing data definitions
echo    of V4 AEC objects and attributes and V5 AEC objects and attributes.
echo    The comparison is used to build a mapping table from V4 data to V5
echo    data, and the mapping table is considered when comparing the data
echo    in order to find V4 data that does not correspond to V5 data and that
echo    has not been explicitly excluded from the mapping. For non-mapped
echo    objects or attributes, proposed mappings and V5 data definitions 
echo    are listed.
echo.
echo Usage:
echo.
echo    %BATCHNAME% -h
echo    %BATCHNAME% [-env file -direnv dir] [-installdir dir] -i V4Dict V5Dict -m MappingTable -o OutputFile
echo.
echo    -h                : Print this help.
echo    -env              : CATIAV5 Environment name
echo    -direnv           : Directory where the CATIAV5 environment file is stored
echo    -installdir dir   : CATIA installation directory.
echo    -i V4Dict V5Dict  : V4Dict is an XML file defining the V4 data.
echo                        V5Dict is an XML file defining the V5 data.
echo    -m MappingTable   : MappingTable is a csv (comma separated value)
echo                        file defining the V4 to V5 data mappings.
echo    -o OutputFile     : OutputFile defines the names of the files output
echo                        by this program: the report (OutputFile.html),
echo                        the proposed V5 Data additions (OutputFile.xml) and
echo                        the proposed mapping table additions (OutputFile.csv).
echo.
echo    If the CATIA installation directory is not specified, the batch
echo    assumes the directory is this where the batch is located.
echo    It should be in CATIAInstallDir\intel_a\code\command.

goto END


rem ============
rem Batch End...
rem ============

:END
rem Reset variables
set BATCHNAME=

set V5ENV=""
set V5ENVFILE=""
set V5DIRENV=""
set V5DIRENVPATH=""

set INSTALLDIR=
set INSTALLDIRFOUND=

set V4DICTXML=
set V5DICTXML=
set MAPPINGTABLE=
set OUTFILE=
set DICTIONARIESFOUND=
set MAPPINGTABLEFOUND=
set OUTFILEFOUND=

set WSOSCODEBIN=

rem set CNEXTOUTPUT=
set AECMIGR_DIRECTORYPATH=
