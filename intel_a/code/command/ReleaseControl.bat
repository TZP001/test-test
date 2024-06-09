@echo off
setlocal
set CATDefaultEnvironment=ReleaseManagerEnvironment
set CATTraDecDir=NUL
call "%RELEASEMANAGER_PATH%\code\bin\ReleaseControl.exe" %*

