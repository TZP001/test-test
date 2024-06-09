@echo off
goto :main

:NOSLT
"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\IDE\devenv.exe" /debugexe %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:NOOPTIONS
set solution=%debuggerLoadPath:.exe=.sln%
if not exist %solution%  goto :NOSLT
"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\IDE\devenv.exe" %solution%
set rc=%ERRORLEVEL%
echo exit %rc%| sh
goto :EOF

:main
set debuggerLoadPath=%debuggerLoadPath%
if not defined DEBUGGEROPTIONS goto :NOOPTIONS
"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\IDE\devenv.exe" "%DEBUGGEROPTIONS%"
set rc=%ERRORLEVEL%
echo exit %rc%| sh

:end
