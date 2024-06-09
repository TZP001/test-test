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
