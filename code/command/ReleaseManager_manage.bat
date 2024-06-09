@echo off
setlocal
set CATInstallPath=%RELEASEMANAGER_PATH%
call "%RELEASEMANAGER_PATH%\code\bin\ReleaseManager_manage.exe" %*

