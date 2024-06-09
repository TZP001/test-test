@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " ExecuteCommandM"
rem -------------------------------------------------------------------------------------

set CMD_NAME=TAExecuteCommandM.exe

set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ %CMD_NAME% %*

