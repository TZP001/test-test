@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " LaunchmkodtconfigM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=LaunchmkodtconfigM.exe

set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ %CMD_NAME% %*

endlocal

