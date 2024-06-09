@if NOT DEFINED _DEBUG_ @echo off
set NTunsetenvPath=%~dp0
if NOT DEFINED TMP if DEFINED SystemDrive set TMP=%SystemDrive%\temp
if NOT DEFINED TEMP if DEFINED SystemDrive set TEMP=%SystemDrive%\temp
if NOT EXIST "%NTunsetenvPath%..\bin\NTunsetenvM.exe" (
@echo ERROR : %NTunsetenvPath%..\bin\NTunsetenvM.exe not found
goto :EOF
)
if DEFINED TMP if NOT EXIST "%TMP%" mkdir "%TMP%"
call "%NTunsetenvPath%..\bin\NTunsetenvM.exe" -getppid
if ERRORLEVEL 0 (
set NTunsetup=%TMP%\NTunsetup%ERRORLEVEL%.bat
) ELSE (
set NTunsetup=%TMP%\NTunsetup.bat
)
call "%NTunsetenvPath%..\bin\NTunsetenvM.exe" -os > "%NTunsetup%"
call "%NTunsetup%"
del /F "%NTunsetup%"
set NTunsetup=
goto :EOF
