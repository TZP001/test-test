@echo off

rem  COPYRIGHT DASSAULT SYSTEMES 2001

rem ============================================
rem Set environment variables used by program...
rem ============================================
rem set AECMIGR_PROJECT=Project
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
   
  if NOT EXIST %1 (
    echo ERROR!! Installation directory was not found!
    goto HELP
  )

  set INSTALLDIR=%1
  set INSTALLDIRFOUND=1

  goto ANALARGSNEXT

:NOTINSTALLDIR
rem No other argument
if (%1)==() goto ANALARGSEND

:ANALARGSNEXT
rem Analyse Next argument
SHIFT

goto ARGSLOOP

:ANALARGSEND

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
rem === The environment variable MIGRATION_MASTER_APPLI is set to AEC_MDLR
rem === to cause the AEC style of migration to be executed.
set MIGRATION_MASTER_APPLI=AEC_MDLR
%WSOSCODEBIN%\CNEXT.exe %V5ENV% %V5ENVFILE% %V5DIRENV% %V5DIRENVPATH% -batch -e CATV4ToV5Migration 2>&1

rem Delete CATIA environment
%WSOSCODEBIN%\delcatenv.exe

goto END


rem =======
rem Help...
rem =======

:HELP
echo.
echo AEC BATCH MIGRATION of V4 Design Models
echo    This batch program migrates V4 AEC design models.
echo.
echo Usage:
echo.
echo    %BATCHNAME% -h
echo    %BATCHNAME% [-env file -direnv dir] [-installdir dir]
echo.
echo    -h                : Print this help.
echo    -env              : CATIAV5 Environment name
echo    -direnv           : Directory where the CATIAV5 environment file is stored
echo    -installdir dir   : CATIA installation directory.
echo.
echo    If the CATIA installation directory is not specified, the batch
echo    assumes the directory is this where the batch is located.
echo    It should be in CATIAInstallDir\intel_a\code\command.
echo
echo    To migrate pipes and parametric piping parts, you must use a
echo    customized Project file (e.g. Project.xml) in the directory 
echo    defined by the CATIA environment variable CATDisciplinePath.
echo    A separate Project file with only the CATAecV4V5Migration
echo    discipline (including its applications) is most common. The 
echo    project name should be specified in the AECMIGR_PROJECT 
echo    environment variable within this batch file.
echo.

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

set WSOSCODEBIN=

set CNEXTOUTPUT=
set AECMIGR_DIRECTORYPATH=
set AECMIGR_PROJECT=
