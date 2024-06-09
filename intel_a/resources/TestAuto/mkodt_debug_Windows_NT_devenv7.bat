@echo off
goto :main

:NOSLT
%DBGPATH% /debugexe %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:NOOPTIONS
set solution=%debuggerLoadPath:.exe=.sln%
if not exist %solution%  goto :NOSLT
%DBGPATH% %solution%
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:main
if  "%MkmkOS_BuildTime%" EQU "win_b64" set DBGPATH="C:\Program Files (x86)\Microsoft Visual Studio 8\Common7\IDE\devenv.exe"
if  "%MkmkOS_BuildTime%" NEQ "win_b64" set DBGPATH="C:\Program Files\Microsoft Visual Studio .NET\Common7\IDE\devenv.exe"

set debuggerLoadPath=%debuggerLoadPath%
if not defined DEBUGGEROPTIONS goto :NOOPTIONS
%DBGPATH% "%DEBUGGEROPTIONS%"
set rc=%ERRORLEVEL%
echo exit %rc%| sh

:end
