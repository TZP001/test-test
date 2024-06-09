@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " mkodtAssistantM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=mkodtAssistantM

set Path=%Path%;%MkmkSHLIB_PATH%


if NOT DEFINED _DEBUG_ %CMD_NAME% %*

endlocal

