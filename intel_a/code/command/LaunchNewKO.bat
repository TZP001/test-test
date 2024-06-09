@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " LaunchNewKOM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=LaunchNewKOM.exe

set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ %CMD_NAME% %*

