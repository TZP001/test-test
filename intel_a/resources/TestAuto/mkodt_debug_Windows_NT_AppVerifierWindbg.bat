@echo off

rem ---------------------------------------
rem get _APPVERIFIER_DEBUGGER_CMD_LINE
rem ---------------------------------------

rem set _APPVERIFIER_DEBUGGER_CMD_LINE=E:\users\rwn\util\DebugTools\windbg.exe -xd av -xd ch -xd sov
if defined _APPVERIFIER_DEBUGGER_CMD_LINE set APPVERIFIER_DEBUGGER_CMD_LINE=%_APPVERIFIER_DEBUGGER_CMD_LINE%
if not defined _APPVERIFIER_DEBUGGER_CMD_LINE set APPVERIFIER_DEBUGGER_CMD_LINE=windbg.exe -xd av -xd ch -xd sov

rem Error targetted
rem set APPVERIFIER_DEBUGGER_CHECK_LIST=Handles Exceptions Heaps Locks Memory TLS

set debuggerLoadPath=%debuggerLoadPath%
set debuggerLoadArgs=%*%

echo ## APPVERIFIER_DEBUGGER_CMD_LINE=%APPVERIFIER_DEBUGGER_CMD_LINE%
call %MkmkROOT_PATH%\resources\TestAuto\mkodt_debug_Windows_NT_AppVerifier.bat
set rc=%ERRORLEVEL%


echo exit %rc%| sh


