
@if not DEFINED TCK_DEBUG @echo off

rem ================================
rem Start TCK server on current host
rem ================================

set TCKHelp=-
if "%1"=="-h" set TCKHelp=true
if "%1"=="-help" set TCKHelp=true
if "%1"=="-?" set TCKHelp=true

if "%TCK_ROOT_PATH%"=="" goto enverror
if "%TCK_SERVER%"=="" goto enverror
if "%TCK_SITE_FILE%"=="" goto enverror

setlocal

if "%SystemDrive%"=="" set SystemDrive=C:
set TEMP=%SystemDrive%\TEMP
if not exist "%TEMP%" set TEMP=C:\TEMP
set PATH=%PATH%;%TCK_ROOT_PATH%\code\bin
set CATMsgCatalogPath=%TCK_ROOT_PATH%\resources\msgcatalog
set CATDictionaryPath=%TCK_ROOT_PATH%\code\dictionary
set CATReffilesPath=%TCK_ROOT_PATH%\reffiles
set CATNoErrorLog=1
set CATTraDecDir=nul

if "%TCKHelp%"=="-" goto execcmd
:help
call "%TCK_ROOT_PATH%\code\bin\TCKServer" -h
endlocal
set rtcode=%ERRORLEVEL%
goto end

:execcmd
rem Save previous log file
copy "%TEMP%"\TCK_server_*.txt "%TEMP%"\TCK_server_old.txt > nul 2<&1
call "%TCK_ROOT_PATH%\code\bin\return_random"
set TCKNumber=%ERRORLEVEL%

call "%TCK_ROOT_PATH%\code\bin\TCKServer.exe" %* >"%TEMP%"\TCK_server_%TCKNumber%.txt 2>&1
endlocal
set rtcode=%ERRORLEVEL%

goto end

:enverror
@echo Environment is not set. Run tck_init.bat.
set rtcode=5

:end
call "%TCK_ROOT_PATH%\code\bin\return_code" %rtcode%
