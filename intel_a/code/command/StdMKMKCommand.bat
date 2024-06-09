@echo off
setlocal
if NOT DEFINED MkmkWSAD_PATH set Path=%Path%;%MkmkSHLIB_PATH%
if DEFINED MkmkWSAD_PATH set Path=%MkmkWSAD_PATH%;%MkmkSHLIB_PATH%
set CATTraDecDir=NUL
set CATICPath=%MkmkIC_PATH%
set CATDictionaryPath=%MkmkDictionary_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
set CATDefaultEnvironment=MkmkEnvironment
set CATUserSettingPath=NUL
if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% %* 
