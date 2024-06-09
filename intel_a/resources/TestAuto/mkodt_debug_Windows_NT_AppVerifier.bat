@echo off

rem ------------------------
rem Check install appverif
rem ------------------------

which appverif > NUL
if %ERRORLEVEL% NEQ 0  goto :NOAppverif

rem ------------------------
rem load properties
rem ------------------------

FOR %%i IN (%debuggerLoadPath%) do set debuggerLoad=%%~nxi
FOR %%i IN (%debuggerLoadPath%) do set debuggerLoadDirname=%%~dpi
if not defined debuggerLoadArgs set debuggerLoadArgs=%*%

rem --------------------------
rem Disable and Clean appverif
rem --------------------------

call appverif -disable * -for %debuggerLoad%
rem if exist "%USERPROFILE%"\AppVerifierLogs\%debuggerLoad%* del /f "%USERPROFILE%"\AppVerifierLogs\%debuggerLoad%*
call appverif -delete logs -for %debuggerLoad%


rem ------------------------
rem Enable appverif
rem get _APPVERIFIER_CHECK_LIST
rem ------------------------

rem prerequesite on AppVerifier 3.4 for RPC and COM
rem failure if APPVERIFIER_CHECK_LIST=*
rem misses : LowRes (CNEXT fails) LuaPriv (too many Informations) DangerousAPIs -with DllMainCheck=TRUE (timeout)
if defined _APPVERIFIER_CHECK_LIST set APPVERIFIER_CHECK_LIST=%_APPVERIFIER_CHECK_LIST%
if not defined _APPVERIFIER_CHECK_LIST set APPVERIFIER_CHECK_LIST=COM RPC Handles Exceptions Heaps Locks Memory TLS ThreadPool FilePaths HighVersionLie InteractiveServices KernelModeDriverInstall DangerousAPIs DirtyStacks TimeRollOver PrintAPI PrintDriver
rem set APPVERIFIER_CHECK_LIST=*

echo ## appverif -enable %APPVERIFIER_CHECK_LIST% -for %debuggerLoad%
call appverif -enable %APPVERIFIER_CHECK_LIST% -for %debuggerLoad%
if %ERRORLEVEL% NEQ 0  goto :NOAppEnabled


rem ------------------------
rem CNEXTOUTPUT
rem ------------------------

set CNEXTOUTPUT=%ADL_ODT_OUT%\%ODT_LOG_NAME%.traces

rem ------------------------
rem Call Module
rem ------------------------

call %APPVERIFIER_DEBUGGER_CMD_LINE% %debuggerLoadPath% %debuggerLoadArgs%
set rc=%ERRORLEVEL%


rem ------------------------
rem Dump AppVerifier log
rem ------------------------

rem Symbols="c:\windows"
call appverif -export log -for %debuggerLoad% -with to=%ADL_ODT_TMP%\%debuggerLoad%.xml 
type %ADL_ODT_TMP%\%debuggerLoad%.xml >> %ADL_ODT_OUT%\%ODT_LOG_NAME%.AppVerifier.xml


rem --------------------------
rem Disable and Clean appverif
rem --------------------------

call appverif -disable * -for %debuggerLoad%
rem if exist "%USERPROFILE%"\AppVerifierLogs\%debuggerLoad%* del /f "%USERPROFILE%"\AppVerifierLogs\%debuggerLoad%*
call appverif -delete logs -for %debuggerLoad%

goto :end



:NOAppverif
echo # ERROR : Application Verifier not installed ... Contact IT Support.
set rc=1

:NOAppEnabled
echo # ERROR : AppVerifer is unable to register %APPVERIFIER_CHECK_LIST% - check _APPVERIFIER_CHECK_LIST content.
set rc=11

:end
echo exit %rc%| sh
