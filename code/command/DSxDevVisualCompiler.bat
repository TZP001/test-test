@echo off
set returnCode=0
setlocal

if NOT DEFINED ddvdSHLIB_PATH goto StartDDVDCommand

set MkmkIC_SCRIPT=
rem set CATICPath=%MkmkIC_PATH%
rem set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%

rem Licensing
set CATReferenceSettingPath=
set CATDictionaryPath=%ddvdROOT_PATH%\code\dictionary

set PATH=%PATH%;%ddvdSHLIB_PATH%

:StartDDVDCommand

DSxDevVisualCompilerM %*
endlocal
set returnCode=%ERRORLEVEL%


exit /b %returnCode%
