
@if not DEFINED TCK_DEBUG @echo off

rem ================================
rem Modify characteristics of an existing TCK on current site
rem ================================

setlocal

set PATH=%PATH%;%TCK_ROOT_PATH%\code\bin
set CATMsgCatalogPath=%TCK_ROOT_PATH%\resources\msgcatalog
set CATDictionaryPath=%TCK_ROOT_PATH%\code\dictionary
set CATReffilesPath=%TCK_ROOT_PATH%\reffiles
set CATNoErrorLog=1
set CATTraDecDir=nul

@call "%TCK_ROOT_PATH%\code\bin\TCKCommand" tck_modify %*

endlocal

