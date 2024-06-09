@echo off
goto :main

:NOMkmkMSVSBINDIR
echo # ERROR : Could not find the Microsoft Visual Studio debugger... Check the MkmkMSVSBINDIR environment variable.
goto :EOF

:NOSLT
"%MkmkMSVSBINDIR%\devenv.exe" /debugexe %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:NOOPTIONS
set solution=%debuggerLoadPath:.exe=.sln%
if not exist %solution%  goto :NOSLT
"%MkmkMSVSBINDIR%\devenv.exe" %solution%
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:main
if not defined MkmkMSVSBINDIR goto :NOMkmkMSVSBINDIR
rem if  "%MkmkOS_BuildTime%" EQU "win_b64" set DBGPATH="C:\Program Files (x86)\Microsoft Visual Studio 8\Common7\IDE\devenv.exe"
rem if  "%MkmkOS_BuildTime%" NEQ "win_b64" set DBGPATH="C:\Program Files\Microsoft Visual Studio 8\Common7\IDE\devenv.exe"

set debuggerLoadPath=%debuggerLoadPath%
if not defined DEBUGGEROPTIONS goto :NOOPTIONS
"%MkmkMSVSBINDIR%\devenv.exe" "%DEBUGGEROPTIONS%"
set rc=%ERRORLEVEL%
echo exit %rc%| sh

:end
