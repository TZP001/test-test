@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " TAProcessInfoM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=TAProcessInfoM

set Path=%Path%;%MkmkSHLIB_PATH%


if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% %*
