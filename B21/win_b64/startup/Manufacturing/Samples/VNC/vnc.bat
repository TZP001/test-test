@echo off

rem #################################################################
rem 
rem             "vnc" Run Script 
rem 
rem  This script should be invoked to run "vnc". It
rem  sets the appropriate environment variables and
rem  then invokes the "vnc" executable either 
rem  directly or under a user specified debugger (if the 
rem  "-d" flag is used).
rem  
rem  Usage:
rem 
rem     vnc [-d debugger] [vnc_argument_list]
rem 
rem     Note: The -d option is not supported on Windows NT
rem 
rem #################################################################

SET DENEB_PRODUCT=vnc
@echo off

set DENEB_PATH=


if "%DENEB_PRODUCT%" == "" goto DENEB_PRODUCT_ERROR
if "%DENEB_PROD_DIR%" == "" set DENEB_PROD_DIR=%DENEB_PATH%\vmap
if "%TMPDIR%" == "" set TMPDIR=%TEMP%
if "%LM_LICENSE_FILE%" == "" set LM_LICENSE_FILE=%DENEB_PATH%\license\license.dat
if "%P_SCHEMA%" == "" set P_SCHEMA=%DENEB_PROD_DIR%\parasolid
if "%COP_CONFIG_LIB%" == "" set COP_CONFIG_LIB=%DENEB_PROD_DIR%\COP\

set VIEWER_LOC=C:\PROGRA~1\Netscape\Commun~1\Program\
set DENEB_DOC_VIEWER=%VIEWER_LOC%Netscape.exe %DENEB_PROD_DIR%\docs\%DENEB_PRODUCT%_HOME\HOMEPAGE.html
set DENEB_BIN_DIR=%DENEB_PROD_DIR%\bin

if "%TMPDIR%" == "" goto TMPDIR_ERROR
if not exist %TMPDIR% goto TMPDIR_ERROR
if not exist %LM_LICENSE_FILE% goto LICENSE_ERROR
if not exist %DENEB_BIN_DIR%\vmap.exe goto EXEC_NOT_FOUND

set OLD_PATH=%PATH%
set PATH=%DENEB_BIN_DIR%;%DENEB_PROD_DIR%\lib;%DENEB_PROD_DIR%\shlib\lib;%DENEB_PROD_DIR%\shlib\bin;%PATH%

rem Set up script for the UG direct server
if not exist %DENEB_PROD_DIR%\UG\UGDSetup.bat goto SKIP_UG
call %DENEB_PROD_DIR%\UG\UGDSetup.bat
:SKIP_UG

rem Set up script for the V5 direct server
if not exist %DENEB_PROD_DIR%\V5\V5setup.bat goto SKIP_V5
call %DENEB_PROD_DIR%\V5\V5setup.bat
:SKIP_V5

cd /d %DENEB_PROD_DIR%

rem start %DENEB_BIN_DIR%\vmap.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
%DENEB_BIN_DIR%\vmap.exe %1 %2 %3 %4 %5 %6 %7 %8 %9

rem Restore original path

set PATH=%OLD_PATH%
set OLD_PATH=
goto CLEAN_EXIT

:DENEB_PRODUCT_ERROR
@echo No DENEB_PRODUCT specified
goto ERROR_EXIT

:TMPDIR_ERROR
@echo Error using TMPDIR=%TMPDIR%
goto ERROR_EXIT

:LICENSE_ERROR
@echo Cannot find LM_LICENSE_FILE=%LM_LICENSE_FILE%
goto ERROR_EXIT

:EXEC_NOT_FOUND
@echo Cannot find %DENEB_BIN_DIR%\vmap.exe
goto ERROR_EXIT

:ERROR_EXIT
pause

:CLEAN_EXIT
