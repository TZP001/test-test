@echo off
setlocal
if exist "%RELEASEMANAGER_PATH%\code\productIC" set CATICPath=%RELEASEMANAGER_PATH%\code\productIC
set CATDefaultEnvironment=ReleaseManagerEnvironment
set CATUserSettingPath=NUL
set CATTraDecDir=NUL
call "%RELEASEMANAGER_PATH%\code\bin\ReleaseServer.exe" %*

