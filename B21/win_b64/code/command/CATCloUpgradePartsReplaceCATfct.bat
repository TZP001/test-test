@echo off

rem  COPYRIGHT DASSAULT SYSTEMES 2007

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
set INSTALLDIRFOUND=0

rem Reset product variables
set PARTDIR=
set PARTDIRFOUND=0
set PARTDIR2=

rem In Catfct variables
set INCATFCTOPT=""
set INCATFCT=""
set INCATFCTFOUND=0
set REPLACECATFCT=""
set REPLACECATFCTFOUND=0

set FILEMODE=""
set FILEMODEFOUND=
 
:ARGSLOOP
rem Help wanted
if (%1)==(-h) goto HELP
rem Check Cnext input
if (%1)==(-env) (
  set V5ENV=-env
  set V5ENVFILE=%2
  set V5ENVFILEFOUND=1 
  rem echo Here1 
  rem echo Here11
  SHIFT
  goto ANALARGSNEXT
)
rem echo Here2 
rem Check Cnext input
if (%1)==(-direnv) (
  set V5DIRENV=-direnv
  set V5DIRENVPATH=%2    
  rem echo Here3
  SHIFT  
  goto ANALARGSNEXT
)

rem Check for -InCATfct option
if (%1)==(-InCATfct) (
  set INCATFCTOPT=-InCATfct
  set INCATFCT=%2
  set INCATFCTFOUND=1  
  rem echo Here4
  echo Input CATfct is %2
  SHIFT  
  goto ANALARGSNEXT
)
rem echo Here5 
if (%PARTDIRFOUND%) == (1) goto REPLACECATFCTDATA

rem Install directory option detected
if NOT (%1)==(-installdir) goto NOTINSTALLDIR

  rem option already detected
  if NOT (%INSTALLDIRFOUND%)==(0) (
    echo ERROR!! -installdir option was specified more than once!
    goto HELP
  )
  rem echo Here4
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
  if (%1)==(-f) (
    set FILEMODE=%1
    set FILEMODEFOUND=1        
    rem echo Here6
    goto ANALARGSNEXT    
  )      
  rem echo Here7
  set PARTDIR=%1
  if %FILEMODE%=="" ( echo Input Directory is %PARTDIR% ) else ( echo Input File is %PARTDIR% )
  if NOT EXIST %2 (
    echo ERROR!! The Part Directory %2 was not found!
    goto HELP
  )
  set PARTDIRFOUND=1
  set PARTDIR2=%2      
  echo Output directory is %PARTDIR2%  
  SHIFT     
  goto ANALARGSNEXT
  
:REPLACECATFCTDATA
rem Analyse Replace CATFct
if (%1)==() goto ANALARGSEND

 set REPLACECATFCT=%1 
 set REPLACECATFCTFOUND=1
 echo Replace CATfct is %1   
 goto ANALARGSEND 
 
:ANALARGSNEXT
rem Analyse Next argument
SHIFT

goto ARGSLOOP

:ANALARGSEND


if %V5ENVFILEFOUND%==0 (
     echo ERROR!! No environment name is specified! Use the -env option.
     goto HELP
  )

if %REPLACECATFCTFOUND%==0 (
     echo ERROR!! No Replace CATfct is specified.
     goto HELP
  )


if %PARTDIRFOUND%==1 goto INSTALLATIONDIR

echo ERROR!! Part Directory Name was not specified!
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
%WSOSCODEBIN%\setcatenv.exe -e %V5ENVFILE%  

rem Launch part generation
rem if (%FILEMODEFOUND%) == (1) (
 %WSOSCODEBIN%\CNEXT.exe %V5ENV% %V5ENVFILE% %V5DIRENV% %V5DIRENVPATH% -batch -e CATCloUpgradePartsReplaceCATfct %FILEMODE% %PARTDIR% %PARTDIR2% %INCATFCTOPT%  %INCATFCT%  %REPLACECATFCT% 2>&1
rem ) else 
rem %WSOSCODEBIN%\CNEXT.exe %V5ENV% %V5ENVFILE% %V5DIRENV% %V5DIRENVPATH% -batch -e CATCloUpgradePartsReplaceCATfct %PARTDIR% %PARTDIR2%  %INCATFCTOPT% %INCATFCT%  %REPLACECATFCT% 2>&1


rem Delete CATIA environment
%WSOSCODEBIN%\delcatenv.exe -e %V5ENVFILE%  

goto END


rem =======
rem Help...
rem =======

:HELP
echo.
echo BATCH Program to upgrade existing Tubing part documents to re-link to a renamed CATfct.
echo.
echo Usage:
echo.
echo    %BATCHNAME% -h
echo    %BATCHNAME% -env file [-direnv dir] [-installdir dir] DirectoryPathIn DirectoryPathOut [-InCATfct OldCATfct] ReplaceCATfct
echo    %BATCHNAME% -env file [-direnv dir] [-installdir dir] -f FilePathIn DirectoryPathOut [-InCATfct OldCATfct]  ReplaceCATfct
echo.
echo    -h                : Print this help.
echo    -env fileName     : CATIAV5 Environment name
echo    -direnv  dir      : Directory where the CATIAV5 environment file is stored
echo    -installdir dir   : CATIA installation directory.
echo    -f                : Use the option to upgrade one part at a time
echo    FilePath          : full path name to the directory containing the  parts
echo    DirectoryPathIn   : Part Directory Path Name, full path name
echo                        to the directory containing the
echo                        parametric CATParts/CATShapes.
echo    DirectoryPathOut  : Part Directory Path Name, full path name
echo.     
echo   -InCATfct OldCATfct : Original link CATfct.   
echo   ReplaceCATfct	     : Catfct that will be used to replace existing catfct.
echo.     
echo.     
echo    If the CATIA installation directory is not specified, the batch
echo    assumes the directory is where the batch is located.
echo    It should be in installdir\intel_a\code\command.

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

set INCATFCTOPT=
set INCATFCT=
set INCATFCTFOUND=

set REPLACECATFCT=""
set REPLACECATFCTFOUND=
set FILEMODE=""
set FILEMODEFOUND=

set WSOSCODEBIN=

set CNEXTOUTPUT=
