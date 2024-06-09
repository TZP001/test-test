@echo off
rem start /w cmd
goto :main

:NOSLT
%DBGPATH% /debugexe %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:NOOPTIONS
set INIT_SLN_FILE=%TEMP%\init_sln_path.%RANDOM%.bat
set MKODT_DEVENV_SOLUTION=%debuggerLoadPath:.exe=.8%
%MkmkROOT_PATH%\code\bin\%VCPROJGEN% -out %MKODT_DEVENV_SOLUTION% %debuggerLoadPath% %* >%INIT_SLN_FILE%
if not "%ERRORLEVEL%" == "0" goto default

rem CALL %INIT_SLN_FILE%
DEL %INIT_SLN_FILE%
goto :open_sln

:default

set MKODT_DEVENV_SOLUTION=%debuggerLoadPath:.exe=.sln%
if not exist %MKODT_DEVENV_SOLUTION% goto :NOSLT

:open_sln
%DBGPATH% %MKODT_DEVENV_SOLUTION%.sln
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:main
if  "%MkmkOS_BuildTime%" EQU "win_b64" set DBGPATH="C:\Program Files (x86)\Microsoft Visual Studio 8\Common7\IDE\devenv.exe"& set VCPROJGEN=TAMkOrUpdateVCProjM.exe
if  "%MkmkOS_BuildTime%" NEQ "win_b64" set DBGPATH="C:\Program Files\Microsoft Visual Studio 8\Common7\IDE\devenv.exe"& set VCPROJGEN=TAMkOrUpdateVCProjM.exe

set debuggerLoadPath=%debuggerLoadPath%
if not defined DEBUGGEROPTIONS goto :NOOPTIONS
%DBGPATH% "%DEBUGGEROPTIONS%"
set rc=%ERRORLEVEL%
echo exit %rc%| sh

:end
