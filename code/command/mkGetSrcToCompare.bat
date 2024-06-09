@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " mkGetSrcToCompareM "
rem -------------------------------------------------------------------------------------
set CMD_NAME=mkGetSrcToCompareM

set MkmkIC_SCRIPT=
set CATICPath=%MkmkIC_PATH%
set Path=%Path%;%MkmkSHLIB_PATH%
rem set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%

rem Licensing
rem set CATUserSettingPath=%TCK_RADECATSettingPath%\CUT
rem set CATReferenceSettingPath=


if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% %*
