@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " TAKillodtM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=TAKillodtM.exe

set Path=%PATH%;%MkmkSHLIB_PATH%

if NOT DEFINED _DEBUG_ %CMD_NAME% %*

endlocal

