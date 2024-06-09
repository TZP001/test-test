@if not DEFINED ADL_DEBUG @echo off
rem #########################################
rem # Graphic User Interface Initialisation #
rem #########################################

set rtcode=0
set ADL_PATH_SET=

rem # Get random number
if "%ADL_PATH%"=="" ( set ADL_PATH_SET=t)
set RANDOM_NUMBER=%RANDOM%

rem # What is the current mode ?
if not "%ADL_PATH%"=="" goto normal_mode

rem # mkrun, mkodt mode => CATInstallPath (concatenation)
set ADL_PATH=%~dp0\..\..
goto end_mode
	
:normal_mode
rem # Normal mode => ADL_PATH set(installation)
set CATDefaultEnvironment=
set CATEnvName=%ADL_PATH%\code\command\admin\SCMEnv.txt

:end_mode
rem # Is java available ?
if "%ADL_JAVA_ROOT_PATH%"=="" (
	echo #ERR# The environment variable ADL_JAVA_ROOT_PATH is not set. Please contact your SCM administrator
	set rtcode=5
	goto end
)

rem # Translation of ADL_JAVA_ROOT_PATH to its short name to solve Oracle Bug on WinXP 64 bits, when it contains a "(" character
if "%PROCESSOR_ARCHITEW6432%" == "AMD64" goto translation
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" goto translation
goto afterTranslation

:translation
call :TranslateToShortName ADL_JAVA_ROOT_PATH "%ADL_JAVA_ROOT_PATH%"
goto afterTranslation

:TranslateToShortName
set %1=%~s2
goto :eof

:afterTranslation
rem # Check java installation
set javaversiontmpfile=%ADL_TMP%\adl_java_version_%RANDOM_NUMBER%.txt
call "%ADL_JAVA_ROOT_PATH%\bin\java" -version >%javaversiontmpfile% 2>&1
if not "%ERRORLEVEL%" == "0" (
	echo #ERR# Java not found or bad installation. Check installation of java on current host.
	cat %javaversiontmpfile% 
	del /Q "%javaversiontmpfile%"
	set rtcode=5
	goto end
)

rem # Deleteing temporary file
del /Q "%javaversiontmpfile%"

rem # Common local environment
set PATH=%ADL_LIB_DBMS%;%ADL_PATH%\code\bin;%PATH%
set JAVA_HOME=%ADL_JAVA_ROOT_PATH%
set options=-ms128M -mx512M
rem # Set temporary output file (to be destroyed by the application itself)
set OutputTmpFile=%ADL_TMP%\adl_guis_tmp_%RANDOM_NUMBER%.txt

:end

exit /B %rtcode%
