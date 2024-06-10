@echo off

rem  COPYRIGHT DASSAULT SYSTEMES 2002

rem ============================================
rem Set environment variables used by program...
rem ============================================
rem === Set the AECMIGR_DIRECTORYPATH to your copy of the MigrationDirectory 
set AECMIGR_DIRECTORYPATH=\YourPath\MigrationDirectory
set CNEXTOUTPUT=CONSOLE

if NOT EXIST %AECMIGR_DIRECTORYPATH%\nul (
  echo AECMIGR_DIRECTORYPATH=%AECMIGR_DIRECTORYPATH%
  echo ERROR!! AEC Migration Directory was not found!
  goto HELP
)

rem ====================
rem Analyse arguments...
rem ====================

rem Save Program name
set BATCHNAME=%0

if (%1)==() (
  echo ERROR!! Part Definition File not specified!
  goto HELP
)

rem Reset install directory variables
set INSTALLDIR=""
set INSTALLDIRFOUND=0

rem Reset product variables
set PARTDEFFILE=""
set PARTDEFFILEFOUND=0

:ARGSLOOP
rem Help wanted
if (%1)==(-h) goto HELP

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

  rem argument should be a model
  rem option already detected
  if NOT (%PARTDEFFILEFOUND%)==(0) (
    echo Part Definition File=%PARTDEFFILE%
    echo ERROR!! The Part Definition File was specified more than once!
    goto HELP
  )

  set PARTDEFFILE=%1
  set PARTDEFFILEFOUND=1

  goto ANALARGSNEXT

:ANALARGSNEXT
rem Analyse Next argument
SHIFT

goto ARGSLOOP

:ANALARGSEND

if (%PARTDEFFILEFOUND%)==(1) goto INSTALLATIONDIR

echo ERROR!! Part Definition File was not specified!
goto HELP

rem =========================
rem Installation directory...
rem =========================
:INSTALLATIONDIR

if (%INSTALLDIRFOUND%)==(1) goto GENERATIONRUN

rem No installation directory given as argument.
rem We assume we are in the directory where the batch is.
rem (i.e. %INSTALLDIR%\intel_a\code\command)

rem get install dir
set INSTALLDIR=..\..\..

:GENERATIONRUN

set WSOSCODEBIN=%INSTALLDIR%\intel_a\code\bin

if (%AECMIGR_DIRECTORYPATH%)==() (
  set AECMIGR_DIRECTORYPATH=%INSTALLDIR%\intel_a\startup\EquipmentAndSystems\MigrationDirectory
)


rem =============
rem Generation...
rem =============

rem Check all programs are available.
if NOT EXIST %WSOSCODEBIN%\setcatenv.exe (
  echo ERROR!! An executable, setcatenv, cannot be found!
  goto HELP
)

if NOT EXIST %WSOSCODEBIN%\CNEXT.exe (
  echo ERROR!! An executable, CNEXT, cannot be found!
  goto HELP
)

if NOT EXIST %WSOSCODEBIN%\delcatenv.exe (
  echo ERROR!! An executable, delcatenv, cannot be found!
  goto HELP
)

rem Set CATIA environment
%WSOSCODEBIN%\setcatenv.exe

rem Launch part generation
%WSOSCODEBIN%\CNEXT.exe -batch -e CATAecPartGeneration %PARTDEFFILE% 2>&1

rem Delete CATIA environment
%WSOSCODEBIN%\delcatenv.exe

goto END


rem =======
rem Help...
rem =======

:HELP
echo.
echo BATCH GENERATION OF V5 Catalog Parts from Part Definition Files
echo    This batch program generates resolved V5 parts
echo    by using template CATParts and xml part definition files
echo.
echo Usage:
echo.
echo    %BATCHNAME% -h
echo    %BATCHNAME% [-installdir dir] PartDefinitionFile.xml
echo.
echo    -h                : Print this help.
echo    -installdir dir   : CATIA installation directory.
echo    PartDefinitionFile: Part Definition File, an xml file.
echo                        Should reside in directory 
echo                        PartGeneration\PartDefinitions within the
echo                        migration directory specified by the
echo                        AECMIGR_DIRECTORYPATH environment variable.
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

set INSTALLDIR=
set INSTALLDIRFOUND=

set PARTDEFFILE=
set PARTDEFFILEFOUND=

set WSOSCODEBIN=

set CNEXTOUTPUT=
set AECMIGR_DIRECTORYPATH=
