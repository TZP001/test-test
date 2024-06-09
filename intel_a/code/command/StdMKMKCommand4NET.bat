@echo off
setlocal ENABLEDELAYEDEXPANSION
rem ---
rem --- usage:
rem --- set CMD_NAME=cmdname
rem --- call StdMKMKCommand4NET %*
set clrpath=
set first=0
rem --- for each concatenation path of tools
@for %%f in (%MkmkROOT_PATH:;= %) do (
	if exist  "%%f\code\clr" (
		if !first! EQU 0 (
			set clrpath=%%f\code\clr
			set first=1
		) else (
			set clrpath=!clrpath!;%%f\code\clr
		)
	)
) 
rem --- Defines the PATH
if DEFINED clrpath set Path=%Path%;%clrpath%;%MkmkSHLIB_PATH%
if NOT DEFINED clrpath set Path=%Path%;%MkmkSHLIB_PATH%
rem --- CATIA env
set CATTraDecDir=NUL
set CATICPath=%MkmkIC_PATH%
set CATDictionaryPath=%MkmkDictionary_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
set CATDefaultEnvironment=MkmkEnvironment
set CATUserSettingPath=NUL
rem --- Calls the command
if NOT DEFINED startorcallcmd set startorcallcmd=call
if DEFINED _DEBUG_ (call devenv) ELSE %startorcallcmd% %CMD_NAME% %*
