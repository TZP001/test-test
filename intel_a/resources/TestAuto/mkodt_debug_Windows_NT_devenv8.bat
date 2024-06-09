@echo off

rem ratrap
if not defined CATDbgPath set CATDbgPath="C:\Program Files\Microsoft Visual Studio 8\Common7\IDE\devenv.exe"

%CATDbgPath% /debugexe %debuggerLoadPath% %*
echo exit %rc%| sh
