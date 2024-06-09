@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " mkOdtM "
rem -------------------------------------------------------------------------------------
set CMD_NAME=mkOdtM

set MkmkIC_SCRIPT=
set CATICPath=%MkmkIC_PATH%
set Path=%Path%;%MkmkSHLIB_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%

rem Licensing
rem set CATUserSettingPath=%TCK_RADECATSettingPath%\CUT
rem set CATReferenceSettingPath=

if NOT DEFINED NO_SINGLE_SETCATENV set SINGLE_SETCATENV=1

if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% %*


