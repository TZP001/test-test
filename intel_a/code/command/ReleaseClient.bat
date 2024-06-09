@echo off
setlocal
IF NOT DEFINED RELEASECLIENT_OLD_PATH GOTO LABEL_NOTSAVED
GOTO LABEL_SAVED
:LABEL_NOTSAVED
set RELEASECLIENT_OLD_PATH=%PATH%
set PATH=%RELEASEMANAGER_PATH%\code\bin;%PATH%
GOTO LABEL_SAVED
:LABEL_SAVED
title ReleaseClient.exe %*
set CATDefaultEnvironment=ReleaseManagerEnvironment
set CATTraDecDir=NUL
call ReleaseClient.exe %*

