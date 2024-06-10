@echo off

rem  COPYRIGHT DASSAULT SYSTEMES 2001

rem ============================================
rem Set environment variables used by program...
rem ============================================
rem === Set the AECMIGR_DIRECTORYPATH to your copy of the MigrationDirectory 
rem set AECMIGR_DIRECTORYPATH=\YourPath\MigrationDirectory
set CNEXTOUTPUT=CONSOLE
rem set CNEXTOUTPUT=TraceOfCATAecV4ToV5PipingTables.txt

rem ====================
rem Analyse arguments...
rem ====================

rem Save Program name
set BATCHNAME=%0

if (%1)==() (
  echo ERROR!! V4 Table List not specified!
  goto HELP
)

rem input to CNEXT
set V5ENV=""
set V5ENVFILE=""
set V5DIRENV=""
set V5DIRENVPATH=""

rem Reset install directory variables
set INSTALLDIR=""
set INSTALLDIRFOUND=0

rem Reset product variables
set TABLELIST=""
set TABLELISTFOUND=0

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
rem No other argument
if (%1)==() goto ANALARGSEND

  rem argument should be a file
  rem option already detected
  if NOT (%TABLELISTFOUND%)==(0) (
    echo ERROR!! The V4 Table List was specified more than once!
    goto HELP
  )

  set TABLELIST=%1
  set TABLELISTFOUND=1

  goto ANALARGSNEXT

:ANALARGSNEXT
rem Analyse Next argument
SHIFT

goto ARGSLOOP

:ANALARGSEND

if (%TABLELISTFOUND%)==(1) goto INSTALLATIONDIR

echo ERROR!! V4 Table List was not specified!
goto HELP

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

:MIGRATIONRUN

set WSOSCODEBIN=%INSTALLDIR%\intel_a\code\bin

if (%AECMIGR_DIRECTORYPATH%)==() (
  set AECMIGR_DIRECTORYPATH=%INSTALLDIR%\intel_a\startup\EquipmentAndSystems\MigrationDirectory
)


rem ============
rem Migration...
rem ============

rem Check all programs are available.
if NOT EXIST %WSOSCODEBIN%\setcatenv.exe (
  echo ERROR!! An executable for migration cannot be found!
  goto HELP
)

if NOT EXIST %WSOSCODEBIN%\CNEXT.exe (
  echo ERROR!! An executable for migration cannot be found!
  goto HELP
)

if NOT EXIST %WSOSCODEBIN%\delcatenv.exe (
  echo ERROR!! An executable for migration cannot be found!
  goto HELP
)

rem Set CATIA environment
%WSOSCODEBIN%\setcatenv.exe

rem Launch migration
%WSOSCODEBIN%\CNEXT.exe %V5ENV% %V5ENVFILE% %V5DIRENV% %V5DIRENVPATH% -batch -e CATAecV4ToV5PipingTables %TABLELIST% ALL ASTL 2>&1

echo Read trace file in %CNEXTOUTPUT%

rem Delete CATIA environment
%WSOSCODEBIN%\delcatenv.exe

goto END


rem =======
rem Help...
rem =======

:HELP
echo.
echo BATCH MIGRATION OF V4 Piping Setup tables to V5
echo    This batch program migrates V4 piping setup tables.
echo.
echo Usage:
echo.
echo    %BATCHNAME% -h
echo    %BATCHNAME% [-env file -direnv dir] [-installdir dir] V4TableList
echo.
echo    -h                : Print this help.
echo    -env              : CATIAV5 Environment name
echo    -direnv           : Directory where the CATIAV5 environment file is stored
echo    -installdir dir   : CATIA installation directory.
echo    V4TableList       : File containing a lsit of V4 Tables to be
echo                        migrated to V5 tables. 
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

set TABLELIST=
set TABLELISTFOUND=

set WSOSCODEBIN=

rem set CNEXTOUTPUT=
set AECMIGR_DIRECTORYPATH=
