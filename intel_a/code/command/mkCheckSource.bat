@echo off
setlocal
set CATTraDecDir=NUL
set CATICPath=%MkmkIC_PATH%
set CATDictionaryPath=%MkmkDictionary_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
set CATDefaultEnvironment=MkmkEnvironment
set CATUserSettingPath=NUL
set CATReferenceSettingPath=
set PATH=%PATH%;%mkcsSHLIB_PATH%
if DEFINED _DEBUG_ (call devenv) ELSE call mkCheckSourceM %*

rem set returnCode=0
rem setlocal
rem set MkmkIC_SCRIPT=
rem set CATICPath=%MkmkIC_PATH%
rem set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
rem 
rem Licensing
rem set CATReferenceSettingPath=
rem set PATH=%PATH%;%mkcsSHLIB_PATH%
rem mkCheckSourceM %*
rem endlocal
rem set returnCode=%ERRORLEVEL%
rem exit /b %returnCode%
