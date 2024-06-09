@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " mkodtjobsM "
rem -------------------------------------------------------------------------------------
set CMD_NAME=mkodtjobsM

set MkmkIC_SCRIPT=
set CATICPath=%MkmkIC_PATH%
set Path=%Path%;%MkmkSHLIB_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%

set CATReferenceSettingPath=

if NOT DEFINED NO_SINGLE_SETCATENV set SINGLE_SETCATENV=1

if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% %*


