
@if not DEFINED TCK_DEBUG @echo off

rem ================================
rem Retrieve/execute profiles of tools
rem associated with a given TCK
rem ================================

set TCKHelp=-
if "%1"=="-h" set TCKHelp=true
if "%1"=="-help" set TCKHelp=true
if "%1"=="-?" set TCKHelp=true

if "%TCKHelp%"=="-" goto settmpfile
:help
setlocal
call "%TCK_ROOT_PATH%\code\bin\TCKCommand" tck_get_profile -h
endlocal
set rtcode=%ERRORLEVEL%
goto afterexec2

:settmpfile
"%TCK_ROOT_PATH%\code\bin\return_random"
set TCK_TMP_FILE=%TEMP%\tckexec_%TCKName%_%USERNAME%_%ERRORLEVEL%.bat
if exist "%TCK_TMP_FILE%" goto settmpfile

setlocal
set PATH=%PATH%;%TCK_ROOT_PATH%\code\bin
set CATMsgCatalogPath=%TCK_ROOT_PATH%\resources\msgcatalog
set CATDictionaryPath=%TCK_ROOT_PATH%\code\dictionary
set CATReffilesPath=%TCK_ROOT_PATH%\reffiles
set CATNoErrorLog=1
set CATTraDecDir=nul

echo set TCK_ID=%TCK_ID%>"%TCK_TMP_FILE%"
call "%TCK_ROOT_PATH%\code\bin\TCKCommand" tck_get_profile %* -f "%TCK_TMP_FILE%"
endlocal
set rtcode=%ERRORLEVEL%
if not "%rtcode%"=="0" goto afterexec

rem Execute profiles
set TCK_ID=-
set TCK_ID=
call "%TCK_TMP_FILE%"
if "%TCK_ID%"=="" set rtcode=1

:afterexec
rem No test on profile execution return code
rem since some tools may not return 0 even when execution is successful
del /Q "%TCK_TMP_FILE%"

:afterexec2
if not "%rtcode%"=="0" @echo Failed to set up environment
call "%TCK_ROOT_PATH%\code\bin\return_code" %rtcode%

