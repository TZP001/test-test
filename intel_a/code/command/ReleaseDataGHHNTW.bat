@echo off
set CATDefaultEnvironment=ReleaseManagerEnvironment
set CATTraDecDir=NUL
call "%RELEASEMANAGER_PATH%\code\bin\ReleaseData.exe" -getnumber
set RELEASEDATA_NUMBER=%ERRORLEVEL%
call "%RELEASEMANAGER_PATH%\code\bin\ReleaseData.exe" -gethost -notype -wait -type set -file "%RELEASEMANAGER_TMP%\ReleaseData-%RELEASEDATA_NUMBER%.bat"
if %ERRORLEVEL% EQU 0 goto LABEL_THEN
goto :EOF
:LABEL_THEN
call "%RELEASEMANAGER_TMP%\ReleaseData-%RELEASEDATA_NUMBER%.bat"
del "%RELEASEMANAGER_TMP%\ReleaseData-%RELEASEDATA_NUMBER%.bat"
goto :EOF

