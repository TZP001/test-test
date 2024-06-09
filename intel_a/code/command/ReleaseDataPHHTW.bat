@echo off
setlocal
set CATDefaultEnvironment=ReleaseManagerEnvironment
set CATTraDecDir=NUL
call "%RELEASEMANAGER_PATH%\code\bin\ReleaseData.exe" -puthost %1 -wait

