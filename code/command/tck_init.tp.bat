@echo off
rem ======================================= 
if defined TCK_ROOT_PATH @call "%TCK_ROOT_PATH%\TCK\command\tck_unset.bat" >NUL 2>&1
rem ======================================= 
set TOOLSROOTPATHFULL=to_be_substituted
set TOOLSROOTPATH=to_be_substituted
rem == Name of the host where the TCK server is running 
set TCK_SERVER=to_be_set_manually
rem ======================================= 
set TCK_INSTALL_PATH=-
set TCK_INSTALL_PATH=
set TCK_ROOT_PATH=-
set TCK_ROOT_PATH=
set TCK_SERVER_PORT=-
set TCK_SERVER_PORT=
set TCK_NO_SERVER=-
set TCK_NO_SERVER=
rem ======================================= 
rem if not "%USERDOMAIN%"=="DS_DEV" set TCK_NO_SERVER=true
rem if not "%USERDOMAIN%"=="DS" set TCK_NO_SERVER=true
rem ======================================= 
rem == Path to local TCK information directory
set TCK_LOCAL_INFO=C:\Program Files
if DEFINED ProgramFiles set TCK_LOCAL_INFO=%ProgramFiles%
rem ======================================= 
set tckOFFICIAL_PATH=%TOOLSROOTPATHFULL%
rem ======================================= 
rem == Get windows Version numbers
for /f "tokens=2 delims=[]" %%G in ('ver') Do (set _version=%%G) 
for /f "tokens=2,3,4 delims=. " %%G in ('echo %_version%') Do (set _major=%%G& set _minor=%%H& set _build=%%I) 
echo #INF: Major version: %_major% Minor Version: %_minor% Build: %_build%
if DEFINED _major if "%_major%"=="5" goto sub5
if DEFINED _major if "%_major%"=="6" goto sub6
echo #ERR: Unsupported Windows version.
set ERRORLEVEL=2
goto end
rem ======================================= 
:Sub5
rem ======================================= 
rem == Path to the TCK tools installation directory 
set TCK_INSTALL_PATH=%tckOFFICIAL_PATH%\_oldos
set TCK_ROOT_PATH=%TCK_INSTALL_PATH%
set PATH=%PATH%;%TCK_ROOT_PATH%\intel_a\TCK\command
goto end
rem ======================================= 
:Sub6
rem ======================================= 
rem == Path to the TCK tools installation directory 
set TCK_INSTALL_PATH=%tckOFFICIAL_PATH%
set tckOS_Runtime=intel_a
set TCK_ROOT_PATH=%TCK_INSTALL_PATH%\%tckOS_Runtime%
set PATH=%PATH%;%TCK_ROOT_PATH%\TCK\command
goto end
:end
rem ======================================= 
set _version=
set _major=
set _minor=
set _build=
set tckOFFICIAL_PATH=
set TCK_ROOT_PATH >NUL 2>NUL
