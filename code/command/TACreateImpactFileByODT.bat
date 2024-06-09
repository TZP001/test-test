@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " TACreateImpactFileByODTM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=TACreateImpactFileByODTM.exe

set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ %CMD_NAME% %*

