@echo off

rem  COPYRIGHT DASSAULT SYSTEMES 2003

set CNEXTOUTPUT=CONSOLE

rem ====================
rem Analyse arguments...
rem ====================

rem Save program name
set BATCHNAME=%0

if (%1)==() (
  echo ERROR!! Part Directory Path Name not specified!
  goto HELP
)

rem input to CNEXT
set V5ENV=""
set V5ENVFILE=""
set V5ENVFILEFOUND=0
set V5DIRENV=""
set V5DIRENVPATH=""

rem Reset install directory variables
set INSTALLDIR=""
set SYSTEMOS=%OSDS%
if (%OSDS%)==() (
  set SYSTEMOS=intel_a
)
set INSTALLDIRFOUND=0

rem Reset product variables
set PARTDIR=
set PARTDIRFOUND=0
set PARTDIR2=

set APPL=
set APPLICATION=
set REPLACE=
set STRIP=
 
:ARGSLOOP
rem Help wanted
if (%1)==(-h) goto HELP

rem Check Cnext input
if (%1)==(-env) (
  set V5ENV=-env
  set V5ENVFILE=%2
  set V5ENVFILEFOUND=1
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

rem Check for Application input
if (%1)==(-appl) (
  set APPL=-appl
  set APPLICATION=%2
  SHIFT
  goto ANALARGSNEXT
)

rem Check for -replace option
if (%1)==(-replace) (
  set REPLACE=-replace
  goto ANALARGSNEXT
)

rem Check for -strip option
if (%1)==(-strip) (
  set STRIP=-strip
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


  set INSTALLDIR=%1\%SYSTEMOS%
  set INSTALLDIRFOUND=1

  goto ANALARGSNEXT

:NOTINSTALLDIR
rem No other argument
if (%1)==() goto ANALARGSEND

  if NOT EXIST %1 (
    echo ERROR!! The Part Directory %1 was not found!
    goto HELP
  )

  set PARTDIR2=%1
  if NOT (%PARTDIRFOUND%)==(0) (
    
    goto ANALARGSNEXT
  )

  set PARTDIR=%1
  set PARTDIRFOUND=1

  goto ANALARGSNEXT

:ANALARGSNEXT
rem Analyse Next argument
SHIFT

goto ARGSLOOP

:ANALARGSEND

if (%V5ENVFILEFOUND%)==(0) (
     echo ERROR!! No environment name is specified! Use the -env option.
     goto HELP
  )

if (%PARTDIRFOUND%)==(1) goto INSTALLATIONDIR

echo ERROR!! Part Directory Name was not specified!
goto HELP

rem =========================
rem Installation directory...
rem =========================
:INSTALLATIONDIR

if (%INSTALLDIRFOUND%)==(1) goto GENERATIONRUN

rem No installation directory given as argument.
rem We assume we are in the directory where the batch is.
rem (i.e. %INSTALLDIR%\%OSDS%\code\command)

rem get install dir
set INSTALLDIR=..\..

:GENERATIONRUN

set WSOSCODEBIN=%INSTALLDIR%\code\bin

rem =============
rem Generation...
rem =============

rem Check all programs are available.

if NOT EXIST %WSOSCODEBIN%\CNEXT.exe (
  echo ERROR!! An executable, CNEXT, cannot be found in %WSOSCODEBIN%
  goto HELP
)


rem Launch part generation
%WSOSCODEBIN%\CNEXT.exe %V5ENV% %V5ENVFILE% %V5DIRENV% %V5DIRENVPATH% -batch -e CATCloGenerateResolvedParts %PARTDIR% %PARTDIR2% %APPL% %APPLICATION% %REPLACE% %STRIP% 2>&1


goto END


rem =======
rem Help...
rem =======

:HELP
echo.
echo BATCH GENERATION OF V5 Resolved Parts from V5 Parametric Parts
echo    This batch program generates resolved V5 CATParts from
echo    parametric V5 CATParts with a design table containing 
echo    part numbers and other parametric parameters.
echo    Linked CATShapes, when applicable, are also generated.
echo.
echo Usage:
echo.
echo    %BATCHNAME% -h
echo    %BATCHNAME% -env file [-direnv dir] [-installdir dir] DirectoryPathIn [DirectoryPathOut -appl applname -replace -strip]
echo.
echo    -h                : Print this help.
echo    -env fileName     : CATIAV5 Environment name
echo    -direnv  dir      : Directory where the CATIAV5 environment file is stored
echo    -installdir dir   : CATIA installation directory.
echo    DirectoryPathIn   : Part Directory Path Name, full path name
echo                        to the directory containing the
echo                        parametric CATParts/CATShapes.
echo    DirectoryPathOut  : Part Directory Path Name, full path name
echo      (optional)        to the directory containing the generated
echo                        resolved CATParts/CATShapes.
echo    -appl applname    : Application name  (e.g., -appl Structure,
echo      (optional)        because structure parts have special handling).
echo    -replace          : Replace option (existing parts in outpath 
echo      (optional)        will be replaced/overwritten).
echo    -strip            : Strip option (generated resolved parts 
echo      (optional)        will be stripped of sketch constraints).
echo.
echo    If the CATIA installation directory is not specified, the batch
echo    assumes the directory is where the batch is located. The batch script
echo    should be in installdir\%OSDS%\code\command.

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

set PARTDIR=
set PARTDIRFOUND=
set PARTDIR2=

set APPL=
set APPLICATION=
set REPLACE=
set STRIP=

set WSOSCODEBIN=

set CNEXTOUTPUT=
set SYSTEMOS=
