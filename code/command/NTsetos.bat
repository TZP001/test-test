@if NOT DEFINED _DEBUG_ @echo off
set NTsetenvPath=%~dp0
if NOT DEFINED TMP if DEFINED SystemDrive set TMP=%SystemDrive%\temp
if NOT DEFINED TEMP if DEFINED SystemDrive set TEMP=%SystemDrive%\temp
goto Begin
:Begin
if NOT EXIST "%NTsetenvPath%..\bin\NTsetenvM.exe" (
@echo ERROR : %NTsetenvPath%..\bin\NTsetenvM.exe not found
goto :EOF
)
if DEFINED TMP if NOT EXIST "%TMP%" mkdir "%TMP%"
call "%NTsetenvPath%..\bin\NTsetenvM.exe" -getppid
if ERRORLEVEL 0 (
set NTsetup=%TMP%\NTsetup%ERRORLEVEL%.bat
) ELSE (
set NTsetup=%TMP%\NTsetup.bat
)
call "%NTsetenvPath%..\bin\NTsetenvM.exe" -os > "%NTsetup%"
call "%NTsetup%"
del /F "%NTsetup%"
set NTsetup=
if NOT EXIST \dev md \dev
if NOT EXIST \tmp md \tmp
goto :EOF
